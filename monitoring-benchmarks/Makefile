MKFILE_PATH  := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(dir $(MKFILE_PATH))
HACK_DIR := $(ROOT_DIR)/hack
COMMON_SCRIPT := $(HACK_DIR)/common.sh
PYTHON := $(ROOT_DIR)/.venv/bin/python
PIP := $(ROOT_DIR)/.venv/bin/pip
JUPYTER := $(ROOT_DIR)/.venv/bin/jupyter
BIN_DIR ?= $(shell pwd)/.local/bin

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

.PHONY: build-jsonnet
build-jsonnet: $(TOOLING)
	$(HACK_DIR)/build-jsonnet.sh


.venv:
	python -m venv .venv

.PHONY: deps
deps: .venv
	cd $(ROOT_DIR) && $(PIP) install -e .

.PHONY: run/notebook
run/notebook: # make run/notebook output=$(pwd)/foo.html
	cd $(ROOT_DIR) && $(JUPYTER) nbconvert --to=html --execute monitoring-benchmarks/monitoring-benchmarks.ipynb --output="${output}"

## FIXME DRY image tag

.PHONY: image/build/local
image/build/local:
	docker build -t openshift/monitoring-benchmarks:latest .

.PHONY: image/shell/local
image/shell/local:
	docker run -it --rm --entrypoint /bin/bash openshift/monitoring-benchmarks:latest

.PHONY: image/build/openshift-internal
image/build/openshift-internal: # assumes KUBECONFIG for user with permissions (e.g. kubeadmin)
	docker build -t "$(shell oc get route default-route -n openshift-image-registry -o jsonpath="{.spec.host}")/openshift/monitoring-benchmarks:latest" .