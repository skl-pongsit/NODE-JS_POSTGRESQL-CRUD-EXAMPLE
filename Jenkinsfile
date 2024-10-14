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
        // DOCKER_CREDENTIALS = credentials('docker-registry-credentials')
        DOCKER_USERNAME = credentials('docker-registry-credentials')
        DOCKER_PASSWORD = credentials('docker-registry-credentials')
        REGISTRY = 'docker.io'
        IMAGE_NAME = 'sklpongsit/poc-ci-cd'
    }
  stages {
        stage('Use Credentials') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', 
                        usernameVariable: 'USERNAME', 
                        passwordVariable: 'PASSWORD')]) {
                        // Now you can use the USERNAME and PASSWORD environment variables
                        sh 'echo Username: $USERNAME'
                        sh 'echo Password: $PASSWORD'
                    }
                }
            }
        }
    stage('Login-Into-Docker') {
      steps {
        container('docker') {
        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
        // sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin $REGISTRY'
        sh 'echo Username: $DOCKER_USERNAME'
        sh 'echo Password: $DOCKER_PASSWORD'
       }
      }
    }
    stage('Build-Docker-Image') {
      steps {
        container('docker') {
          sh 'docker build -t $REGISTRY/sklpongsit/poc-ci-cd:latest .'
        }
      }
    }
    
     stage('Push-Images-Docker-to-DockerHub') {
      steps {
        container('docker') {
          sh 'docker push $REGISTRY/sklpongsit/poc-ci-cd:latest'
         
        }
      }
    }
  } 
  //   post {
  //     always {
  //       container('docker') {
  //         sh 'docker logout'
  //     }
  //   }
  // }
}
//     stage('Build-Jar-file') {
//       steps {
//         container('maven') {
//           sh 'mvn package'
//         }
//       }
//     }