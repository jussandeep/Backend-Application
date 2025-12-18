FROM eclipse-temurin:17-jdk

WORKDIR /app 

EXPOSE 8080

COPY target/Backend-Application.jar Backend-Application.jar

ENTRYPOINT ["java", "-jar", "Backend-Application.jar"]



