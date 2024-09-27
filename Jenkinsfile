def dockerImage
// Variables for input
def inputDeploy

pipeline {

  environment {
    dockerimagename = "0crash0/testdepl"
    registryCredentials = 'dockerhub'
    kubeCredential='kub_x509'
    //dockerImage = ""
    //DOCKER_ID = credentials('DOCKER_ID')
    //DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
  }
  /*parameters {
        booleanParam(name: 'Deploy', defaultValue: false, description: 'Set to true to Deploy to kubernetes')
  }*/
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
	stage("Choose what to do") {
            steps {
                script {

                    // Get the input
                    def userInput = input(
                            id: 'userInput', message: 'Enter path of test reports:?',
                            parameters: [
								booleanParam(
									name: 'Deploy',
									defaultValue: true,
									description: 'Deploy it to kubernetes?'
								),
                            ])

                    // Save to variables. Default to empty string if not found.
                    inputDeploy = userInput.Deploy
                }
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
				script {
					//if(params.Deploy == true){
					if(inputDeploy == true){
						sh "echo 'Deploy to kubernetes is started!'"
						withKubeConfig( clusterName: 'microk8s-cluster', contextName: 'microk8s-cluster', credentialsId: 'kube_just_cert', namespace: 'def', restrictKubeConfigAccess: false, serverUrl: 'https://172.16.0.230:16443') {
						  sh 'curl -LO "https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl"'
						  sh 'chmod u+x ./kubectl'
						  sh './kubectl get nodes'
						  sh 'envsubst \'${BRANCH_NAME} ${dockerimagename}\' < Deployment.yml | ./kubectl apply -f -'
						}
						sh "echo 'Deploy to kubernetes is finished!'"
					} else {
						sh "echo 'Deploy to kubernetes is canceled!'"
					}
				} 
			  }
	}
  }

}