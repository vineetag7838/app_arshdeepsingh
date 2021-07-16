FROM openjdk:8
EXPOSE 7100
ADD target/DevopsSampleProject.jar DevopsSampleProject.jar
ENTRYPOINT ["java","-jar","/DevopsSampleProject.jar"]
