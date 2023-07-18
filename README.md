# satstack

This is my stack of orchestrated open source software for self-hosting personal, social, and financial infrastructure.

Core tools

* __Observability__: <img src="docs/logos/grafana.svg" width="16" height="16"> [Grafana](https://grafana.com/), <img src="docs/logos/prometheus.svg" width="16" height="16"> [Prometheus](https://prometheus.io/), <img src="docs/logos/ntfy.svg" width="16" height="16"> [ntfy](https://ntfy.sh/)
* __TLS/tor__: [nginx](https://nginx.org/en/), [acme-lego](https://go-acme.github.io/lego/), [certbot](https://certbot.eff.org/), [onion services](ansible/playbooks/tor/README.md)
* __Data__: [postgresql](https://www.postgresql.org/), [mariadb](https://mariadb.org/)

Podman Containers for JS/PHP (better opsec, lower maintenance)

* __Bitcoin__: [Samourai Dojo](https://github.com/bleetube/ansible-role-samourai-dojo), [mempool.space](ansible/playbooks/containers/mempool/README.md), [Ride-The-Lightning](ansible/playbooks/containers/rtl/README.md)
* __Tools__: [nextcloud](ansible/playbooks/containers/nextcloud/README.md), [changedetection](ansible/playbooks/containers/changedetection/README.md), [chat-with-gpt](ansible/playbooks/containers/chat-with-gpt/README.md)

NixOS (WIP):

* __nixBitcoin__: bitcoind, electrs, core-ln
* __Personal__: vaultwarden

Monitoring and backups are built-in. The aim is to build an opinionated home network effectively from scratch and minimize long-term maintenance.