# mempool.space

Status: this container runs and mostly works except it can't do searches on specific addresses. (WIP)

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

Logs:

```shell
podman logs --follow mempool-backend mempool-frontend
podman exec -it mempool-frontend tail -f /var/log/nginx/access_mempool.log
podman exec -it mempool-frontend tail -f /var/log/nginx/error_mempool.log
```

Verify config:

```shell
podman inspect mempool-backend | jq
podman exec -it mempool-backend cat mempool-config.json
podman exec -it mempool-frontend cat /var/www/mempool/browser/resources/config.js | jq
podman exec -it mempool-frontend cat /etc/nginx/conf.d/nginx-mempool.conf
```

Test cross-container communication

```shell
podman exec -it mempool-frontend /bin/sh -c "wget --quiet -O - http://\$BACKEND_MAINNET_HTTP_HOST:8999/api/v1/mempool"
```

## systemd

```
systemctl --user status container-mempool-backend.service container-mempool-frontend.service
```
