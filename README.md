# satstack

Codifed private infrastructure services built on open source. Composed with Ansible Roles, dockerless containers, and Nix.

* [strfry nostr relay](https://github.com/bleetube/ansible-role-strfry), [matrix-synapse](https://github.com/bleetube/ansible-role-synapse), [disposable-mail aliases](https://github.com/bleetube/ansible-role-disposable-mail)
* [jellyfin](https://github.com/bleetube/ansible-role-jellyfin), peertube, [castopod](https://github.com/bleetube/ansible-role-castopod)
* lnbits, fedi alpha, btcpayserver

Podman Containers for JS/PHP (better opsec, lower maintenance):
* [samourai-dojo](https://github.com/bleetube/ansible-role-samourai-dojo), [mempool.space](ansible/playbooks/containers/mempool/README.md), [ride-the-lightning](ansible/playbooks/containers/rtl/README.md)
* [nextcloud](https://github.com/bleetube/ansible-role-nextcloud), [wiki.js](https://github.com/bleetube/ansible-role-wikijs), [changedetection](ansible/playbooks/containers/changedetection/README.md), [chat-with-gpt](ansible/playbooks/containers/chat-with-gpt/README.md)

Tools in packages provided by official upstream repositories

* <img src="docs/logos/grafana.svg" width="16" height="16"> [grafana](ansible/playbooks/observability/main.yml), <img src="docs/logos/prometheus.svg" width="16" height="16"> [prometheus](ansible/host_vars/wartortle.satstack.net/prometheus.yml), <img src="docs/logos/ntfy.svg" width="16" height="16"> [ntfy](https://github.com/bleetube/ansible-role-ntfy)+[alertmanager](https://github.com/bleetube/ansible-role-ntfy-alertmanager)
* [nginx](ansible/playbooks/nginx/main.yml), [acme-lego](https://github.com/bleetube/ansible-role-lego), [tor onion services](ansible/playbooks/tor/)
* [postgresql](ansible/playbooks/postgresql.yml), [mariadb](ansible/playbooks/mariadb.yml)

[NixOS](nix/chespin.satstack.net/configuration.nix):

* ln-ws-proxy, bitcoind and electrs
* vaultwarden, miniflux
