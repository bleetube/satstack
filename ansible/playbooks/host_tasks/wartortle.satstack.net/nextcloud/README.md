# nextcloud

See [bleetube/ansible-role-nextcloud](https://github.com/bleetube/ansible-role-nextcloud)

## upgrades

In addition to what's described by the role, check for any meaningful changes to [nginx.conf](https://github.com/nextcloud/docker/blob/master/.examples/docker-compose/with-nginx-proxy/postgres/fpm/web/nginx.conf)

## deployment

```shell
ansible-playbook playbooks/postgresql.yml
ansible-playbook playbooks/host_tasks/wartortle.satstack.net/nextcloud.yml
```

Apps:

```
podman exec -it -u www-data nextcloud /var/www/html/occ app:install calendar
podman exec -it -u www-data nextcloud /var/www/html/occ app:install contacts
```

## systemd

```
systemctl --user status container-nextcloud.service
```

## updates

```
ansible-playbook playbooks/host_tasks/wartortle.satstack/nextcloud.yml --tags nextcloud
podman exec -it -u www-data nextcloud /var/www/html/occ app:update --all
podman exec -it -u www-data nextcloud /var/www/html/occ upgrade
```

## backups

```shell
rsync -tav ${TARGET}:/var/compose/nextcloud $HOME/archive/${TARGET}/
ssh ${TARGET} "doas -u postgres /usr/bin/pg_dump -Fc nextcloud | /usr/bin/bzip2 > nextcloud_${TIMESTAMP}.dump.bz2"
mkdir -p$HOME/archive/${TARGET}/postgresql/
rsync -tav ${TARGET}:nextcloud_${TIMESTAMP}.dump.bz2 $HOME/archive/${TARGET}/postgresql/
```

### restore

```bash
rsync -ta --delete nextcloud/ ${TARGET}:/var/compose/nextcloud/
rsync -t nextcloud_07-14-2023.dump.bz2  ${TARGET}:/var/lib/postgresql/
```

Re-run `ansible-playbook playbooks/postgresql.yml` create a new database. Then import the data on the target machine:

```shell
su - postgres
bzcat nextcloud_*.dump.bz2 | pg_restore -d nextcloud
```

## troubleshooting

```
tail -f /var/compose/nextcloud/data/nextcloud.log
```

If you see `Database query failed: invalid locale name:` it means postgresql needs to be [restarted](https://github.com/ANXS/postgresql/issues/539). You should also confirm your desired locale is already set up:

```
locale -a
locale-gen en_US.UTF-8
```