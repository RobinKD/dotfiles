#!/usr/bin/env bash
set -euo pipefail

PKG_DIR="$1"
DEFAULT_NIX="$PKG_DIR/default.nix"

URL_PREFIX="https://download2.interactivebrokers.com/installers/tws/latest-standalone"
URL_JSON="$URL_PREFIX/version.json"
URL_INSTALLER="$URL_PREFIX/tws-latest-standalone-linux-x64.sh"

UPSTREAM_VERSION=$(curl $URL_JSON | sed 's/twslatest_callback({"buildVersion":"\(.*\)","buildDateTime.*/\1/')
LOCAL_VERSION=$(grep -Po 'version = "\K([^"]*)' "$DEFAULT_NIX")
echo 'Upstream:' $UPSTREAM_VERSION
echo 'Local:' $LOCAL_VERSION

if [ "$UPSTREAM_VERSION" != "$LOCAL_VERSION" -a -n "$UPSTREAM_VERSION" ]; then
	sed -i -e 's/version = ".*/version = "'$UPSTREAM_VERSION'";/' "$DEFAULT_NIX"
	HASH=$(nix-prefetch-url $URL_INSTALLER --executable | xargs nix hash convert --hash-algo sha256)
	echo 'HASH: '$HASH
	sed -i -e 's|sha256 = ".*|sha256 = "'$HASH'";|' "$DEFAULT_NIX"
fi
