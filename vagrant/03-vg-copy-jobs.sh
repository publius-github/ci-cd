#!/bin/bash

sudo cp -rf /tmp/vagrant-jenkins/jobs/* /var/lib/jenkins/jobs/
sudo cp -rf /tmp/vagrant-jenkins/configs/* /var/lib/jenkins/
sudo chown jenkins:jenkins -R /var/lib/jenkins
sudo systemctl restart jenkins