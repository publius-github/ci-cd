
        //-----------//
        // makefile  //
        //-----------//
        //-----------//
        //  vagrant  //
        // terraform //
        //  puppet   //
        //-----------//
               | 
               | AWS
               | 
               V
            
        |-----------------|
        | Jenkins master  |                        Dinamic Jenkins agent                               
        | * plugins       |            JOB 1.         *build job*                    Deploy       
        | * config        |            ------>                                       -------->       FARGATE
        | * users         |
        | * jobs          |
        |-----------------|            JOB 2.
                                       ------>     Destroy FARGATE


How it works:
1. Fill aws key/secure key in  terraform/nonprod.tfvars
2. Check other parameters in terraform/nonprod.tfvars, terraform/99-vars.tf
2. Type `make init`
3. Type `make plan`
4. Type `make apply`
5. Add credentials to jenkins
> sonar-login<br/>
> sonar-password<br/>
> aws<br/>
> env-aws-access-key<br/>
> env-aws-secret-key<br/>
6. BUILD! 



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
19. groovy init script ec2
2. make file create s3 for state
4. docker compose as service on host system
8. Block device mapping to slave (or just more space)
<!-- 9. role for slave -->
15. документация
17. Код деплой
<!-- 10. ДНС для фаргейт -->
sonar hide credentials
1st-pipeline Aproove for destroy
<!-- change subnet in config.xml -->
run sonar in parallel
2 cases: sucsesfull and disaster

init:
1. bucket: 
- simple-testing-capabilities-tests
2. ecr:
- cicd-jenkins
- cicd-sonar
- simple-testing-capabilities
- simple-testing-capabilities-spa

