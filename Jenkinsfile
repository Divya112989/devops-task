pipeline {
    agent any

    environment {
        VENV_DIR = 'venv'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Divya112989/devops-task.git'
            }
        }
     
    stage('Setup Python Environment') {
            steps {
                 bat 'python -m venv venv'
                 bat 'venv\\Scripts\\pip install -r requirements.txt'
    }
}

        stage('Run Flask Check') {
            steps {
                bat "%VENV_DIR%\\Scripts\\activate && python -m flask --version"
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir('terraform') {
                    bat "terraform init"
                    bat "terraform plan"
                }
            }
        }

        // Optional: apply stage (careful with real cloud resources)
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat "terraform apply -auto-approve"
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
