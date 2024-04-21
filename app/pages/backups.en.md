---
title: Backups
layout: tech
---

# Backups

## Daily backups

The 666a database is backed up daily to a consumer-grade Samsung SSD.

## Restore process

Restoring the database requires uploading the SQLite data files to the Fly volume. The following set of instructions is based on [Richard Neil Ilagan's “Copying files to a volume on Fly.io” blog post](https://www.richardneililagan.com/posts/copying-files-to-fly-io-volume/). 

### Wireguard config

```
fly wireguard create
```

### SSH key

```
fly ssh issue
```

Name the resulting files `666a.key` and `666a.key-cert.pub`.

### Upload

```
scp -i 666a.key data.sqlite3 root@666a.internal:/data/production/data.sqlite
scp -i 666a.key data.sqlite3-shm root@666a.internal:/data/production/data.sqlite3-shm
scp -i 666a.key data.sqlite3-wal root@666a.internal:/data/production/data.sqlite3-wal
```