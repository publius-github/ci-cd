
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

> Now you have configured jenkins master in your AWS account with role, that allows build every job on dinamic agent
>
> [need to be autmate in future]<br/>
> **You need to change some fields in preferences:**<br/>
>
> Settings/cloud/Amazon EC2<br/>
> * EC2 Key Pair's Private Key <br/>

5. Add credentials to jenkins

sonar-login
sonar-password
aws
env-aws-access-key
env-aws-secret-key

6. BUILD! 





> 1. Create ECR in terraform, and comment it <br/>
> 2. create s3<br/>
> 3. find the way to provide ec2 private key properly <br/>
> 4. artifact to s3 <br/>

