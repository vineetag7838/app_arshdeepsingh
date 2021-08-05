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
	         bat "docker build -t i-arshdeepsingh-master:master-${BUILD_NUMBER} --no-cache -f Dockerfile ."
	     }
	}
	stage('Container') {
         parallel {
          stage('PreContainer check') {
             steps{
                  bat 'docker rm -f c-arshdeepsingh-master && echo "container c-arshdeepsingh-master removed" || echo "container c-arshdeepsingh-master does not exist" '
                }
          }
          stage('Push docker image to docker hu') {
              steps {
               bat "docker tag i-arshdeepsingh-master:master-${BUILD_NUMBER} ${registry}:master-${BUILD_NUMBER}"
		       bat "docker tag i-arshdeepsingh-master:master-${BUILD_NUMBER} ${registry}:master-latest"
		       withDockerRegistry([credentialsId: 'Test_Docker', url:""]){
			  bat "docker push ${registry}:master-${BUILD_NUMBER}"
			  bat "docker push ${registry}:master-latest"     
		       }
           }
         }
       }
    }
	stage ("Docker Deployment"){
	      steps {
		      bat "docker run --name c-arshdeepsingh-master -d -p 7200:8080 ${registry}:master-latest"
	       }
	}
	stage ("Deploy to GKE"){
		steps{	
	             bat "kubectl apply -f deployment.yaml"
		}
	}
    }
}