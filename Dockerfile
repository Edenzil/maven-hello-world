# Stage 1: Build the application
FROM maven:3.8.1-openjdk-11 AS builder

WORKDIR /myapp

COPY myapp/* .

RUN ls -l -R

RUN mvn package 
# Stage 2: Create a lightweight image to run the application
FROM adoptopenjdk:11-jre-hotspot

WORKDIR /myapp

# Copy the JAR file from the builder stage
COPY --from=builder /myapp/target/*.jar /myapp/myapp.jar

RUN cat myapp.jar

# Create a non-root user
RUN adduser --system --group nonrootuser

# Change ownership of the application directory to the non-root user
RUN chown -R nonrootuser:nonrootuser /myapp/*
# Expose the port your application runs on
EXPOSE 8080
# Switch to the non-root user
USER nonrootuser

# Command to run the application
CMD ["java", "-jar", "myapp.jar" ]
