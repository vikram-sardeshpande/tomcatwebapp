pipeline {
    agent any
    environment {
        containerName = "vikramsardeshpande/tomcatwebapp"
        container_version = "2.0.0.${BUILD_ID}"
        dockerTag = "${containerName}:${container_version}"
    }
    stages{
        stage ('Build Container') {
            steps {
                sh 'docker build -f "Dockerfile" --no-cache -t ${dockerTag} .'
                //sh 'docker build -f "Dockerfile" -t ${dockerTag} .'
                  }
             }
        stage('Docker Push') {
            // agent any
            steps {
             withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
             sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
             sh 'docker push ${dockerTag}'
             }
        }
      }
        stage ('Deploy Container') {
                steps {
                    sh 'docker rm -f test'
                    sh 'docker run -it --name test -d -p 9000:8080 ${dockerTag}'
                    sh 'docker exec -it test tomcat7 start'

                  }
            }
      }
        stage('Docker Cleanup') {
              steps {
                sh "docker images ${dockerTag} -q | tee ./xxx"
            sh 'docker rmi `cat ./xxx` --force ||exit 0'
            }
        }
        
   post {
        always {
            echo 'Clean up work directory'
            deleteDir() /* clean up our workspace */
        }
    }
} 
