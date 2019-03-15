
        //-----------//
        // make box //
        //-----------//
        
        terraform
        puppet
               |
               V
            
        Jenkins master                          Jenkins agent
        * plugins
        * config                JOB ------>  
        * users
        * jobs


➜ cat ~/.aws/config
[profile_1]
output = json
region = eu-west-1
[profile_2]
output = json
region = eu-west-1

➜ cat ~/.aws/credentials
[profile_1]
aws_access_key_id =
aws_secret_access_key =
[profile_2]
aws_access_key_id =
aws_secret_access_key =


aws configure --profile user2


https://plugins.jenkins.io/cloudbees-credentials
https://plugins.jenkins.io/amazon-ecr