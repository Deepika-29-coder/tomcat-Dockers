pipeline {
    agent any

    environment {
        SONAR_PROJECT_KEY = 'tomcat-Docker'
    }

    stages {

        stage('Checkout') {
            steps {
                git(
                    url: 'git@github.com:Deepika-29-coder/tomcat-Dockers.git',
                    branch: 'master',
                    credentialsId: 'github-ssh'
                )
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck(
                    additionalArguments: '--scan .',
                    odcInstallation: 'Dependency-Check'
                )
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn sonar:sonar \
                          -Dsonar.projectKey=tomcat-Docker \
                          -Dsonar.projectName=tomcat-Docker
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t tomcat-docker-app:latest .'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker stop tomcat-docker-container || true
                    docker rm tomcat-docker-container || true

                    docker run -d \
                        --name tomcat-docker-container \
                        -p 8083:8080 \
                        tomcat-docker-app:latest
                '''
            }
        }
    }
}
