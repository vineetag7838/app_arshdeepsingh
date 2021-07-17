pipeline { 
    agent any
    
	environment {
	    def mvn = tool 'Maven3';
		def registry = 'arshdeepsingh070/devops-home-assignment';
	 
	}
    tools {
        maven 'Maven3'
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
	 stage("Remove docker images and container"){
		 steps {
			 bat "docker rmi arshdeepsingh/devops-home-assignment:${BUILD_NUMBER} -1"
			 bat "docker stop DevopsHomeAssignment"
			 bat "docker rm DevopsHomeAssignment"
		 }
	  }
	 stage("create docker image"){
             steps {
	         bat "docker build -t i-arshdeepsingh-master --no-cache -f Dockerfile ."
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
