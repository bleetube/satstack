# satstack

This is my stack of orchestrated open source software for self-hosting personal, social, and financial infrastructure.

Core tools

* __Observability__: <img src="docs/logos/grafana.svg" width="16" height="16"> [grafana](https://grafana.com/), <img src="docs/logos/prometheus.svg" width="16" height="16"> [prometheus](https://prometheus.io/), <img src="docs/logos/ntfy.svg" width="16" height="16"> [ntfy](https://ntfy.sh/)
* __TLS/tor__: [nginx](https://nginx.org/en/), [acme-lego](https://go-acme.github.io/lego/), [certbot](https://certbot.eff.org/), [onion services](ansible/playbooks/tor/)
* __Data__: [postgresql](https://www.postgresql.org/), [mariadb](https://mariadb.org/)

Podman Containers for JS/PHP (better opsec, lower maintenance)

* __Bitcoin__: [samourai-dojo](https://github.com/bleetube/ansible-role-samourai-dojo), [mempool.space](ansible/playbooks/containers/mempool/README.md), [ride-the-lightning](ansible/playbooks/containers/rtl/README.md)
* __Tools__: [nextcloud](ansible/playbooks/containers/nextcloud/README.md), [wiki.js](https://github.com/bleetube/ansible-role-wikijs), [changedetection](ansible/playbooks/containers/changedetection/README.md), [chat-with-gpt](ansible/playbooks/containers/chat-with-gpt/README.md)

NixOS (WIP):

* __nixBitcoin__: bitcoind, lightningd, electrs, [ln-ws-proxy](https://github.com/jb55/ln-ws-proxy)
* __Tools__: vaultwarden, miniflux

Monitoring and backups are built-in where appropriate. The aim is to build an opinionated home network effectively from scratch and minimize long-term maintenance.