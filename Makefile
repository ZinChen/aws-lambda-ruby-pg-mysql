IMAGE_NAME = lambda-ruby2.5-gem-test
OUTPUT_FOLDER = /var/output

image:
	docker build -t ${IMAGE_NAME} .

generate_file:
	docker run --rm -it -v ${CURDIR}:${OUTPUT_FOLDER} -w ${OUTPUT_FOLDER} ${IMAGE_NAME} make _generate_file

shell:
	docker run --rm -it -v ${CURDIR}:${OUTPUT_FOLDER} -w ${OUTPUT_FOLDER}  ${IMAGE_NAME} bash

test:
	unzip -q deploy.zip -d deploy
	docker run --rm -it -v ${CURDIR}/deploy:/var/task -w /var/task lambci/lambda:ruby2.5 handler.run

aws_create_role:

aws_create_lambda:

aws_update_lambda:

aws_invoke_lambda:

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
