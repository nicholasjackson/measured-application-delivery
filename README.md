# Measured Application Delivery With Consul Service Mesh

This example repo shows how you can do automated canary releases and gradual application migration between virtual machines
and Kubernetes.

## Running the Demo Application

The example application can be run locally using Docker and Shipyard. It runs a simulated environment that
consists of a Kubernetes cluster, serveral Virtual Machines and a federated Consul cluster that spans two
datacenters.

Shipyard is a single binary application that allows the automation of complex environments using Docker. It is kind
of like if Docker Compose and Terraform had a child.

(https://shipyard.run/docs/install)[https://shipyard.run/docs/install]

Once Shipyard is installed you can run the example using the following command:

```shell
shipyard run ./shipyard
```

It might take a little while to run first time as Shipyard needs to download a few Docker containers.

### Grafana dashboard
User: admin
Pass: admin

(http://localhost:8080/d/sdfsdfsdf/application-dashboard?orgId=1&refresh=10s)[http://localhost:8080/d/sdfsdfsdf/application-dashboard?orgId=1&refresh=10s]

### Consul

Consul uses a self signed certificate, you will need to allow this to view the UI

(https://localhost:8501/ui/kubernetes/services)[https://localhost:8501/ui/kubernetes/services]


### Kubernetes
To access the Kubernetes CLI you can use shipyard to set the correct environment valiables

```shell
eval $(shipyard env)
```

You can then use `kubectl` as normal

```
kubectl get pods
```

Consul is installed to the `monitoring` namespace and Grafana and Prometheus in the `monitoring` namespace

## Automated Canary Releases with Kubernetes
