run_for_player_state() {
  local expected_status=$1
  shift
  local player

  while IFS= read -r player; do
    if [[ "$(playerctl -p "$player" status 2>/dev/null || true)" == "$expected_status" ]]; then
      if playerctl -p "$player" "$@"; then
        return 0
      fi
    fi
  done < <(playerctl -l 2>/dev/null || true)

  return 1
}

case "${1:-status}" in
  status)
    run_for_player_state Playing metadata title ||
      run_for_player_state Paused metadata title ||
      true
    ;;
  toggle)
    run_for_player_state Playing play-pause ||
      run_for_player_state Paused play-pause ||
      true
    ;;
  *)
    printf 'Usage: %s [status|toggle]\n' "$0" >&2
    exit 2
    ;;
esac
