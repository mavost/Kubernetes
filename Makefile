new:
	vagrant up

fresh: clean
	vagrant up

clean:
	vagrant destroy -f
	rm -rf .vagrant
	rm -f roles/iad*
# ceph-related
	rm -f cephDisk*

SSHPORT = $(shell vagrant port k8s-m-1 --guest 22)
ROOKDIR = rook-ceph-cluster
KDB_SECRET = $(shell kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $$1}')

get_kube_ssh_key:
	echo "...ssh copying .config from kube-master to HOST via port $(SSHPORT)"
	echo "Password: vagrant"
	scp -P $(SSHPORT) vagrant@127.0.0.1:/home/vagrant/.kube/config ~/.kube/.

kb_dashboard-access:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
	kubectl create -f kubernetes-dashboard-service-np.yaml
	echo $(KDB_SECRET)
	kubectl -n kubernetes-dashboard describe secret $(KDB_SECRET)
## https://192.168.100.11:30002/

ceph_deployment:
#	[-d $(ROOKDIR)] && kubectl delete -f $(ROOKDIR)/cluster.yaml -f $(ROOKDIR)/crds.yaml -f $(ROOKDIR)/common.yaml -f $(ROOKDIR)/operator.yaml
#	curl --create-dirs -OL --output-dir $(ROOKDIR) "https://raw.githubusercontent.com/rook/rook/master/cluster/examples/kubernetes/ceph/{cluster.yaml,common.yaml,crds.yaml,operator.yaml}"
#	curl -OL --output-dir $(ROOKDIR) "https://raw.githubusercontent.com/rook/rook/master/cluster/examples/kubernetes/ceph/{cluster.yaml,common.yaml,crds.yaml,operator.yaml}"
#	curl -L --output-dir $(ROOKDIR) "https://raw.githubusercontent.com/JoergEF/Kubernetes/master/ceph-cluster/10%20-%20rook-toolbox.yaml" -o rook-toolbox.yaml
#	curl -L --output-dir $(ROOKDIR) "https://raw.githubusercontent.com/JoergEF/Kubernetes/master/ceph-cluster/20%20-%20ClusterStorageClass.yaml" -o ClusterStorageClass.yaml
#	curl -L --output-dir $(ROOKDIR) "https://raw.githubusercontent.com/JoergEF/Kubernetes/master/ceph-cluster/30%20-%20ceph-Dashbord-service-np.yaml" -o ceph-Dashbord-service-np.yaml
#	kubectl create -f $(ROOKDIR)/crds.yaml -f $(ROOKDIR)/common.yaml -f $(ROOKDIR)/operator.yaml
#	kubectl create -f $(ROOKDIR)/cluster.yaml
#	kubectl create -f $(ROOKDIR)/rook-toolbox.yaml
	kubectl -n rook-ceph rollout status deploy/rook-ceph-tools
##kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash
##ceph status
##ceph osd status
#	kubectl create -f $(ROOKDIR)/ClusterStorageClass.yaml

ceph_dashboard-access:
	kubectl apply -f $(ROOKDIR)/ceph-Dashbord-service-np.yaml
	kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo
## https://192.168.100.11:30003/