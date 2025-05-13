# Migration procedure from IstioOperator to Istio manifest installation

> ⚠️ If you're migrating from a previous IstioOperator installation, use our migration script to extract your current configurations:

## Prerequisites

Make sure you have these tools in path

| Tool                                    | Version    |
| --------------------------------------- | ---------- |
| [istioctl][istioctl-repo]               | `1.25.2`   |
| [yq][yq-repo]                           | `v4.45.1`  |
| [kube-slice][kube-slice-repo]           | `v1.4.2`   |


### Step 1: extract current resources

- Place the script `docs/migration/istioOperator-to-istio/export_istio_resources.sh` in your installation directory
- Place your Istio Operator manifest file at the same level and rename it to `gateways.yaml`
- Run the script:

```bash
bash export_istio_resources.sh
```

This will generate the following strcture:

```bash
gateway-split/
├── configmap/
│   └── istio.yaml
├── ingress-gateway/
│   └── *.yaml
└── egress-gateway/
    └── *.yaml
```

### Step 2: set up kustomize configuration
Once we have extracted the resources, it is up to us to implement them in our plugin root in the way we prefer, split down into sub-modules with their kustomize file. 
> Note:  Due to the strategy of the vendoring, the istio config and default ingressgateway and its resources must be patched

> - If a component exists in the base profile, use patches
> - If it doesn't, add it as a resource
When you have updated your `kustomization.yaml`, you must have a similar patching like the example in the following:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../vendor/katalog/service-mesh/istio/profiles/sidecar/base
  - ../vendor/katalog/service-mesh/kiali

  # Components not included in the base profile
  - gateway-split/egress-gateway/deployment-istio-egressgateway.yaml
  - gateway-split/egress-gateway/service-istio-egressgateway.yaml
  - gateway-split/egress-gateway/horizontalpodautoscaler-istio-egressgateway.yaml
  - gateway-split/egress-gateway/poddisruptionbudget-istio-egressgateway.yaml
  - gateway-split/egress-gateway/role-istio-egressgateway-sds.yaml
  - gateway-split/egress-gateway/rolebinding-istio-egressgateway-sds.yaml
  - gateway-split/egress-gateway/serviceaccount-istio-egressgateway-service-account.yaml

  # Custom gateways (if you have any)
  - gateway-split/ingress-gateway/deployment-istio-ingressgateway-custom.yaml
  - gateway-split/ingress-gateway/service-istio-ingressgateway-custom.yaml

patches:
  - path: gateway-split/ingress-gateway/deployment-istio-ingressgateway.yaml
  - path: gateway-split/ingress-gateway/service-istio-ingressgateway.yaml
  - path: gateway-split/configmap/istio.yaml
```


### Step 3: analyze the differences against your environment

```bash
kustomize build . | kubectl diff -f - > diff.diff
```

### Step 4: remove the operator

```bash
kubectl -n istio-operator delete deployment istio-operator
kubectl delete customresourcedefinitions istiooperators.install.istio.io
kubectl -n istio-system patch istiooperators.install.istio.io istio -p '{"metadata":{"finalizers":[]}}' --type=merge
```

### Step 5: finally, apply the new manifests

```bash
kustomize build . | kubectl apply -f -
```

### Step 5: clean up old operator-related resources (from istio-operator namespace)

```bash
kubectl -n istio-operator delete deployment istio-operator
kubectl -n istio-operator delete serviceaccount istio-operator
kubectl -n istio-operator delete service istio-operator
kubectl delete clusterrole istio-operator
kubectl delete clusterrolebinding istio-operator
kubectl delete namespace istio-operator
```

## Examples

### Basic Kustomization configuration

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../vendor/katalog/service-mesh/istio/profiles/sidecar/base

patches:
  - path: gateway-split/configmap/istio.yaml
```

### Kustomization with multiple gateways

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../vendor/katalog/service-mesh/istio/profiles/sidecar/base
  - ../vendor/katalog/service-mesh/kiali

  # Egress gateway resources
  - gateway-split/egress-gateway/deployment-istio-egressgateway.yaml
  - gateway-split/egress-gateway/service-istio-egressgateway.yaml

  # Custom TCP gateway
  - gateway-split/ingress-gateway/deployment-istio-ingressgateway-tcp.yaml
  - gateway-split/ingress-gateway/service-istio-ingressgateway-tcp.yaml

  # Custom TLS gateway
  - gateway-split/ingress-gateway/deployment-istio-ingressgateway-tls2.yaml
  - gateway-split/ingress-gateway/service-istio-ingressgateway-tls2.yaml

patches:
  - path: gateway-split/ingress-gateway/deployment-istio-ingressgateway.yaml
  - path: gateway-split/ingress-gateway/service-istio-ingressgateway.yaml
  - path: gateway-split/configmap/istio.yaml
```

## Troubleshooting

### Conflicts

If you encounter errors like:

```bash
may not add resource with an already registered id
```

It could mean you're trying to include a resource that already exists in the base profile.

Check if the resource exists in the base profile:

```bash
kustomize build ../vendor/katalog/service-mesh/istio/profiles/sidecar/base | grep "resource-name"
```

and if it exists, move it from `resources` to `patches`.

<!-- links -->
[istioctl-repo]: https://istio.io/latest/docs/ops/diagnostic-tools/istioctl/#install-hahahugoshortcode971s2hbhb
[yq-repo]: https://github.com/mikefarah/yq
[kube-slice-repo]: https://github.com/patrickdappollonio/kubectl-slice