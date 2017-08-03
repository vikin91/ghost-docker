# Ghost blog

# Operations

## Bootstrap

Run `./boostrap.sh`

## Start

`docker-compose up -d`

## Stop

`docker-compose stop`

## Backup

Run `./backup.sh`

## Restore

Run `./restore.sh <tar_gz_archive>`

## Upgrade

If needed, change image version in `docker-compose.yml` and run `./update.sh`

## Migrate from 0.1

Tune and run `./migrate-images.sh`