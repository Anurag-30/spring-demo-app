FROM openjdk:11
WORKDIR /app
COPY ./build/libs/demo-1.0.0.jar .
ENTRYPOINT ["java","-jar","demo-app-1.0.0.jar"]