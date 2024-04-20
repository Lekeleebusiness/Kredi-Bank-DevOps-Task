# # Deploy Springboot application with Mysql as its  database to AWS Cloud using Docker, Terraform, Kubernetes, Helm and GitHub Action.

The Springboot application basically keeps user records

To ensure a successful deployment from your local environment to the Cloud you can follow the steps below:

1. Build the application locally by building the springboot aplication using maven and running the command "mvn clean package"  

2. Build the docker image by running the command "docker build -t lekelee/user-microservice ."

3. Start the container locally by running the following command "docker run -d -p 8081:8081 --name user-micro lekelee/user-microservice:latest"

4. Test the application by accessing it via Postman by sending a Post request "http://localhost:8081/users" 

5. You can also access it via the browser via "http://localhost:8081/actuator/health" you would get a report of status: up if it is working

6. Push the docker image to dockerhub using the command "docker push lekelee/user-microservice:latest"

7. Setup infrastructure in the cloud using terraform and I set up modules for vpc, eks and rds.

8. Test the conifuration by going to the terraform directory and running the following commands below:

terraform init

terraform plan

terraform apply -auto-approve

9. Deploy the application via helm and Github action

10. After deploying the entire application and destroying it  and also storing all the helm charts in s3, 
I had to comment out some code on Github action so terraform does not build the infrastructure when there is a pull request or merge request because of cost from my end

11 RDS was used for the mysql database and ensured that there was connection and ensured all secerets were stored in secret manager and integrated seceret manager with kubernetes. 

Note: The image only runs on virtual machine that uses ARM64 so in my managed worker node i had to specify via terraform.
