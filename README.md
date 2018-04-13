# Aws Terraform

## Requirement

- [AWS Cli](https://aws.amazon.com/fr/cli|AWS cli)
- [Docker](https://docs.docker.com/install/)
- [Java 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- [Maven](http://maven.apache.org/download.cgi)
- [NodeJs](https://nodejs.org/en/download/)

> The Docker daemon port 2375 need to be expose 

## Initialize AWS

```
aws configure
```

Add AWS Access Key ID and AWS Secret Access Key created in IAM console.

## Create infrastructure

```
cd terraform/infra && \
terraform init && \
terraform apply -auto-approve && \
cd ../../
```

## Deploy docker images in ecr

```
cd terraform/appli && \
terraform init && \
./init.sh
```

## Deploy containers

```
terraform apply -auto-approve && \
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