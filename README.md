# docker-scala-sbt

This is an image that provides ACP's Drone Pipelines with support for using the SBT tool.

This modified version sets the proxy server for ACP's artefactory, avoids using root, and should be backward's compatible with the 30+ Scala projects that depend on it.

### Usage

This image is to be used to build your scala apps. Below in an example of how you would do this in drone.

Contents of .drone.yml:
```
  build:
    commands:
       - "/root/entrypoint.sh '. setjdk 17; sbt clean update test assembly'"
    image: quay.io/ukhomeofficedigital/scala-sbt:latest
    environment:
      - ARTIFACTORY_USERNAME=username
    secrets:
      - ARTIFACTORY_PASSWORD
    when:
      event:
        - push
        - pull_request

```

This build script expects ARTIFACTORY_PASSWORD to be set as a secret in Drone.

Use the setjdk command with the argument 8, 11 or 17 to choose the correct JDK for your application.

The sbt bundled is 1.8.2 but SBT always downloads and uses the sbt associated with your project (from project/build.properties) so this is how you can control the version.
