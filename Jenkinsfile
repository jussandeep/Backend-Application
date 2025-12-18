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

       
        
    }
    // stages {
    //     stage('Build Maven') {
    //         steps {
    //             // simple git checkout (branch main)
    //             git branch: 'main', url: 'https://github.com/jussandeep/Backend-Application.git'

    //             // run maven (Jenkins will put the configured maven on PATH)
    //             sh 'mvn clean install'
    //         }
    //     }
    //     stage('Build Docker Image') {
    //         steps {
    //             script {
    //                 sh 'docker build -t jsandeep9866/backend-application:latest .'
    //             }
    //         }
    //     }
    //     stage('Push Docker Image') {
    //         steps {
    //             script {
    //                 withCredentials([string(credentialsId: 'DockerHubID', variable: 'DockerDubPwd')]) {
    //                     sh 'docker login -u jsandeep9866 -p ${DockerDubPwd}'
    //                     sh 'docker push jsandeep9866/backend-application:latest'
    
    //                }
                    
    //             }
    //         }
    //     }
        
    // }
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

        stage('Deploy to google cloud in k8s') {
            steps {
                script {
                    // Load the JSON key file
                    withCredentials([file(credentialsId: 'GOOGLE_CLOUD_KEY', variable: 'GOOGLE_KEY_FILE')]) {
                        
                        // --- Configuration (Set using confirmed values) ---
                        def PROJECT_ID = "adroit-poet-452006-a3" 
                        def CLUSTER_NAME = "k8scluster1"   
                        def CLUSTER_ZONE = "africa-south1-c"    
                        // -----------------------------------------------------------------

                        // 1. Activate the service account
                        sh "gcloud auth activate-service-account --key-file=${GOOGLE_KEY_FILE}"
                        
                        // 2. Set the project config (Answer to Question 1: YES)
                        sh "gcloud config set project ${PROJECT_ID}"

                        // 3. Get the credentials for the GKE cluster (Answer to Question 2: YES, the approach is correct)
                        sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${CLUSTER_ZONE} --project ${PROJECT_ID}"

                        // 4. Apply the Kubernetes manifest (Answer to Question 3: MUST use backend-app.yaml)
                        // Ensure your backend-app.yaml is configured to pull the image using ${IMAGE}:${TAG}
                        sh "kubectl apply -f backend-app.yaml" 
                    }
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
