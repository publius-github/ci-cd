
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



> 1. Create ECR in 00-terraform<br/>
> 2. Create s3 in 00-terraform<br/>
> 3. Provide ec2 private key to config.xml <br/>
> 4. Pipeline: artifact to s3 (assume role to ec2?) > 01-terraform<br/>


unit во время билда
api в контейнере


1. make file create ecr
2. make file create s3
3. make file docker build && push to ecr
4. docker compose as service on host system
5. attach role to instance
6. pull docker image
7. кондишон исполнения нул ресурса
 	Block device mapping
8. тригерить один за одним паййплайны


1. ДНС для фаргейт
2. ввынести юай / апи тесты в дженкинс (не контейнер)
3. Результаты тестов в файл на с3
4. в косоле дженкинса тоже все логи
5. одну кнопку
6. документация
7. сонаркуб


