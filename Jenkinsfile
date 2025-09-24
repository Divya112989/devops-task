pipeline {
    agent any

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
                // Install dependencies inside venv
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
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
