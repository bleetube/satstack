# command shell

## podman

```.bashrc
repod() {
    systemctl --user restart "container-${1}.service"
    podman logs --tail=0 --follow $1
}
```
