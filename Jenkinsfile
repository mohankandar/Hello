mavenGitflowPipeline {


    /*************************************************************************
    * Stage Flags
    *************************************************************************/

    skipTests = false
    skipFunctionalTests = false
    skipPerformanceTests = false

    // Compliance/Security Stages
    skipSonar = false
    skipFortify = false
    skipOwasp = false
    skipPrismaCloud = false
    skipCodeQL = false
    uploadToSSC = false
    skipCodeQL = false 

    // BIH Stage
    publishTechDocsToS3 = false

    // DEBUG Flags
    skipUndeploy = false
    skipReviewInstance = false
    failOnFortifyGate = false
    safePrismaCloudScan = true

    /*************************************************************************
    * Deployment Configuration
    *************************************************************************/

    helmTimeout = 800
    javaVersion = 17
    buildsToKeep = "5"

    /*************************************************************************
    * Docker Build Configuration
    *************************************************************************/

    // Map of Image Names to sub-directory in the repository. If this is value is non-empty, 
    // the build pipeline will build all images specified in the map. The example below will build an image tagged as
    // `blue/bip-reference-person:latest` using the Docker context of `./bip-reference-person`.
    dockerBuilds = [
        'blue/bip-reference-person': 'bip-reference-person'
    ]
    
    branchToDeployEnvMap = [
        'master': ['lower':['sbx']],
        'development': ['lower':['dev']],
        'release-2.0': ['lower':['test'],'upper':[[
            'env':'uat',
            'source_repository': 'https://container-registry.dev.bip.va.gov',
            'target_repository': 'https://container-registry.stage8.bip.va.gov',
            'source_credential': 'docker-registry',
            'target_credential': 'staging-docker-registry'
        ]]]
    ]
    
    

    /*************************************************************************
    * Functional Testing Configuration
    *************************************************************************/

    //Directory that contains the cucumber reports
    cucumberReportDirectory = "bip-reference-inttest/target/site"

    //Additional Mavn options to use when running functional test cases
    cucumberOpts = "@DEV and not @vefsdocdownload"

    /* Postman Testing Configuration */
   
   //Set of Postman test collections to execute. Required for Postman Testing stage to run.
   //Url of the service is passed to the collection as an environment variable named BASE_URL
   postmanTestCollections = [
     'bip-reference-inttest/src/inttest/resources/bip.postman_collection.json'
   ]

    //Set of Bruno test collections to execute. Required for Bruno Testing stage to run.
    //Url of the service is passed to the collection as an environment variable named BASE_URL
    brunoTestCollection = [
        'bip-reference-inttest/src/inttest/resources/bruno/collection1'
    ]
    //Environment name for your collection. Must have at least BASE_URL variable to run. Required for Bruno Testing stage to run.
    brunoEnv = 'dev'

    // K6 Performance testing instead of JMeter (default) -[skipK6 = false]
    // skipK6 = false
    // k6ScriptPath = "bip-reference-person/scripts/k6/"
    // k6ScriptFile = "script.js"
    // Config File Options or Command line options - jenkins will run either if provided   
    // k6ConfigFile = "config.json"
    // k6Options = "--vus 201"

    /*************************************************************************
    * OpenShift Deployment Configuration
    *
    * This section only applied to builds running on the OpenShift platform.
    * This section should be omitted if you are using Helm for deployments on
    * Kubernetes.
    *************************************************************************/
    //Path to your applications Openshift deployment template
    deploymentTemplates = ["template.yaml"]

    //Deployment parameters for review instances and dev instance
    deploymentParameters = [
        'APP_NAME': 'bip-reference-person',
        'IMAGE': 'bip-reference-person',
        'SPRING_PROFILES': 'dev'
    ]
    
    //Functional Testing Deployment parameters used to configure your Openshift deployment template
    functionalTestDeploymentParameters = [
        'APP_NAME': 'bip-reference-person',
        'IMAGE': 'bip-reference-person',
        'SPRING_PROFILES': 'dev'
    ]

    //Performance Testing Deployment parameters used to configure your Openshift deployment template
    performanceTestDeploymentParameters = [
         'APP_NAME': 'bip-reference-person',
         'IMAGE': 'bip-reference-person',
         'SPRING_PROFILES': 'dev'
    ]

    /*************************************************************************
    * Helm Deployment Configuration
    *
    * This section only applied to builds running on the Kubernetes platform.
    * This section should be omitted if you are using Openshift templates for
    * deployment on Openshift.
    *************************************************************************/

    //Git Repository that contains your Helm chart
    chartRepository = "https://github.com/department-of-veterans-affairs/bip-reference-person-config"

    //Path to your chart directory within the above repository
    chartPath = "charts/bip-reference-person"
    
    //Path to your config directory within the above repository
    configPath = "testing-config"

    chartBranch = "development"

    //Jenkins credential ID to use when connecting to repository. This defaults to `github` if not specified
    chartCredentialId = "github"

    //Value YAML file used to configure the Helm deployments used for functional and performance testing.
    chartValueFunctionalTestFile = "testing.yaml"
    chartValuePerformanceTestFile = "testing.yaml"

    //Value YAML file used to configure the Helm deployments used for the Deploy Review Instance stage
    chartValueReviewInstanceFile = "reviewInstance.yaml"

    //Release name to use
    chartReleaseName = "bip-reference-person"

    /*************************************************************************
     * Fortify Configuration
     *************************************************************************/
    //Specifies the maximum amount of memory Fortify Static Code Analyzer uses. Values can be M or G (ex. 1G).
    fortifyMaxHeap = "1G"

    //Specifies the thread stack size of JVM which runs SCA.
    fortifyThreadSize = "8M"

    //Enable to use the Fortify Jenkins plugin. Maven apps use the Fortify Maven plugin by default.
    useFortifyJenkinsPlugin = true

    //Build ID used for Fortify buildID and file name parameters
    //fortifyBuildID = 'bip-reference-person'



    //Application name and version used for Fortify Upload to SSC when Jenkins plugin is used.
    fortifyAppName = "bip-reference-person"
    fortifyAppVersion = "development"
    
    //Enable to archive Fortify translate and scan log files
    archiveFortifyLogs = false

    //List of files to include in Fortify translate. Value must be in the following syntax: '"./**/*.java" "./**/*.xml"'
    fortifyIncludeList = '"./**/*.java" "./**/*.xml" "./**/*.yml" "./**/*.yaml" "./**/*.xsd" "./**/*.wsdl"'

    //List of files to exclude from Fortify translate. Value must be in the following syntax: '"./dir1" "./dir2"
 fortifyExcludeList = '"./bip-reference-inttest" "./bip-reference-perftest" "./bip-reference-person-db" ' +
             '"./bip-reference-partner-person/src/test" "./bip-reference-partner-person/target/classes" "./bip-reference-partner-person/target/javadoc-bundle-options" "./bip-reference-partner-person/target/test-classes" ' +
             '"./bip-reference-person/src/test" "./bip-reference-person/target/classes" "./bip-reference-person/target/javadoc-bundle-options" "./bip-reference-person/target/test-classes" "./bip-reference-person/target/antrun"'
    //List of properties to add to fortify-sca.properties file.
    //fortifyScaProps = [
    //        "com.fortify.sca.MultithreadedAnalysis = true",
    //        "com.fortify.sca.ThreadCount = 2"
    //]

    /*************************************************************************
    * Tech Docs Build Configuration
    *************************************************************************/

    s3TechDocsBucketName = "default/api/bip-reference-person"
    s3TechDocsEntity = "bip-dev-bih-tech-docs-bucket"
  
    /*************************************************************************
     * OWASP Maven Dependency Check Configuration
     *************************************************************************/
    //Determines if the OWASP Dependency Check stage is executed. Defaults to true.

    //Determines which plugin to use for OWASP Dependency Check. Valid values are "maven" and "jenkins".
    owaspPlugin = "jenkins"

    //Determines vulnerability threshold. If number of vulnerabilities of specified severity exceed this threshold, the pipeline build will be marked as unstable.
//    unstableTotalCritical = 1
//    unstableTotalHigh = 1
//    unstableTotalMedium = 1
//    unstableTotalLow = 1

    //Determines vulnerability threshold. If number of vulnerabilities of specified severity exceed this threshold, the pipeline build will fail.
    //failedTotalCritical = 1
    //failedTotalHigh = 1
    //failedTotalMedium = 1
    //failedTotalLow = 1

    //String for defining Dependency Check command line arguments. See Dependency-Check-CLI documentation (https://jeremylong.github.io/DependencyCheck/dependency-check-cli/arguments.html) for a table of supported command line arguments.
    //owaspArgs = "--suppression ./owasp-suppression.xml"

}