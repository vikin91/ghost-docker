# Ghost blog

# Operations

## Start

`docker-compose up -d -f docker-compose.yml`

## Stop

`docker-compose stop -f docker-compose.yml`

## Backup

```
# alpine_ghost_apps
# alpine_ghost_data
# alpine_ghost_images
# alpine_ghost_themes

docker run -v ghost_images:/images --name helper_images busybox true
docker cp -L helper_images:/images .
docker rm helper_images

docker run -v ghost_themes:/themes --name helper_themes busybox true
docker cp -L helper_themes:/themes .
docker rm helper_themes

docker run -v ghost_data:/data --name helper_data busybox true
docker cp -L helper_data:/data .
docker rm helper_data

docker run -v ghost_apps:/apps --name helper_apps busybox true
docker cp -L helper_apps:/apps .
docker rm helper_apps
```


## Upgrade

Change image version in `docker-compose.yml` and restart with
```
docker-compose down -f docker-compose.yml
docker-compose up -d -f docker-compose.yml
```
