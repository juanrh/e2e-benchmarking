#!/usr/bin/env bash

# Small parameters to use for development

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# From https://github.com/cloud-bulldozer/kube-burner/releases
## This downloads kubeburner to $(pwd)
export KUBE_BURNER_RELEASE_URL='https://github.com/cloud-bulldozer/kube-burner/releases/download/v0.16.1/kube-burner-0.16.1-Darwin-x86_64.tar.gz'
# I don't have a elasticsearch instance
export ENABLE_INDEXING=false

# Setting up a small scenario for this first test
export PODS_PER_NODE=10
export POD_CHURNING_PERIOD='1m'
export NUMBER_OF_NS=2
export WRITE_TO_FILE=true
## to use my metrics file 
export METRICS=${SCRIPT_DIR}/metrics.yaml
