[Draft Details, still writing clear details]

The repository structure
```
.
└── infra-practical
    ├── README.md
    ├── backend.tf
    ├── dev.tfvars
    ├── errored.tfstate
    ├── main.tf
    ├── modules
    │   └── aws_eks
    │       ├── input.tf
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── provider.tf
    └── spec-files
        ├── application-deployment.yaml
        ├── configMap.yaml
        ├── database-deployment.yaml
        ├── namespaces.yaml
        └── secrets.yaml
```
1. Used terraform to create the AWS VPC and EKS cluster.
   - Created module called `modules/aws_eks` and passing the variables via `dev.tfvars`.
   - Refer the modules folder for additional details.
2. Deployed an mongo-express(https://hub.docker.com/_/mongo-express) as the shared repository(https://github.com/swimlane/devops-practical) having an application issue and I'm unware of the Environment Variables to pass to the application(Like mentioned in the both the descriptions of repositories https://hub.docker.com/_/mongo-express and https://hub.docker.com/_/mongo).
3. The kubernetes specification files need to be executed in the below sequence.
  - `configMap.yaml`
  - ```
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: mongodb-configmap
    data:
      database_url: mongo
    ```

  - `secrets.yaml`

    ```
    apiVersion: v1
    kind: Secret
    metadata:
      name: mongo-secret
    type: Opaque
    data:
      username: dXNlcm5hbWU=
      password: cGFzc3dvcmQ=
      web_username: dXNlcm5hbWU=
      web_password: cGFzc3dvcmQ=
    ```
  - I would be using the [AWS ALB Ingress](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html), here, need to install pre-requisites such as OIDC, service account and ALB controller as below. Also, I used [eksctl](https://eksctl.io/) to reduce the efforts.
    - `eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=temporary`
    - `eksctl create iamserviceaccount --cluster=temporary --namespace=kube-system --name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn=arn:aws:iam::aws:policy/AdministratorAccess --approve`
    - Used [helm](https://helm.sh/) to install the ALB ingress controller as mentioned [here](https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html)
  - `database-deployment.yaml`, It launches both DB deployment and as well as the DB service. The service would be available in the name of `mongo` in the same namespace.
  - `application-deployment.yaml` , It launches Application deployment, Service and Ingress. I would be passing the environment variables as mentioned in the repos[1](https://hub.docker.com/_/mongo-express) [2](https://hub.docker.com/_/mongo)



Further enhancements planning.
1. Launch the application in private subnets and launch the ALB ingress in public subnets
2. Create separate namespaces for both App & DB, define network policy in such way that the inbound to DB application only be allowed from application namespace.
3. Create and attach persistent volume for DB
4. Make use of affinity/anti-affinity to make application fault tolerant and use the taints to deploy the DB replicas onto a dedicated hosts.
5. Helmify the above application
