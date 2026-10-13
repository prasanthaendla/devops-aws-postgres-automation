pipeline {
    agent any

    environment {
        TF_VAR_aws_region                = 'ap-south-2'
        TF_VAR_vpc_id                    = 'vpc-09145eca91f7bd4fe'
        TF_VAR_subnet_id                 = 'subnet-082b876b8cb64d327'
        TF_VAR_jenkins_security_group_id = 'sg-06c6f0847f6e4d662'
        TF_VAR_instance_type             = 't3.micro'
        TF_VAR_key_name                  = 'jenkins'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/prasanthaendla/devops-aws-postgres-automation.git'
            }
        }

        stage('Verify Repository') {
            steps {
                sh 'pwd'
                sh 'git status'
                sh 'find . -maxdepth 2 -type f | sort'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval Before Apply') {
            steps {
                input(
                    message: 'Review the Terraform Plan console output. Approve only if the proposed AWS changes are correct.',
                    ok: 'Approve Terraform Apply'
                )
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
