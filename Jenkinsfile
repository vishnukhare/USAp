pipeline {
    agent any 
    
    // Define environment variables for the Docker image
    environment {
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_USERNAME = 'vishhnu24' // Replace with your username
        IMAGE_NAME = 'php-appointment-system'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        // Credential ID for Docker Hub login, stored in Jenkins
        DOCKER_HUB_CREDENTIAL_ID = 'docker-hub-credentials' 
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Gets code from your GitHub repository
                git url: 'https://github.com/vishnukhare/USAp.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Builds the Docker image using your Dockerfile
                sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }
        
        stage('Login and Push to Docker Hub') {
            steps {
                // Uses the Docker Hub credentials saved in Jenkins 
                // to log in and push the image.
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                                                passwordVariable: 'DOCKER_PASSWORD', 
                                                usernameVariable: 'DOCKER_USER')]) {
                    sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USER --password-stdin ${DOCKER_REGISTRY}"
                    sh "docker push ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker logout ${DOCKER_REGISTRY}"
                }
            }
        }
        
        // This stage will deploy the application to Kubernetes
        stage('Deploy to Kubernetes') {
            steps {
                // Deployment logic will be added in Step 4
                echo "Image pushed. Proceeding to Kubernetes deployment..."
            }
        }
    }
}