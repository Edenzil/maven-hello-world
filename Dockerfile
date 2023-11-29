# Stage 1: Build the application
FROM maven:3.8.1-openjdk-11 AS builder

WORKDIR /myapp

COPY /myapp/pom.xml .
COPY /myapp/src/ ./src

# RUN mvn clean --quiet

# ENV current_version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
# ENV new_version=$(echo $current_version | awk -F. '{print $1 "." $2 "." $3+1}')
# RUN mvn versions:set -DnewVersion=$new_version

RUN mvn package 
# Stage 2: Create a lightweight image to run the application
FROM adoptopenjdk:11-jre-hotspot

WORKDIR /myapp

# Copy the JAR file from the builder stage
COPY --from=builder /myapp/target/*.jar ./myapp.jar

# Create a non-root user
RUN adduser --system --group nonrootuser

# Change ownership of the application directory to the non-root user
RUN chown -R nonrootuser:nonrootuser /myapp

# Switch to the non-root user
USER nonrootuser

# Expose the port your application runs on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "myapp.jar"]
