# docker-scala-sbt

This is an image designed to make `sbt` available in ACP's Drone Pipelines. This image is preferrable to the official scala-sbt image because it configures ACP's Artefactory as a proxy (and therefore significantly reduces configuration in your project) as well as making it easy to switch between JDKs.

### Usage

This image is to be used to build your scala apps. Below in an example of how you would do this in drone.

Contents of .drone.yml:
```
  build:
    commands:
       - . /root/entrypoint.sh
       - sbt compile test assembly
    image: quay.io/ukhomeofficedigital/scala-sbt:latest
    environment:
      - ARTIFACTORY_USERNAME=username
      - JRE_VERSION=17
    secrets:
      - ARTIFACTORY_PASSWORD
    when:
      event:
        - push
        - pull_request

```

This build script expects ARTIFACTORY_PASSWORD to be set as a secret in Drone.


Recent Changes:
  * Before you use the sbt command you need to call the entrypoint script. You either need to use `. entrypoint.sh` or `source entrypoint.sh` because it exports environmental variables required to make `sbt` work correctly in subsequent commands.
  * In your .drone.yml, when refencing this project you need to set `JRE_VERSION` enviroment flag to either `8` (aka `1.8.0`), `11` or `17`. Sbt and Scala itself target the LTE versions of the JDK so there shouldnt be a need to refence versions in between.
  * The version sbt bundled is `1.8.2` but sbt always downloads and uses the sbt associated with your project (from `project/build.properties`) so this is how you can control the version.
