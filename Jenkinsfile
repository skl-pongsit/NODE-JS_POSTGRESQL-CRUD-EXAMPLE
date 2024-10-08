pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: jenkins-pipeline
spec:
  serviceAccountName: jenkins  # ระบุ serviceAccount ที่จะใช้
  containers:
  - name: kubectl
    image: bitnami/kubectl:latest
    command:
    - cat
    tty: true
  - name: docker
    image: docker:dind
    securityContext:
      privileged: true  # ต้องการสิทธิพิเศษเพื่อใช้ Docker-in-Docker
    command:
    - dockerd-entrypoint.sh
    args:
    - --host=tcp://0.0.0.0:2375
    - --host=unix:///var/run/docker.sock
    env:
    - name: DOCKER_TLS_CERTDIR
      value: ""
    ports:
    - containerPort: 2375
      hostPort: 2375
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-socket
    hostPath:
      path: /var/run/docker.sock
'''
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
