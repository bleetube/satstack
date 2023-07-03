# chesnaught

Warning: the ssl_ocsp_responder will cause `nginx -t` to hang if there is no internet connectivity.

## node info

OS: Ubuntu 22.04
Running:

* mempool - docker, mariadb
* samourai - docker, mariadb
* SRE stack

## samourai

This is a container for the samourai dojo node tracker. There is a convenient `./docker/chesnaught/scripts/generate-passwords.sh` script to quickly set up the required passwords. The rest of the runtime applications need to be setup by some other means:

* bitcoind
* tor
* electrs

And the `samouari.env` needs to be configured accordingly.

The container has a data-tor volume that the node script wants for some reason. (needs review, consider blocking all outbound connectivity and allowing connections only to bitcoind, electrs, etc.)

Remember to configure the bitcoind rpc credentials in bitcoin.conf: `./rpcauth.py samouari <pass>`

Dojo wants mariadb configured with:

```ini
[mysqld]
sql_mode="NO_ENGINE_SUBSTITUTION"
transaction_isolation=READ-COMMITTED
```

By default our sql_mode ends up being `STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION` which seems fine enough. [Transaction isolation](https://mariadb.com/docs/server/ref/mdb/system-variables/tx_isolation/) might be important so we'll set that too.

I kept the docker network intact since the container exposes three ports, which isn't much shorter than declaring a whole net. I at least resized the subnet properly instead of a whole /16.

## mempool

TODO:

* copy web container volume contents to static location for nginx caching (like peertube, see pancham)
* figure out why building from source fails

## jellyfin

* [vharmers/ansible-jellyfin](https://github.com/vharmers/ansible-jellyfin)

TODO: configure listening address to localhost only.

## docker

This is a bare metal machine, so all containers should build from source. Docker hub is [not a reliable trusted third party](https://news.ycombinator.com/item?id=35166317).

A major benefit to refactoring all of these containers to use runtimes orchestrated by Ansible is that I only need to build the stuff that doesn't already live in a repository. It also mimizes duplication, and avoids running multiple instances of multi-tenant platforms (such as databases). Instead, I am utilizing the multi-tenant nature of mariadb and mysql.

## misc

Saw this [repo](https://github.com/usmanatron/ansible_jellyfin) for a role that installs via docker. Might be interesting to review for educational purposes.
