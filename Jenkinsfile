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
        stage("SonarQube analysis") {
            steps {
              withSonarQubeEnv('SonarQubeScanner') {
                bat "${mvn}/bin/mvn sonar:sonar"
              }
            }
          }
	 stage("create docker image"){
             steps {
	         bat "docker build -t i-arshdeepsingh-master:${BUILD_NUMBER} --no-cache -f Dockerfile ."
	     }
	}
	stage ("Push docker image to docker hub"){
	      steps{
		       bat "docker tag i-arshdeepsingh-master ${registry}:${BUILD_NUMBER}"
		       withDockerRegistry([credentialsId: 'Test_Docker', url:""]){
			  bat "docker push ${registry}:${BUILD_NUMBER}"
		       }
		   }
	}
	stage ("Docker Deployment"){
	      steps {
		      bat "docker run --name c-arshdeepsingh-master -d -p 7100:8080 ${registry}:${BUILD_NUMBER}"
	       }
		
	}
	stage ("The end"){
	      steps{
		    echo "The process end"
	       }
	}    
    }
}
