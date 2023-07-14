# bitwarden

WIP
https://github.com/dani-garcia/vaultwarden
vaultwarden role https://github.com/JensTimmerman/ansible-role-vaultwarden/ 
setup.sh role https://github.com/e-breuninger/ansible-role-bitwarden

maybe nixOS, check $HOME/src/nixpkgs

## requirements

* [nginx](nginx_conf.yml)

## variables

See [host_vars](../../../host_vars/wartortle.satstack.net/bitwarden.yml)

## deployment example

```shell
ansible-playbook playbooks/host_tasks/wartortle.satstack/bitwarden.yml
```

## systemd

```shell
systemctl --user status container-bitwarden.service
```

## updates

```shell
ansible-playbook playbooks/host_tasks/wartortle.satstack/bitwarden.yml --tags podman
```

## backups

```shell
rsync -tav root@${TARGET}:/var/compose/bitwarden $HOME/archive/${TARGET}/
```

Restore:

```shell
rsync -ta --delete bitwarden/ ${TARGET}:/var/compose/nextcloud/
```

## troubleshooting

```shell
podman logs --follow bitwarden
```