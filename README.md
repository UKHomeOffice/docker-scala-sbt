# docker-scala-sbt-nodejs

  
Enables build of ScalaJS apps.

This has:
- sbt
- OpenJDK
- nodejs
- yarn

### Usage

This image is to be used to build your scala-JS apps. Below in an example of how you would do this in drone.

Contents of .drone.yml:
```
  build:
    commands:
       - "/root/entrypoint.sh 'sbt clean update assembly'"
    image: quay.io/ukhomeofficedigital/docker-scala-sbt-nodejs:latest
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
