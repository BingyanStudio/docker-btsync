# BitTorrent Sync #

BitTorrent Sync in a docker box.

## Usage ##

Launch a BitTorrent Sync instance by docker:

```sh
    docker run -it --restart=always --name btsync --net=host \
                   -e DEVICE=$(whoami)@$(hostname) \
                   -e UID=$(id -u) -e GID=$(id -g) \
                   -v /:/host -v $(pwd)/settings:/home/btsync/.sync \
                   bingyan/btsync
```

Or you can use [Docker Compose](https://www.docker.com/products/docker-compose) (1.6.0+, docker 1.10.0+):

Firstly create a file named `docker-compose.yml`:

```yml
version: '2'

services:
  btsync:
    image: bingyan/btsync
    container_name: btsync
    restart: always
    environment:
      - UID=1000
      - GID=1000
      - DEVICE=john@linux
      - DIRECTORY_ROOT=/host
      - USE_UPNP=true
      - LISTENING_PORT=34567
      - WEBUI_PORT=8888
    volumes:
      - /:/host
      - ./settings:/home/btsync/.sync
    ports:
      - 34567:34567
      - 8888:8888
```

Then run `docker-compose up -d`, and visit web-ui via `localhost:8888`.


## Permissions ##

Remember to set `UID` and `GID` environment to your local user's. You
can get you uid and gid by:

```sh
    $ id -u
    $ id -g
```


## Settings Persistentce ##

If you want to preserve the settings of btsync after the container is
recreated, mount a host directory to `/home/btsync/.sync` in the docker
container.


## Authentication ##

Login user can be set up in either web-ui or environment variables.
If you prefer the later, use `LOGIN` and `PASSWORD`/`PASSWORD_HASH`.
`PASSWORD` is plain text and not safe enough so i suggest you using
`PASSWORD_HASH` instead. You can generate `PASSWORD_HASH` with `openssl`:

```sh
    $ openssl passwd -crypt -stdin
    default
    Vx8HKJkOoFBco
    ^C
```

Where the password is `default`, its hash is `Vx8HKJkOoFBco`. so your
`docker-compose.yml` will looks like this:

```yml
...
    environment:
      - LOGIN=john
      - PASSWORD_HASH=Vx8HKJkOoFBco
```
