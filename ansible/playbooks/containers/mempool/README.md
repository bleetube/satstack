# mempool.space

[mempool](https://github.com/mempool/mempool)

### generating secrets


## requirements

* [mariadb](../../../host_vars/wartortle.satstack.net/mariadb.yml)
* [nginx](nginx_conf.yml)

## variables

See [host_vars](../../../host_vars/wartortle.satstack.net/mempool.yml)

## deployment example

```
pass generate -n satstack.net/wartortle/MEMPOOL_CORE_RPC
pass generate -n satstack.net/wartortle/MEMPOOL_MARIADB
ansible-playbook playbooks/host_tasks/wartortle.satstack.net/mempool.yml
```

## updates

```
ansible-playbook playbooks/host_tasks/wartortle.satstack.net/mempool.yml --tags podman
```

## troubleshooting

```
podman logs --follow mempool-backend mempool-frontend
```

## systemd

```
systemctl --user status container-mempool-backend.service container-mempool-frontend.service
```
