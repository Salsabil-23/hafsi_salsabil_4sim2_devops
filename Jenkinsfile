pipeline {
    agent any
    
    tools {
        maven 'M2_HOME'
    }
    
    environment {
        MAVEN_HOME = "${tool 'M2_HOME'}"
        PATH = "${env.MAVEN_HOME}/bin:${env.PATH}"
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

        stage('Prepare Docker') {
            steps {
                sh '''
                    echo "📄 Création du Dockerfile..."
                    cat > Dockerfile << EOF
FROM openjdk:17-alpine
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8089
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

                    echo "🐳 Dockerfile créé. Pour builder manuellement:"
                    echo "docker build -t salsabil55/student-management:${BUILD_NUMBER} ."
                    echo "docker push salsabil55/student-management:${BUILD_NUMBER}"
                '''
            }
        }
    }
}