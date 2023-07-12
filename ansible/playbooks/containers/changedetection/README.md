# changedetection

* [dgtlmoon/changedetection.io](https://github.com/dgtlmoon/changedetection.io)

Useful for watching pages that I can't find an RSS feed for.

## requirements

* [nginx](nginx_conf.yml)

## deployment example

```shell
ansible-playbook playbooks/host_tasks/wartortle.satstack/changedetection.yml
```

## systemd

```shell
systemctl --user status container-changedetection.service
```

## updates

```shell
ansible-playbook playbooks/host_tasks/wartortle.satstack/changedetection.yml --tags podman
```

## backups

```shell
rsync -tav root@${TARGET}:/var/compose/changedetection $HOME/archive/${TARGET}/
```

Restore:

```shell
rsync -ta --delete changedetection/ ${TARGET}:/var/compose/changedetection/
```

## troubleshooting

```shell
podman logs --follow changedetection
```