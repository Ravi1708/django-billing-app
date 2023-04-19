import org.jenkinsci.plugins.credentials.*


pipeline {
    agent {
        node {
            label 'aws'
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
                    sh "scp -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} -r ${WORKSPACE}/* ${SSH_USER}@${REMOTE_HOST}:${REMOTE_DIR}"
                    // enter virtualenv
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'source ${VIRTUALENV_DIR}/bin/activate'"
                    // install requirements
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'pip install -r ${REMOTE_DIR}${REQUIREMENTS_FILE}'"
                    // run migrations
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'python ${REMOTE_DIR}manage.py migrate'"
                    // exit virtualenv
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'deactivate'"
                    // restart apache2
                    sh "ssh -o StrictHostKeyChecking=no -i ${MY_SSH_KEY} ${SSH_USER}@${REMOTE_HOST} 'sudo systemctl restart apache2'"
                }
            }
        }


    }
}
