# dbo-demo
**DBO Demo Environment Setup for SEs on AWS using EKS and RDS Postgres**

**Step 1** - Create EKS Cluster (eks-cluster.yaml)

**Step 2** - Create RDS database (rds.tf) with inputs from EKS including VPC ID, SG & Subnet. Create RDS under same VPC and make sure RDS SG can allow inbound access from EKS VPC on port 5432

**Note** - Modify & enable Performance Monitoring on RDS

**Step 3** - Connect EKS Cluster with CAST - Phase 1 and 2 (Meanwhile while RDS is getting deployed)

**Step 4** - Install AWS load balancer controller - https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html

**Step 5** - Create Pod (psql-client.yaml) to create a database (evershop)

**Step 6** - Deploy DBO Database and Cache - Connect account -> Run Script in EKS Cluster -> Deploy Cache -> Run Script

**Note** - Takes a while to get Cache deployed and running - once completed run the following (kubectl get svc -n castai-db-optimizer) Note down the value needed for DB_HOST

**Step 7** - Create demo-ecom-app.yaml (update values accordingly) and deploy application.

**Step 8** - Check Application Status - k get svc (http://<your-lb-hostname>.elb.<region>.amazonaws.com:3000/)

kubectl exec -it demo-ecom-app-pod-name -- /bin/sh
npm run user:create -- --email "admin@admin.com" --password "admin123" --name "admin" 

**Step 9** - Update & Run Bootstap.vars and ./bootstrap.sh to populate all data into the app.

**Step 10** - Install Locust in your Local system and run the program (locustfile.py) to open up UI
