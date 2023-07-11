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

## deployment notes

An initial `podman-compose` ran this stack basically as-is from the repo.  There were some trade-offs getting it to work with the podman_container Ansible module:

* `restart: on-failure` isn't supported
* `stop_grace_period: 1m` isn't supported
* `command:` was upset when referring to the database as `host.containers.internal`, so it's also disabled

It may be preferable to switch to a compose file for these containers to get those back if problems occur in the future (and a workaround can't be reached). It's probably okay though.
