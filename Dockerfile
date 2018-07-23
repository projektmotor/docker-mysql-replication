FROM mysql:5.7
COPY replication-setup.sh /docker-entrypoint-initdb.d/
COPY docker-entrypoint-wrapper.sh /docker-entrypoint-wrapper.sh

# Entrypoint overload to catch the ctrl+c and stop signals
# see: https://github.com/docker-library/mysql/issues/47
ENTRYPOINT ["/bin/bash", "/docker-entrypoint-wrapper.sh"]
CMD ["mysqld"]

#moo
