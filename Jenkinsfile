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
    }
  }
  environment {
        dockerImage = ''
        ns_deploy = ''
        DOCKER_IMAGE = "sklpongsit/poc-ci-cd:$GIT_BRANCH-$GIT_COMMIT.take(7)"
        GIT_HASH = GIT_COMMIT.take(7)
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
            sh "sed -i.bak 's|image: .*|image: $DOCKER_IMAGE|' deployment.yaml" //find & replace image: xxx to image: $DOCKER_IMAGE
            sh 'kubectl apply -f deployment.yaml'
          }
        }
      }
    }
  }
}