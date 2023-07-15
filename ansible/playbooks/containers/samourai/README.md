# samourai

See [bleetube/ansible-role-samourai](https://github.com/bleetube/ansible-role-samourai)

## trade-offs

Critiques of running Samourai this way are invited and will be documented here.

* The nginx response may differ slightly from the more widely distributed dojo version, facilitating the fingerprinting of a dojo. Thus this setup is really intended only for single-user instances and you should never share the onion address (eg. treat it as a secret and avoid committing it into a repo). I did try to match the behavior exactly, and a cursory check does indicate the responses are identical.

## upgrades

In addition to what's described by the role, check for any meaningful changes to [nginx.conf](https://code.samourai.io/dojo/samourai-dojo/-/tree/develop/docker/my-dojo/nginx/mainnet.conf)

## deployment

```shell
ansible-playbook playbooks/mariadb.yml
ansible-playbook playbooks/host_tasks/wartortle.satstack.net/samourai.yml
```

## systemd

```
systemctl --user status container-samourai.service
```

## updates

```
ansible-playbook playbooks/host_tasks/wartortle.satstack/samourai.yml --tags samourai
```

## troubleshooting

```
podman inspect samourai
```