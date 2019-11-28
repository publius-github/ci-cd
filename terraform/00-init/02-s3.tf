 resource "aws_s3_bucket" "simple-testing-capabilities-test-bucket" {
   bucket = "simple-testing-capabilities-tests"
   acl    = "private"
   tags = {
     Name        = "My bucket"
     Environment = "Dev"
   }
 }
