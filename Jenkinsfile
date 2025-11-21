pipeline {
    agent any
    
    tools {
        maven 'M2_HOME'
    }
    
    environment {
        MAVEN_HOME = "${tool 'M2_HOME'}"
        PATH = "${env.MAVEN_HOME}/bin:${env.PATH}"
        DOCKER_IMAGE = "salsabil55/student-management"
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Salsabil-23/hafsi_salsabil_4sim2_devops.git'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                        echo "🔍 Vérification des fichiers..."
                        ls -la target/

                        echo "📄 Création du Dockerfile..."
                        cat > Dockerfile << EOF
FROM openjdk:17-alpine
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8089
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

                        echo "🐳 Construction de l'image Docker..."
                        # Utilisation de sudo temporairement
                        sudo docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        sudo docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest

                        echo "✅ Image construite avec succès"
                        sudo docker images | grep student-management
                    '''
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh '''
                            echo "🔐 Authentification à DockerHub..."
                            echo $DOCKER_PASSWORD | sudo docker login -u $DOCKER_USERNAME --password-stdin

                            echo "🚀 Envoi de l'image ${DOCKER_IMAGE}:${DOCKER_TAG}"
                            sudo docker push ${DOCKER_IMAGE}:${DOCKER_TAG}

                            echo "🚀 Envoi de l'image ${DOCKER_IMAGE}:latest"
                            sudo docker push ${DOCKER_IMAGE}:latest

                            echo "✅ Images envoyées avec succès vers DockerHub!"
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline réussi avec succès!'
            echo "🐳 Image Docker: ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
        }
        failure {
            echo '❌ Pipeline a échoué!'
        }
        always {
            sh '''
                echo "🔒 Déconnexion de DockerHub"
                sudo docker logout || true
            '''
        }
    }
}