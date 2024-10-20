# This is a comment
pipeline {
      agent { label 'slave' }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/MuhammedA-maker/new-test-deploy.git'
            }
        }
        
        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') {
                        sh "docker build -t muhammedabdullah/docker-pull-push:latest ."
                        sh "docker push muhammedabdullah/docker-pull-push:latest"
                    }
                }
            }
        }
        
         stage('Run Terraform') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'Aws-Credential']]) {
                        dir('terraform') {
                            sh '''
                                terraform init
                                terraform apply -auto-approve
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Get Instance IP') {
            steps {
                dir('terraform') {
                    script {
                        // Run Terraform output command to get the IP
                        INSTANCE_IP = sh(script: 'terraform output instance_ips', returnStdout: true).trim()
                        
                        // Check if the IP was retrieved successfully
                        if (INSTANCE_IP) {
                            echo "The instance IP is: ${INSTANCE_IP}"
                        } else {
                            error("Failed to retrieve instance IPs. Please check your Terraform outputs.")
                        }
                    }
                }    
            }
        } 
        stage('Debug Inventory') {
            steps {
                dir('ansible') {
                    script {
                        // Print the contents of the hosts.ini file for debugging
                        sh 'cat hosts.ini'
                    }
                }
            }
        }
        stage('Update Inventory') {
            steps {
                dir('ansible') {
                    script {
                        // Write the instance IP to the hosts.ini file
                        writeFile file: 'hosts.ini', text: """
                        [web]
                        instance ansible_host=${INSTANCE_IP} ansible_user=ubuntu
                        """
                        
                        // Print the updated hosts.ini for verification
                        sh 'cat hosts.ini'
                    }
                }
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                sshagent(['slave-test']) {
                    dir('ansible') {
                        script {
                            // Print the instance IP for debugging
                            echo "Using instance IP: ${INSTANCE_IP}"
                            
                            // Run the ansible-playbook command
                            sh """
                                export ANSIBLE_HOST_KEY_CHECKING=False
                                ansible-playbook site.yml -i hosts.ini --extra-vars "instance_ip=${INSTANCE_IP}"
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            slackSend(channel: '#test-aws', message: "Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
        }
        failure {
            slackSend(channel: '#test-aws', message: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
        }
        unstable {
            slackSend(channel: '#test-aws', message: "Build Unstable: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
        }
    }
}
