def dockerImage

pipeline {

  environment {
    dockerimagename = "0crash0/testdepl"
    registryCredentials = 'dockerhub'
    kubeCredential='kub_x509'
    //dockerImage = ""
    //DOCKER_ID = credentials('DOCKER_ID')
    //DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
  }

  agent any

  stages {
    stage('Init') {
             steps {
                 echo 'Initializing..'
                 echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
                 echo "Current branch: ${env.BRANCH_NAME}"
                 /*withCredentials([usernamePassword(credentialsId:env.registryCredential,passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                 }*/

             }
    }
    stage('Checkout Source') {
      steps {
        echo env.BRANCH_NAME
        //git  'https://github.com/0crash0/test_cicd.git'
        sh 'ls -la'
      }
    }

    stage('Build image') {
      steps{
        script {
            dockerImage = docker.build "${dockerimagename}:${env.BRANCH_NAME}"
        }
      }
    }

    stage('Pushing Image') {
      steps{
        script {
          //withDockerRegistry(credentialsId: 'registryCredentials', url: "https://myregistry") {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredentials ) {
            dockerImage.push()
          }
        }
      }
    }
    /*stage('Deploy to Cluster') {
      steps {
        sh 'envsubst < Deployment.yml | cat'
      }
    }*/
    /*stage('Deploying React.js container to Kubernetes') {
      steps {

          kubernetesDeploy(configs: "Deployment.yml")

     }
    }*/
    stage('Integrate Remote k8s with Jenkins ') {
          steps {

                withKubeConfig( clusterName: 'microk8s-cluster', contextName: 'microk8s-cluster', credentialsId: 'kube_just_cert', namespace: 'def', restrictKubeConfigAccess: false, serverUrl: 'https://172.16.0.230:16443') {
                  //sh 'curl -LO "https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl"'
                  //sh 'chmod u+x ./kubectl'
                  sh './kubectl get nodes'
                  sh 'envsubst \${BRANCH_NAME} < Deployment.yml | ./kubectl apply -f -'
              }
          }
    }
  }

}