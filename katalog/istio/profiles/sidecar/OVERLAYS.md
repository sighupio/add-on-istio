# Overlay Profile Structure


```
profiles/
└─ sidecar/
   ├─ base/
   │   └─ kustomization.yaml
   ├─ debug-logs/
   │   ├─ kustomization.yaml
   │   └─ patches/
   │       └─ patch-enable-debug-logs.yaml
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
   │   │       └─ patch-disable-telemetry.yaml

```