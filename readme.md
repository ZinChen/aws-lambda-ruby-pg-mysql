# Play with AWS lambda

Deploy ruby script with mysql and postgresql gems and libs.

## Makefile commands

### Generate deploy.zip file

`make image` - build Docker image

`make generate_file` - generate "deploy.zip" file to deploy on lambda

`make test` - extract "deploy.zip" and run script in lambda container

### Deploy and update lambda

Run `make shell` to get into container

Login into AWS account `aws configure`

Create IAM role for lambda function `make generate_role role_name=<name_your_role>`

Create lambda function from zip file `make generate_lambda region=<region> role=<role_arn_code>`

Run lambda function with `make invoke_lambda`

To update lambda function recreate "deploy.zip" file with `make generate_file`
and push update with command `mage update_lambda`

Also avaliable variable: `lambda_name` - name of your lambda function on AWS

## Credits

Big thanks to explainers

<https://stackoverflow.com/questions/54330779/how-to-correctly-load-a-gem-extension-in-aws-lambda>
<https://www.stevenringo.com/ruby-in-aws-lambda-with-postgresql-nokogiri/>
<https://stackoverflow.com/questions/53854487/cannot-load-file-mysql2-on-aws-lambda>
<https://memotut.com/it-is-said-that-libmysqlclient.so.18-does-not-exist-f1a2b/>
