#!/bin/bash
input=$(cat)

DIR=$(basename "$(echo "$input" | jq -r '.workspace.current_dir')")
MODEL=$(echo "$input" | jq -r '.model.display_name')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
USAGE=$(echo "$input" | jq '.context_window.current_usage')

if [ "$USAGE" != "null" ] && [ "$CONTEXT_SIZE" != "null" ] && [ "$CONTEXT_SIZE" != "0" ]; then
    CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    PERCENT_USED=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
    printf "\033[34m%s \033[90m%s \033[33m[%d%%]\033[0m" "$DIR" "$MODEL" "$PERCENT_USED"
else
    printf "\033[34m%s \033[90m%s \033[33m[0%%]\033[0m" "$DIR" "$MODEL"
fi
