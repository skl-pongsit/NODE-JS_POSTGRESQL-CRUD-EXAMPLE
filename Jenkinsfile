pipeline {
    agent {
        docker {
            image 'docker:latest' // ใช้ Docker image ที่มี Docker ติดตั้ง
            args '-v /var/run/docker.sock:/var/run/docker.sock' // เชื่อมต่อ Docker socket
        }
    }

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
                    sh 'docker build -t pond:latest .'
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
