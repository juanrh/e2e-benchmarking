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


[ namespace(),  benchmarks_pvc() ]
