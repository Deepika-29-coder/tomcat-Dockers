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
                        mvn org.sonarsource.scanner.maven:sonar-maven-plugin:5.7.0.6970:sonar \
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

        stage('OWASP Dependency Check') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'nvd-api-key',
                        variable: 'NVD_API_KEY'
                    )
                ]) {
                    sh '''
                        mvn org.owasp:dependency-check-maven:13.0.0:check \
                        -DnvdApiKey="$NVD_API_KEY" \
                        -DfailBuildOnCVSS=11
                    '''
                }
            }
        }

        stage('Archive OWASP Report') {
            steps {
                archiveArtifacts artifacts: 'target/dependency-check-report.html',
                                 allowEmptyArchive: false
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
            echo 'SonarQube Quality Gate: PASSED'
            echo 'OWASP Dependency Check: PASSED'
        }

        failure {
            echo 'Pipeline failed. Check the console output.'
        }
    }
}
