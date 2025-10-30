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
                // Gets code from your GitHub repository (This line needs correction)
                git url: 'https://github.com/vishnukhare/USAp.git', 
                    branch: 'phase-0' // <-- ADD THIS LINE
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // This runs the 'sh' command *inside* the docker:dind container
                    docker.image('docker:dind').inside { 
                        sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} ."
                    }
                }
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
                script {
                    echo "Deploying image tag: ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
                    
                    // 1. Create/Update Secrets (These rarely change)
                    sh "kubectl apply -f k8s/mariadb-secrets.yaml" 
                    
                    // 2. Deploy the Database (If it's the first run)
                    sh "kubectl apply -f k8s/db-deployment.yaml"
                    
                    // 3. Temporarily update the application deployment YAML with the new image tag
                    // This uses 'sed' to replace the 'latest' placeholder with the actual build tag
                    sh """
                        sed -i "s|vishhnu24/php-appointment-system:latest|vishhnu24/php-appointment-system:${IMAGE_TAG}|g" k8s/app-deployment.yaml
                    """

                    // 4. Apply the application deployment and service
                    sh "kubectl apply -f k8s/app-deployment.yaml" 
                    
                    // Optional: Revert the change in the local file to keep Git clean
                    // sh "git checkout k8s/app-deployment.yaml" 
                }
            }
        }
    }
}