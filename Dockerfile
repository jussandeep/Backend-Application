FROM openjdk:17-jdk-slim

EXPOSE 8080

ADD target/Backend-Application.jar Backend-Application.jar

ENTRYPOINT ["java", "-jar", "Backend-Application.jar"]



