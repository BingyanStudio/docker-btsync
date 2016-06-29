#!/usr/bin/env sh

has_gid () {
    cut -d: -f1,4 /etc/passwd | grep -q "^${1}:${2}" || return 1
}

# example: ensure_user btsync 1000 1000
ensure_user () {
    local user=$1
    local uid=$2
    local gid=$3
    local group_prefix=${4:-_}

    {
        deluser $user
        delgroup $user
        delgroup $group_prefix$user
    } 2>/dev/null

    adduser -s /bin/sh -D -u $uid $user
    has_gid $user $gid || {
        addgroup -g $gid $group_prefix$user
        sed -i 's/^\('$user'\(:[^:]\{1,\}\)\{2\}\):[0-9]\{1,\}/\1:'$gid/ /etc/passwd
    }

}

ensure_user btsync $UID $GID

CONF=/etc/btsync.conf
CONF_DIR=/home/btsync/.sync

[ -d "$CONF_DIR" ] && chown -R btsync "$CONF_DIR"

if [ ! -f "$CONF" ]; then
    cat <<EOF > "$CONF"
{
  "device_name": "${DEVICE//\"/\\\"}"
  ,"listening_port": ${LISTENING_PORT}
  ,"pid_file": "/home/btsync/btsync.pid"
  ,"use_upnp": $USE_UPNP
  ,"webui": {
    "listen": "0.0.0.0:${WEBUI_PORT}"
//  ,"login": "${LOGIN//\"/\\\"}"
//  ,"password": "${PASSWORD//\"/\\\"}"
//  ,"password_hash": "${PASSWORD_HASH}"
//  ,"force_https": true
//  ,"ssl_certificate": "${SSL_CERT}"
//  ,"ssl_private_key": "${SSL_KEY}"
    ,"directory_root": "${DIRECTORY_ROOT//\"/\\\"}"
  }
}
EOF

    uncomment () {
        sed -i 's/\/\/\( *, *"'$1'".*\)/  \1/' "$CONF"
    }

    [ "$LOGIN" ] && {
        uncomment login
        if [ "$PASSWORD_HASH" ]; then
            uncomment password_hash
        else
            uncomment password
        fi
    }

    [ "$FORCE_HTTPS" = true ] && {
        uncomment force_https
        uncomment ssl_certificate
        uncomment ssl_private_key
    }
fi

cd /home/btsync
exec su btsync -c "exec $*"
