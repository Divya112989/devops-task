pipeline {
    agent any

    environment {
        // Azure SP credentials from Jenkins credentials
        ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
        ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Divya112989/devops-task.git', branch: 'main'
            }
        }

        stage('Check Python') {
            steps {
                sh 'python3 --version'
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh 'python3 -m venv venv'
                sh 'venv/bin/pip install -r requirements.txt'
            }
        }

        stage('Run Flask Check') {
            steps {
                sh 'venv/bin/python -m flask --version'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy App to Azure VM') {
            steps {
                sshagent(credentials: ['my-ssh-cred-id']) {
                    sh '''
                        echo "Deploying app to Azure VM..."
                        ssh -o StrictHostKeyChecking=no azureuser@52.234.153.165 "mkdir -p /app && cd /app && git pull || git clone https://github.com/Divya112989/devops-task.git . && nohup python3 app.py > app.log 2>&1 &"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
