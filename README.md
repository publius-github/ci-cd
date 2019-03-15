
        //-----------//
        // Terraform //
        //-----------//

               |
               V
            
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