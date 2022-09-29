# Monitoring benchmarks

Steps to run the benchmarks

0. Prerequisites
1. Create a cluster
2. Launch benchmarks
3. Collect results, store results in repo, and delete cluster

Follow the subsections below to perform each step

## Prerequisites

### Install jq

For MacOS use `brew install jq`

### Get IAM user in our dev account, and setup AWS CLI profile

TODO: blocked by account request

Install the AWS CLI following [its documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).  
Creare an AWS CLI profile called `openshift-monitoring-benchmarks` by running `aws configure --profile=openshift-monitoring-benchmarks` and introducing the credentials you obtained when setting up your IAM user. If all went well you should be able to run the following command successfully.  

```bash
export AWS_PROFILE=openshift-monitoring-benchmarks
aws iam get-user 
```

### Install the openshift installer

Download the OpenShift installer CLI and your pull secret from [here](https://console.redhat.com/openshift/install/aws/installer-provisioned). Add OpenShift installer CLI to your `PATH`, in MacOSX you can do that by adding `export PATH=${PATH}:PATH_TO_openshift-install` to `~/.bash_profile`. Verify by checking the following command runs succesfully.

```bash
openshift-install --help
```

### (Local dev only) Install python

[pyenv](https://github.com/pyenv/pyenv) is a simple option, but any installtion of Python 3.9.10 works.

First time setup:

```bash
pyenv install 3.9.10
pyenv shell 3.9.10
make python/deps
```

Daily usage: `source .venv/bin/activate`

## Create a cluster

```bash
export AWS_PROFILE=openshift-monitoring-benchmarks
# Define env vars to locate your pull secret, and a public ssh key file to access the cluster nodes.
## path to file where you stored your pull secret
export PULL_SECRET_PATH=...
## path to ssh public key to use to setup ssh access to cluster nodes
export SSH_KEY_PATH=...

# must include your RH SSO login
export cluster_name=$(make cluster/new-name)
# adjust accordingly
export num_workers=3
# Check stdout for cluster login (will be removed from log)
make cluster/create
# get cluster credentials
export KUBECONFIG=$(make cluster/kubeconfig)
```

## Launch benchmarks


```bash
docker login -u QUAY_USER quay.io
```


TODO

## Collect results, store results in repo, and delete cluster

TODO

TODO: ensure to collect the results before the cluster is automatically destroyed. Make clear persistent storage is this git repo

Delete a cluster as follows:

```bash
# If needed see latest cluster name as follows
make cluster/list
# cluster to delete
export cluster_name=...
make cluster/delete
```

## TODO Launch all release benchmarks

Script to launch benchmarks on all clusters for a release