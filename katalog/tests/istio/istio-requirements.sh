#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2086,SC2154,SC2034

load ./../helper

@test "Install istio requirements" {
  info
  test(){
    apply katalog/tests/istio/requirements
  }
  loop_it test 30 2
  status=${loop_it_result}
  [ "$status" -eq 0 ]
}

@test "Wait for istio requirements to be running" {
  info
  test(){
    retry_counter=0
    max_retry=30
    while kubectl get pods -n monitoring | grep -ie "\(Pending\|Error\|CrashLoop\|ContainerCreating\|PodInitializing\|Init:\)" >&2
    do
      [ $retry_counter -lt $max_retry ] || ( kubectl describe all -n monitoring >&2 && return 1 )
      sleep 2 && echo "# waiting..." $retry_counter >&3
      retry_counter=$(( retry_counter + 1 ))
    done
  }
  run test
  [ "$status" -eq 0 ]
}
