local prompt_host=""
if [[ -n "$SSH_CONNECTION" ]]; then
  prompt_host+="["
  if [[ "$USER" != "nicksay" ]]; then
    prompt_host+="%n@"
  fi
  prompt_host+="%2m] "
fi

local prompt_dir="%{$fg[cyan]%}%~%{$reset_color%} "

local prompt_newline=$'\n%{\r%}'

local prompt_symbol="%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})❯%{$reset_color%} "

local prompt_continuation="… %(1_.%_ .%_)"

PROMPT="$prompt_host$prompt_dir$prompt_newline$prompt_symbol"

PROMPT2="$prompt_continuation$prompt_symbol"
