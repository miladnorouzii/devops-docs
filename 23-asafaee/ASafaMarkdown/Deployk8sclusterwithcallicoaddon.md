
sudo apt update


sudo apt install -y curl apt-transport-https ca-certificates gnupg lsb-release


curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

kubectl get pods -n kube-system

sudo kubeadm join <control-plane-ip>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>

kubectl get nodes

kubectl get pods -n kube-system

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --target-port=80
kubectl get services

kubectl edit configmap calico-config -n kube-system


