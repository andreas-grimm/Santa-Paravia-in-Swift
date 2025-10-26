pipeline {
    agent { label 'swift' }
    stages {
        stage('Build') {
            steps {
                sh '/home/jenkins/.local/share/swiftly/bin/swift package clean'
                sh '/home/jenkins/.local/share/swiftly/bin/swift build -c release'
            }
        }
        stage('Deploy') {
            steps {
                sh 'cp /home/jenkins/workspace/Santa-Paravia-in-Swift/.build/x86_64-unknown-linux-gnu/release/Santa-Paravia /import/sol/work/Jenkins-Builds/Swift/Santa-Paravia'
            }
        }
    }
}
