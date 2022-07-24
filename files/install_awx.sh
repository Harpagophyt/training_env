echo This script following https://computingforgeeks.com/how-to-install-ansible-awx-on-debian-buster/
apt install -y git build-essential curl jq
curl -sfL https://get.k3s.io | bash -
chmod 644 /etc/rancher/k3s/k3s.yaml
kubectl get nodes
git clone https://github.com/ansible/awx-operator.git
export NAMESPACE=awx
kubectl create ns ${NAMESPACE}
kubectl config set-context --current --namespace=$NAMESPACE
cd awx-operator/
RELEASE_TAG=`curl -s https://api.github.com/repos/ansible/awx-operator/releases/latest | grep tag_name | cut -d '"' -f 4`
echo $RELEASE_TAG
git checkout $RELEASE_TAG
export NAMESPACE=awx
make deploy

echo $(date) - wait 60 seconds
sleep 60
kubectl get pods
echo $(date) - wait 540 seconds
sleep 540
kubectl get pods

cat <<EOF | kubectl create -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: static-data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 5Gi
EOF

cat > awx-deploy.yml<<EOF
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
spec:
  service_type: nodeport
  projects_persistence: true
  projects_storage_access_mode: ReadWriteOnce
  web_extra_volume_mounts: |
    - name: static-data
      mountPath: /var/lib/projects
  extra_volumes: |
    - name: static-data
      persistentVolumeClaim:
        claimName: static-data-pvc
EOF
kubectl apply -f awx-deploy.yml

kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator" -n awx
echo $(date) - wait 120 seconds
sleep 120
kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator" -n awx
echo $(date) - wait 1080 seconds
sleep 1080
kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator" -n awx

#kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager -n awx
#kubectl get pvc -n awx
#ls /var/lib/rancher/k3s/storage/
kubectl get svc -l "app.kubernetes.io/managed-by=awx-operator" -n awx
echo ======================================================================
echo Ansible AWX web portal is now accessible on http://10.0.1.6:30080 
echo Use previous portmap output to see which is the port for http connection
echo Username: admin
kubectl get secret awx-admin-password -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}' -n awx
echo ======================================================================
