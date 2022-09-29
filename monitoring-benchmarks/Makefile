MKFILE_PATH  := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(dir $(MKFILE_PATH))
HACK_DIR := $(ROOT_DIR)/hack
COMMON_SCRIPT := $(HACK_DIR)/common.sh
PYTHON := $(ROOT_DIR)/.venv/bin/python
PIP := $(ROOT_DIR)/.venv/bin/pip
JUPYTER := $(ROOT_DIR)/.venv/bin/jupyter
LOCAL_ROOT := $(ROOT_DIR)/.local
export LOCAL_ROOT
BIN_DIR := $(LOCAL_ROOT)/bin
MANIFESTS_ROOT := $(LOCAL_ROOT)/manifests
export MANIFESTS_ROOT
E2E_BENCHMARKING_ROOT := $(LOCAL_ROOT)/e2e-benchmarking
export E2E_BENCHMARKING_ROOT
E2E_BENCHMARKING_HASH := 'ec219202f02e766214b9c66618b41c717a58189a'

IMAGE_GROUP := openshift
IMAGE_NAME := monitoring-benchmarks
IMAGE_VERSION := '0.1.0'
IMAGE_TAG := $(IMAGE_GROUP)/$(IMAGE_NAME):$(IMAGE_VERSION)

JSONNET_BIN=$(BIN_DIR)/jsonnet
TOOLING=$(JSONNET_BIN)

.PHONY: cluster/new-name
cluster/new-name:
	@source $(COMMON_SCRIPT) && echo "$${USER}-prombenchmark-$$(date_w_format)"

.PHONY: cluster/create
cluster/create:
	source $(COMMON_SCRIPT) && create_cluster "${cluster_name}" ${num_workers}

.PHONY: cluster/delete
cluster/delete:
	source $(COMMON_SCRIPT) && delete_cluster "${cluster_name}"

.PHONY: cluster/list
cluster/list:
	source $(COMMON_SCRIPT) && ls -ltr "$${MON_BENCHMARKS_ROOT}/clusters"

.PHONY: cluster/kubeconfig
cluster/kubeconfig:
	@source $(COMMON_SCRIPT) && echo "$$(cluster_config_dir "${cluster_name}")/auth/kubeconfig"

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(TOOLING): $(BIN_DIR)
	@echo Installing tools from hack/tools.go
	@cd hack/tools && go list -mod=mod -tags tools -f '{{ range .Imports }}{{ printf "%s\n" .}}{{end}}' ./ | xargs -tI % go build -mod=mod -o $(BIN_DIR) %

.PHONY: jsonnet/build
jsonnet/build: $(TOOLING)
	source $(COMMON_SCRIPT) && jsonnet_build

.PHONY: benchmarks/deploy
benchmarks/deploy: jsonnet/build
	jq -r .[] $(MANIFESTS_ROOT)/main.json | oc apply -f -

.PHONY: benchmarks/undeploy
benchmarks/undeploy: jsonnet/build
	jq -r .[] $(MANIFESTS_ROOT)/main.json | oc delete --ignore-not-found=true -f -

.venv:
	python -m venv .venv

.PHONY: python/deps
python/deps: .venv
	cd $(ROOT_DIR) && $(PIP) install -e .

.PHONY: run/notebook
run/notebook: # make run/notebook output=$(pwd)/foo.html
	cd $(ROOT_DIR) && $(JUPYTER) nbconvert --to=html --execute monitoring-benchmarks/monitoring-benchmarks.ipynb --output="${output}"

$(LOCAL_ROOT):
	mkdir -p $(LOCAL_ROOT)

$(E2E_BENCHMARKING_ROOT): $(LOCAL_ROOT)
	ls $(E2E_BENCHMARKING_ROOT) || ( cd $(LOCAL_ROOT) && git clone https://github.com/cloud-bulldozer/e2e-benchmarking.git && cd e2e-benchmarking && git checkout $(E2E_BENCHMARKING_HASH) )

.PHONY: run/benchmarks
# This assumes KUBECONFIG is set
# Example: make run/benchmarks run_root=".local/run_benchmarks/$(date +%Y-%m-%d--%H-%M-%S)" pods_per_node=10 pod_churning_period='1m' number_of_ns=2
run/benchmarks: $(E2E_BENCHMARKING_ROOT)
	source $(COMMON_SCRIPT) && run_benchmarks "${run_root}" "${pods_per_node}" "${pod_churning_period}" "${number_of_ns}"

.PHONY: run/benchmarks/continuously
run/benchmarks/continuously: $(E2E_BENCHMARKING_ROOT)
	source $(COMMON_SCRIPT) && run_benchmarks_continuously

.PHONY: image/build/local
image/build/local:
	docker build -t $(IMAGE_TAG) .

.PHONY: image/shell/local
image/shell/local:
	docker run -it --rm --entrypoint /bin/bash $(IMAGE_TAG)

.PHONY: image/push
image/push:
	echo 'Assumming logged with `docker login -u "${USER}" quay.io`'
	docker tag $(IMAGE_TAG) quay.io/${USER}/$(IMAGE_NAME):$(IMAGE_VERSION)
	docker push quay.io/${USER}/$(IMAGE_NAME):$(IMAGE_VERSION)
	echo "Asumming project is public at https://quay.io/repository/${USER}/$(IMAGE_NAME)?tab=settings "

.PHONY: image/build/openshift-internal
image/build/openshift-internal: # assumes KUBECONFIG for user with permissions (e.g. kubeadmin)
	docker build -t "$(shell oc get route default-route -n openshift-image-registry -o jsonpath="{.spec.host}")/$(IMAGE_TAG)" .
