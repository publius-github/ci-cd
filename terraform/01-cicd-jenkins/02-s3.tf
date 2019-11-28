 resource "aws_s3_bucket" "simple-testing-capabilities-tests-bucket" {
   bucket = "simple-testing-capabilities-tests"
   acl    = "private"
 }
