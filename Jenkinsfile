pipeline {
    agent any

    environment {
        // Use Jenkins credentials for Azure SP
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
                // Create virtual environment
                bat '"C:\\Users\\divya\\AppData\\Local\\Programs\\Python\\Python313\\python.exe" -m venv venv'
                // Install dependencies
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
                    // Initialize Terraform with backend
                    bat 'terraform init'
                    // Plan with variable file
                    bat 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform apply -var-file=terraform.tfvars -auto-approve'
                }
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'azure-vm',  // Must exist in Jenkins SSH Sites
                            transfers: [
                                sshTransfer(
                                    sourceFiles: '**/*',
                                    removePrefix: '',
                                    remoteDirectory: '/home/azureuser/app',
                                    execCommand: '''
                                        cd /home/azureuser/app
                                        python3 -m venv venv
                                        source venv/bin/activate
                                        pip install -r requirements.txt
                                        nohup python app.py &
                                    '''
                                )
                            ]
                        )
                    ]
                )
            }
        }
    } // end of stages

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
