**1_infrastructure**

 1. Created a VPC
 2. Added two Subnets in VPC 
 3. Created a Security Group
 4. Lanched an ELB as an entrypoint for both the subnets through VPC.
 5. Created an ASG and Launch Configuration inside the subnets.
 6. Placed a DNS outside the VPC, linking it to the ELB.



**2_automation**

 1. Assuimung that the application is already containerized using Dockerfile.
 2. Using Docker Image, EKS Cluster, SAM STACK NAME created a pipeline with different stages i.e 
   - 'Build' stage
      - building the docker file
   - 'Test' stage 
      - Here we can implement code quality checks i.e SonarQube. Currently I have kept it echo "Running Tests"
   - 'Deploy to EKS' stage
      - Deploying to EKS via kubectl 
   -  'Deploy Serverless Components with SAM' stage
      - Packaging and Deploying application 
 3. Next step is to configure Jenkins and run the pipeline


**3_coding**

 1. Imported libraries i.e. csv, redis, boto3, StringIO
 2. Configuration of Redis and S3
 3. Connection to Redis and S3
 4. Upload the file to S3



