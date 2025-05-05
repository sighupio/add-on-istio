# Telemetry Patch Overlay(WIP) 

## Jaeger Tracing
WIP
## Tempo Tracing
WIP

## telemetry Draw of internal dependencies from v1 to v2(WIP)
flowchart LR
  Client --> Envoy[Envoy proxy]
  subgraph Data-plane (Envoy WASM)
    Envoy -->|generate spans| TelemetryWASM[Telemetry WASM filter]
    TelemetryWASM -->|export via Zipkin| Jaeger[Jaeger collector]
    TelemetryWASM -->|export via OTLP| Tempo[Tempo (OTLP)]
  end
  Istiod[Control-plane] -->|XDS config| Envoy