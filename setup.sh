#!/bin/bash

set -ouex pipefail

sed -i 's@#pl_PL.UTF-8@pl_PL.UTF-8@g' /etc/locale.gen
locale-gen

sed -i '1s|^|Server = https://ftp.icm.edu.pl/pub/Linux/dist/archlinux/$repo/os/$arch\n|' /etc/pacman.d/mirrorlist
sed -i '1s|^|Server = https://ftp.psnc.pl/linux/archlinux/$repo/os/$arch\n|' /etc/pacman.d/mirrorlist
echo 'Server = https://archive.archlinux.org/.all' >> /etc/pacman.d/mirrorlist

pacman-key --init
pacman-key --populate

# BioArchLinux
pacman-key --recv-keys B1F96021DB62254D
pacman-key --finger B1F96021DB62254D
pacman-key --lsign-key B1F96021DB62254D
tee -a /etc/pacman.conf <<'EOF'
[bioarchlinux]
Server = https://repo.bioarchlinux.org/$arch
EOF

# Chaotic AUR
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
tee -a /etc/pacman.conf <<'EOF'
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF

# Arch4Edu
pacman-key --recv-keys 7931B6D628C8D3BA
pacman-key --finger 7931B6D628C8D3BA
pacman-key --lsign-key 7931B6D628C8D3BA
curl --retry 3 -sSLo /etc/pacman.d/mirrorlist.arch4edu https://raw.githubusercontent.com/arch4edu/mirrorlist/refs/heads/master/mirrorlist.arch4edu
tee -a /etc/pacman.conf <<'EOF'
[arch4edu]
Include = /etc/pacman.d/mirrorlist.arch4edu
EOF

pacman -Syu --noconfirm bioarchlinux-keyring arch4edu-keyring mirrorlist.arch4edu pkgstats
pacman -Scc --noconfirm
rm -rf /var/cache/pacman/pkg/*
