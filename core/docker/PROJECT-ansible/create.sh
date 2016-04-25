#!/bin/bash
set -eu

cd "$(dirname "$BASH_SOURCE")"
source ../../.pipeline-template/util/docker.sh

name="$(basename "$(pwd)")"

if ! image_exists "$name"; then
  echo "Building image $name..."
  ../../.pipeline-template/util/ensure-ssh-keys-generated
  cp ~/.ssh/id_rsa.pub .
  cp ../../requirements.yml .
  docker build -t $name .
fi

if ! container_exists "$name"; then
  echo "Creating container $name..."
  docker create -h $name --name $name \
    --security-opt seccomp=unconfined \
    --stop-signal=SIGRTMIN+3 \
    --tmpfs /run \
    --tmpfs /run/lock \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -t \
    -v "$(cd ../.. && pwd):/project" \
    -P \
    $name \
    >/dev/null
fi
