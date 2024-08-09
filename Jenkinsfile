#!groovy
import groovy.json.JsonSlurperClassic

node {
    def BUILD_NUMBER = env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR = "tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    // Environment variables for Dev2
    def DEV2_HUB_ORG = 'rajukumarsfdevops-susq@force.com.dev2'
    def DEV2_SFDC_HOST = 'https://test.salesforce.com'
    def DEV2_JWT_KEY_CRED_ID = 'bde74365-fe66-45fa-886d-0942a42dbba1'
    def DEV2_CONNECTED_APP_CONSUMER_KEY = '3MVG9NKbrATitsDbyBEl8XLAzstYT.6djPavrFgGgTkor3RVRGzn0FK.gi6oew_G9vh98eAE0Xfc3oFg0JWJ1'

    // Environment variables for Test2
    def TEST2_HUB_ORG = 'rajukumarsfdevops-susq@force.com.test2'
    def TEST2_SFDC_HOST = 'https://test.salesforce.com'
    def TEST2_JWT_KEY_CRED_ID = 'bde74365-fe66-45fa-886d-0942a42dbba1'
    def TEST2_CONNECTED_APP_CONSUMER_KEY = '3MVG9bFKi1uCqVFW8jjY.Py1iR0s6UUMTFRMTCVaHjGOqWvqBijGNMIPjahphbA5L327TR6YKU69nrqfI6PON'

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
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${DEV2_CONNECTED_APP_CONSUMER_KEY} --username ${DEV2_HUB_ORG} --jwtkeyfile ${jwt_key_file_dev2} --setdefaultdevhubusername --instanceurl ${DEV2_SFDC_HOST}"
            } else {
                rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${DEV2_CONNECTED_APP_CONSUMER_KEY} --username ${DEV2_HUB_ORG} --jwtkeyfile \"${jwt_key_file_dev2}\" --setdefaultdevhubusername --instanceurl ${DEV2_SFDC_HOST}"
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
