pipeline { 
    agent any
        
    tools {
        maven 'Maven3'
    }
    environment {
	    def mvn = tool 'Maven3';
	    def registry = 'arshdeepsingh070/devops-home-assignment';
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
	 stage("create docker image"){
             steps {
	         bat "docker build -t i-arshdeepsingh-master:${BUILD_NUMBER} --no-cache -f Dockerfile ."
	     }
	}
	stage('Container') {
         parallel {
          stage('PreContainer check') {
             steps{
                  bat 'docker rm -f c-arshdeepsingh-master || exit '
                }
          }
          stage('Push docker image to docker hu') {
              steps {
               bat "docker tag i-arshdeepsingh-master:${BUILD_NUMBER} ${registry}:${BUILD_NUMBER}"
		       bat "docker tag i-arshdeepsingh-master:${BUILD_NUMBER} ${registry}:latest"
		       withDockerRegistry([credentialsId: 'Test_Docker', url:""]){
			  bat "docker push ${registry}:${BUILD_NUMBER}"
			  bat "docker push ${registry}:latest"     
		       }
           }
         }
       }
    }
	stage ("Docker Deployment"){
	      steps {
		      bat "docker run --name c-arshdeepsingh-master -d -p 7200:8080 ${registry}:latest"
	       }
	}
	stage ("Deploy to GKE"){
		steps{	
	             bat "kubectl apply -f deployment.yaml"
		}
	}
    }
}