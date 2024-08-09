
#!groovy
import groovy.json.JsonSlurperClassic

node {
    def BUILD_NUMBER = env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR = "tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    // Dev2 Environment Variables
    def DEV2_HUB_ORG = env.HUB_ORG_DEV2
    def DEV2_SFDC_HOST = env.SFDC_HOST_DEV2
    def DEV2_JWT_KEY_CRED_ID = env.JWT_CRED_ID_DEV2
    def DEV2_CONNECTED_APP_CONSUMER_KEY = env.CONNECTED_APP_CONSUMER_KEY_DEV2

    // Test2 Environment Variables
    def TEST2_HUB_ORG = env.HUB_ORG_TEST2
    def TEST2_SFDC_HOST = env.SFDC_HOST_TEST2
    def TEST2_JWT_KEY_CRED_ID = env.JWT_CRED_ID_TEST2
    def TEST2_CONNECTED_APP_CONSUMER_KEY = env.CONNECTED_APP_CONSUMER_KEY_TEST2

    def toolbelt = tool 'toolbelt'

    stage('Checkout Source') {
        // When running in multi-branch job, one must issue this command
        checkout scm
    }

    // Authorize and Deploy to Dev2
    withCredentials([file(credentialsId: DEV2_JWT_KEY_CRED_ID, variable: 'dev2_jwt_key_file')]) {
        stage('Authorize and Deploy to Dev2') {
            def rc
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${DEV2_CONNECTED_APP_CONSUMER_KEY} --username ${DEV2_HUB_ORG} --jwtkeyfile ${dev2_jwt_key_file} --setdefaultdevhubusername --instanceurl ${DEV2_SFDC_HOST}"
            } else {
                rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${DEV2_CONNECTED_APP_CONSUMER_KEY} --username ${DEV2_HUB_ORG} --jwtkeyfile \"${dev2_jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${DEV2_SFDC_HOST}"
            }
            if (rc != 0) { error 'Dev2 org authorization failed' }

            println rc

            // Deploy metadata to Dev2
            def rmsg
            if (isUnix()) {
                rmsg = sh returnStdout: true, script: "${toolbelt} force:mdapi:deploy -d manifest/. -u ${DEV2_HUB_ORG}"
            } else {
                rmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:mdapi:deploy -d manifest/. -u ${DEV2_HUB_ORG}"
            }

            println rmsg
        }
    }

    // Authorize and Deploy to Test2
    withCredentials([file(credentialsId: TEST2_JWT_KEY_CRED_ID, variable: 'test2_jwt_key_file')]) {
        stage('Authorize and Deploy to Test2') {
            def rc
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${TEST2_CONNECTED_APP_CONSUMER_KEY} --username ${TEST2_HUB_ORG} --jwtkeyfile ${test2_jwt_key_file} --setdefaultdevhubusername --instanceurl ${TEST2_SFDC_HOST}"
            } else {
                rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${TEST2_CONNECTED_APP_CONSUMER_KEY} --username ${TEST2_HUB_ORG} --jwtkeyfile \"${test2_jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${TEST2_SFDC_HOST}"
            }
            if (rc != 0) { error 'Test2 org authorization failed' }

            println rc

            // Deploy metadata to Test2
            def rmsg
            if (isUnix()) {
                rmsg = sh returnStdout: true, script: "${toolbelt} force:mdapi:deploy -d manifest/. -u ${TEST2_HUB_ORG}"
            } else {
                rmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:mdapi:deploy -d manifest/. -u ${TEST2_HUB_ORG}"
            }

            println rmsg
        }
    }
}
