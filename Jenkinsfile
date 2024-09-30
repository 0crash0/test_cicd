def dockerImage
// Variables for input
def inputDeploy
def inputPushDocker

pipeline {

  environment {
    dockerimagename = "0crash0/testdepl"
    registryCredentials = 'dockerhub'
    kubeCredential='kub_x509'
    //dockerImage = ""
    //DOCKER_ID = credentials('DOCKER_ID')
    //DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
    TELEGRAM_TOKEN = credentials('telegram-token') // change this line with your credential id for Telegram bot access token
    TELEGRAM_CHAT_ID = 389929520 // change this line with your credential id for Telegram bot chat id

    TEXT_PRE_BUILD = "Jenkins is building ${JOB_NAME}"
    TEXT_SUCCESS_BUILD = "${JOB_NAME} is Success"
    TEXT_FAILURE_BUILD = "${JOB_NAME} is Failure"
    TEXT_ABORTED_BUILD = "${JOB_NAME} is Aborted"
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
								[$class: 'ChoiceParameterDefinition',
                                    choices: ['no','yes'].join('\n'),
                                    name: 'input',
                                    description: 'Menu - select box option'],
                                    booleanParam(
                                        name: 'Push',
                                        defaultValue: true,
                                        description: 'Push it to docker?'
								),
								/*[$class: 'ChoiceParameterDefinition',
                                    choices: ['no','yes'].join('\n'),
                                    name: 'input',
                                    description: 'Menu - select box option'],
                                    booleanParam(
                                        name: 'Deploy',
                                        defaultValue: true,
                                        description: 'Deploy it to kubernetes?'
                                ),*/
                            ])

                    // Save to variables. Default to empty string if not found.
                    inputDeploy = userInput.input
                    //inputPushDocker = userInput.input
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
					//if(params.Deploy == "yes"){
					if(inputDeploy== "yes"){
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
  post{
          success{
              script {
                telegramSend(message: "Build ${env.BUILD_ID} on ${env.JENKINS_URL} Current branch: ${env.BRANCH_NAME} is SUCCESS" , chatId: ${env.TELEGRAM_CHAT_ID})
                  //bat ''' curl -s -X POST https://api.telegram.org/bot"%TELEGRAM_TOKEN%"/sendMessage -d chat_id="%TELEGRAM_CHAT_ID%" -d text="%TEXT_SUCCESS_BUILD%" '''
              }
          }
          failure{
              script {
                telegramSend(message: "Build ${env.BUILD_ID} on ${env.JENKINS_URL} Current branch: ${env.BRANCH_NAME} is FAILED", chatId: ${env.TELEGRAM_CHAT_ID})
                  //bat ''' curl -s -X POST https://api.telegram.org/bot"%TELEGRAM_TOKEN%"/sendMessage -d chat_id="%TELEGRAM_CHAT_ID%" -d text="%TEXT_FAILURE_BUILD%" '''
              }
          }
          aborted{
              script {
                telegramSend(message: "Build ${env.BUILD_ID} on ${env.JENKINS_URL} Current branch: ${env.BRANCH_NAME} is ABORTED", chatId: ${env.TELEGRAM_CHAT_ID})
                  //bat ''' curl -s -X POST https://api.telegram.org/bot"%TELEGRAM_TOKEN%"/sendMessage -d chat_id="%TELEGRAM_CHAT_ID%" -d text="%TEXT_ABORTED_BUILD%" '''
              }
          }

  }
}