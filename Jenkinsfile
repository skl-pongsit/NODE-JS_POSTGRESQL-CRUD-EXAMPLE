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
    image: docker:19.03.12
    command:
    - cat
    tty: true
'''
        }
    }
    stages {
        stage('Build and Deploy') {
            steps {
                container('kubectl') {
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
}
