# oneshot: doas

Requires root. Example inventory:

```ini
[doas:vars]
ansible_user=root
```

Ubuntu requires setting a root password before `sudo` can be removed.