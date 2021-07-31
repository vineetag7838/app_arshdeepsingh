pipeline { 
    agent any
        
    tools {
        maven 'Maven3'
    }
    environment {
	    def mvn = tool 'Maven3';
	    def registry = 'arshdeepsingh070/devops-home-assignment';
	    project_id = 'java-jenkins-deployment'
	    cluster_name = 'java-jenkins-deployment-cluster-two'
	    location = 'us-central1'
	    credentials_id = 'GoogleJenkinsTest'
	 
    }
    
    options {
        timestamps()
        
        timeout(time: 1, unit: 'HOURS' )
        
        buildDiscarder(logRotator(daysToKeepStr: '10', numToKeepStr: '20'))
    }
    
    stages {
        stage('Checkout') {
            steps {
		    echo "checkout"
            }
        }
        
        stage('Build') {
            steps {
                bat 'mvn clean install'
            }
        }
	stage('Unit Testing') {
            steps {
                bat 'mvn test'
            }
        }    
        stage("SonarQube analysis") {
            steps {
              withSonarQubeEnv('SonarQubeScanner') {
                bat "${mvn}/bin/mvn sonar:sonar"
              }
            }
          }
	 stage("create docker image"){
             steps {
	         bat "docker build -t i-arshdeepsingh-develop:${BUILD_NUMBER} --no-cache -f Dockerfile ."
	     }
	}
	stage ("Push docker image to docker hub"){
	      steps{
		       bat "docker tag i-arshdeepsingh-develop:${BUILD_NUMBER} ${registry}:${BUILD_NUMBER}"
		       bat "docker tag i-arshdeepsingh-develop:${BUILD_NUMBER} ${registry}:latest"
		       withDockerRegistry([credentialsId: 'Test_Docker', url:""]){
			  bat "docker push ${registry}:${BUILD_NUMBER}"
			  bat "docker push ${registry}:latest"     
		       }
		   }
	} 
	stage ("Docker Deployment"){
	      steps {
		      bat "docker run --name c-arshdeepsingh-develop -d -p 7300:8080 ${registry}:${BUILD_NUMBER}"
	       }
		
	}
	stage ("Deploy to GKE"){
		steps{	
	              step ([$class: 'KubernetesEngineBuilder', projectId: env.project_id, clusterName: env.cluster_name, location: env.location, manifestPattern: 'deployment.yaml', credentialsId: env.credentials_id, verifyDeployment: true])
		}
	}
    }
}
