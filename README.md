# bazzite-docker-vpn &nbsp; [![bluebuild build badge](https://github.com/sals1994/bluebuild-dms-niri/actions/workflows/build.yml/badge.svg)](https://github.com/sals1994/bluebuild-dms-niri/actions/workflows/build.yml)

[Bazzite](https://bazzite.gg) (KDE) with **Docker CE** and **NordVPN** baked in, and
nothing else.

Everything else — the desktop, the OGC kernel, Steam/Proton/gamescope, HDR, controller
firmware, NVIDIA drivers — comes from Bazzite and is deliberately not configured here.
The image exists only to bake in those two packages: layered onto a running host they
would be re-resolved against every Bazzite update, so a broken third-party repo would
block system updates. Baked in, that failure shows up as a red CI badge instead.

| Variant | Image | Base |
| --- | --- | --- |
| Standard | `ghcr.io/sals1994/bazzite-docker-vpn` | `ghcr.io/ublue-os/bazzite` |
| NVIDIA | `ghcr.io/sals1994/bazzite-docker-vpn-nvidia` | `ghcr.io/ublue-os/bazzite-nvidia-open` |

The NVIDIA variant uses the **open** kernel modules, which require a Turing (RTX 2000)
or newer GPU. Both track Bazzite's `stable` tag.

## Installation

Install [Bazzite](https://bazzite.gg) normally, then rebase once:

```bash
# 1. rebase to the unsigned image first, to get the signing keys and policies installed
sudo bootc switch --transport registry ghcr.io/sals1994/bazzite-docker-vpn:latest
systemctl reboot

# 2. then rebase to the signed image
sudo bootc switch --enforce-container-sigpolicy ghcr.io/sals1994/bazzite-docker-vpn:latest
systemctl reboot
```

### Post-install (once per machine)

The image creates the `docker` and `nordvpn` groups and enables `docker.socket` and
`nordvpnd.service`, but your user still has to be added to the groups:

```bash
sudo usermod -aG docker,nordvpn "$USER"
```

Log out and back in for it to take effect.

> [!NOTE]
> NordVPN's **killswitch is expected not to work**. It depends on `iptables-legacy`,
> which Fedora no longer uses by default, and NordVPN dropped Fedora support at 42.
> Carrying a deprecated firewall backend for one feature was judged not worth it.

### Migrating from `bluebuild-dms-niri`

This repo used to build a niri + Dank Material Shell image. That image is gone and is no
longer built; its final state is tagged [`niri-dms-final`](../../tree/niri-dms-final).
Machines still tracking it will **silently stop receiving updates** — there is no
redirect. Run the `bootc switch` above once per machine to move over.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s
[cosign](https://github.com/sigstore/cosign). Download `cosign.pub` from this repo and:

```bash
cosign verify --key cosign.pub ghcr.io/sals1994/bazzite-docker-vpn
```
