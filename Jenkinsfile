pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
  - name: kubectl
    image: alpine/k8s:1.29.2
    command:
    - sleep
    args:
    - 99999999
    tty: true
  - name: docker
    image: registry.hub.docker.com/library/docker:dind
    command:
      - sh
    args:
      - -c
      - "/usr/local/bin/dockerd-entrypoint.sh && sleep 99999999"
    tty: true 
    securityContext:
      privileged: true
      runAsUser: 0
'''
            defaultContainer 'kubectl'
        }
    }
    stages {
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    script {
                        // สร้าง Docker image โดยใช้ Docker-in-Docker
                        sh 'docker build -t your-docker-image:latest .'
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    // ใช้ kubectl deploy ไปยัง Kubernetes cluster
                    sh 'kubectl apply -f deployment.yaml'
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
