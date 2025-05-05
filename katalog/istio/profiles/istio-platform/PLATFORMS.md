# Istio Platforms(WIP)

In this package we collect all resources we need for advanced Istio Setups


```
istio-platforms/
   ├─ strict-mtls/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       ├─ patch-strict-mtls.yaml
   │       └─ patch-destrules-global.yaml
   ├─ permissive-mtls/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ patch-permissive-mtls.yaml
   ├─ disable-mtls/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ patch-disable-mtls.yaml
   ├─ wasm-filter/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ envoyfilter-wasm.yaml
   ├─ egress-policy/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ serviceentry-external.yaml
   ├─ workloadentry-support/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ workloadentry-external.yaml
```