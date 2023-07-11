# mempool.space

This is dope. It uses tls for an external electrs service running on NixOS. Tor for any external calls. The configuration is a dictionary of environment variables, so it's simple to change or add them.

## generating secrets

```
pass generate -n satstack.net/wartortle/MEMPOOL_CORE_RPC
pass generate -n satstack.net/wartortle/MEMPOOL_MARIADB
```

## requirements

* mariadb
* nginx

See the related playbooks.

## systemd usage

```
systemctl --user status container-mempool-backend.service
systemctl --user status container-mempool-frontend.service
```

## variables

See `host_vars/wartortle../mempool.yml`

## deployment

Configure variables and then run all the tasks from a playbook for the target host. Example:

```
ansible-playbook playbooks/host_tasks/wartortle.satstack.net.yml
```

## upgrades

Check release notes and merge any meaningful changes to [RTL-Config.json](https://github.com/Ride-The-Lightning/RTL/blob/master/Sample-RTL-Config.json)

Then update [versions.yml](../../../group_vars/all/versions.yml) and run the podman_container module:

```
ansible-playbook playbooks/host_tasks/wartortle.satstack.net.yml --tags podman
```

## podman-compose vs ansible module

Using environment variables avoids needing to merge changes to `mempool-config.json` in the future.

## future improvements

* Switch to using container names instead of exposing a port for inter-container communication. I [opened an issue](https://github.com/containers/ansible-podman-collections/issues/604) in an effort to figure this out.

* The containers still fail to build from source using `docker-compose build`, so I need to figure out what else they need.

* systemd won't see containers that are already running and we must use "state: present|started" in order to use recreate. Recreate was required for changes to mempool_config to take effect.