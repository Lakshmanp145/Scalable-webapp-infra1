## ingress controler
REGION_CODE=us-east-1
CLUSTER_NAME=web_app-prod
ACC_ID=503561459301

### IAM permissions
* OIDC privider  #authentication service
```
eksctl utils associate-iam-oidc-provider \
    --region $REGION_CODE \
    --cluster $CLUSTER_NAME \
    --approve
```
* IAM policy
```
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.12.0/docs/install/iam_policy.json

```

* Create IAM role
```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```

* provide access to EKS through IAM policy
```
eksctl create iamserviceaccount \
--cluster=$CLUSTER_NAME \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::$ACC_ID:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region $REGION_CODE \
--approve
```

### Install drivers

* Add the EKS chart repo to Helm
```
helm repo add eks https://aws.github.io/eks-charts
```

* Install AWS loadbalancer controller
```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=$CLUSTER_NAME --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
```