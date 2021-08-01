pipeline { 
    agent any
        
    tools {
        maven 'Maven3'
    }
    environment {
	    def mvn = tool 'Maven3';
	    def registry = 'arshdeepsingh070/devops-home-assignment';
	    project_id = 'devops-final-project-321607'
	    cluster_name = 'devops-java-jenkins-cluster'
	    location = 'us-central1-c'
	    credentials_id = 'Test_GoogleJenkins'
	 
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
	         bat "docker build -t i-arshdeepsingh-develop:develop-${BUILD_NUMBER} --no-cache -f Dockerfile ."
	     }
	}
	stage ("Push docker image to docker hub"){
	      steps{
		       bat "docker tag i-arshdeepsingh-develop:develop-${BUILD_NUMBER} ${registry}:develop-${BUILD_NUMBER}"
		       bat "docker tag i-arshdeepsingh-develop:develop-${BUILD_NUMBER} ${registry}:develop-latest"
		       withDockerRegistry([credentialsId: 'Test_Docker', url:""]){
			  bat "docker push ${registry}:develop-${BUILD_NUMBER}"
			  bat "docker push ${registry}:develop-latest"     
		       }
		   }
	} 
	stage ("Docker Deployment"){
	      steps {
		      bat "docker run --name c-arshdeepsingh-develop -d -p 7300:8080 ${registry}:develop-latest"
	       }
		
	}
	stage ("Deploy to GKE"){
		steps{	
	              step ([$class: 'KubernetesEngineBuilder', projectId: env.project_id, clusterName: env.cluster_name, location: env.location, manifestPattern: 'deployment.yaml', credentialsId: env.credentials_id, verifyDeployment: true])
		}
	}
    }
}
