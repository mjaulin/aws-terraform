#!/usr/bin/env sh
set -e

ECR_REPOSITORY_URL_FRONT=`terraform output -state=../infra/terraform.tfstate ecr_repository_url_front`
ECR_REPOSITORY_URL_BACK=`terraform output -state=../infra/terraform.tfstate ecr_repository_url_back`
ECS_CLUSTER_ID=`terraform output -state=../infra/terraform.tfstate ecs_cluster_id`
ELB_TARGET_GROUP_ARN_FRONT=`terraform output -state=../infra/terraform.tfstate elb_target_group_arn_front`
ELB_TARGET_GROUP_ARN_BACK=`terraform output -state=../infra/terraform.tfstate elb_target_group_arn_back`
ELB_PUBLIC_DNS_NAME=`terraform output -state=../infra/terraform.tfstate elb_public_dns_name`
API_URL="http://${ELB_PUBLIC_DNS_NAME}/api/"

CURR=`pwd`

cd ../../test-kotlin/
mvn clean install -Dimage.name=${ECR_REPOSITORY_URL_BACK}:latest
cd $CURR

cd ../../test-react/
npm install && API_URL=$API_URL npm run build
docker build -t ${ECR_REPOSITORY_URL_FRONT}:latest .
cd $CURR

`aws ecr get-login --no-include-email`
docker push ${ECR_REPOSITORY_URL_FRONT}:latest
docker push ${ECR_REPOSITORY_URL_BACK}:latest

sed -i -e "s|^ecr_repository_url_front=.*|ecr_repository_url_front=\"$ECR_REPOSITORY_URL_FRONT\"|" \
       -e "s|^ecr_repository_url_back=.*|ecr_repository_url_back=\"$ECR_REPOSITORY_URL_BACK\"|" \
       -e "s|^ecs_cluster_id=.*|ecs_cluster_id=\"$ECS_CLUSTER_ID\"|" \
       -e "s|^elb_target_group_arn_front=.*|elb_target_group_arn_front=\"$ELB_TARGET_GROUP_ARN_FRONT\"|" \
       -e "s|^elb_target_group_arn_back=.*|elb_target_group_arn_back=\"$ELB_TARGET_GROUP_ARN_BACK\"|" \
       terraform.tfvars
