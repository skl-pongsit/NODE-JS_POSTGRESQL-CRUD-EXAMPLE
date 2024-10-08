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
    jenkins-agent: kubernetes
spec:
  containers:
  - name: kubectl
    image: bitnami/kubectl:latest
    command:
    - cat
    tty: true
  - name: docker
    image: docker:19.03.12
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-socket
    hostPath:
      path: /var/run/docker.sock
"""
        }
    }
    environment {
        REGISTRY = 'docker.io/sklpongsit'
        IMAGE_NAME = 'your-image-name'
        REGISTRY_CREDENTIALS_ID = 'docker-registry-credentials' // Docker credentials in Jenkins
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
