# pancham

Tandoor needs:

* certbot
* docker
* nginx
* postgres

Peertube needs:

* certbot
* docker
* redis
* nginx
* postfix
* postgres + 2 extensions

Funny, the peertube container reads some config from /config/production.yaml, and some config from environment variables. For posterity:

* smtp config must be in the environment variables
* postgres config must be in production.yaml
* redis config must be in production.yaml
* the peertube secret must be in the environment variables

How do I even have the patience for this?

## Synapse (matrix)

Why docker? Synapse is built using Python and rust. Running in a container allows us to trivially adjust between release versions and build from source.

* https://matrix-org.github.io/synapse/latest/usage/configuration/config_documentation.html#registration
* https://matrix-org.github.io/synapse/latest/usage/administration/admin_api/index.html
* https://matrix-org.github.io/synapse/latest/turn-howto.html
* https://github.com/Awesome-Technologies/synapse-admin
* https://matrix-org.github.io/synapse/develop/reverse_proxy.html#synapse-administration-endpoints

ntfy was installed by hand using their heckel.io repo. See notes in wiki.js about ansible. It runs as `ntfy.service`.