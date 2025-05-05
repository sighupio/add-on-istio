
```
profiles/
└─ sidecar/
   ├─ base/
   │   └─ kustomization.yaml       
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
   ├─ debug-logs/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ patch-enable-debug-logs.yaml
   ├─ resource-tuning/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ patch-resource-tuning.yaml
   ├─ core-dump/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ patch-enable-core-dump.yaml
   ├─ telemetry-legacy/
   │   ├─ telemetry-legacy/
   │   │    ├─ kustomization.yaml
   │   │    └─ patches/
   │   │       └─ patch-disable-telemetry-v2.yaml
   │   ├─ tempo/
   │   │    ├─ kustomization.yaml
   │   │    └─ resource/
   │   │       └─ tempo-telemetry.yaml
   │   └─ jaeger/
   │   │    ├─ kustomization.yaml
   │   │    └─ resource/
   │   │       └─ jaeger-telemetry.yaml
   ├─ wasm-filter/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ envoyfilter-wasm.yaml
   ├─ sds-enabled/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ patch-enable-sds.yaml
   ├─ egress-policy/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ serviceentry-external.yaml
   ├─ workloadentry-support/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ workloadentry-external.yaml
   └─ hpa-gateway/
       ├─ kustomization.yaml
       └─ patches/
           └─ hpa-egressgateway.yaml

```