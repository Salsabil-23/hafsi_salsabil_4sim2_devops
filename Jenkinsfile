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
                    // Méthode alternative pour trouver le JAR
                    sh '''
                        echo "🔍 Recherche des fichiers JAR..."
                        ls -la target/
                        JAR_FILE=$(ls target/*.jar | head -1)
                        echo "📦 Fichier JAR trouvé: $JAR_FILE"

                        # Créer le Dockerfile
                        cat > Dockerfile << EOF
FROM openjdk:17-alpine
COPY target/*.jar app.jar
EXPOSE 8089
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

                        echo "📄 Contenu du Dockerfile:"
                        cat Dockerfile

                        # Builder l'image Docker
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest

                        echo "✅ Image Docker buildée avec succès"
                        docker images | grep student-management
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
                            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin

                            echo "🚀 Pushing image ${DOCKER_IMAGE}:${DOCKER_TAG}"
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}

                            echo "🚀 Pushing image ${DOCKER_IMAGE}:latest"
                            docker push ${DOCKER_IMAGE}:latest

                            echo "✅ Images poussées avec succès vers DockerHub!"
                        '''
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    echo "🧹 Nettoyage..."
                    docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true
                    docker rmi ${DOCKER_IMAGE}:latest || true
                '''
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline réussi avec succès!'
            echo "🐳 Image Docker disponible sur: ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
        }
        failure {
            echo '❌ Pipeline a échoué!'
        }
        always {
            sh '''
                echo "🔒 Déconnexion de DockerHub"
                docker logout || true

                echo "🧹 Nettoyage des fichiers temporaires"
                rm -f Dockerfile || true
            '''
        }
    }
}