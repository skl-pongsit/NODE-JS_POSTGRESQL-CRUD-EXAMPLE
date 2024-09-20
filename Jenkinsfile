pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // ดึงโค้ดจาก GitHub
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    // สร้าง Docker image
                    sh 'docker build -t your-image-name:latest .'
                }
            }
        }

        stage('Test') {
            steps {
                // รันการทดสอบ
                sh 'npm install'
                sh 'npm test'
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    // Deploy ไปยัง Production (ตัวเลือก)
                    kubernetesDeploy(
                        configs: 'k8s/deployment-production.yaml',
                        kubeconfigId: 'your-kubeconfig-id'
                    )
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
