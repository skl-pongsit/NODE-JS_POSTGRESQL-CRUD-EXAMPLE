pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: kubectl
            image: alpine/k8s:1.29.2
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
        DOCKER_IMAGE = 'sklpongsit/poc-ci-cd:V2'
        // ns_deploy = ''
        // GIT_HASH = GIT_COMMIT.take(7)
        // ns_develop = 'develop'
        // ns_staging = 'staging'
        // application_name = 'kubectl'

        K8S_NAMESPACE = ''
        K8S_DEPLOYMENT = ''
        APP_NAME = ''
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
    // stage('Deploy') {
    //   steps {
    //     container('kubectl') {
    //       script {
    //         if (env.BRANCH_NAME == 'main') {
    //             ns_deploy = env.ns_staging
    //           } else {
    //           error "Unsupported branch: ${env.BRANCH_NAME}"
    //         }

    //         sh 'kubectl get all -A'
    //         sh "echo ${env.BRANCH_NAME}"
    //         sh "echo ${env.GIT_COMMIT}"
    //         sh "echo $ns_staging"
    //         sh "echo $ns_deploy"

    //         sh "helm upgrade -i ${env.application_name} helm-generic-chart -f deployment/values-${ns_deploy}.yaml --set image.repository=sklpongsit/${env.application_name} --set image.tag=${env.BRANCH_NAME}-${env.GIT_HASH} --set fullnameOverride=${env.application_name} -n ${ns_deploy}"
    //       }
    //     }
    //   }
    // }
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

    stage('Deploy-to-Kubernetes') {
      steps {
        container('kubectl') {
          sh '''
            kubectl set image deployment/cicd-deployment app-container=$DOCKER_IMAGE --namespace=ops
            kubectl rollout status deployment/cicd-deployment --namespace=ops
          '''
        }
      }
    }
  }
}