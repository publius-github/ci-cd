FROM mysql:5.7
USER root

ENV MYSQL_ROOT_PASSWORD=
ENV MYSQL_DATABASE=
ENV MYSQL_USER=
ENV MYSQL_PASSWORD=
ENV MYSQL_ROOT_PASSWORD=

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY security.groovy /var/jenkins_home/init.groovy.d/security.groovy
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
RUN apt update && apt install -y make
USER jenkins
EXPOSE 8080
EXPOSE 50000

#  docker build -f Dockerfile -t cicd-jenkins .
#  docker run -d -v /w/devops/projects/godel/ci-cd/docker/jenkins/home/:/var/jenkins_home -p 8080:8080 -p 50000:50000 cicd-jenkins:latest