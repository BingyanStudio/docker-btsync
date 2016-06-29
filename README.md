# BitTorrent Sync #

BitTorrent Sync in a docker box.

## Usage ##

If you want to use docker only, use this command:

```sh
    docker run -it --restart=always --name btsync --net=host \
                   -e DEVICE=$(whoami)@$(hostname) \
                   -e UID=$(id -u) -e GID=$(id -g) \
                   -v /:/host -v $(pwd)/settings:/home/btsync/.sync \
                   bingyan/btsync
```

Or use [Docker Compose](https://www.docker.com/products/docker-compose)(1.6.0+, docker 1.10.0+):

Firstly create a file named `docker-compose.yml`:

```yml
version: '2'

services:
  btsync:
    image: bingyan/btsync
    container_name: btsync
    network_mode: host
    environment:
      DEVICE: john@linux
      UID: 1000
      GID: 1000
      DIRECTORY_ROOT: /sync
      USE_UPNP: "true"
    volumes:
      - /:/host
      - ./settings:/home/btsync/.sync
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

If you want to preserve the settings of btsync, mount a directory to
`/home/btsync/.sync` in the docker container.


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
      LOGIN: john
      PASSWORD_HASH: Vx8HKJkOoFBco
```


## Ports ##

By default, port `34567` and `34567/udp` are used for data transfering,
and `8888` is used for web-ui. If you don't use docker's `host`
network mode, please remember to map these ports to outside world.


## More Info ##

Please reference the Dockerfile directly.
