#!/usr/bin/env bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC1128,SC2068


set -euo pipefail

# -----------------------------------------------------------------
# download_istio_full.sh
# 1) Gateway API CRDs → gatewayapi-crd/
# 2) Istio default mode → crd/ + default/
# 3) Istio ambient mode → ambient/
# -----------------------------------------------------------------

OUTDIR="${OUTDIR:-istio-split}"
ISTIOCTL_CMD="${ISTIOCTL_CMD:-asdf exec istioctl}"
SLICE_CMD="${SLICE_CMD:-kubectl-slice}"
GAPI_VERSION="${GAPI_VERSION:-v1.2.1}"

usage(){
  echo "Usage: $0 [--outdir DIR]"
  exit 1
}

# Parsing CLI
while [[ $# -gt 0 ]]; do
  case "$1" in
    --outdir) OUTDIR="$2"; shift 2 ;;
    *) usage ;;
  esac
done

echo "folding ${OUTDIR}/..."
rm -rf "${OUTDIR}"
mkdir -p \
  "${OUTDIR}/gatewayapi-crd" \
  "${OUTDIR}/crd" \
  "${OUTDIR}/default" \
  "${OUTDIR}/ambient"

# # 1) Download Gateway API CRDs
# GAPI_URL="https://github.com/kubernetes-sigs/gateway-api/releases/download/${GAPI_VERSION}/standard-install.yaml"
# echo "Download Gateway API CRDs (${GAPI_VERSION})..."
# curl -sL "${GAPI_URL}" > gatewayapi.yaml :contentReference[oaicite:0]{index=0}

# echo " CRD Unfold in ${OUTDIR}/gatewayapi-crd/..."
# $SLICE_CMD -f gatewayapi.yaml \
#   -o "${OUTDIR}/gatewayapi-crd" \

# rm gatewayapi.yaml

echo -e "\n Gen Istio [profile=default] manifest…"
$ISTIOCTL_CMD manifest generate \
  --set profile=default \
  --set values.global.istioNamespace=istio-system \
  > all-default.yaml

echo "  • Unfold CRD Istio → ${OUTDIR}/crd/"
$SLICE_CMD -f all-default.yaml \
  -o "${OUTDIR}/crd" \
  --include-kind CustomResourceDefinition \
  --skip-non-k8s \
  --prune                                                  :contentReference[oaicite:2]{index=2}

echo "  • Unfold risorse default → ${OUTDIR}/default/"
$SLICE_CMD -f all-default.yaml \
  -o "${OUTDIR}/default" \
  --exclude-kind CustomResourceDefinition \
  --skip-non-k8s \
  --prune                                                  :contentReference[oaicite:3]{index=3}

rm all-default.yaml

echo -e "\n Gen Istio [profile=ambient] manifest…"
$ISTIOCTL_CMD manifest generate \
  --set profile=ambient \
  --set values.global.istioNamespace=istio-system \
  > all-ambient.yaml

echo " • Unfold risorse ambient → ${OUTDIR}/ambient/"
$SLICE_CMD -f all-ambient.yaml \
  -o "${OUTDIR}/ambient" \
  --exclude-kind CustomResourceDefinition \
  --skip-non-k8s \
  --prune                                                  :contentReference[oaicite:4]{index=4}

rm all-ambient.yaml
