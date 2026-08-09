source "$ZSH/themes/refined.zsh-theme"

PROMPT="%(?.%F{122}.%F{204})❯%f "
RPROMPT='%F{8}${SSH_TTY:+%n@%m}%f%F{122}$(nix_shell_information)%f'

nix_shell_information() {
  local information=$(nix-shell-info)
  information=${information//$'\e[1;32m'/}
  information=${information//$'\e[0m'/}
  [[ -n $information ]] && echo " $information"
}

repo_information() {
  echo "%F{105}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
}

cmd_exec_time() {
  local stop=$(date +%s)
  local start=${cmd_timestamp:-$stop}
  local elapsed=$((stop - start))
  (( elapsed > 5 )) || return

  local hours=$((elapsed / 3600))
  local minutes=$(((elapsed % 3600) / 60))
  local seconds=$((elapsed % 60))
  local duration=""

  (( hours > 0 )) && duration+="${hours}h "
  (( minutes > 0 )) && duration+="${minutes}m "
  (( seconds > 0 || elapsed < 60 )) && duration+="${seconds}s"
  echo "${duration% }"
}

precmd() {
  setopt localoptions nopromptsubst
  vcs_info
  print -P "\n$(repo_information) %F{143}$(cmd_exec_time)%f"
  unset cmd_timestamp
}
