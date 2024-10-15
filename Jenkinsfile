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
          // คุณสามารถใช้ตัวแปร DOCKER_USERNAME และ DOCKER_PASSWORD ได้ที่นี่
          echo "Using Docker Username: $DOCKER_USERNAME"
          echo 'Using Docker Username: $DOCKER_USERNAME'
        }
      }
        }
    stage('Login-Into-Docker') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD $REGISTRY'
          }
          // sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
          sh 'echo Username: $DOCKER_USERNAME'
          sh 'echo Password: $DOCKER_PASSWORD'
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
  }
}