# Aws Terraform

## Initialize AWS

```
$ aws configure
```

## Create infrastructure

```
cd terraform/infra && \
terraform init && \
terraform apply && \
cd ../../
```

## Deploy docker image in ecr

You need to start docker locally before launch this step

```
cd terraform/appli && \
terraform init && \
./init.sh
```

## Deploy container

```
terraform apply && \
cd ../../
```

## Destroy
```
cd terraform/appli && \
terraform destroy -auto-approve && \
cd ../../ && \
cd terraform/infra && \
terraform destroy -auto-approve && \
cd ../../
```