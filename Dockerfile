FROM openjdk:8
EXPOSE 8080
ADD target/DevopsSampleProject-0.0.1-SNAPSHOT.jar DevopsSampleProject-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/DevopsSampleProject-0.0.1-SNAPSHOT.jar"]
