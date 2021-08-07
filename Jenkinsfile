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
	stage('Container') {
         parallel {
          stage('PreContainer check') {
             steps{
                  bat 'docker rm -f c-arshdeepsingh-develop || exit '
                }
          }
          stage('Push docker image to docker hub') {
              steps {
               bat "docker tag i-arshdeepsingh-develop:${BUILD_NUMBER} ${registry}:develop-${BUILD_NUMBER}"
		       bat "docker tag i-arshdeepsingh-develop:${BUILD_NUMBER} ${registry}:develop-latest"
		       withDockerRegistry([credentialsId: 'Test_Docker', url:""]){
			  bat "docker push ${registry}:develop-${BUILD_NUMBER}"
			  bat "docker push ${registry}:develop-latest"     
		       }
           }
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
	               bat "kubectl apply -f deployment.yaml"
		}
	}
    }
}