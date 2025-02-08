sudo apt update && sudo apt upgrade -y

sudo swapoff -a

sudo apt install -y docker.io
sudo systemctl enable --now docker

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

sudo kubeadm init --control-plane-endpoint "<LOAD_BALANCER_IP>:6443" --upload-certs

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

kubeadm token create --print-join-command

sudo kubeadm join <LOAD_BALANCER_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH> --control-plane --certificate-key <CERTIFICATE_KEY>

kubectl get nodes

kubeadm token create --print-join-command

sudo kubeadm join <LOAD_BALANCER_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>

kubectl get nodes

sudo apt install haproxy -y

frontend kubernetes
    bind *:6443
    mode tcp
    option tcplog
    default_backend kubernetes-masters

backend kubernetes-masters
    mode tcp
    option tcp-check
    balance roundrobin
    server master1 <MASTER1_IP>:6443 check
    server master2 <MASTER2_IP>:6443 check
    server master3 <MASTER3_IP>:6443 check

sudo systemctl restart haproxy

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

kubectl get services

