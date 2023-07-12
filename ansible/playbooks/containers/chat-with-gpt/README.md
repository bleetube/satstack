# chat-with-gpt

* [cogentapps/chat-with-gpt](https://github.com/cogentapps/chat-with-gpt)

## requirements

* nginx

See the related playbook(s).

## systemd usage

```
systemctl --user status container-chat-with-gpt.service
```

## Updates

Versioning is non-existent, so just redeploy the container:

```
ansible-playbook playbooks/host_tasks/wartortle.satstack/chat-with-gpt.net.yml --tags podman
```

## Troubleshooting

```
podman logs --follow chat-with-gpt
```