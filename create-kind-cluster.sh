while getopts fn:w: flag
do
    case "${flag}" in
	f) force=true;;
	n) name=${OPTARG};;
	w) workers=${OPTARG};;
    esac
done

deleteCluster() {
    if [ ${force} ]; then
      [ -v ${name} ] && kind delete cluster || kind delete cluster --name $name   
    fi 
}

prepareConfig() {
  config="$(cat <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: $name
nodes:
- role: control-plane
- role: worker
EOF
)"

for i in $(seq $(($workers - 1)))
 do
   config="$config \n- role: worker";
 done 

}

configureCluster() { 
  echo -e "$config" | kind create cluster --config -
}

addMetricsServer() {

  echo -e 'Adding metrics-server ...\n'

  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.1/components.yaml
  kubectl patch -n kube-system deployment metrics-server --type=json \
    -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

  echo -e '\nDone.'
}


deleteCluster
prepareConfig
configureCluster
addMetricsServer
