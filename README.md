Docker install
### чтобы локальный докер мог стягивать с нексуса надо создать папкуи и скопировать туда все серт что получили выше
https://docs.docker.com/engine/security/certificates/
```bash
sudo mkdir /etc/docker/certs.d
sudo mkdir /etc/docker/certs.d/samodocker.samo.ru
sudo cp ca.crt /etc/docker/certs.d/samodocker.samo.ru
sudo cp client.key /etc/docker/certs.d/samodocker.samo.ru
sudo cp client.cert /etc/docker/certs.d/samodocker.samo.ru
```

-------------------------------------------------------------------
Jenkins install
sudo apt-get install default-jdk
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins




sudo usermod -a -G docker jenkins
sudo usermod -a -G docker $USER

---------------------------------------------------------------------
Jenkins plugins required:

at install:
Pipeline
Credentials Binding
Git

after:
Remote Jenkinsfile Provider
MultiBranch Action Triggers
Pipeline: Stage View
Docker Pipeline
Kubernetes CLI
Job DSL  // IF YOU LIKE TO GENERTE ALL JOBS USING JenkinsDSL File

---------------------------------------------------------------------
YOU MUST CREATE CREDETINALS

kube_just_cert --- certificate for kubernetes connection
Certificates: /var/snap/microk8s/current/certs/client.cert
Private key: /var/snap/microk8s/current/certs/client.key

dockerhub --- user pass for docker hub ~ NOT NEEDED IF USE OWN REPO
samodocker-repo --- user pass for OWN REPO
telegram-token --- token for telegram bot api








-----------------------------------------------------------------

Jenkins plugins recommended:

Workspace Cleanup
Pipeline Graph View
Purge Job History Plugin




красотульки 
https://devopscube.com/setup-custom-materialized-ui-theme-jenkins/

Login theme
material theme

BlueOcean