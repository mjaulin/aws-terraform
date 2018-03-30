#!/usr/bin/env sh
set -e

ECR_REPOSITORY_URL=`terraform output -state=../infra/terraform.tfstate ecr_repository_url`
ECS_CLUSTER_ID=`terraform output -state=../infra/terraform.tfstate ecs_cluster_id`
ELB_TARGET_GROUP_ARN=`terraform output -state=../infra/terraform.tfstate elb_target_group_arn`

#docker build -t $ECR_REPOSITORY_URL:latest ../../nginx/

#$(aws ecr get-login --no-include-email)

#docker push $ECR_REPOSITORY_URL:latest

sed -i -e "s|^ecr_repository_url=.*|ecr_repository_url=\"$ECR_REPOSITORY_URL\"|" \
    -e "s|^ecs_cluster_id=.*|ecs_cluster_id=\"$ECS_CLUSTER_ID\"|" \
    -e "s|^elb_target_group_arn=.*|elb_target_group_arn=\"$ELB_TARGET_GROUP_ARN\"|" \
    terraform.tfvars