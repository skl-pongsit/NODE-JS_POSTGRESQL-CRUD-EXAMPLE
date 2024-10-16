pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: maven
            image: maven:alpine
            command:
            - cat
            tty: true
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock
        '''
    }
  }
  environment {
        REGISTRY = 'docker.io'
        IMAGE_NAME = 'sklpongsit/poc-ci-cd'
  }
  stages {
      stage('Setup Credentials') {
        steps {
        // ใช้ withCredentials เพื่อดึงค่า credentials
        withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
          echo "Using Docker Username: $DOCKER_USERNAME"
          echo 'Using Docker Username: $DOCKER_USERNAME'
        }
        }
      }
    stage('Login-Into-Docker') {
      steps {
        container('docker') {
          // ใช้ withCredentials เพื่อดึงค่า credentials
          withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD $REGISTRY' //ใช้ตัวแปร DOCKER_USERNAME และ DOCKER_PASSWORD ได้ที่นี่
          }
        }
      }
    }
    stage('Build-Docker-Image') {
      steps {
        container('docker') {
          sh "docker build -t $REGISTRY/sklpongsit/poc-ci-cd:V2 ."
        }
      }
    }

    stage('Push-Images-Docker-to-DockerHub') {
      steps {
        container('docker') {
          sh "docker push $REGISTRY/sklpongsit/poc-ci-cd:V2"
        }
      }
    }
    stage('Prepare') { 
      steps {
        container('kubectl') {
          script {
            // Set environment variables
            def NAMESPACE = sh(script: 'cat /var/run/secrets/kubernetes.io/serviceaccount/namespace', returnStdout: true).trim()
            def TOKEN = sh(script: 'cat /var/run/secrets/kubernetes.io/serviceaccount/token', returnStdout: true).trim()
            def KUBE_API = 'https://kubernetes.default.svc.cluster.local'
            def SA = 'jenkins-runner'

            // Configure kubectl
            sh "kubectl config set-cluster my-cluster --server=$KUBE_API --insecure-skip-tls-verify=true"
            sh "kubectl config set-credentials $SA --token=$TOKEN --namespace=$NAMESPACE"
            sh "kubectl config set-context my-context --user=$SA --cluster=my-cluster --namespace=$NAMESPACE"
            sh 'kubectl config use-context my-context'
          }
        }
      }
    }
  }
}