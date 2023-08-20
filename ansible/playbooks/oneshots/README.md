# oneshots

Quick and dirty setup scripts for bare metal machines and cheap VMs.

## doas

```bash
ansible-playbook oneshots/doas/main.yml -e "ansible_user=root" --limit <host>
```

* This is a oneshot because changing from sudo to doas midflight requires the inventory file should be changed.
* Ubuntu requires setting a root password before `sudo` can be removed.
