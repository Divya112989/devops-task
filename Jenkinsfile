pipeline {
    agent any

    environment {
        // Azure credentials (Terraform will use these)
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
                bat '"C:\\Users\\divya\\AppData\\Local\\Programs\\Python\\Python313\\python.exe" --version'
            }
        }

        stage('Setup Python Environment') {
            steps {
                bat '"C:\\Users\\divya\\AppData\\Local\\Programs\\Python\\Python313\\python.exe" -m venv venv'
                bat 'venv\\Scripts\\pip install -r requirements.txt'
            }
        }

        stage('Run Flask Check') {
            steps {
                bat 'venv\\Scripts\\python -m flask --version'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                    bat 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy App to Azure VM') {
            steps {
                sshagent(credentials: ['my-ssh-cred-id']) {
                    sh '''
                        echo "Deploying app to Azure VM..."
                        ssh -o StrictHostKeyChecking=no azureuser@52.234.153.165 "cd /app && git pull && nohup python3 app.py --host=0.0.0.0 --port=5000 > app.log 2>&1 &"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'/
        }
    }
}
