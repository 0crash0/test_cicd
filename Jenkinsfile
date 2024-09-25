pipeline {

  environment {
    dockerimagename = "0crash0/testdepl"
    registryCredential = 'dockerhub-credentials'
    dockerImage = ""
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
                 //sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_ID --password-stdin'
             }
    }
    stage('Checkout Source') {
      steps {
        echo env.BRANCH_NAME
        sh 'git clone https://github.com/0crash0/test_cicd.git'
        sh 'ls -la'
      }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build "${dockerimagename}"
        }
      }
    }

    //stage('Pushing Image') {
    //  environment {
    //           registryCredential = 'dockerhub-credentials'
    //       }
    //  steps{
    //    script {
    //      docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
    //        dockerImage.push(env.BRANCH_NAME)
    //      }
    //    }
    //  }
    //}

    //stage('Deploying React.js container to Kubernetes') {
    //  steps {
    //    script {
    //      kubernetesDeploy(configs: "deployment.yaml", "service.yaml")
    //    }
    // }
    //}

  }

}