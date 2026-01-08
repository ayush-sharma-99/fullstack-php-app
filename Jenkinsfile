pipeline {
    agent any

    tools {
        sonarRunner 'SonarScanner'
    }

    environment {
        SONAR_HOST  = "http://13.60.186.213:9000"
        PROJECT_KEY = "fullstack-php-app"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ayush-sharma-99/fullstack-php-app.git'
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('sonarqube-ec2') {
                    sh """
                    sonar-scanner \
                    -Dsonar.projectKey=${PROJECT_KEY} \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=${SONAR_HOST}
                    """
                }
            }
        }

        stage('Fetch SonarQube JSON Report') {
            steps {
                withCredentials([string(credentialsId: 'sonar-api-token', variable: 'SONAR_TOKEN')]) {
                    sh """
                    curl -u ${SONAR_TOKEN}: \
                    "${SONAR_HOST}/api/issues/search?componentKeys=${PROJECT_KEY}" \
                    -o sonar-report.json
                    """
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'sonar-report.json', fingerprint: true
        }
    }
}
