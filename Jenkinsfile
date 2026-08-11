pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git(
                    url: 'git@github.com:Deepika-29-coder/tomcat-Dockers.git',
                    branch: 'master',
                    credentialsId: 'ssh-new'
                )
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t tomcat-docker-app:latest .'
            }
        }

        stage('Deploy') {
            steps {
                sh 
                    docker stop tomcat-docker-container || true
                    docker rm tomcat-docker-container || true

                    docker run -d \
                        --name tomcat-docker-container \
                        -p 8083:8080 \
                        tomcat-docker-app:latest
                
            }
        }
    }
}
