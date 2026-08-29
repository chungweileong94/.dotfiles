#!/bin/sh
input=$(cat)

display_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

# Extract short model name: "Claude 3.5 Sonnet" -> "Sonnet 3.5", "Claude Sonnet 4.6" -> "Sonnet 4.6"
short_model=$(echo "$display_name" | sed 's/^Claude //')

# Merge model + effort into one field
if [ -n "$effort" ]; then
  model_str="${short_model} (${effort})"
else
  model_str="${short_model}"
fi

# Format context as "10k (10%)"
context_str=""
if [ -n "$total_tokens" ] && [ "$total_tokens" != "0" ] && [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  token_compact=$(echo "$total_tokens" | awk '{
    if ($1 >= 1000000) printf "%.1fm", $1/1000000
    else if ($1 >= 1000) printf "%.0fk", $1/1000
    else printf "%d", $1
  }')
  context_str="${token_compact} (${used_int}%)"
elif [ -n "$total_tokens" ] && [ "$total_tokens" != "0" ]; then
  context_str=$(echo "$total_tokens" | awk '{
    if ($1 >= 1000000) printf "%.1fm", $1/1000000
    else if ($1 >= 1000) printf "%.0fk", $1/1000
    else printf "%d", $1
  }')
fi

# Last component of cwd
dir_str=""
if [ -n "$cwd" ]; then
  dir_str=$(basename "$cwd")
fi

dir_branch_str=""
if [ -n "$dir_str" ] && [ -n "$branch" ]; then
  dir_branch_str="${dir_str} [${branch}]"
elif [ -n "$dir_str" ]; then
  dir_branch_str="${dir_str}"
fi

# Format rate limits as "5h:42%(3PM) 7d:18%(Jun 20)"
# Show minutes only when non-zero: "3PM" vs "3:45PM", "Jun 20" vs "Jun 20 3:45PM"
rate_str=""
if [ -n "$five_hour" ]; then
  five_label="5h:$(printf '%.0f' "$five_hour")%"
  if [ -n "$five_hour_reset" ] && [ "$five_hour_reset" != "null" ]; then
    five_min=$(date -r "$five_hour_reset" "+%M" 2>/dev/null || date -d "@$five_hour_reset" "+%M" 2>/dev/null)
    if [ "$five_min" = "00" ]; then
      five_reset_fmt=$(date -r "$five_hour_reset" "+%-I%p" 2>/dev/null || date -d "@$five_hour_reset" "+%-I%p" 2>/dev/null)
    else
      five_reset_fmt=$(date -r "$five_hour_reset" "+%-I:%M%p" 2>/dev/null || date -d "@$five_hour_reset" "+%-I:%M%p" 2>/dev/null)
    fi
    [ -n "$five_reset_fmt" ] && five_label="${five_label}(${five_reset_fmt})"
  fi
  rate_str="$five_label"
fi
if [ -n "$seven_day" ]; then
  seven_label="7d:$(printf '%.0f' "$seven_day")%"
  if [ -n "$seven_day_reset" ] && [ "$seven_day_reset" != "null" ]; then
    seven_min=$(date -r "$seven_day_reset" "+%M" 2>/dev/null || date -d "@$seven_day_reset" "+%M" 2>/dev/null)
    seven_hour=$(date -r "$seven_day_reset" "+%H" 2>/dev/null || date -d "@$seven_day_reset" "+%H" 2>/dev/null)
    if [ "$seven_hour" = "00" ] && [ "$seven_min" = "00" ]; then
      seven_reset_fmt=$(date -r "$seven_day_reset" "+%b %-d" 2>/dev/null || date -d "@$seven_day_reset" "+%b %-d" 2>/dev/null)
    else
      seven_reset_fmt=$(date -r "$seven_day_reset" "+%b %-d %-I:%M%p" 2>/dev/null || date -d "@$seven_day_reset" "+%b %-d %-I:%M%p" 2>/dev/null)
    fi
    [ -n "$seven_reset_fmt" ] && seven_label="${seven_label}(${seven_reset_fmt})"
  fi
  if [ -n "$rate_str" ]; then
    rate_str="${rate_str} ${seven_label}"
  else
    rate_str="${seven_label}"
  fi
fi

out="${model_str}"
[ -n "$context_str" ] && out="${out} · ${context_str}"
[ -n "$rate_str" ] && out="${out} · ${rate_str}"
[ -n "$dir_branch_str" ] && out="${out} · ${dir_branch_str}"
printf "%s" "$out"
