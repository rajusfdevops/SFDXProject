#!groovy
import groovy.json.JsonSlurperClassic

node {
    def BUILD_NUMBER = env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR = "tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    // Environment variables for Dev2
    def DEV2_HUB_ORG = env.DEV2_HUB_ORG
    def DEV2_SFDC_HOST = env.DEV2_SFDC_HOST
    def DEV2_JWT_KEY_CRED_ID = env.DEV2_JWT_CRED_ID
    def DEV2_CONNECTED_APP_CONSUMER_KEY = env.DEV2_CONNECTED_APP_CONSUMER_KEY

    // Environment variables for Test2
    def TEST2_HUB_ORG = env.TEST2_HUB_ORG
    def TEST2_SFDC_HOST = env.TEST2_SFDC_HOST
    def TEST2_JWT_KEY_CRED_ID = env.TEST2_JWT_CRED_ID
    def TEST2_CONNECTED_APP_CONSUMER_KEY = env.TEST2_CONNECTED_APP_CONSUMER_KEY

    def toolbelt = tool 'toolbelt'

    stage('Checkout Source') {
        // When running in multi-branch job, one must issue this command
        checkout scm
    }

    // Authorize Dev2 Org
    withCredentials([file(credentialsId: DEV2_JWT_KEY_CRED_ID, variable: 'jwt_key_file_dev2')]) {
        stage('Authorize Dev2 Org') {
            def rc
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${DEV2_CONNECTED_APP_CONSUMER_KEY} --username ${DEV2_HUB_ORG} --jwtkeyfile ${DEV2_JWT_KEY_CRED_ID} --setdefaultdevhubusername --instanceurl ${DEV2_SFDC_HOST}"
            } else {
                rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${DEV2_CONNECTED_APP_CONSUMER_KEY} --username ${DEV2_HUB_ORG} --jwtkeyfile \"${DEV2_JWT_KEY_CRED_ID}\" --setdefaultdevhubusername --instanceurl ${DEV2_SFDC_HOST}"
            }
            if (rc != 0) { error 'Dev2 org authorization failed' }
        }
    }

    // Authorize Test2 Org
    withCredentials([file(credentialsId: TEST2_JWT_KEY_CRED_ID, variable: 'jwt_key_file_test2')]) {
        stage('Authorize Test2 Org') {
            def rc
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${TEST2_CONNECTED_APP_CONSUMER_KEY} --username ${TEST2_HUB_ORG} --jwtkeyfile ${jwt_key_file_test2} --setdefaultdevhubusername --instanceurl ${TEST2_SFDC_HOST}"
            } else {
                rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${TEST2_CONNECTED_APP_CONSUMER_KEY} --username ${TEST2_HUB_ORG} --jwtkeyfile \"${jwt_key_file_test2}\" --setdefaultdevhubusername --instanceurl ${TEST2_SFDC_HOST}"
            }
            if (rc != 0) { error 'Test2 org authorization failed' }
        }
    }

    // Retrieve Metadata from Dev2
    stage('Retrieve Metadata from Dev2') {
        def retrieveCommand
        if (isUnix()) {
            retrieveCommand = "${toolbelt} force:source:retrieve -m ApexClass,ApexTrigger,CustomObject,Profile -u Dev2"
        } else {
            retrieveCommand = "\"${toolbelt}\" force:source:retrieve -m ApexClass,ApexTrigger,CustomObject,Profile -u Dev2"
        }
        def retrieveResult = sh(script: retrieveCommand, returnStatus: true)
        if (retrieveResult != 0) {
            error "Metadata retrieval from Dev2 failed"
        }
    }

    // Deploy Metadata to Test2
    stage('Deploy Metadata to Test2') {
        def deployCommand
        if (isUnix()) {
            deployCommand = "${toolbelt} force:source:deploy -p force-app -u Test2"
        } else {
            deployCommand = "\"${toolbelt}\" force:source:deploy -p force-app -u Test2"
        }
        def deployResult = sh(script: deployCommand, returnStatus: true)
        if (deployResult != 0) {
            error "Metadata deployment to Test2 failed"
        }
    }
}
