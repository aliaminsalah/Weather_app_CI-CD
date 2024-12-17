pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'aliamin10'    // Docker Hub username
        IMAGE_NAME = 'webweather'       // Docker image name
        CONTAINER_NAME = 'weather-app'  // Docker container name
        DOCKER_PORT = '5000'            // Application port
    }

    stages {
        stage('Build Image') {
            steps {
                script {
                    sh """
                        docker build --no-cache -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest .
                    """
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    // Ensure any existing container is removed
                    sh """
                        docker rm -f ${CONTAINER_NAME} || true
                        docker run -d --name ${CONTAINER_NAME} -p ${DOCKER_PORT}:${DOCKER_PORT} ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Verify the container is running
                    sh """
                        docker ps | grep ${CONTAINER_NAME}
                    """
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // sh """
                           // echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USER} --password-stdin
                            // docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                        //"""
                        sh """ 
                            echo "this stage is done"
                            """
                    }
                }
            }
        }

        stage('Play Ansible') {
            steps {
                script {
                    // Assuming inventory and playbook.yml files are available
                    sh """
                        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory playbook.yml
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                // Cleanup any resources used
                sh """
                    docker rm --force ${CONTAINER_NAME} || true
                    docker rmi --force ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest || true
                    docker logout || true
                """
            }
        }
    }
}
