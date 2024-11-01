pipeline {
    agent { 
        label 'Agents'
    }

    environment {
        IMAGE_NAME         = 'weather_app_gitops'
        DOCKERHUB_REPO     = 'hadarkravetsky/gitops'
        DOCKER_CREDENTIALS = credentials('docker_hub_credentials')
        GITLAB_CREDENTIALS = 'gitlab_token_for_deployment_with_root_username_type_usernamepassword'
        GITLAB_TOKEN       = 'gitlab_token_for_deployment_with_root_username' 
        MANIFEST_FOLDER_ARGOCD = 'manifests'
        GIT_REPO           = '172.32.2.11/root/deployment'
    }

    stages {
        stage('Clean Previous Docker Containers and Images') {
            steps {
                script {
                    sh '''
                        docker system prune -f
                        docker image prune -f
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${env.BUILD_NUMBER}"
                    def imageName = "${IMAGE_NAME}:${imageTag}"
                    sh "docker build -t ${imageName} ."
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    sh "docker login -u ${DOCKER_CREDENTIALS_USR} -p ${DOCKER_CREDENTIALS_PSW}"
                }
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    sh "docker tag ${IMAGE_NAME}:${env.BUILD_NUMBER} ${DOCKERHUB_REPO}:${env.BUILD_NUMBER}"
                    sh "docker push ${DOCKERHUB_REPO}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Clean Workspace and Clone Deployment Repo') {
            steps {
                script {
                    // Clean the directory if it exists before cloning
                    sh '''
                        if [ -d "deployment" ]; then
                            rm -rf deployment
                        fi
                    '''
                    
                    withCredentials([string(credentialsId: "${GITLAB_TOKEN}", variable: 'GIT_TOKEN')]) {
                        sh '''
                            git clone http://root:$GIT_TOKEN@${GIT_REPO}
                        '''
                    }
                    sh '''
			    sed -i "s|image: .*|image: hadarkravetsky/gitops:${BUILD_NUMBER}|g" deployment/manifests/weather-app.yaml

	            '''
                }
            }
        }

        stage('Commit and Push Updated YAML') {
            steps {
                script {
                    withCredentials([string(credentialsId: "${GITLAB_TOKEN}", variable: 'GIT_TOKEN')]) {
                        sh '''
                            cd deployment
                            git config user.name "Jenkins CI"
                            git config user.email "jenkins@mycompany.com"
                            git add ${MANIFEST_FOLDER_ARGOCD}/weather-app.yaml
                            git commit -m "Updated weather-app deployment image to tag ${BUILD_NUMBER}"
                            git push http://root:${GIT_TOKEN}@${GIT_REPO} HEAD:main
                        '''
                    }
                }
            }
        }
    }
}
