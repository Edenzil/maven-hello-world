# Stage 1: Build the application
FROM maven:3.8.1-openjdk-11 AS builder

WORKDIR /myapp

COPY myapp/* .

RUN mvn package 
# Stage 2: Create a lightweight image to run the application
FROM adoptopenjdk:11-jre-hotspot

WORKDIR /myapp

# Copy the JAR file from the builder stage
COPY --from=builder /myapp/target/*.jar /myapp/

# Create a non-root user
RUN adduser --system --group nonrootuser

# Change ownership of the application directory to the non-root user
RUN chown -R nonrootuser:nonrootuser /myapp

# Switch to the non-root user
USER nonrootuser

# Expose the port your application runs on
EXPOSE 8080

# Command to run the application
CMD ["java", "-cp", "*.jar", "com.myapp.App"]
