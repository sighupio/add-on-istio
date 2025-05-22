#!/usr/bin/env bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------
# export_istio_resources.sh
# Exporting from gateways.yaml(or other name):
#  - ConfigMap "istio"
#  - All resources (Deployment, Service, HPA, PDB, Role/SDS, SA…) 
#    for ingress- and egress-gateway
# -----------------------------------------------------------------
OUTDIR="${OUTDIR:-gateway-split}"      
GATEWAYS_YAML="${GATEWAYS_YAML:-gateways.yaml}"
ISTIOCTL_CMD="${ISTIOCTL_CMD:-istioctl}"
YQ_CMD="${YQ_CMD:-yq e}"
SLICE_CMD="${SLICE_CMD:-kubectl-slice}"

echo "Make resource structure in ${OUTDIR}/..."
rm -rf "${OUTDIR}"
mkdir -p \
  "${OUTDIR}/configmap" \
  "${OUTDIR}/ingress-gateway" \
  "${OUTDIR}/egress-gateway"

echo "Generate manifest from ${GATEWAYS_YAML}…"
${ISTIOCTL_CMD} manifest generate -f "${GATEWAYS_YAML}" > all-gateways.yaml

echo "Extract ConfigMap istio → ${OUTDIR}/configmap/istio.yaml"
${YQ_CMD} 'select(.kind=="ConfigMap" and .metadata.name=="istio")' all-gateways.yaml \
  > "${OUTDIR}/configmap/istio.yaml"

# label app.kubernetes.io/name or operator.istio.io/component
INGRESS_FILTER='select(
  (.metadata.labels["app.kubernetes.io/name"] == "istio-ingressgateway") or
  (.metadata.labels["operator.istio.io/component"]  == "IngressGateways")
)'

echo "Extract resources ingress-gateway → ${OUTDIR}/ingress-gateway/ingress-gateway-resources.yaml"
${YQ_CMD} "${INGRESS_FILTER}" all-gateways.yaml \
  > "${OUTDIR}/ingress-gateway/ingress-gateway-resources.yaml"


echo "Splitting ingress-gateway resources into individual files…"
  ${SLICE_CMD} \
    --input-file="${OUTDIR}/ingress-gateway/ingress-gateway-resources.yaml" \
    --output-dir="${OUTDIR}/ingress-gateway" \
    --prune

# label app.kubernetes.io/name or operator.istio.io/component
EGRESS_FILTER='select(
  (.metadata.labels["app.kubernetes.io/name"] == "istio-egressgateway") or
  (.metadata.labels["operator.istio.io/component"]  == "EgressGateways")
)'

echo "Extract resources egress-gateway → ${OUTDIR}/egress-gateway/egress-gateway-resources.yaml"
${YQ_CMD} "${EGRESS_FILTER}" all-gateways.yaml \
  > "${OUTDIR}/egress-gateway/egress-gateway-resources.yaml"

echo "Splitting egress-gateway resources into individual files…"
  ${SLICE_CMD} \
    --input-file="${OUTDIR}/egress-gateway/egress-gateway-resources.yaml" \
    --output-dir="${OUTDIR}/egress-gateway" \
    --prune

rm all-gateways.yaml

echo -e "\n Gateway resources ready in:\n  • ${OUTDIR}/configmap/istio.yaml\n  • ${OUTDIR}/ingress-gateway/\n  • ${OUTDIR}/egress-gateway/"
