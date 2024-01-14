# RTL

Note: v0.15.0 of RTL has breaking changes, this playbook needs updating.
* create a file with the rune: `echo "LIGHTNING_RUNE=\"$(lightning-cli commando-rune | jq -r .rune)\"" > .rune`
* configure the [rune path](https://github.com/Ride-The-Lightning/RTL/blob/master/.github/docs/Application_configurations.md) in RTL
* the RTL-config.json in /var/compose is spurious, iirc this pod is using env variables
* we probably dont need a macaroon anymore with clnrest

[Ride-The-Lightning/RTL](https://github.com/Ride-The-Lightning/RTL)

This deployment has extra steps due to handling sensitive macaroon material. Upgrades are a single command though.

## variables

See [host_vars](../../../host_vars/wartortle.satstack.net/rtl.yml)

## deployment example

* Generate an app password and source it into the environment. Then run the setup tasks.

```
pass generate -n satstack.net/wartortle/RTL_PASS
export wartortle_RTL_PASSWORD=$(pass satstack.net/wartortle/RTL_PASS)
ansible-playbook playbooks/host_tasks/wartortle.satstack.net/rtl.yml --tags setup
```

* Copy the sensitive `access.macaroon` (which is a plaintext admin macaroon) from your [cl-rest](https://github.com/saubyk/c-lightning-REST) to /var/compose/.secrets/lightningd/

* Run the rest of the play and let systemd start the container

    ```
    ansible-playbook playbooks/host_tasks/wartortle.satstack.net/rtl.yml
    systemctl --user restart container-RTL.service
    podman logs --follow RTL
    ```
    
## systemd

```
systemctl --user status container-RTL.service
```


## upgrades

```
ansible-playbook playbooks/host_tasks/wartortle.satstack.net/rtl/main.yml --tags podman
```

## troubleshooting

```shell
podman inspect RTL | jq
```

Drop this in your bashrc:

```shell
repod() {
    systemctl --user restart "container-${1}.service"
    podman logs --tail=0 --follow $1
}
```

Then you get nice output when you `repod RTL`.