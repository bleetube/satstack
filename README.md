# <img src="docs/logos/bitcoin.svg" width="24" height="24"> satstack

Codifed private infrastructure services built on open source. Composed with Ansible Roles, dockerless containers, and Nix.

* [<img src="docs/logos/strfry.svg" width="26.53238788475561" height="16"> strfry nostr relay](https://github.com/bleetube/ansible-role-strfry)+[snort](https://github.com/bleetube/ansible-role-snort), [<img src="docs/logos/matrix.svg" width="16" height="16"> matrix-synapse](https://github.com/bleetube/ansible-role-synapse), [disposable-mail aliases](https://github.com/bleetube/ansible-role-disposable-mail)
* [<img src="docs/logos/jellyfin.png" width="16" height="16"> jellyfin](https://github.com/bleetube/ansible-role-jellyfin), [<img src="docs/logos/peertube.png" width="16" height="16"> peertube](https://github.com/bleetube/ansible-role-peertube), [<img src="docs/logos/castopod.svg" width="23.6" height="16"> castopod](https://github.com/bleetube/ansible-role-castopod)
* lnbits, fedi alpha, btcpayserver

Podman Containers for JS/PHP (better opsec, lower maintenance):
* [<img src="docs/logos/samourai.png" width="16" height="16"> samourai-dojo](https://github.com/bleetube/ansible-role-samourai-dojo), <img src="docs/logos/mempool.png" width="16" height="16"> mempool.space, [<img src="docs/logos/rtl.png" width="16" height="16"> ride-the-lightning](ansible/playbooks/host_tasks/wartortle.satstack.net/rtl/README.md)
* [<img src="docs/logos/nextcloud.png" width="16" height="16"> nextcloud](https://github.com/bleetube/ansible-role-nextcloud), [<img src="docs/logos/wikijs.png" width="16" height="16"> wiki.js](https://github.com/bleetube/ansible-role-wikijs), [changedetection](ansible/playbooks/host_tasks/wartortle.satstack.net/changedetection/README.md), [chat-with-gpt](ansible/playbooks/host_tasks/wartortle.satstack.net/chat-with-gpt/README.md)

Tools in packages provided by official upstream repositories

* [<img src="docs/logos/grafana.svg" width="16" height="16"> grafana](ansible/playbooks/observability/main.yml), [<img src="docs/logos/prometheus.svg" width="16" height="16"> prometheus](ansible/host_vars/wartortle.satstack.net/prometheus.yml), [<img src="docs/logos/ntfy.svg" width="16" height="16"> ntfy](https://github.com/bleetube/ansible-role-ntfy)+[alertmanager](https://github.com/bleetube/ansible-role-ntfy-alertmanager)
* [<img src="docs/logos/nginx.png" width="16" height="16"> nginx](ansible/playbooks/nginx/main.yml), [acme-lego](https://github.com/bleetube/ansible-role-lego), <img src="docs/logos/tor.png" width="16" height="16"> tor onion services
* [postgresql](ansible/playbooks/postgresql.yml), [mariadb](ansible/playbooks/mariadb.yml), [redis](https://github.com/bleetube/ansible-role-redis)

Nix:

* [<img src="docs/logos/nix-bitcoin.png" width="17" height="16"> nix-bitcoin](nix/chespin.satstack.net/configuration.nix) with ln-ws-proxy, <img src="docs/logos/vaultwarden.png" width="16" height="16"> vaultwarden, <img src="docs/logos/miniflux.png" width="16" height="16"> miniflux
* [stable-diffusion-webui](nix/charmander.satstack.net/configuration.nix) and steam

And [<img src="docs/logos/wireguard.png" width="16" height="16"> wireguard](https://github.com/bleetube/ansible-role-wireguard) configuration management for managing your own VPN services.