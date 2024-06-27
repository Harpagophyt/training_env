# Do the following steps as root
# Install KVM
dnf -y install snapd
systemctl enable --now snapd.service snapd.socket
sleep 5

# Add the student user to libvirt for using minikube
usermod -aG libvirt student

# Steps to use awx on minikube
ln -s /var/lib/snapd/snap /snap
echo 'export PATH=$PATH:/var/lib/snapd/snap/bin' > /etc/profile.d/snap.sh

# Install minikube
sudo snap install kubectl --classic
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -O minikube
wget https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2
chmod 755 minikube docker-machine-driver-kvm2
mv minikube docker-machine-driver-kvm2 /usr/local/bin/
