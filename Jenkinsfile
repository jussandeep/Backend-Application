pipeline {
    agent any

    tools {
        // Use the exact name of your configured Maven tool in Jenkins
        maven 'Maven_3.9.11'
    }

    stages {
        stage('Build Maven') {
            steps {
                // simple git checkout (branch main)
                git branch: 'main', url: 'https://github.com/jussandeep/Backend-Application.git'

                // run maven (Jenkins will put the configured maven on PATH)
                sh 'mvn clean install'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t jsandeep9866/backend-application:latest .'
                }
            }
        }
    }
    
    
    



    post {
        always {
            // optional: archive build logs/artifacts, etc.
            echo "Pipeline finished"
        }
    }
}
