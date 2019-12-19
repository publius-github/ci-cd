FROM jenkins/jenkins:lts

USER root

RUN apt-get update -y -qq && apt-get install -y -qq apt-transport-https ca-certificates curl gnupg2 software-properties-common git
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(cat /etc/os-release | grep VERSION= | awk -F "(" {'print $2'} | sed 's/)\"//') stable"
RUN apt-get update -y -qq && apt-get install -y -qq docker-ce docker-ce-cli containerd.io && apt-get install -y -qq awscli

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY --chown=jenkins:jenkins jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY --chown=jenkins:jenkins jenkins/ /var/jenkins_home/

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

EXPOSE 8080
EXPOSE 50000
