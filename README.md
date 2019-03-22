
        //-----------//
        // make box  //
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
        | * plugins       |            JOB            *build job*                    DESTROING       Valhalla
        | * config        |            ------>                                       -------->       
        | * users         |
        | * jobs          |
        |-----------------|



How it works:
1. Fill aws key/secure key in  terraform/nonprod.tfvars
2. Check other parameters in terraform/nonprod.tfvars, terraform/99-vars.tf
2. Type `make init`
3. Type `make plan`
4. Type `make apply`

> Now you have configured jenkins master in your AWS account with role, that allows build every job on dinamic agent
>
> ***[need to be autmate in future]***<br/>
> **You need to change some fields in preferences:**<br/>
> Settings/cloud/Amazon EC2<br/>
> * EC2 Key Pair's Private Key <br/>
> Settings/cloud/Amazon EC2/Advanced<br/>
> * Subnet IDs for VPC

5. Add credentials to jenkins
6. BUILD! 

> **What should be done in future:**<br/>
>         ***Case_1*** (Dinamic jenkins agent)<br/>
> 1. grep subnet ID after creating -> config.xml
> 2. find the way to provide ec2 private key properly
> 3. Terraform ECR
> 4. dinamic sonar
> 5. RDS for sonar
> 6. Terraform subnet for RDS
> 7. Parse RDS url for sonar.properties
> 8. configure RDS in makefile (user/database/password)
> 9. sonar pipeline
> 10. sonar logs to s3
>         ***Case_2*** (Fargate)
> 1. Find the way to provide details in ./terraform-ecs
