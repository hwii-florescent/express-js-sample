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

        stage('Build Docker Image') {
            steps {
                script {
                    def tag = "${env.BUILD_NUMBER}"
                    sh "docker build -t 10.14.171.18:8082/hello-express:${tag} -f Dockerfile ."
                    sh "docker tag 10.14.171.18:8082/hello-express:${tag} 10.14.171.18:8082/hello-express:latest"
                    env.DOCKER_IMAGE_TAG = tag
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: '022220ef-2cf3-4223-811a-24b04851528e', url: 'http://10.14.171.18:8082', toolName: 'docker') {
                        sh "docker push 10.14.171.18:8082/hello-express:${env.DOCKER_IMAGE_TAG}"
                        sh "docker push 10.14.171.18:8082/hello-express:latest"
                    }
                }
            }
        }
        stage('Deploy to localhost') {
            steps {
                script {
                    withDockerRegistry(credentialsId: '022220ef-2cf3-4223-811a-24b04851528e', url: 'http://10.14.171.18:8082', toolName: 'docker') {
                        sh "docker pull 10.14.171.18:8082/hello-express:latest"
                        sh "docker rm -f hello-express || true"
                        sh "docker run -d -p 3000:3000 --name hello-express 10.14.171.18:8082/hello-express:latest"
                    }
                }
            }
        }
    }
    post {
        always {
            // Clean up the workspace
            cleanWs()
        }
    }
}
