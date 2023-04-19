pipeline {
    agent {
        node {
            label 'aws'
        }
    }
    
    environment {
        SSH_USER = 'ubuntu'
        SSH_KEY = credentials('ssh-key.key')
        APP_NAME = 'billing_software'
        REMOTE_HOST = 'ec2-43-205-217-147.ap-south-1.compute.amazonaws.com'
        REMOTE_DIR = '/var/www/billing_software/'
        VIRTUALENV_DIR = '/var/www/billing_software/venv'
        REQUIREMENTS_FILE = 'requirements.txt'
    }
    
    stages {

        stage('Install Dependencies') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: '$SSH_KEY', keyFileVariable: 'SSH_KEY', passphraseVariable: '', usernameVariable: 'SSH_USER')]) {
                    sh "rsync -avz -e 'ssh -o StrictHostKeyChecking=no -i ${SSH_KEY}' ${REQUIREMENTS_FILE} ${SSH_USER}@${REMOTE_HOST}:${REMOTE_DIR}"
                    sh "python3 -m venv ${VIRTUALENV_DIR}"
                    sh "source ${VIRTUALENV_DIR}/bin/activate"
                    sh "pip install -r ${REQUIREMENTS_FILE}"
                }
            }
        }


        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', keyFileVariable: 'SSH_KEY', passphraseVariable: '', usernameVariable: 'SSH_USER')]) {
                    sh "rsync -avz -e 'ssh -o StrictHostKeyChecking=no -i ${SSH_KEY}' . ${SSH_USER}@${REMOTE_HOST}:${REMOTE_DIR}"
                    sh "ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'cd ${REMOTE_DIR} && source ${VIRTUALENV_DIR}/bin/activate && python manage.py migrate'"
                }
            }
        }
        
        stage('Restart Application') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', keyFileVariable: 'SSH_KEY', passphraseVariable: '', usernameVariable: 'SSH_USER')]) {
                    sh "ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'sudo systemctl restart apache2'"
                }
            }
        }
    }
}
