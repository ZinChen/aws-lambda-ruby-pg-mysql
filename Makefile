IMAGE_NAME = lambda-ruby2.5-gem-test
OUTPUT_FOLDER = /var/output
lambda_name := RubyPgMsNk
role_name := lambda-ex
region := us-west-2

image:
	docker build -t $(IMAGE_NAME) .

generate_file:
	docker run --rm -it -v $(CURDIR):$(OUTPUT_FOLDER) -w $(OUTPUT_FOLDER) $(IMAGE_NAME) make _generate_file

shell:
	docker run --rm -it -v $(CURDIR):$(OUTPUT_FOLDER) -w $(OUTPUT_FOLDER)  $(IMAGE_NAME) bash

test:
	unzip -q deploy.zip -d deploy
	docker run --rm -it -v $(CURDIR)/deploy:/var/task -w /var/task lambci/lambda:ruby2.5 handler.run

# Container scripts

_generate_file: _add_handler _copy_libs _zip

_add_handler:
	cp /var/output/handler.rb /var/task/

_copy_libs:
	mkdir /var/task/lib
	cp /usr/lib64/libpq.so.5.5 /var/task/lib/libpq.so.5
	cp /usr/lib64/mysql/libmysqlclient.so.18.0.0 /var/task/lib/libmysqlclient.so.18

_zip:
	rm -f /var/output/deploy.zip
	cd /var/task && zip -q -r -y /var/output/deploy.zip . && cd -

_aws_create_role:
	aws iam create-role \
		--role-name $(role_name) \
		--assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'

_aws_create_lambda:
	aws lambda create-function \
		--region $(region) \
		--function-name $(lambda_name) \
		--zip-file fileb://deploy.zip \
		--runtime ruby2.5 \
		--role $(role) \
		--timeout 20 \
		--handler handler.run

_aws_invoke_lambda:
	aws lambda invoke \
		--region $(region) \
		--function-name $(lambda_name) /dev/stdout

_aws_update_lambda:
	aws lambda update-function-code \
		--region $(region) \
		--function-name $(lambda_name) \
		--zip-file fileb://deploy.zip
