# Service Kubernetes Cluster with Calico CNI

## Table of Contents

- [Kubernetes Cluster Deployment](#kubernetes-cluster-deployment)
  - [Terraform Initialize](#terraform-initialize)
  - [Terraform Plan](#terraform-plan)
  - [Terraform Apply](#terraform-apply)
- [Configure kubectl](#configure-kubectl)
- [Install Calico CNI Driver](#install-calico-cni-driver)
- [Deploy App on Kubernetes](#deploy-app-on-kubernetes)

## Kubernetes Cluster Deployment

### Terraform Initialize
Initialize terraform for each environment. For example, for stage run this command.

```shell
$ make init
```

### Terraform Plan
Check the deployment plan, after any terraform configuraion change.

```shell
$ make plan
```

### Terraform Apply
Deploy the resources, as per the planned changes.

```shell
$ make apply
```

## Configure kubectl

To configure kubetcl, you need both [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and [AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html).

The following command will get the access credentials for your cluster and automatically configure `kubectl`. Enter the correct aws-profile

```shell
$ aws eks --region us-west-2 update-kubeconfig --name acme-calico --profile [stage]
```

The Kubernetes cluster name and AWS region can be obtained from terraform outputs.

```shell
$ terraform output
```

## Install Calico CNI Driver

1. Since this cluster will use Calico for networking, we must delete the aws-node daemon set to disable AWS VPC networking for pods.

```shell
$ kubectl delete daemonset -n kube-system aws-node
```

2. Install Calico CNI drivers in the cluster.

```shell
kubectl apply -f https://docs.projectcalico.org/manifests/calico-vxlan.yaml
```

3. Go to the console and terminate 2 worker nodes that has VPC CNI. The auto-scale will bring-up two new worker nodes with Calico CNI driver.

## Deploy App on Kubernetes

Deploy the testapp, if not done already. 

See the worker nodes, deployed on SL-network. 

```shell
$ kubectl get nodes -o wide
NAME                                         STATUS   ROLES    AGE     VERSION               INTERNAL-IP    EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION                  CONTAINER-RUNTIME
ip-10-186-67-49.us-west-2.compute.internal   Ready    <none>   5h32m   v1.17.11-eks-cfdc40   10.186.67.49   <none>        Amazon Linux 2   4.14.193-149.317.amzn2.x86_64   docker://19.3.6
ip-10-186-67-6.us-west-2.compute.internal    Ready    <none>   5h30m   v1.17.11-eks-cfdc40   10.186.67.6    <none>        Amazon Linux 2   4.14.193-149.317.amzn2.x86_64   docker://19.3.6
```

See the POD deployment on a different network, managed by Calico.

```shell
$ kubectl get pods -n test -o wide 
NAME                       READY   STATUS    RESTARTS   AGE     IP               NODE                                         NOMINATED NODE   READINESS GATES
testapp-7ddc8b8c7f-5xh4q   1/1     Running   0          160m    192.168.32.196   ip-10-186-67-6.us-west-2.compute.internal    <none>           <none>
testapp-7ddc8b8c7f-db2bs   1/1     Running   0          160m    192.168.32.197   ip-10-186-67-6.us-west-2.compute.internal    <none>           <none>
testapp-7ddc8b8c7f-v52qc   1/1     Running   0          5h19m   192.168.38.69    ip-10-186-67-49.us-west-2.compute.internal   <none>           <none>
testapp-7ddc8b8c7f-xrdnj   1/1     Running   0          5h31m   192.168.38.68    ip-10-186-67-49.us-west-2.compute.internal   <none>           <none>
testapp-7ddc8b8c7f-zhglr   1/1     Running   0          160m    192.168.32.198   ip-10-186-67-6.us-west-2.compute.internal    <none>           <none>
```
