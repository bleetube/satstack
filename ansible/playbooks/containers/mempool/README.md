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

Using environment variables avoids needing to merge changes to `mempool-config.json` in the future.

## future improvements

* Switch to using container names instead of exposing a port for inter-container communication. I [opened an issue](https://github.com/containers/ansible-podman-collections/issues/604) in an effort to figure this out.

* The containers still fail to build from source using `docker-compose build`, so I need to figure out what else they need.

* systemd won't see containers that are already running and we must use "state: present|started" in order to use recreate. Recreate was required for changes to mempool_config to take effect.