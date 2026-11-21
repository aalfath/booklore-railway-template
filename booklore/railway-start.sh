#!/bin/sh
# Railway start script for BookLore: puts all state on the volume at /data,
# listens on Railway's PORT and waits for MariaDB before starting the app.
set -e

DATA_DIR="${BOOKLORE_DATA_DIR:-/data}"
export USER_ID="${USER_ID:-1000}"
export GROUP_ID="${GROUP_ID:-1000}"
export TZ="${TZ:-Etc/UTC}"
export DISK_TYPE="${DISK_TYPE:-LOCAL}"
export BOOKLORE_PORT="${PORT:-${BOOKLORE_PORT:-6060}}"

# Railway volumes are mounted root-owned. Create the folders and hand them to the
# app user (top level only, so a large library doesn't slow every boot).
mkdir -p "$DATA_DIR/app" "$DATA_DIR/books" "$DATA_DIR/bookdrop"
chown "$USER_ID:$GROUP_ID" "$DATA_DIR" "$DATA_DIR/app" "$DATA_DIR/books" "$DATA_DIR/bookdrop" 2>/dev/null || true

# Wait for the database (up to 3 minutes) so a first deploy doesn't crash while
# MariaDB is still initialising its volume.
if [ -n "$DATABASE_HOST" ]; then
  i=0
  until nc -z -w 3 "$DATABASE_HOST" "${DATABASE_PORT:-3306}" 2>/dev/null; do
    i=$((i+1))
    if [ "$i" -ge 90 ]; then
      echo "railway-start: MariaDB at $DATABASE_HOST:${DATABASE_PORT:-3306} not reachable after 3 minutes, starting anyway" >&2
      break
    fi
    [ $((i % 10)) -eq 1 ] && echo "railway-start: waiting for MariaDB at $DATABASE_HOST:${DATABASE_PORT:-3306}..."
    sleep 2
  done
fi

# Point BookLore's data and BookDrop folders at the volume, then hand over to the
# image's own entrypoint (creates the app user and drops root).
exec /usr/local/bin/entrypoint.sh "$@" \
  "--app.path-config=$DATA_DIR/app" \
  "--app.bookdrop-folder=$DATA_DIR/bookdrop"
