pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git branch: 'EKS-Terraform', url: 'https://github.com/vhskishore/Production_Level_CICD.git'
            }
        }
        stage('Terraform Init') {
            steps {
            withAWS(credentials: 'aws', region: 'us-east-1') {
                sh ''' terraform init '''
            }
            }
        }
        stage('Terraform FMT') {
            steps {
            withAWS(credentials: 'aws', region: 'us-east-1') {
                sh ''' terraform fmt '''
            }
            }
        }
        stage('Terraform Validate') {
            steps {
            withAWS(credentials: 'aws', region: 'us-east-1') {
                sh ''' terraform validate '''
            }
            }
        }
        stage('Terraform Plan') {
            steps {
            withAWS(credentials: 'aws', region: 'us-east-1') {
                sh ''' terraform plan '''
            }
            }
        }
        
    }
}
