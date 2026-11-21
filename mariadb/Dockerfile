# MariaDB for BookLore on Railway: the official image (11.4 LTS), pinned by version and digest.
# Bump the tag and digest together, and add a CHANGELOG.md entry.
FROM mariadb:11.4.13@sha256:a8992b5e5404d11e03c54a31d0c1bdea3fd116d283aa6d1a627551f29045309b

COPY railway.cnf /etc/mysql/conf.d/zz-railway.cnf

# Run mariadb-upgrade automatically when a newer image starts on an older data directory.
ENV MARIADB_AUTO_UPGRADE=1

EXPOSE 3306

# The base image's entrypoint initialises the data directory on first start and
# creates MARIADB_DATABASE and MARIADB_USER.
CMD ["mariadbd"]
