# Monitoring benchmarks

Steps to run the benchmarks

0. Prerequisites
1. Create a cluster
2. Launch benchmarks
3. Collect results, store results in repo, and delete cluster

Follow the subsections below to perform each step

## Prerequisites

TODO

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

## Create a cluster

```bash
# Define env vars to locate your pull secret, and a public ssh key file to access the cluster nodes.
## path to file where you stored your pull secret
export PULL_SECRET_PATH=...
## path to ssh public key to use to setup ssh access to cluster nodes
export SSH_KEY_PATH=...

source common.sh
# must include your login
cluster_name="${USER}-prombenchmark-$(date_w_format)"
# adjust accordingly
num_workers=3
create_cluster "${cluster_name}" ${num_workers}
```

## Launch benchmarks

TODO

## Collect results, store results in repo, and delete cluster

TODO

TODO: ensure to collect the results before the cluster is automatically destroyed. Make clear persistent storage is this git repo

Delete a cluster as follows:

```bash
source common.sh
# If needed see latest cluster name as follows
ls -ltr "${MON_BENCHMARKS_ROOT}/clusters"
# cluster to delete
cluster_name=...
delete_cluster "${cluster_name}"
```

## TODO Launch all release benchmarks

Script to launch benchmarks on all clusters for a release