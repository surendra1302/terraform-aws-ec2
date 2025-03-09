pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/surendra1302/terraform-aws-ec2.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'cd terraform'
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Fetch EC2 IP') {
            steps {
                script {
                    env.INSTANCE_IP = sh(script: "terraform output -raw public_ip", returnStdout: true).trim()
                }
            }
        }

        stage('Ansible Configuration') {
            steps {
                writeFile file: 'ansible/inventory', text: "[ec2]\n${env.INSTANCE_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/my-aws-key.pem"
                sh 'ansible-playbook -i ansible/inventory ansible/playbook.yml'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/*.tfstate', fingerprint: true
        }
    }
}

