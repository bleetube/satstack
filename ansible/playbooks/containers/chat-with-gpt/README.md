# chat-with-gpt

* [cogentapps/chat-with-gpt](https://github.com/cogentapps/chat-with-gpt)

Better than using the official web-app.

## requirements

* [nginx](nginx_conf.yml)

## deployment example

```shell
ansible-playbook playbooks/host_tasks/wartortle.satstack/chat-with-gpt.yml
```

## systemd

```
systemctl --user status container-chat-with-gpt.service
```

## updates

```
ansible-playbook playbooks/host_tasks/wartortle.satstack/chat-with-gpt.yml --tags podman
```

## troubleshooting

```
podman logs --follow chat-with-gpt
```