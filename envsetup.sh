#!/usr/bin/env bash
set -euo pipefail

if [[ "$EUID" -eq 0 ]]; then
	SUDO=()
else
	if ! command -v sudo >/dev/null 2>&1; then
		echo "sudo is required to install host build dependencies." >&2
		exit 1
	fi
	SUDO=(sudo)
fi

if command -v apt-get >/dev/null 2>&1; then
	"${SUDO[@]}" apt-get update
	"${SUDO[@]}" apt-get install -y build-essential bc bison flex libssl-dev libelf-dev libncurses-dev perl python3 git zip
elif command -v dnf >/dev/null 2>&1; then
	"${SUDO[@]}" dnf install -y gcc gcc-c++ make bc bison flex openssl-devel elfutils-libelf-devel ncurses-devel perl python3 git zip
elif command -v pacman >/dev/null 2>&1; then
	"${SUDO[@]}" pacman -S --needed --noconfirm base-devel bc bison flex openssl libelf ncurses perl python git zip
else
	echo "Unsupported package manager. Install the host dependencies listed in BUILDING.md." >&2
	exit 1
fi
