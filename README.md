### Create a Virtual Machine with 2CPU and 4GB Memory with IAM Access
### Make Sure to open ports 
- Type            Protocol            Port Range          Source
- Custom TCP      TCP                 1000-11000          0.0.0.0/0
- HTTP            TCP                 80                  0.0.0.0/0
- Custom TCP      TCP                 500-1000            0.0.0.0/0
- HTTPS           TCP                 443                 0.0.0.0/0
- SSH             TCP                 22                  0.0.0.0/0

### Prerequsites:
- aws cli
- # Production_Level_CICD

- Create 3 t2.medium machines for Jenkins Nexus SonarQube
- Install Docker and run below commands
```
curl https://get.docker.com | bash
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins
newgrp docker
```
- Restart Jenkins Server
- Run Nexus and Sonarqube with Docker
```
docker run -d -p 9000:9000 sonarqube:lts-community
```
```
docker run -d -p 8081:8081 sonatype/nexus3
```
```
docker exec -it sonanexyx -it /bin/bash
cat sonatype-work/nexus3/admin.password
```
- To access the cluster create the kubeconfig file with following command.
```
aws eks --region us-east-1 update-kubeconfig --name <cluster_name>
```

### Jenkins Plugins
- Pipeline:Stage View
- Kubernetes
- Kubernetes Client API
- Kubernetes Credentials
- Kubernetes CLI
- SonarQube Scanner
- Docker
- Docker Pipeline
- Config file provider