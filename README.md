# dbo-demo
**DBO Demo Environment Setup for SEs on AWS using EKS and RDS Postgres**

**Step 1** - Create EKS Cluster (eks-cluster.yaml)

**Step 2** - Create RDS database (rds.tf) with inputs from EKS including VPC ID, SG & Subnet. Create RDS under same VPC and make sure RDS SG can allow inbound access from EKS VPC on port 5432

**Note** - Modify & enable Performance Monitoring on RDS

**Step 3** - Connect EKS Cluster with CAST - Phase 1 and 2 (Meanwhile while RDS is getting deployed)

**Step 4** - Install AWS load balancer controller - https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html

**Step 5** - Create Pod (psql-client.yaml) to create a database (evershop)

**Step 6** - Create demo-ecom-app.yaml to deploy application.
