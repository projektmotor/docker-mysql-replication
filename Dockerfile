FROM mysql:5.7
COPY replication-setup.sh /docker-entrypoint-initdb.d/
