# # Stage 1: Build the application
# FROM maven:3.8.1-openjdk-11 AS builder

# WORKDIR /myapp

# COPY myapp/ .

# RUN mvn package 
# # Stage 2: Create a lightweight image to run the application
# FROM adoptopenjdk:11-jre-hotspot

# WORKDIR /myapp

# # Copy the JAR file from the builder stage
# COPY --from=builder /myapp/target/*.jar /myapp/myapp.jar

# # Create a non-root user && Change ownership of the application directory to the non-root user
# RUN adduser --system --group nonrootuser && chown -R nonrootuser:nonrootuser /myapp/*

# # Expose the port your application runs on
# EXPOSE 8080
# # Switch to the non-root user
# USER nonrootuser

# # Command to run the application
# CMD ["java", "-jar", "myapp.jar" ]

#
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
