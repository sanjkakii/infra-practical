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
2. Deployed an mongo-express as the shared repository having an issue and I'm unware of the Environment Variables to pass to the application.
3. The kubernetes specification files need to be executed in the below sequence.
  - `configMap.yaml`
  - `secrets.yaml`
  - `database-deployment.yaml`
  - `application-deployment.yaml`



Further enhancements planning.
1. Launch the application in private subnets and launch the ALB ingress in public subnets
2. Create separate namespaces for both App & DB, define network policy in such way that the inbound to DB application only be allowed from application namespace.
3. Create and attach persistent volume for DB
4. Make use of affinity/anti-affinity to make application fault tolerant and use the taints to deploy the DB replicas onto a dedicated hosts.
5. Helmify the above application
