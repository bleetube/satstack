# nextcloud

See [bleetube/ansible-role-nextcloud](https://github.com/bleetube/ansible-role-nextcloud)

## upgrades

Check for any meaningful changes to [nginx.conf](https://github.com/nextcloud/docker/blob/master/.examples/docker-compose/with-nginx-proxy/postgres/fpm/web/nginx.conf)

## requirements

* [nginx](nginx_conf.yml)
* podman

## dependencies

* mariadb (optional)
* postgresql (optional)

## variables

See [host_vars](../../../host_vars/wartortle.satstack.net/nextcloud.yml)

## deployment example

```shell
ansible-playbook playbooks/postgresql.yml
ansible-playbook playbooks/host_tasks/wartortle.satstack.net/nextcloud.yml
```

## systemd

```
systemctl --user status container-nextcloud.service
```

## updates

```
ansible-playbook playbooks/host_tasks/wartortle.satstack/nextcloud.yml --tags nextcloud
podman exec -it nextcloud /var/www/html/occ app:update --all
podman exec -it nextcloud /var/www/html/occ upgrade
```

You may need to add a `-u` flag with the accountname that the pod is running as on Linux.

I also need to chown everything to the same 100081 uid/gid after a migration from docker.

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
podman exec -it nextcloud cat config/config.php
podman logs --follow nextcloud
tail -f /var/compose/nextcloud/data/nextcloud.log
```

If you see `Database query failed: invalid locale name:` it means postgresql needs to be [restarted](https://github.com/ANXS/postgresql/issues/539). You should also confirm your desired locale is already set up:

```
locale -a
locale-gen en_US.UTF-8
```