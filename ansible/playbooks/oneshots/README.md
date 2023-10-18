# oneshots

Quick and dirty setup scripts for bare metal machines and cheap VMs.

## doas

```bash
ansible-playbook oneshots/doas/main.yml -e "ansible_user=root" --limit <host>
```

* This is a oneshot because changing from sudo to doas midflight requires the inventory file to be changed.
