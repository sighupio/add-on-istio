#!/usr/bin/env bash

# You can change this variable to download a different version

VERSION='2.4.3'

# Run the following script to automatically detect the operating system and download Kuma:

curl -L https://kuma.io/installer.sh | VERSION=$VERSION sh -

# You can omit the VERSION variable to install the latest version.

# Add the kumactl executable to your path and cleanup:

cp kuma-${VERSION}/bin/kumactl ./kumactl

rm -rf kuma-${VERSION}
