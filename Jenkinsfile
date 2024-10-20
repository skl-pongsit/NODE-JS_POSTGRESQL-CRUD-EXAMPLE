pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          serviceAccountName: jenkins
          automountServiceAccountToken: true
          containers:
          - name: kubectl
            image: alpine/k8s:1.29.2
            command:
            - cat
            tty: true
          - name: docker
            image: registry.hub.docker.com/library/docker:dind
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
        // IMAGE_NAME = 'sklpongsit/poc-ci-cd'
        DOCKER_IMAGE = 'sklpongsit/poc-ci-cd:V2'
        GIT_HASH = GIT_COMMIT.take(7)

  // ns_deploy = ''
  }
  stages {
    stage('Build') {
      steps {
        container('docker') {
          script {
            dockerImage = docker.build("${env.DOCKER_IMAGE}")
            withDockerRegistry(
                            credentialsId: 'docker-registry-credentials',
                            url: 'https://index.docker.io/v1/') {
              dockerImage.push()
                            }
          }
        }
      }
    }

        stage('Deploy') {
      steps {
        container('kubectl') {
          script {
            sh 'kubectl apply -f deployment.yaml'
          }
        }
      }
    }
  }
}