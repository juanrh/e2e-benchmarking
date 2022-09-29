local benchmarks_namespace = "monitoring-benchmarks";

local namespace() =
{
    apiVersion: "v1",
    kind: "Namespace",
    metadata: {
        name: benchmarks_namespace
    }
};

local benchmarks_pvc() = 
{
    apiVersion: "v1",
    kind: "PersistentVolumeClaim",
    metadata: {
        name: "monitoring-benchmarks-data-claim",
        namespace: benchmarks_namespace,
        annotations: {
            "volume.beta.kubernetes.io/storage-class": "gp2"
        }
            
    },
    spec: {
        accessModes: [ "ReadWriteOnce" ],
        resources: {
            requests: {
                storage: "4Gi"
            }
        }
    }
};

// FIXME: add configuration instead of hardcoded
local benchmarks_runner_image = 'quay.io/jrodrig/monitoring-benchmarks:0.1.0';
local pods_per_node = '10';
local pod_churning_period = '1m';
local number_of_ns = '2';
local benchmarks_runner_replica_set() =
{
    apiVersion: "apps/v1",
    kind: "ReplicaSet",
    metadata: {
      name: "benchmarks-runner",
      namespace: benchmarks_namespace,
      labels: {
        app: "monitoring-benchmarks"
      },
    },
    spec: {
        replicas: 1,
        selector: {
            matchLabels: {
                app: "monitoring-benchmarks",
            },
        },
        template: {
            metadata: {
                labels: {
                    app: "monitoring-benchmarks",
                }
            },
            spec: {
                volumes: [
                    {
                        name: "benchmarks-runner",
                        persistentVolumeClaim: {
                            claimName: "monitoring-benchmarks-data-claim"
                        },
                    }
                ],
                containers: [
                    {
                        name: "runner",
                        image: benchmarks_runner_image,
                        imagePullPolicy: 'Always',
                        command: [ 'make'],
                        args: ['run/benchmarks/continuously' ],
                        volumeMounts: [
                            {
                                name: 'benchmarks-runner',
                                mountPath: '/var/lib/benchmarks'
                            }
                        ],
                        env: [
                            {
                                name: 'BENCHMARKS_RUNS_ROOT', 
                                value: '/var/lib/benchmarks/runs'
                            },
                            {   
                                name: 'PODS_PER_NODE',
                                value: pods_per_node
                            },
                            {   
                                name: 'POD_CHURNING_PERIOD',
                                value: pod_churning_period
                            },
                            {   
                                name: 'NUMBER_OF_NS',
                                value: number_of_ns
                            },
                        ],
                        securityContext: {
                            allowPrivilegeEscalation: false,
                            capabilities: {
                                drop: [ "ALL" ],
                            },
                            runAsNonRoot: true,
                            seccompProfile: {
                                type: 'RuntimeDefault',
                            }
                        }
                    }
                ]
            }
        }
    }
};

// FIXME kube credentails: like an operator
// FIXME config to env var

[ namespace(),  benchmarks_pvc(), benchmarks_runner_replica_set() ]
