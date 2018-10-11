#!/bin/sh
PATH=/bin:/sbin:$PATH

set -e

if [ "${1:0:1}" = '-' ]; then
    set -- python "$@"
fi

sed -i "s#"_DATABASE_"#"$MYSQL_DBNAME"#g" /legendsock/usermysql.json;
sed -i "s#"_USERNAME_"#"$MYSQL_USER"#g" /legendsock/usermysql.json;
sed -i "s#"_PASSWORD_"#"$MYSQL_PASSWORD"#g" /legendsock/usermysql.json;
sed -i "s#"_HOSTNAME_"#"$MYSQL_HOST"#g" /legendsock/usermysql.json;
sed -i "s#"_PORT_"#"$MYSQL_PORT"#g" /legendsock/usermysql.json;

sed -ri "s@^(.*\"timeout\": ).*@\1$TCP_TIMEOUT,@" /legendsock/user-config.json
sed -ri "s@^(.*\"udp_timeout\": ).*@\1$UDP_TIMEOUT,@" /legendsock/user-config.json
sed -ri "s@^(.*\"protocol_param\": ).*@\1\"$PROTOCOL_PARAM\",@" /legendsock/user-config.json
sed -ri "s@^(.*\"speed_limit_per_con\": ).*@\1$SPEED_LIMIT_PER_CON,@" /legendsock/user-config.json
sed -ri "s@^(.*\"speed_limit_per_user\": ).*@\1$SPEED_LIMIT_PER_USER,@" /legendsock/user-config.json
sed -ri "s@^(.*\"redirect\": ).*@\1\"${MYSQL_HOST}:443\",@" /legendsock/user-config.json

echo $DOCKER_DNS > /legendsock/dns.conf

exec python /legendsock/server.py m
