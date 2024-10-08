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
  serviceAccountName: jenkins
  containers:
  - name: kubectl
    image: bitnami/kubectl:latest
    command:
    - cat
    tty: true
  - name: docker
    image: docker:20.10-dind
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
'''
        }
    }

    stages {
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    script {
                        // Build Docker image
                        sh 'docker build -t my-app-image:latest .'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                container('docker') {
                    script {
                        // Push Docker image to a registry
                        sh 'docker tag my-app-image:latest registry.hub.docker.com/library/docker:dind/my-app-image:latest'
                        sh 'docker push registry.hub.docker.com/library/docker:dind/my-app-image:latest'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    script {
                        // Apply Kubernetes manifests
                        sh 'kubectl apply -f deployment.yaml'
                    }
                }
            }
        }
    }
}
