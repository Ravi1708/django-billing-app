import org.jenkinsci.plugins.credentials.*


pipeline {
    agent {
        node {
            label 'aws agent'
        }
    }
    
    environment {
        SSH_USER = 'ubuntu'
        MY_SSH_KEY = credentials('ssh-key.key')
        APP_NAME = 'billing_software'
        REMOTE_HOST = 'ec2-43-205-217-147.ap-south-1.compute.amazonaws.com'
        REMOTE_DIR = '/var/www/billing_software/'
        VIRTUALENV_DIR = '/var/www/billing_software/venv'
        REQUIREMENTS_FILE = 'requirements.txt'
    }
    
    stages {

        stage('Deploy to EC2') {
            steps {
                sshagent (credentials: ['ssh-key.key']) {
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'sudo rm -rf ${REMOTE_DIR}/*'"
                    
                    // copy files to remote host
                    sh "scp -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} -r ${WORKSPACE}/* ${SSH_USER}@${REMOTE_HOST}:${REMOTE_DIR}"
                    
                    // create virtualenv
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'python3 -m venv ${VIRTUALENV_DIR}'"
                    
                    // install requirements
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'source ${VIRTUALENV_DIR}/bin/activate && pip install -r ${REMOTE_DIR}${REQUIREMENTS_FILE}'"

                    // create .env file in gstbilling directory
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'touch ${REMOTE_DIR}gstbilling/.env'"
                    // run migrations
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'source ${VIRTUALENV_DIR}/bin/activate && cd ${REMOTE_DIR} && python manage.py migrate'"

                    // restart apache2
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'sudo systemctl restart apache2'"
                }
            }
        }


    }
}
