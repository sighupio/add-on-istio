# Ports of the istio-ingressgateway Service

- **Status-port (15021)**: Envoy health-check port (readiness/liveness probe).

- **http2 (80 → 8080, nodePort 31380)**: External HTTP/2 traffic: exposes port 80 → container port 8080; nodePort 31380 on cluster nodes.

- **https (443 → 8443, nodePort 31390)**: HTTPS traffic (TLS terminated by Envoy): exposes port 443 → container port 8443; nodePort 31390 on cluster nodes.

- **Tcp-istiod (15012, nodePort 31400)**: gRPC/XDS port used by Envoy to connect to Istiod (the control-plane), useful in multicluster or remote-pilot setups; exposed as nodePort 31400.

- **Tls (15443)**: TCP listener for TLS passthrough or SNI-based routing (e.g., end-to-end TLS or multicluster SNI-aware gateway).
