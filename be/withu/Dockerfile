# 빌드 스테이지
FROM gradle:7.6.1-jdk17 AS build
WORKDIR /home/gradle/src
COPY build.gradle settings.gradle /home/gradle/src/
COPY gradle /home/gradle/src/gradle
RUN gradle dependencies --no-daemon

COPY --chown=gradle:gradle . .
RUN gradle build --no-daemon -x test

# 실행 스테이지
FROM openjdk:17-jdk-slim

WORKDIR /app

# 빌드 스테이지에서 생성된 JAR 파일 복사
COPY --from=build /home/gradle/src/build/libs/*.jar app.jar

# 설정 파일 복사
COPY src/main/resources/application.properties /app/application.properties
COPY src/main/resources/firebase-service-account.json /app/firebase-service-account.json

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]