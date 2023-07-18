# tor

Sets up private [bridges](https://support.torproject.org/glossary/#bridge) to act as tor [guards](https://support.torproject.org/glossary/#guard), and configure homelab machines to use them.

Configures [onion services](https://support.torproject.org/glossary/#onion-services) for Samourai Dojo and lightningd.

See [ansible-relayor](https://github.com/nusenu/ansible-relayor) docs

* [ ] obs4
* [ ] [auto-updates](https://github.com/NewNewYorkBridges/ansible-tor-bridge/blob/main/templates/50unattended-upgrades.j2)


## troubleshooting

```bash
curl --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/
journalctl -fu tor@default
```