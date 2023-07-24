# satstack

Codifed private infrastructure services built on open source. Composed with Ansible Roles, dockerless containers, and Nix.

* strfry nostr relay, matrix synapse, [disposable-mail aliases](https://github.com/bleetube/ansible-role-disposable-mail)
* lnbits, btcpayserver
* [jellyfin](https://github.com/bleetube/ansible-role-jellyfin), peertube, [castopod](https://github.com/bleetube/ansible-role-castopod)

Podman Containers for JS/PHP (better opsec, lower maintenance):
* [samourai-dojo](https://github.com/bleetube/ansible-role-samourai-dojo), [mempool.space](ansible/playbooks/containers/mempool/README.md), [ride-the-lightning](ansible/playbooks/containers/rtl/README.md)
* [nextcloud](ansible/playbooks/containers/nextcloud/README.md), [wiki.js](https://github.com/bleetube/ansible-role-wikijs), [changedetection](ansible/playbooks/containers/changedetection/README.md), [chat-with-gpt](ansible/playbooks/containers/chat-with-gpt/README.md)

Tools in packages provided by official upstream repositories

* <img src="docs/logos/grafana.svg" width="16" height="16"> [grafana](https://grafana.com/), <img src="docs/logos/prometheus.svg" width="16" height="16"> [prometheus](https://prometheus.io/), <img src="docs/logos/ntfy.svg" width="16" height="16"> [ntfy](https://ntfy.sh/)
* [nginx](https://nginx.org/en/), [acme-lego](https://go-acme.github.io/lego/), [certbot](https://certbot.eff.org/), [onion services](ansible/playbooks/tor/)
* [postgresql](https://www.postgresql.org/), [mariadb](https://mariadb.org/)

NixOS:

* core-lightning, lnd
* [ln-ws-proxy](https://github.com/jb55/ln-ws-proxy), [bitcoind and electrs](nix/chespin.satstack.net/configuration.nix)
* vaultwarden, miniflux

[Monitoring](ansible/host_vars/wartortle.satstack.net/prometheus.yml) and [backups](scripts/backups/) are built-in where appropriate. 