pipeline {
    agent any
    
    tools {
        jdk 'jdk11'
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
        // stage('Sonarqube Analysis') {
        //     steps {
        //         sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.url=http://10.15.220.97:9000/ -Dsonar.login=squ_eabaeb4d5f6eb9f839b0cf2e34ea26c502da8bdb -Dsonar.projectName=express-sameple -Dsonar.sources=. -Dsonar.projectKey=express-sameple '''
        //     }
        // }
        // stage('OWASP SCAN') {
        //     steps {
        //         dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DP'
        //             dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
        //     }
        // }
        // stage('Build Application') {
        //     steps {
        //         sh 'mvn clean install -DskipTests=true'
        //     }
        // }
        stage('Build & Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: '5b5fe71b-ef0c-497a-a6c9-674b90a0699e', url: 'http://localhost:8083' toolName: 'docker') {
                        sh "docker build -t hello-express:latest -f Dockerfile ."
                        sh "docker tag hello-express:latest localhost:8083/hello-express:latest"
                        sh "docker push localhost:8083/hello-express:latest"
                        sh "docker run -d --name hello-express -p 3000:3000 localhost:8083/hello-express:latest"
                    }
                }
            }
        }
    }
}
