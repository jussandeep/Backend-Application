pipeline {
    agent any

    tools {
        // Use the exact name of your configured Maven tool in Jenkins
        maven 'Maven_3.9.11'
    }
    environment {
        DOCKER_HUB_USER = 'jsandeep9866'
        IMAGE = "${DOCKER_HUB_USER}/backend-application"
        TAG = "v1.0.${BUILD_NUMBER}"

        ARTIFact_NAME = "Backend-Application.jar"
        S3_BUCKET = "my-artifact-bucket"
       
        
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/jussandeep/Backend-Application.git'
            }
        }
        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Upload Artifact to S3'){
            steps {
                sh '''
                aws s3 cp target/${ARTIFact_NAME} 
                s3://${S3_BUCKET}/${ARTIFact_NAME}-${BUILD_NUMBER}
                '''
            }

        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE}:${TAG} ."
                sh "docker tag ${IMAGE}:${TAG} ${IMAGE}:latest"
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'DockerHubID', variable: 'DockerHubPwd')]) {
                        sh 'echo $DockerHubPwd | docker login -u ${DOCKER_HUB_USER} --password-stdin'
                        sh "docker push ${IMAGE}:${TAG}"
                        sh "docker push ${IMAGE}:latest"
    
                   }
                    
                }
            }
        }

        stage('Deploy to AWS EKS') {
            steps {
                sh '''
                # Connect kubectl to EKS
                aws eks update-kubeconfig \
                    --region ap-south-1 \
                    --name fullstack-cluster

                # Deploy MongoDB FIRST
                kubectl apply -f mongoDB.yaml

                # Deploy backend application
                kubectl apply -f backend.yaml

                # Verify rollout
                kubectl rollout status deployment/backend-deployment
                '''
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
