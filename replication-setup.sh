#!/bin/bash

# Inspired by: https://github.com/docker-library/mysql/pull/43/files
#
#  - MYSQL_REPLICA_USER
#  - MYSQL_REPLICA_PASS
#  - MYSQL_MASTER_SERVER
#  - MYSQL_MASTER_PORT
#
# IF using master-master-replication, provide config like "auto-increment-increment" & "auto-increment-offset"
# as config-file (e.g. via bind volume)

#
# MASTER/SLAVES: create replication user
#
if [ "$MYSQL_REPLICA_USER" ]; then
        if [ -z "$MYSQL_REPLICA_PASS" ]; then
                echo >&2 'error: MYSQL_REPLICA_USER set, but MYSQL_REPLICA_PASS not set'
                exit 1
        fi

	echo "CREATE USER '$MYSQL_REPLICA_USER'@'%' IDENTIFIED BY '$MYSQL_REPLICA_PASS'; "
	echo "GRANT REPLICATION SLAVE ON *.* TO '$MYSQL_REPLICA_USER'@'%'; "

        echo "CREATE USER '$MYSQL_REPLICA_USER'@'%' IDENTIFIED BY '$MYSQL_REPLICA_PASS'; " | "${mysql[@]}"
        echo "GRANT REPLICATION SLAVE ON *.* TO '$MYSQL_REPLICA_USER'@'%'; " | "${mysql[@]}"
fi

#
# SLAVES: add replication config
#
if [ "$MYSQL_MASTER_SERVER" ]; then
    MYSQL_MASTER_PORT=${MYSQL_MASTER_PORT:-3306}

    if [ -z "$MYSQL_REPLICA_USER" ]; then
            echo >&2 'error: MYSQL_REPLICA_USER not set'
            exit 1
    fi
    if [ -z "$MYSQL_REPLICA_PASS" ]; then
            echo >&2 'error: MYSQL_REPLICA_PASS not set'
            exit 1
    fi

    echo "CHANGE MASTER TO MASTER_HOST='$MYSQL_MASTER_SERVER', MASTER_PORT=$MYSQL_MASTER_PORT, MASTER_USER='$MYSQL_REPLICA_USER', MASTER_PASSWORD='$MYSQL_REPLICA_PASS';"
    echo "CHANGE MASTER TO MASTER_HOST='$MYSQL_MASTER_SERVER', MASTER_PORT=$MYSQL_MASTER_PORT, MASTER_USER='$MYSQL_REPLICA_USER', MASTER_PASSWORD='$MYSQL_REPLICA_PASS';"  | "${mysql[@]}"

    echo "START SLAVE;"  | "${mysql[@]}"
fi
