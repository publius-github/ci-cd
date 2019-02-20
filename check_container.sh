#!/bin/bash

terraform_path=/path-to-terraform
response=$(curl --write-out %{http_code} --silent --output /dev/null $1)

if [ $response -eq 200 ]
then
    cd $terraform_path
    /usr/local/bin/terraform destroy -auto-approve
else

    echo "no"
    cd $terraform_path
    /usr/local/bin/terraform destroy -auto-approve
    # report
fi
