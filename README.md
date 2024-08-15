## What is this repository for?

This is a suite of projects to demonstrate various patterns required to deploy and run spring boot application and spring cloud services on the BIP Platform.

The Production Operations Manual for BIP Framework Applications can be found [here](https://github.com/department-of-veterans-affairs/bip-reference-person/blob/master/docs/production-operations-manual.md).

The BIP Framework has been updated to use the OpenAPI v3 "design first" approach to REST API declaration.
- Please review the [Framework Release Notes](https://github.com/department-of-veterans-affairs/bip-framework/wiki/Framework-Release-Notes)
- If you are creating a new project, please see the [BIP OpenAPI v3 Developer Guide](docs/openapi-v3-developer-guide.md)
- If you are upgrading from BIP Framework 1.x to BIP Framework 2.x, please review the above links, and see the help at [Migrating from BIP Framework 1.x to BIP Framework 2.x](docs/openapi-v3-migration-guide.md).

## Project Breakdown 

1. [bip-reference-reactor](https://github.com/department-of-veterans-affairs/bip-reference-person): This is the root reactor project (you are in that repo now). This project forms the aggregate of modules that make up the complete service app, and manages the Fortify scans. In addition to its typical reactor duties, this project contains:
	- a maven profile, and a `./fortify.sh` script to run Fortify
	- a local-dev folder with docker images to run in the spring "local-int" (docker) mode, and with tools to simplify SwA code review submissions.
	- a `template.yaml` file which is the Openshift deployment template used during the CI/CD pipeline for deployment.
	- a `testing.yaml` file which is used to configure the Helm Chart used by the CI/CD pipeline for the Kubernetes deployments.
	- a `Jenkinsfile` file which configures the CI/CD pipeline for the project. For more information on the CI/CD pipeline see the [Java Gitflow Pipeline](https://github.com/department-of-veterans-affairs/bip-jenkins-lib/tree/master/docs/spring-boot-pipelines) and [Pipeline Configuration](https://github.com/department-of-veterans-affairs/bip-jenkins-lib/blob/master/docs/spring-boot-pipelines/pipeline-config.md) documents (Must be on a VA network to access these documents).

2. [bip-reference-partner-person](https://github.com/department-of-veterans-affairs/bip-reference-person/tree/master/bip-reference-partner-person): Partner service for reference person, showing sample mock data for BGS. It should be noted by service designers and tech leads that Partner projects would typically be stand-alone (in their own repo, and not part of a reactor project). The intent is for Partner projects to be freely available for use by any number of service applications that might need them by including them as a maven dependency.

3. [bip-reference-person](https://github.com/department-of-veterans-affairs/bip-reference-person/tree/master/bip-reference-person): Service implementation project. This project demonstrates the recommended design patterns, configuration pointers, and coding examples. It shows how to produce a documented end-point, how to register the app with Consul, how to use secrets from Vault, how to implement a Hystrix circuit breaker, how to get and use loggers, etc. The design consists of three layers:
	- The Provider (or "web") layer contains the REST end-points and model, JSR 303 annotations in the resource class and the model, and the use of an adapter class to transform models and call the service interface. The end-points demonstrate use cases such that fetching some data based on a request, submitting data, file uploads and downloads.
	- The Domain (or "service") layer contains examples of business validation, business logic, to call Partner services and process the returned data, and exception handling.
	- The Partner (or "client") layer shows how to perform model transformation, how to call a partner client interface, and how to handle responses (or exceptions thrown) from the partner client.

4. [bip-reference-inttest](https://github.com/department-of-veterans-affairs/bip-reference-person/tree/master/bip-reference-inttest): Contains the integration tests using the framework Test Library Spring Rest Template, Cucumber libraries, and other capabilities). It includes functioning test cases that run against the end-points in `bip-reference-person`.

5. [bip-reference-perftest](https://github.com/department-of-veterans-affairs/bip-reference-person/tree/master/bip-reference-perftest): Contains functioning performance JMX test scripts for Apache JMeter that run against the endpoints in `bip-reference-person`.

## How to include the framework libraries in your project

The projects in this repository are dependent on the libraries from [BIP framework](https://github.com/department-of-veterans-affairs/bip-framework) and [BIP framework test library](https://github.com/department-of-veterans-affairs/bip-framework/tree/master/bip-framework-test-lib) for  auto configuration, common shared libraries, parent pom maven configuration and test libary. These libraries can be included as shown below.

1. Make `bip-framework-parentpom` the parent of your application's parent POM
	```xml
    <!-- ./bip-[application-name]-parentpom POM file -->
    <parent>
    	<groupId>gov.va.bip.framework</groupId>
    	<artifactId>bip-framework-parentpom</artifactId>
    	<version>VERSION</version>
    	<relativePath />
    </parent>
	```

2. The POM hierarchy for the application modules must resolve to the parent POM
	```xml
    <!-- ./bip-[module-name] POM file -->
    <parent>
    	<groupId>[application.group.id]</groupId>
    	<artifactId>bip-[application-name]-parentpom</artifactId>
    	<version>VERSION</version>
    	<relativePath>..</relativePath>
    </parent>
	```

3. Each module may add framework dependencies as needed
	```xml
    <dependency>
    	<groupId>gov.va.bip.framework</groupId>
    	<artifactId>bip-framework-autoconfigure</artifactId>
    	<version><!-- add the appropriate version --></version>
    </dependency>
    <dependency>
    	<groupId>gov.va.bip.framework</groupId>
    	<artifactId>bip-framework-libraries</artifactId>
    	<version><!-- add the appropriate version --></version>
    </dependency>
    <dependency>
    	<groupId>gov.va.bip.framework</groupId>
    	<artifactId>bip-framework-test-lib</artifactId>
    	<version><!-- add the appropriate version --></version>
    </dependency>
	```

To make these libraries available for compilation, read [this section](#how-to-make-the-dependency-framework-libraries-available).

## How to build and test?

The fastest way to get set up is to visit the [Quick Start Guide](docs/quick-start-guide.md).

## Application Core Concepts and Patterns
#### Design
* [Layer Separation Design](docs/design-layer-separation.md)

#### Development
* [Developing with BIP Framework](docs/developing-with-bip-framework.md)
* [BIP Service Application Flow](docs/application-flow.md)

#### Configuration & Usage Patterns
* [Service Discovery](docs/service-discovery-guide.md)
* [Configuration Management](docs/config-management.md)
* [Secrets Management](docs/secrets.md)
* [Kong: API Gateway Management](docs/api-gateway-management.md)
* [Swagger Management](docs/swagger-management.md)
* [Security Management](docs/application-security-management.md)
* [Secure Communications](docs/secure-communication.md)
* [SSL Certificates Management](docs/application-ssl-certs-management.md)
* [Log and Audit Management](docs/log-audit-management.md)
* [Cache Management](docs/cache-management.md)
* [Validation Management](docs/validation.md)
* [Exception Handling](docs/exception-handling.md)
* [Database Management](docs/database-config-usage.md)
* [Resilience4J Circuit Breaker Management](docs/resilience4j-management.md)
* [Hystrix Circuit Breaker Management](docs/hystrix-management.md)
* [Actuator Management](docs/actuator-management.md)
* [Build Info and Git Properties Plugin](docs/build-and-git-properties.md)
* [Prometheus Grafana Local Dev](docs/prometheus-grafana-setup.md)
* [Deployment Packaging](docs/deployment-package.md)
* [OpenAPI V3 Developer Guide](docs/openapi-v3-developer-guide.md)
* [Fortify and SwA Secure Code Reviews](docs/fortify-and-swa.md)

## How to make the dependency framework libraries available

To make the framework libraries available locally for the service projects to compile and build, there are 3 options.

#### Option 1 - Clone the libraries from GitHub
This option downloads the bip-framework code to your local workstation to be built.

1. Clone the BIP framework repository `git clone https://github.com/department-of-veterans-affairs/bip-framework.git`
2. Navigate to the folder `bip-framework` and run the `mvn clean install` command. This builds all the libraries with versions as configured in `pom.xml` files.

#### OPTION 2 - Retrieve the libraries from the VA Nexus repo
This option requires that your workstation is connected to the VA network. It allows maven to retrieve the libraries from nexus, so you don't need to build them.

Add the repository definition to the `pom.xml` file in your reactor (root) project. Note that the URL provided in this snippet is the correct base URL for the VA nexus repository used for BIP Framework.

```xml
<repositories>
	<repository>
		<id>nexus3</id>
		<name>BIP Nexus Repository</name>
		<url>https://nexus.dev.bip.va.gov/repository/maven-public</url>
	</repository>
</repositories>
```

#### OPTION 3 - Retrieve the libraries from a GitHub repository
This is a temporary work-around for those who are not connected to the VA network. In this case, GitHub is co-opted to act as a repository for the framework libraries.

There are two steps to make this work.

1. Add the below section in the reactor (root) `pom.xml` of your service project. A complete and functioning example can be seen in the [bip-reference-reactor pom.xml](https://github.com/department-of-veterans-affairs/bip-reference-person/blob/master/pom.xml).

```xml
<repositories>
	<repository>
		<id>github</id>
		<name>GitHub Repository</name>
		<url>https://raw.github.com/department-of-veterans-affairs/bip-framework/mvn-repo</url>
	</repository>
</repositories>
```

2. Update your local `~/.m2/settings.xml` as shown below. Replace values between `{{Text}}` with your personal GitHub information

```xml
<settings>
	<servers>
		<server>
			<id>github</id>
			<username>{{Your GitHub User Name}}</username>
			<password>{{Your Personal Access Token}}</password>
			<configuration>
				<httpHeaders>
					<property>
						<name>Authorization</name>
						<!--
						For value tag below:
							Step 1: Base64-encode your username and Github access token together
								in the form: {{username}}:{{access_token}}
								Example: encode the string "myGithubUsername:ab123983245sldfkjsw398r7"
							Step 2: Add the encoded string to the value tag in the form of
								"Basic {{encoded-string}}"
								Example: <value>Basic YXJtaXvB4F5ghTE2OGYwNmExMWM2NDdhYjWExZjQ1N2FhNGJiMjE=</value>
						Base64 encoders:
							https://www.freeformatter.com/base64-encoder.html
							https://www.base64encode.org/
						-->
						<value>Basic {{base64 encoded content}}</value>
					</property>
				</httpHeaders>
			</configuration>
		</server>
	</servers>
</settings>
```

## Local Development
Instructions on running the application on a local workstation can be found in the [local-dev README](local-dev).

## Contribution guidelines
If you or your team wants to contribute to this repository, then fork the repository and follow the steps to create a PR for our upstream repo to review and commit the changes:
[Creating a pull request from a fork](https://help.github.com/articles/creating-a-pull-request-from-a-fork/)

## Searching for an Archetype to build a React UI?
If you want to use a React frontend that will work with these archetype spring projects, consider using the BIP React Archetype.
Learn more: [BIP Archetype UI React README](https://github.com/department-of-veterans-affairs/bip-archetype-ui-react/blob/master/README.md)

