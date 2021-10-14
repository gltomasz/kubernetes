# Kubernetes

## Simple script allowing to create a development cluster

file: create-kind-cluster.sh

usage: `./create-kind-cluster.sh -n test -w 2 -f`

arguments:

- -n: cluster name
- -w: worker nodes count
- -f: force create, will delete existing cluster of a given name
