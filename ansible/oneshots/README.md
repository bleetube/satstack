# oneshots

Quick and dirty setup scripts for bare metal machines and cheap VMs.

## doas

```bash
ansible-playbook oneshots/doas/main.yml -e "ansible_user=root" --limit <host>
```

* This is a oneshot because changing from sudo to doas midflight requires the inventory file should be changed.
* Ubuntu requires setting a root password before `sudo` can be removed.

## ssh

Learned this setup from NixOS.

```bash
ansible-playbook oneshots/ssh.yml -e "ansible_user=root" -e "sysadmin_username=ansible" --limit <host>
```

## ansible_user

Ansible requires `NOPASS`. On physically accessible systems where sudo or doas should require a passphrase, Ansible can use a dedicated account.

```bash
ansible-playbook oneshots/ansible_user.yml  -e "ansible_user=root"
ansible-playbook oneshots/doas/main.yml -e "ansible_user=root" -e "sysadmin_username=ansible" --limit <host>
ansible-playbook oneshots/ssh.yml -e "ansible_user=root" -e "sysadmin_username=ansible" --limit <host>
```
