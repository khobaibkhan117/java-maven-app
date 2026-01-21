pipeline {
    agent any
    tools {
        maven "maven3"
    }
    stages {
        stage('Clean WorkSpace') {
            steps {
                cleanWs()
            }
        }
        stage('Git clone') {
            steps {
                git branch: 'main', url: 'https://github.com/khobaibkhan117/java-maven-app.git'
            }
        }
        stage('Maven war file ') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Docker Images/Containers removal') {
            steps { 
                script{
                    sh '''
                    docker stop javamavenapp_container
                    docker rm javamavenapp_container
                    docker rmi khobaibtw/javamavenapp:latest
                    docker rmi $(docker images -f "dangling=true" -q)
                    '''
                }
            }
        }
        stage('Docker Build and Push Image to Docker Hub') {
            steps { 
                script{
                    withDockerRegistry(credentialsId: 'khobaibtw', toolname: 'docker') {
                        // Build and push the new image
                        sh '''
                        docker build -t javamavenapp .
                        docker tag javamavenapp khobaibtw/javamavenapp:latest
                        docker push khobaibtw/javamavenapp:latest
                        '''
                    }
                }
            }
        }
        stage('Docker Container of MavenApp') {
            steps {
                // Run the new container with mapped ports
                sh 'docker run -d -p 9000:8080 --name javamavenapp_container -t khobaibtw/javamavenapp:latest'
            }
        }
    }
    post {
    always {
        script {
            def buildStatus = currentBuild.currentResult
            def buildUser = currentBuild.getBuildCauses('hudson.model.Cause$UserIdCause')[0]?.userId ?: 'Github User'
            
            emailext (
                subject: "Pipeline ${buildStatus}: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    <p>This is a Jenkins maven CICD pipeline status.</p>
                    <p>Project: ${env.JOB_NAME}</p>
                    <p>Build Number: ${env.BUILD_NUMBER}</p>
                    <p>Build Status: ${buildStatus}</p>
                    <p>Started by: ${buildUser}</p>
                    <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                to: 'khobaibtw@gmail.com',
                from: 'khobaibtw@gmail.com',
                replyTo: 'khobaibtw@gmail.com',
                mimeType: 'text/html',
                attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
            )
        }
    }
}
}
