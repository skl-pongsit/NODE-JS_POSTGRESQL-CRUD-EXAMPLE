pipeline {
    agent {
        kubernetes {
            label 'jenkins-k8s-agent'
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: jenkins-pipeline
spec:
  serviceAccountName: jenkins
  containers:
  - name: kubectl
    image: bitnami/kubectl:latest
    command:
    - cat
    tty: true
  - name: docker
    image: docker:19.03.12-dind
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run/docker.sock
    - name: docker-storage
      mountPath: /var/lib/docker
  volumes:
  - name: docker-socket
    emptyDir: {}
  - name: docker-storage
    emptyDir: {}
"""
        }
    }

    environment {
        REGISTRY = 'docker.io/sklpongsit' // แทนที่ด้วย Docker registry ของคุณ
        IMAGE_NAME = 'your-image-name' // แทนที่ด้วยชื่อ image ของคุณ
        REGISTRY_CREDENTIALS_ID = 'docker-registry-credentials' // ID ของ Docker credentials ใน Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/rtyler/14a43e3c2c21d876d3f6315b1e82bc25.git', branch: 'master'
            }
        }

        stage('Login to Docker') {
            steps {
                container('docker') {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD $REGISTRY'
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    script {
                        sh 'docker build -t $REGISTRY/$IMAGE_NAME:latest .'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                container('docker') {
                    script {
                        sh 'docker push $REGISTRY/$IMAGE_NAME:latest'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    script {
                        sh 'kubectl apply -f kubernetes/deployment.yaml --kubeconfig=$KUBECONFIG'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
