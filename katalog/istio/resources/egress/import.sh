#!/usr/bin/env bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC1128,SC2068,SC2086


# refresh.sh
# Create a kustomization.yaml and then add all kubernetes YAMLs into resources...
echo -n "
# built by ./refresh.sh
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
" > kustomization.yaml

yamls=$(find . -type f -name "*.yaml" | grep -v kustomization.yaml)

for y in ${yamls[@]}; do
  asdf exec kustomize edit add resource $y
done