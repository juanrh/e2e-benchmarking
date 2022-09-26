#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mkdir -p "${SCRIPT_DIR}/logs"

function date_w_format {
  date +%Y-%m-%d--%H-%M-%S
}

function log {
    log_file="${1}"
    msg="${2}"

    touch "${log_file}"
    echo "[$(date_w_format)] ${msg}" | tee -a "${log_file}"
}

function create_cluster {
    CLUSTER_NAME="${1}"
    NUM_WORKERS="${2}"

    log_file="${SCRIPT_DIR}/logs/create_cluster-$(date_w_format).log"
    echo "Using log file ${log_file}"
    temp_dir=$(mktemp -d)
    
    SSH_KEY=$(cat ${SSH_KEY_PATH})
    export SSH_KEY
    PULL_SECRET=$(cat ${PULL_SECRET_PATH})
    export PULL_SECRET
    export CLUSTER_NAME
    export NUM_WORKERS
    install_config_file="${temp_dir}/install-config.yaml"
    < "${SCRIPT_DIR}/config/install-config.template.yaml" envsubst > "${install_config_file}"
    install_config_redacted=$(grep -v pullSecret "${install_config_file}" | grep -v ssh)
    log "${log_file}" "Using install configuration ${install_config_redacted}"

    openshift-install --dir="${temp_dir}" create cluster 2>&1 | tee -a "${log_file}"

    unset SSH_KEY
    unset PULL_SECRET
    unset CLUSTER_NAME
    unset NUM_WORKERS

    rm -rf "${temp_dir}"
    echo
    echo "See logs at ${log_file}"
}