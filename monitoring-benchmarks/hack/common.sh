#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_ROOT="${SCRIPT_DIR}/../config"

MON_BENCHMARKS_ROOT="${HOME}/.rh/monitoring-benchmarks"
LOGS_ROOT="${SCRIPT_DIR}/../logs"

mkdir -p "${LOGS_ROOT}"

function date_w_format {
  date +%Y-%m-%d--%H-%M-%S
}

function log {
    log_file="${1}"
    msg="${2}"

    touch "${log_file}"
    echo "[$(date_w_format)] ${msg}" | tee -a "${log_file}"
}

function secure_mkdir {
    dir_path="${1}"

    mkdir -p "${dir_path}"
    chmod 700 "${dir_path}"
}

function cluster_config_dir {
    cluster_name="${1}"

    echo "${MON_BENCHMARKS_ROOT}/clusters/${cluster_name}"
}

function create_cluster {
    CLUSTER_NAME="${1}"
    NUM_WORKERS="${2}"

    log_file="${LOGS_ROOT}/create_cluster-$(date_w_format).log"
    echo "Using log file ${log_file}"
    config_dir="$(cluster_config_dir "${CLUSTER_NAME}")"
    mkdir -p "${config_dir}"
    
    SSH_KEY=$(cat "${SSH_KEY_PATH}")
    export SSH_KEY
    PULL_SECRET=$(cat "${PULL_SECRET_PATH}")
    export PULL_SECRET
    export CLUSTER_NAME
    export NUM_WORKERS
    install_config_file="${config_dir}/install-config.yaml"
    < "${CONFIG_ROOT}/install-config.template.yaml" envsubst > "${install_config_file}"
    install_config_redacted=$(grep -v pullSecret "${install_config_file}" | grep -v ssh)
    log "${log_file}" "Using install configuration ${install_config_redacted}"

    openshift-install --dir="${config_dir}" create cluster 2>&1 | tee -a "${log_file}"
    < "${log_file}" grep -v password > "${log_file}.clean"
    mv "${log_file}.clean" "${log_file}"

    log "${log_file}" "cluster kubeconfig available at ${config_dir}/auth/kubeconfig"

    unset SSH_KEY
    unset PULL_SECRET
    unset CLUSTER_NAME
    unset NUM_WORKERS

    echo
    echo "See logs at ${log_file}"
}

function delete_cluster {
    CLUSTER_NAME="${1}"
    
    log_file="${LOGS_ROOT}/delete_cluster-$(date_w_format).log"
    echo "Using log file ${log_file}"
    config_dir="$(cluster_config_dir "${CLUSTER_NAME}")"

    openshift-install destroy cluster --dir="${config_dir}" --log-level=debug 2>&1 | tee -a "${log_file}"
}