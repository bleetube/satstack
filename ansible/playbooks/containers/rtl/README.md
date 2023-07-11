# RTL

[Ride-The-Lightning/RTL](https://github.com/Ride-The-Lightning/RTL)

In practice RTL is particularly useful just to check on my node when Zeus is acting up. It will probably become more useful when anchor outputs get implemented widely and we can use Lightning Ads!

## variables

See `host_vars/wartortle../rtl.yml`

## deployment

Configure variables and then run all the tasks from a playbook for the target host. Example:

```
ansible-playbook playbooks/host_tasks/wartortle.satstack.net.yml
```

## Upgrades

Update [versions.yml](../../../group_vars/all/versions.yml) and run the podman_container module:

```
ansible-playbook playbooks/host_tasks/wartortle.satstack.net.yml --tags podman
```