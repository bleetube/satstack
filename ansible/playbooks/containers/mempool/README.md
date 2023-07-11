# mempool.space

## requirements

* mariadb
* nginx

See the related playbooks.

## systemd usage

```
systemctl --user status container-mempool-backend.service
systemctl --user status container-mempool-frontend.service
```

## podman-compose vs ansible module

`podman-compose` will run this stack natively, it's also easy to work with.

The Ansible module `podman_container` works, but there were some trade-offs getting it to work:

* `restart: on-failure` isn't supported
* `stop_grace_period: 1m` isn't supported
* `command:` was upset when referring to the database as `host.containers.internal`, so it's also disabled

Using environment variables avoids needing to merge changes to `mempool-config.json` in the future.

## future improvements

The mempool-config.json does not expose a socketPath variable to connect to the unix socket:

```
volumes:
  - /var/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock
```