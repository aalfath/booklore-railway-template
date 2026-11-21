# BookLore for Railway: the official image, pinned by version and digest.
# Bump the tag and digest together, and add a CHANGELOG.md entry.
FROM ghcr.io/booklore-app/booklore:v2.4.0@sha256:f92dae443c38098bf8348742465f6f3b17b619cb8f0e5c2cf195dcdfbb88eaeb

COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod 755 /usr/local/bin/railway-start.sh

# Everything BookLore keeps lives under /data (one Railway volume):
#   /data/app       settings, covers, thumbnails, cache  (upstream's /app/data)
#   /data/books     your library folder (pick it in the setup wizard)
#   /data/bookdrop  BookDrop: files put here are picked up and queued for import
EXPOSE 6060

ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD ["java", "-jar", "/app/app.jar"]
