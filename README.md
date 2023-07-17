# satstack

This is my stack of orchestrated open source software for self-hosting personal, social, and financial infrastructure.

Core tools

* __Observability__: <img src="docs/logos/grafana.svg" width="16" height="16"> [Grafana](https://grafana.com/), <img src="docs/logos/prometheus.svg" width="16" height="16"> [Prometheus](https://prometheus.io/), <img src="docs/logos/ntfy.svg" width="16" height="16"> [ntfy](https://ntfy.sh/)
* __TLS__: [nginx](https://nginx.org/en/), [acme-lego](https://go-acme.github.io/lego/), [certbot](https://certbot.eff.org/)
* __Data__: [postgresql](https://www.postgresql.org/), [mariadb](https://mariadb.org/)
* __Mail__: [postfix](http://www.postfix.org/), [dovecot](https://www.dovecot.org/)

Podman Containers for JS/PHP (better opsec, lower maintenance)

* AI: [chat-with-gpt](ansible/playbooks/containers/chat-with-gpt/README.md)
* Bitcoin: [Samourai Dojo](https://github.com/bleetube/ansible-role-samourai-dojo), [mempool.space](ansible/playbooks/containers/mempool/README.md), [Ride-The-Lightning](ansible/playbooks/containers/rtl/README.md)
* Tools: [nextcloud](ansible/playbooks/containers/nextcloud/README.md), [changedetection](ansible/playbooks/containers/changedetection/README.md)

Monitoring and backups are built-in. The aim is to build an opinionated home network effectively from scratch and minimize long-term maintenance.