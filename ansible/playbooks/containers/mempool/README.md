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

The [Ansible module](https://github.com/containers/ansible-podman-collections) [podman_container](https://docs.ansible.com/ansible/latest/collections/containers/podman/podman_container_module.html) works, but there were some trade-offs getting it to work:

* `restart: on-failure` has no apparent equivalent yet
* `stop_grace_period: 1m` has no apparent equivalent yet

There is a [feature request](https://github.com/containers/ansible-podman-collections/issues/199) asking for a new module that orchestrates with podman-compose directly.  Not a bad idea.

Using environment variables avoids needing to merge changes to `mempool-config.json` in the future.

## future improvements

* Switch to using container names instead of exposing a port for inter-container communication. I [opened an issue](https://github.com/containers/ansible-podman-collections/issues/604) in an effort to figure this out.

* The containers still fail to build from source using `docker-compose build`, so I need to figure out what else they need.