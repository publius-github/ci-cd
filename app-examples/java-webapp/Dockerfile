FROM httpd:latest

LABEL version="1.0"
LABEL Name="test java"
#USER root
#RUN apt-get update && apt-get install -y make && apt-get clean
# COPY sonar.properties /opt/sonarqube/conf/

EXPOSE 80/tcp
COPY ./exampl.html /usr/local/apache2/htdocs/