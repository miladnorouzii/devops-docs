sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

sudo apt update && sudo apt upgrade -y

sudo apt install -y curl wget net-tools

sudo apt install -y docker.io
sudo systemctl enable --now docker

sudo apt install -y containerd
sudo systemctl enable --now containerd

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

kubeadm token create --print-join-command

sudo <join-command>

kubectl get nodes

