# nagp-devops-final-assignment

-> Created a simple spring boot application with RestController giving the detail of an employee with few Junit test cases available.

-> Using the Jenkins multi branch pipeline to handle the CI/CD for different branches (master and develop):

  - created separated Jenkinsfiles for each branch having all the steps to follow inside a script.
  - Did sonarqube integration and did the analysis (Used the SonarQube version 6 as it is compatible with JDK 8) 
  - Created a Dockerfile to create a docker image 
  - Pushed that docker image to Docker hub's public repository , link for that is : https://hub.docker.com/repository/docker/arshdeepsingh070/devops-home-assignment
  - Finally deploy the docker container on port:
     7200 for master
     7300 for develop
     
   - Also did the Kubernetes deployment for our contains and for that created separate deployment.yaml file for each branch on ports:
   
     30157 for master
     30158 for develop 
  
    
    


