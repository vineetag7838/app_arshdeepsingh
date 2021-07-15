pipeline { 
    agent any
    
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
                git url: 'https://github.com/ArshdeepSingh070/nagp-devops-home-assignment'
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
    }
}
