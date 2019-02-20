
FROM jenkins/jenkins:lts

LABEL version="1.0"
LABEL Name="jenkins-test"

USER root
RUN apt-get update && apt-get install -y ruby maven && apt-get clean
USER jenkins

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

EXPOSE 8080/tcp
EXPOSE 50000/tcp


COPY jenkins-plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
