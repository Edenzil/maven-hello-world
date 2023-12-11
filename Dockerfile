# Build stage
#
FROM maven:3.8.1-openjdk-11 AS build
ENV HOME=/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME
ADD myapp/ $HOME
RUN ls -R
RUN --mount=type=cache,target=/root/.m2 mvn -f $HOME/pom.xml clean package

#
# Package stage
#
FROM eclipse-temurin:17-jre-jammy 
ARG JAR_FILE=/usr/app/target/*.jar
COPY --from=build $JAR_FILE /app/myapp.jar
# # Create a non-root user && Change ownership of the application directory to the non-root user
RUN adduser --system --group nonrootuser && chown -R nonrootuser:nonrootuser /app/*
USER nonrootuser
EXPOSE 8080
ENTRYPOINT java -jar /app/myapp.jar
