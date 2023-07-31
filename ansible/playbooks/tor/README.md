# Ansible Playbook: onion services

This playbook runs a forked version of systemli.onion and uses host_vars to configure private [bridges](https://support.torproject.org/glossary/#bridge) to act as stable tor [guards](https://support.torproject.org/glossary/#guard), and configure homelab machines to use them. This is entirely for educational purposes.

* [ ] obs4
* [ ] [auto-updates](https://github.com/NewNewYorkBridges/ansible-tor-bridge/blob/main/templates/50unattended-upgrades.j2)

## Variables

See [host_vars](../../host_vars/wartortle.satstack.net/onion.yml)

## troubleshooting

```bash
curl --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/
journalctl -fu tor@default
```