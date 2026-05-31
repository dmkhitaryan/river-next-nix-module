{
  writeShellApplication,
  coreutils,
}:

# Adapted from: https://github.com/greenm01/triad/blob/master/flake.nix
# for usage in this repository.
writeShellApplication {
  name = "triad-manager-loop";

  runtimeInputs = [ coreutils ];

  text = ''
    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/triad"
    mkdir -p "$state_dir"

    triad_bin="''${TRIAD_BIN:-/run/current-system/sw/bin/triad}"
    rapid_restarts=0

    while :; do
      start_sec="$(date +%s)"
      session_id="''${TRIAD_SESSION_ID:-$(date +%Y%m%d-%H%M%S)-$$}"
      log="$state_dir/triad-$session_id.log"
      latest="$state_dir/triad-latest.log"

      ln -sfn "$log" "$latest" 2>/dev/null || true

      {
        printf '%s\n' "triad-manager-loop: started at $(date -Is 2>/dev/null || date)"
        printf '%s\n' "triad-manager-loop: binary: $triad_bin"
      } >> "$log" 2>&1

      set +e
      "$triad_bin" >> "$log" 2>&1
      status=$?
      set -e

      end_sec="$(date +%s)"
      duration=$((end_sec - start_sec))

      printf '%s\n' "triad-manager-loop: exited with status $status in $duration seconds" >> "$log" 2>&1

      if [ "$duration" -lt 5 ]; then
        rapid_restarts=$((rapid_restarts + 1))
      else
        rapid_restarts=0
      fi

      if [ "$rapid_restarts" -ge 3 ]; then
        printf '%s\n' "triad-manager-loop: rapid restart count exceeded, cooling down" >> "$log" 2>&1
        sleep 5
      else
        sleep 1
      fi
    done
  '';

  meta = {
    description = "Manager loop for Triad logging";
    mainProgram = "triad-manager-loop";
  };
}
