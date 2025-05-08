#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2086,SC2154,SC2034

load ./../helper

@test "Install istio minimal profile" {
  info
  test(){
    apply katalog/istio/profiles/sidecar/base
  }
  loop_it test 30 2
  status=${loop_it_result}
  [ "$status" -eq 0 ]
}

@test "Wait for istio package to be running" {
  info
  test(){
    retry_counter=0
    max_retry=50
    while true; do
      not_ready=$(kubectl get pods -n istio-system --no-headers | grep -v '1/1 *Running' || true)
      if [ -z "$not_ready" ]; then
        break
      fi
      echo -n "Pods not ready in istio-system namespace:" >&3
      echo "$not_ready" >&3

      [ $retry_counter -lt $max_retry ] || (kubectl describe all -n istio-system >&2 && return 1)
      sleep 10 && echo "# waiting..." $retry_counter >&3
      retry_counter=$(( retry_counter + 1 ))
    done
  }
  run test
  [ "$status" -eq 0 ]
}
