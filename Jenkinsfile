pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-runner
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

    environment {
        dockerImage = ''
        ns_deploy = ''
        GIT_HASH = GIT_COMMIT.take(7)
        application_name = "poc-application"
    }
}