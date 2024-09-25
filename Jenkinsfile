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

              //withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'demo1', contextName: '', credentialsId: 'SECRET_TOKEN', namespace: 'default', serverUrl: '']]) {
              /*withKubeConfig(caCertificate: '''-----BEGIN CERTIFICATE-----
              MIIDDzCCAfegAwIBAgIUaqnDgyvxbnSVZ31mWoIi45p4nhwwDQYJKoZIhvcNAQEL
              BQAwFzEVMBMGA1UEAwwMMTAuMTUyLjE4My4xMB4XDTI0MDkyMzA5MjIyN1oXDTM0
              MDkyMTA5MjIyN1owFzEVMBMGA1UEAwwMMTAuMTUyLjE4My4xMIIBIjANBgkqhkiG
              9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxYpB72CwSVQCbUw6QPXi1+TUl7F05ruLx44S
              tSDwKkRSkXWKcnZLN5h0sIbyRfz5rsGkWmFOWJ5AcIzwx2kSyZoG3njavDmvJ9H8
              UWd3R6dl3kNE1XWHl+y6Acg7vrMi/HrbDZjtNo8OGcbu9NztygB5Ow4Z5KI1ox+B
              9phJX6CayxtTNRQs8zXjnZo5el6NcibSkZFD54Hppt4O4MpfY5Q6CGkn2V31HmX6
              +dk6ho/Wth7Kn/On9GdE1kHuxLBB40yWLb9tVHPmE0obwF8KDFVfdFkM0ve32x0A
              bu1Qhy0BY898EJC4tG+GqL78JiWPT+e53eVdfa5aA3Y0zmfCvQIDAQABo1MwUTAd
              BgNVHQ4EFgQUctEP8T0dF1hzUs7EyqQp04KJTJ4wHwYDVR0jBBgwFoAUctEP8T0d
              F1hzUs7EyqQp04KJTJ4wDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOC
              AQEAvZ6TE2dGJYUQwqIwuC8ZakLJyfsTbCQHoMgNhbhSNCyD195CNNO8ANd4OfiB
              yTanQ+CERrC+/Okm3pAkAvKHif48Z/VJ0tGck9c4g1mpd73+/7Hj0SqSXbT13V+x
              Sok8dNLT/3VXrRfUmcMDJvUM7/kbFm1Sw/6JMQcWGrzdXFLj1OWLzmvCW3QyF8JA
              9S/rSrdcrhx/+dqaHnABi0jZ+3rHMP8F32Ba22TJmS0BY9y0yUy+Hs/+Dr7QUzQK
              TaRxjPuDFDmnF1M/6hPk9pLB4M+Yjpuq2KzBiBiAO8TpYVrJMUMyLT2cU0FaLJhO
              DfuEiKloZa7BiJwDNq1pGA9iZg==
              -----END CERTIFICATE-----''', clusterName: 'microk8s-cluster', contextName: 'microk8s-cluster', credentialsId: 'kube_just_cert', namespace: 'def', restrictKubeConfigAccess: false, serverUrl: 'https://172.16.0.230:16443') {
                  // some block
*/
              withCredentials([usernamePassword(credentialsId:env.kubeCredential,passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                  sh 'curl.exe -LO "https://dl.k8s.io/release/v1.31.0/bin/windows/amd64/kubectl.exe"'
                  sh 'chmod u+x ./kubectl'
                  sh './kubectl get nodes'
              }
          }
  }

}