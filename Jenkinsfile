pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'master', changelog: false, poll: false, url: 'https://github.com/hwii-florescent/express-js-sample.git'
            }
        }
        // stage('Compile') {
        //     steps {
        //         sh "mvn clean compile"
        //     }
        // }
        stage('Sonarqube Analysis') {
            steps {
                sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.host.url=http://localhost:9000/ -Dsonar.login=squ_544036d422b742deaf641e6ef159161c6a49acbc -Dsonar.projectName=express-sameple -Dsonar.sources=. -Dsonar.projectKey=express-sameple '''
            }
        }
        stage('OWASP SCAN') {
            steps {
                dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DP'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        // stage('Build Application') {
        //     steps {
        //         sh 'mvn clean install -DskipTests=true'
        //     }
        // }
        stage('Build & Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: '022220ef-2cf3-4223-811a-24b04851528e', url: 'http://10.14.171.18:8082', toolName: 'docker') {
                        sh "docker build -t hello-express:latest -f Dockerfile ."
                        sh "docker tag hello-express:latest 10.14.171.18:8082/hello-express:latest"
                        sh "docker push 10.14.171.18:8082/hello-express:latest"
                        sh "docker run -d --name hello-express -p 3000:3000 10.14.171.18:8082/hello-express:latest"
                    }
                }
            }
        }
    }
}
