pipeline {
    agent { label 'swift' }
    stages {
        stage('Build') {
            steps {
                sh 'swift build -c release'
            }
        }
        stage('Deploy') {
            steps {
                sh 'cp ~/Santa-Paravia-in-Swift/.build/release/Santa-Paravia /import/sol/work/Jenkins-Builds/Swift/Santa-Paravia'
            }
        }
    }
}
