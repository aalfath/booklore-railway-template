[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/booklore-2?utm_medium=integration&utm_source=button&utm_campaign=booklore)

# BookLore on Railway

One-click [BookLore](https://github.com/booklore-app/booklore) for Railway: a self-hosted, multi-user digital library for EPUB, PDF, comics and audiobooks, with smart shelves, automatic metadata, a built-in reader, Kobo and KOReader sync, OPDS and BookDrop imports. It ships with its own MariaDB database.

**Versions:**
- BookLore `v2.4.0`: `ghcr.io/booklore-app/booklore:v2.4.0@sha256:f92dae443c38098bf8348742465f6f3b17b619cb8f0e5c2cf195dcdfbb88eaeb`
- MariaDB `11.4.13` (11.4 LTS): `mariadb:11.4.13@sha256:a8992b5e5404d11e03c54a31d0c1bdea3fd116d283aa6d1a627551f29045309b`

## What it deploys

| Service | Source | What it does |
|---|---|---|
| `BookLore` | `booklore/` in this repo | The web app and API (Spring Boot with the Angular UI), the public entry point. Health check `/api/v1/healthcheck`. Volume at `/data`. |
| `MariaDB` | `mariadb/` in this repo | BookLore's database: users, libraries, shelves, metadata, reading progress. Private network only. Volume at `/var/lib/mysql`. |

Everything BookLore stores on disk is on its volume at `/data`:

- `/data/app`: settings, covers, thumbnails and cache (upstream's `/app/data`)
- `/data/books`: your library folder. Choose it in the setup wizard when you create your first library.
- `/data/bookdrop`: the BookDrop folder. Files put here (or uploaded through BookDrop in the UI) are picked up, enriched with metadata and queued for import.

The start script (`booklore/railway-start.sh`) creates these folders, makes BookLore listen on Railway's `PORT`, waits for MariaDB on the first boot, then starts the app through the image's own entrypoint.

## Variables

The deployer is asked for nothing. All values are generated or derived:

- `MARIADB_PASSWORD` and `MARIADB_ROOT_PASSWORD` (on `MariaDB`): generated at deploy.
- `DATABASE_HOST`, `DATABASE_NAME`, `DATABASE_USERNAME`, `DATABASE_PASSWORD` (on `BookLore`): references to the `MariaDB` service.
- `PORT` (`6060`): the port BookLore listens on.

Optional settings you can add to `BookLore` later (see upstream's docs): `TZ`, `ALLOWED_ORIGINS` (CORS), `FORCE_DISABLE_OIDC`, `REMOTE_AUTH_*` (header-based login behind a proxy). OIDC login and email (send to Kindle) are set up in BookLore's own settings.

## After deploy

1. Open the `BookLore` service's public URL. The setup wizard asks you to create the admin account (only the first visitor can do this, so do it straight away).
2. Create a library and pick `/data/books` as its folder.
3. Upload books in the UI, or use BookDrop.

## Updates

Both services build from this repo. When the pinned versions are bumped on `main`, Railway shows everyone who deployed the template an "update available" notice, and you choose when to apply it. Read `CHANGELOG.md` first: breaking changes are listed at the top of each entry. MariaDB upgrades run `mariadb-upgrade` automatically (`MARIADB_AUTO_UPGRADE=1`).

Upstream note: BookLore's authors announced that BookLore is entering maintenance mode (bug fixes and security updates) and that [BookOrbit](https://bookorbit.app) is its successor.

## Licence

This wrapper is MIT. BookLore is AGPL-3.0, MariaDB is GPL-2.0.
