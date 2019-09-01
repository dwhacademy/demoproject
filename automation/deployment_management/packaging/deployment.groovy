pipeline {
  agent {
        label "master"
    }
  stages {
    stage ('Clean workspace and create root folders') {
      steps {
        script {
          echo '========== CLEANING WORKSPACE =========='
          deleteDir()
        }
      }
    }
    stage ('Checkout repository') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: BRANCH_NAME]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'demoproject'], [$class: 'LocalBranch', localBranch: BRANCH_NAME], [$class: 'CloneOption', depth: 0, honorRefspec: true, noTags: false, reference: '', shallow: true]], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/dwhacademy/demoproject.git', refspec: "+refs/heads/${BRANCH_NAME}:refs/remotes/origin/${BRANCH_NAME}"]]])   
      }
    }
    stage ('Copy the packaging script and configuration') {
      steps {
        script {
          echo 'Copy files'
          findAndCopy("demoproject/automation/deployment_management/packaging", "*.sh", ".")
          findAndCopy("demoproject/automation/deployment_management/packaging", "*.config", ".")
        }
      }
    }
    stage('Generate the package') {
      steps {
        sh 'chmod 777 ./pack.sh'
        sh "./pack.sh ${TARGET_ENVIRONMENT} ${BRANCH_NAME} ${USER}"
      }
     }
    stage('Deploy to the database') {
      steps {
        sh """#!/bin/bash +x
        export PGPASSWORD=${PASSWORD}
        psql -h localhost -d DWH_ACADEMY -U ${USER} -a -w -f _deployment/script/deployment.sql
        """
      }
     }
    stage('CheckLog') {
      steps {
        if (manager.logContains('.*error.*')) {
          error("SQL errors within deployment")    
        }
      }
     }
    }
  post {
        success {
      zip zipFile: "deployment_${BRANCH_NAME}_${TARGET_ENVIRONMENT}_${new Date().format("yyyy-MM-dd'T'HH:mm:ss'Z'", TimeZone.getTimeZone("UTC"))}.zip", archive: true, dir: '_deployment', glob: '**'
        }
    }
}

void findAndCopy (String dirName, String mask, String destPath) {
  sh "find ${dirName} -name \"${mask}\" -type f | xargs -Ifile cp file -t ${destPath}"
}