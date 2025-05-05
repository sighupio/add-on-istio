#!/bin/bash -e
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