# debian upgrade

The cheap Virmach VMs start out on Debian 10 or Ubuntu 20.04. This is some helpful copypasta to bring them up so we can run Ansible.

Buster (10) to Bullseye (11)
```shell
apt -y update &&
apt -y upgrade &&
apt -y autoremove  &&
sed -i 's/buster\//bullseye-/' /etc/apt/sources.list &&
sed -i 's/buster/bullseye/' /etc/apt/sources.list &&
apt -y update &&
apt -y full-upgrade &&
reboot
```
Bullseye (11) to Bookworm (12)

```shell
apt -y update &&
apt -y upgrade &&
apt -y autoremove  &&
sed -i 's/bullseye/bookworm/' /etc/apt/sources.list &&
apt -y update &&
apt -y full-upgrade &&
reboot
```

Post ugprade:

```shell
apt -y autoremove &&
apt install -y doas
```