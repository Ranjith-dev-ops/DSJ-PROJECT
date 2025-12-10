pipeline {
    agent any

    environment {
        DOCKERHUB_CREDS = credentials('docker-hub-token')
        SONARQUBE = 'sonar-local'
        IMAGE = "ranjitha001/my-ci-app"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Ranjith-dev-ops/DSJ-PROJECT.git'
            }
        }

        stage('Test') {
            steps {
                bat """
                echo Running tests...
                "C:\\Program Files\\Git\\bin\\bash.exe" test.sh
                """
            }
        }


        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    bat """
                    sonar-scanner ^
                      -Dsonar.projectKey=my-ci-app ^
                      -Dsonar.sources=.
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 2, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Quality Gate failed: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    bat """
                    docker build -t ${IMAGE}:${BUILD_NUMBER} .
                    echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin
                    docker push ${IMAGE}:${BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Deploy Locally') {
            steps {
                bat """
                docker rm -f my-ci-app || true
                docker run -d --name my-ci-app ${IMAGE}:${BUILD_NUMBER}
                """
            }
        }
    }
}

