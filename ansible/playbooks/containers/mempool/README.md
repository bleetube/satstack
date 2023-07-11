# mempool.space

This is dope. It uses tls for an external electrs service running on NixOS. Tor for any external calls. The configuration is a dictionary of environment variables, so it's simple to change or add them.

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

The containers still fail to build from source using `docker-compose build`, so I need to figure out what else they need.