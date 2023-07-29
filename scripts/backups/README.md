# backups

Restoring mariadb:

```shell
doas -u mysql mysql -c 'drop database castopod; create database castopod;'
doas -u mysql bzcat /tmp/nextcloud_00-00-0000.dump.bz2 | mysql -uroot
```

Restoring postgresql:

```shell
su - postgres
createuser --pwprompt nextcloud
createdb nextcloud -O nextcloud
bzcat nextcloud_00-00-0000.dump.bz2 | pg_restore -d nextcloud
```