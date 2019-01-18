pipeline {

    //agent { dockerfile true }

    def app

    stage('Build image') {
        /* This builds the actual image; synonymous to docker build on the command line */
        app = docker.build("getintodevops/hellonode")
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image. For this example, we're using a Volkswagen-type approach ;-) */
        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage ('Run Application') {
        try {
            // Start database container here
            // sh 'docker run -d --name db -p 8091-8093:8091-8093 -p 11210:11210 arungupta/oreilly-couchbase:latest'

            // Run application using Docker image
            sh "DB=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db`"
            sh "docker run -e DB_URI=$DB arungupta/docker-jenkins-pipeline:${env.BUILD_NUMBER}"

            // Run tests using Maven
            //dir ('webapp') {
            //  sh 'mvn exec:java -DskipTests'
            //}
        } catch (error) {
        } finally {
            // Stop and remove database container here
            //sh 'docker-compose stop db'
            //sh 'docker-compose rm db'
        }
    }

    stage('Run Tests') {
        try {
            dir('webapp') {
                sh "mvn test"
                docker.build("arungupta/docker-jenkins-pipeline:${env.BUILD_NUMBER}").push()
            }
        } catch (error) {
        } finally {
            junit '**/target/surefire-reports/*.xml'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags: First, the incremental build number from Jenkins Second, the 'latest' tag. 
        Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    stages {

        stage('Checkout from Git')
        {
            steps {
                checkout scm
            }
        }

        stage('Test')
        {
            steps {
                echo 'Test'
            }
        }

        //stage('Archive') {
        //    agent any
        //    steps {
        //        dir ('TestSolution/bin') {
        //            unstash 'bins'
        //        }
        //    archive '**/bin/Release/**.dll'
        //    }
        //}

        //stage ('Archive') {
        //    archive '${PROJECT_NAME}/bin/Release/**'
        //}
    }

    post {
        always {
            echo 'Post message'
        }
        failure {
            echo 'On Failure post-condition'
        }
        success {
            echo 'On Success post-condition'
        }
    }
}