
kubectl cluster-info


kubectl get pods --all-namespaces


kubectl proxy &  
curl http://localhost:8001/api/v1/nodes

pip install kubernetes

from kubernetes import client, config

def main():
    
    config.load_kube_config()

  
    v1 = client.CoreV1Api()
    print("Listing nodes in the cluster:")
    ret = v1.list_node(watch=False)
    for i in ret.items:
        print(f"Node name: {i.metadata.name}")

if __name__ == '__main__':
    main()

go get k8s.io/client-go@latest

package main

import (
    "context"
    "fmt"
    "path/filepath"

    "k8s.io/client-go/kubernetes"
    "k8s.io/client-go/tools/clientcmd"
    "k8s.io/client-go/util/homedir"
)

func main() {
    var kubeconfig string
    if home := homedir.HomeDir(); home != "" {
        kubeconfig = filepath.Join(home, ".kube", "config")
    } else {
        kubeconfig = ""
    }

 
    config, err := clientcmd.BuildConfigFromFlags("", kubeconfig)
    if err != nil {
        panic(err.Error())
    }

   
    clientset, err := kubernetes.NewForConfig(config)
    if err != nil {
        panic(err.Error())
    }

    nodes, err := clientset.CoreV1().Nodes().List(context.TODO(), metav1.ListOptions{})
    if err != nil {
         panic(err.Error())
    }
    fmt.Println("Listing nodes in the cluster:")
    for _, node := range nodes.Items {
        fmt.Printf("Node name: %s\n", node.Name)
    }
}


APISERVER=$(kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " ")


TOKEN=$(kubectl describe secret $(kubectl get secrets | grep ^default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d " ")

curl -X GET $APISERVER/api/v1/nodes \
  -H "Authorization: Bearer $TOKEN" \
  --insecure


TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)


APISERVER=https://kubernetes.default.svc


curl -X GET $APISERVER/api/v1/nodes \
  -H "Authorization: Bearer $TOKEN" \
  --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt

