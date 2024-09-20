pipeline {
    agent any

    environment {
        // Load environment variables from .env file if needed
        DATABASE_URL = 'postgres://user:password@db:5432/mydatabase'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository
                //git 'https://github.com/skl-pongsit/NODE-JS_POSTGRESQL-CRUD-EXAMPLE.git'
                sh 'ls -la'
            }
        }

        docker {
            image 'docker/compose:1.29.2'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    
        stage('Build and Run Docker Compose') {
            steps {
                script {
                    // Build and run services with Docker Compose
                    sh 'docker-compose -f docker-compose.yml up --build -d'
                }
            }
        }

        stage('Run Tests') {
            steps {
                // Run any tests for your Node.js app (if applicable)
                sh 'docker-compose exec api npm test'
            }
        }

        stage('Clean Up') {
            steps {
                // Stop and remove Docker containers
                sh 'docker-compose down'
            }
        }
    }

    post {
        always {
            // Always cleanup Docker environment after build
            sh 'docker-compose down -v'
        }
    }
}