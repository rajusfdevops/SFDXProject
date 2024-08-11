node {
    def toolbelt = 'sfdx' // Path to Salesforce CLI
    def dev2_jwt_key_file = 'bde74365-fe66-45fa-886d-0942a42dbba1'
    def test2_jwt_key_file = 'bde74365-fe66-45fa-886d-0942a42dbba1'
    def DEV2_CONNECTED_APP_CONSUMER_KEY = '3MVG9NKbrATitsDbyBEl8XLAzstYT.6djPavrFgGgTkor3RVRGzn0FK.gi6oew_G9vh98eAE0Xfc3oFg0JWJ1'
    def TEST2_CONNECTED_APP_CONSUMER_KEY = '3MVG9bFKi1uCqVFW8jjY.Py1iR0s6UUMTFRMTCVaHjGOqWvqBijGNMIPjahphbA5L327TR6YKU69nrqfI6PON'
    def DEV2_HUB_ORG = 'rajukumarsfdevops-susq@force.com.dev2'
    def TEST2_HUB_ORG = 'rajukumarsfdevops-susq@force.com.test2'
    def DEV2_SFDC_HOST = 'https://login.salesforce.com'
    def TEST2_SFDC_HOST = 'https://login.salesforce.com'
    def packageXmlPath = 'manifest/package.xml'
    def retrieveDir = 'manifest'
    def zipFilePath = "${retrieveDir}/unpackaged.zip"
    def unzipDir = "${retrieveDir}/unpackaged"

    try {
        // Authorize Dev2 Org
        def rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${DEV2_CONNECTED_APP_CONSUMER_KEY} --username ${DEV2_HUB_ORG} --jwtkeyfile \"${dev2_jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${DEV2_SFDC_HOST}"
        if (rc != 0) { error 'Dev2 org authorization failed' }

        // Retrieve Metadata from Dev2
        def rmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:mdapi:retrieve -r ${retrieveDir} -u ${DEV2_HUB_ORG} -k ${packageXmlPath} --wait 10"
        println "Dev2 Retrieve Result: ${rmsg}"

        // Unzip Retrieved Metadata
        bat "powershell -command \"Expand-Archive -Path ${zipFilePath} -DestinationPath ${unzipDir} -Force\""

        // Authorize Test2 Org
        rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${TEST2_CONNECTED_APP_CONSUMER_KEY} --username ${TEST2_HUB_ORG} --jwtkeyfile \"${test2_jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${TEST2_SFDC_HOST}"
        if (rc != 0) { error 'Test2 org authorization failed' }

        // Deploy Metadata to Test2
        def dmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:mdapi:deploy -d ${unzipDir} -u ${TEST2_HUB_ORG} --wait 10 --testlevel RunLocalTests"
        println "Test2 Deploy Result: ${dmsg}"

        // Check Deployment Status
        def status = bat returnStdout: true, script: "\"${toolbelt}\" force:mdapi:deploy:report -u ${TEST2_HUB_ORG}"
        println "Deployment Status: ${status}"
    } catch (Exception e) {
        error "An error occurred: ${e.message}"
    }
}
