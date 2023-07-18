# tor

Runs a forked version of systemli.onion that sets up private [bridges](https://support.torproject.org/glossary/#bridge) to act as tor [guards](https://support.torproject.org/glossary/#guard), and configure homelab machines to use them.

* [ ] obs4
* [ ] [auto-updates](https://github.com/NewNewYorkBridges/ansible-tor-bridge/blob/main/templates/50unattended-upgrades.j2)

## troubleshooting

```bash
curl --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/
journalctl -fu tor@default
```