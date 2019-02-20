FROM sonarqube:lts

LABEL version="1.0"
LABEL Name="sonarqube-test"

#USER root
#RUN apt-get update && apt-get install -y make && apt-get clean
# COPY sonar.properties /opt/sonarqube/conf/

EXPOSE 9000/tcp
