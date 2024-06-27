#!/usr/bin/bash

# Do the following steps as user
if $USER == "root"
then
    echo Start $0 as user and not as root >&2
    exit 1
fi

# Start minikube
minikube start --vm-driver=kvm2 --cpus=4 --memory=8g --addons=ingress

# Deploy AWX
git clone https://github.com/ansible/awx-operator.git
cd awx-operator
git checkout 0.17.0
export NAMESPACE=ansible-awx
make deploy
kubectl get pods -n $NAMESPACE
cp awx-demo.yml ansible-awx.yml
sed -ie 's/awx-demo/ansible-awx/' ansible-awx.yml # Change the name line to name: ansible-awx
kubectl config set-context --current --namespace=$NAMESPACE
kubectl apply -f ansible-awx.yml
sleep 3
for min in $(seq 15 -1 1)
do
    echo Wait $min minutes
    echo You can use kubectl 'logs -f deployments/awx-operator-controller-manager -c awx-manager' for checking progress
    sleep 60
done

# Check deployment
kube_url=$(minikube service ansible-awx-service --url -n $NAMESPACE)

# Get the login password for admin user
awx_pass=$(kubectl get secret ansible-awx-admin-password -o jsonpath="{.data.password}" | base64 --decode)

cat <<EOF > ~/awx.pass
URL: $kube_url
User: admin
Pass: $awx_pass
You have to start "minikube start" after a reboot and wait 1 minute
EOF
