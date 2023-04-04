# docker-scala-sbt

Enables build of Scala apps.

This has:
- sbt
- Various versions of the Elipse Temurin JREs

### Usage

This image is to be used to build your scala apps. Below in an example of how you would do this in drone.

Contents of .drone.yml:
```
  build:
    commands:
       - "/root/entrypoint.sh 'sbt clean update test assembly'"
    image: quay.io/ukhomeofficedigital/scala-sbt:v0.3.0
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
