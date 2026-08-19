#!/usr/bin/env bash
set -euo pipefail

# Installs the NordVPN client. The RPM creates the `nordvpn` group and ships its
# units to /etc/systemd/system; nordvpnd.service is enabled in common.yml.
#
# Known limitation: the killswitch depends on iptables-legacy, which Fedora no
# longer uses by default, and NordVPN deprecated Fedora support at 42. Baking in
# iptables-legacy (still packaged, 1.8.11-13.fc44) was considered and rejected: not
# worth carrying a deprecated firewall backend for one feature.

ARCH=$(uname -m)
BASE_URL=https://repo.nordvpn.com
KEY_PATH=/gpg/nordvpn_public.asc
REPO_PATH=/yum/nordvpn/centos

rpm -v --import "${BASE_URL}${KEY_PATH}"

repo="${BASE_URL}${REPO_PATH}/${ARCH}"
dnf5 config-manager addrepo --id="nordvpn" --set=baseurl="${repo}" --set=enabled=1 --overwrite
dnf5 install -y nordvpn
