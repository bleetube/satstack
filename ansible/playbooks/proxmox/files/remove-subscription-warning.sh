#!/bin/bash
patch -N -r- /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/local/src/remove-subscription-warning.patch &&
	systemctl restart pveproxy.service
exit 0
