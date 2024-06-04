#!/bin/bash

# 변수 파일 설정
SECRETS_FILE="secrets.pkrvars.hcl"
PACKER_FILE="aws-ami.pkr.hcl"

# Packer init 및 build 명령 실행
packer init .
packer build -var-file=$SECRETS_FILE $PACKER_FILE