pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    credentialsId: 'github-ssh',
                    url: 'git@github.com:Deepika-29-coder/tomcat-Dockers.git'
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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
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

    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the Jenkins console log.'
        }
    }
}
