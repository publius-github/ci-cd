New-NetFirewallRule -DisplayName "_jenkins 8080" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8080
New-NetFirewallRule -DisplayName "_jenkins 50000" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 50000
New-NetFirewallRule -DisplayName "_sonarqube 9000" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 9000

#  https://updates.jenkins.io/2.150/latest/
docker build -f .\jenkins.dockerfile -t jenkins_test .

docker run -d --name jenkins_test `
    -v c:\_devops\docker\jenkins\jenkins_home:/var/jenkins_home `
    -p 8080:8080 `
    -p 50000:50000 `
    jenkins_test


$container = docker ps | select-string jenkins; $con="$container".split(' ')[0]; Write-host $con
docker exec $con cat /var/jenkins_home/secrets/initialAdminPassword

docker build -f .\sonarqube.dockerfile -t sonarqube .


docker run -d --name sonarqube `
    -p 9000:9000 `
    -v c:\_devops\docker\sonarqube\conf:/opt/sonarqube/conf `
    -v c:\_devops\docker\sonarqube\data:/opt/sonarqube/data `
    -v c:\_devops\docker\sonarqube\logs:/opt/sonarqube/logs `
    -v c:\_devops\docker\sonarqube\extensions:/opt/sonarqube/extensions `
    sonarqube

#    -e sonar.jdbc.username=sonar `
#    -e sonar.jdbc.password=sonar `
#    -e sonar.jdbc.url=jdbc:postgresql://localhost/sonar `