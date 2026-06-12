pipeline {
    agent any

    stages {
        stage('Clone Code') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Gradle Build & Test') {
            steps {
                echo 'Building application with Gradle inside Docker...'
                // This utilizes the multi-stage Dockerfile to build the application
                // It ensures you don't even need Gradle installed on your Jenkins server!
                sh 'docker build --target builder -t gradle-build-stage .'
            }
        }

        stage('Docker Build Image') {
            steps {
                echo 'Packaging final production Docker Image...'
                // This builds the final lightweight runtime image
                sh 'docker build -t my-gradle-app:latest .'
            }
        }

        stage('Docker Deploy / Run') {
            steps {
                echo 'Deploying application container...'
                // Stop and remove the existing container if it's already running from a previous build
                sh 'docker stop my-app-container || true'
                sh 'docker rm my-app-container || true'
                
                // Run the new container on port 8085
                sh 'docker run -d -p 8085:8080 --name my-app-container my-gradle-app:latest'
                echo 'Application successfully deployed to http://localhost:8085'
            }
        }
    }
}
