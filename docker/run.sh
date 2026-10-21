#!/usr/bin/env bash
# Usage: docker/run.sh inhand_ddp_leap_zrot_cube.py
# MeshCat: http://localhost:7070 
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT="${1:?usage: $0 <task_script.py> [args...]}"
shift

colima status >/dev/null 2>&1 || colima start

# Forward Mac:7070 -> VM:7000 (Drake MeshCat binds localhost:7000 in the host-networked container)
MESHCAT_PORT=7070
if ! pgrep -f "${MESHCAT_PORT}:localhost:7000" >/dev/null; then
    SSH_CFG="$(mktemp)"
    colima ssh-config > "$SSH_CFG"
    ssh -F "$SSH_CFG" -f -N -o ExitOnForwardFailure=yes -L "${MESHCAT_PORT}:localhost:7000" colima
    rm -f "$SSH_CFG"
fi

if ! docker image inspect inhand >/dev/null 2>&1; then
    docker build --platform linux/amd64 -t inhand -f "$REPO/docker/Dockerfile" "$REPO"
fi

echo "MeshCat: http://localhost:${MESHCAT_PORT}"
exec docker run --rm -it --platform linux/amd64 --network host \
    -v "$REPO":/workspace inhand python3 -u "$SCRIPT" "$@"
