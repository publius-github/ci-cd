![](https://github.com/publius-github/ci-cd/blob/master/CI_POC.png)

**How to deploy dynamic jenkins env:**
1. Set profile in Makefile
2. Each env should use profile/bucket you have access, and it should be changed in:
* terraform/00-init/01-provider.tf
* terraform/01-cicd-jenkins/01-provider.tf
* terraform/02-cicd-ecs/01-provider.tf
* terraform/03-cicd-fargate/01-provider.tf
2. Type `make 00-init`
3. Type `make 01-plan`
4. Type `make 01-apply`
5. Add credentials to jenkins
6. Build.

**Credentials required for work**  
should be saved as secret text  
1. aws (aws credentials)
2. sonar_db_login (login for sonar db)
3. sonar_db_passwd (password for sonar db)
4. github (github credentials)

should be added in jenkins settings
1. ssh private key

**Features for new release**
* Block device mapping to slave (or just more space)
* groovy init script ec2
* make file create s3 for state
* docker compose as service on host system
* email notification on fail
* code deploy

**Jenkinsfiles**
* jenkinsfiles/stc-docker.jenkinsfile - build and test app on ec2 dynamic agent
* jenkinsfiles/stc-aws-fargate.jenkinsfile - deploy app to fargate + run tests there
* jenkinsfiles/stc-aws-shared-resourses.jenkinsfile - deploy app to fargate + run tests there + use shared DB
* jenkinsfiles/stc-aws-fargate-destroy.jenkinsfile - destroy fargate environment if required

**Helper**  
Each applications could be scaled, and deployed across multiple availability zones.  
For this purposes a few variables should be changed:  
* `desired_count` in terraform/03-cicd-fargate/08-backend.tf
* `az_count` in terraform/03-cicd-fargate/99-vars.tf  
  
jenkins URL: http://jenkins.simple-testing-capabilities.co.uk:8080/  
sonarqube URL: http://sonar.simple-testing-capabilities.co.uk:9000/  
app URL: http://frontend.simple-testing-capabilities.co.uk:3000  
  
logs location: s3://simple-testing-capabilities-tests/logs  
api tests location: s3://simple-testing-capabilities-tests/api-tests  
ui tests location: s3://simple-testing-capabilities-tests/ui-tests  


<!-- > 1. Create ECR in 00-terraform<br/> -->
<!-- > 4. Pipeline: artifact to s3 (assume role to ec2?) > 01-terraform<br/> -->
<!-- 3. create s3 for tests result -->
<!-- 12. Результаты тестов в файл на с3 -->
<!-- 1. make file create ecr -->
<!-- 3. make file docker build && push to ecr (means JENKINS) -->
<!-- 5. attach role to instance -->
<!-- 6. pull docker image -->
<!-- 7. кондишон исполнения нул ресурса -->
<!-- 9. тригерить один за одним паййплайны -->
<!-- 11. ввынести юай / апи тесты в дженкинс (не контейнер) (установить дотнет) -->
<!-- 13. в косоле дженкинса тоже все логи -->
<!-- 14. одну кнопку -->
<!-- 16. сонаркуб -->
<!-- 19. сонаркуб в пайплайн -->
<!-- 18. add 00000 to sg application -->
<!-- 9. role for slave -->
<!-- 10. ДНС для фаргейт -->
<!-- change subnet in config.xml -->
<!-- sonar hide credentials -->
<!-- 1st-pipeline Aproove for destroy -->
<!-- sonar revisia versia of build -->
<!-- link to sonar result from pipeline -->
<!-- UI automated test instead of this -->
<!-- release dynamic env instead of this -->
<!-- faild scenario + -->
<!-- 2 errors -->
<!-- sonar route 53 + pipelineoutput -->
<!-- pulling instead time out -->
<!-- failere case : store logs on s3 also -->
<!-- unit tests on s3 -->
<!-- run sonar in parallel -->
<!-- 2 cases: sucsesfull and disaster -->
<!-- Фаргейт запустить -->
<!-- 15. документация -->
