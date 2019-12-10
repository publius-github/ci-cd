
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
<!-- 9. role for slave -->
<!-- 10. ДНС для фаргейт -->
<!-- change subnet in config.xml -->
<!-- sonar hide credentials -->
<!-- 1st-pipeline Aproove for destroy -->


<!-- sonar revisia versia of build -->
<!-- link to sonar result from pipeline -->
<!-- UI automated test instead of this -->
<!-- release dynamic env instead of this -->
unit tests on s3
<!-- faild scenario + -->
 email notification on fail
<!-- 2 errors -->

19. groovy init script ec2
2. make file create s3 for state
4. docker compose as service on host system
15. документация
17. Код деплой
<!-- run sonar in parallel -->


<!-- 2 cases: sucsesfull and disaster -->
<!-- Фаргейт запустить -->
8. Block device mapping to slave (or just more space)



init:
1. bucket: 
- simple-testing-capabilities-tests
2. ecr:
- cicd-jenkins
- cicd-sonar
- simple-testing-capabilities
- simple-testing-capabilities-spa


Variables:

github keys


app = "simple-testing-capabilities:latest"
app2 = "simple-testing-capabilities-spa:latest"
registry_url = "803808824931.dkr.ecr.us-east-1.amazonaws.com"
app_backend = "simple-testing-capabilities:latest"
app_port_backend = "50504"
app_frontend = "simple-testing-capabilities-spa:latest"
app_port_frontend = "3000"
app_db = "redis:latest"
app_port_db = "6379"
access_key = credentials('env-aws-access-key')
secret_key = credentials('env-aws-secret-key')
sonar_db_login = credentials('sonar-login')
sonar_db_passwd = credentials('sonar-passwd')


Results File: /build/MainTests/TestResults/_7000d7f855d8_2019-11-28_11_12_21_172.trx


> cc@0.1.0 test /simple-testing-capabilities-spa
> cross-env CI=true react-scripts test --env=jsdom

[91m PASS  src/App.test.js
[0m[91m  ✓ renders without crashing (66ms)
[0m[91m  Given the Books component
[0m[91m    when it is rendered
      and when it is mounted
[0m[91m        ✓ should update the state (9ms)
[0m[91m        ✓ should match the snaptshot (17ms)
[0m[91m        ✓ unBook func should be called (9ms)
[0m[91m  Given the Statistics component
    when it is rendered
[0m[91m      and when it is mounted
[0m[91m        ✓ should update the state (1ms)
[0m[91m        ✓ should match the snaptshot (2ms)
[0m[91m        ✓ injected func should be called once (1ms)
[0m[91m  Given the Calculate component
    when it is rendered
      and when it is mounted
[0m[91m        ✓ should update the state (1ms)
        ✓ should match the snaptshot (2ms)
[0m[91m        ✓ injected func should be called at least once (1ms)
[0m[91m
[0m[91mTest Suites: 1 passed, 1 total
Tests:       10 passed, 10 total
Snapshots:   3 passed, 3 total
Time:        2.166s
Ran all test suites.