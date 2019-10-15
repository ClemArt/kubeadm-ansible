# Metrics Server

From https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/#metrics-server

## Launching metrics-server

With an admin connexion to the cluster, apply all the `yaml` files in this folder to the cluster using : 

    for i in metrics-server/*.yaml; do kubectl apply -f $i; done

