
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
                                       ------>     Destroy


How it works:
1. Fill aws key/secure key in  terraform/nonprod.tfvars
2. Check other parameters in terraform/nonprod.tfvars, terraform/99-vars.tf
2. Type `make init`
3. Type `make plan`
4. Type `make apply`

> Now you have configured jenkins master in your AWS account with role, that allows build every job on dinamic agent
>
> [need to be autmate in future]<br/>
> **You need to change some fields in preferences:**<br/>
>
> Settings/cloud/Amazon EC2<br/>
> * EC2 Key Pair's Private Key <br/>
>
> Settings/cloud/Amazon EC2/Advanced<br/>
> * Subnet IDs for VPC

5. Add credentials to jenkins
6. BUILD! 

> **What should be done in future:**<br/>
>
> ***Case_1*** (Dinamic jenkins agent) <br/>
> 0. Grep ECR images and paste to terraform-ecr
> 1. mysql server at jenkins master
> 2. terraform ebs master
> 3. configure database/user
> 4. sonar-runner master
> 5. sonar.properties
> 6. dinamic sonar
> 7. grep subnet ID after creating -> config.xml
> 8. find the way to provide ec2 private key properly
> 9. sonar pipeline
> 10. sonar logs to s3 <br/>
>
> ***Case_2*** (Fargate) <br/>
> 1. Find the way to provide details in ./terraform-ecs
