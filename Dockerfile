# -------------------------------
# Build stage
# -------------------------------

# Use a Maven image with Java 17 to build the application
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Declare a build-time variable (we pass GitHub SHA here)
ARG BUILD_ID

# Set working directory inside the container
WORKDIR /app

# Copy only pom.xml first (this allows Docker to cache Maven dependencies)
COPY app/pom.xml .

# Download all Maven dependencies
# This layer will be reused if pom.xml didn’t change
RUN mvn dependency:resolve

# Copy the Java source code into the container
COPY app/src ./src

# Create a file inside the app that contains the GitHub SHA
# This guarantees the build output changes on every CI run
RUN mkdir -p src/main/resources && echo "$BUILD_ID" > src/main/resources/build.txt

# Compile the project and package it as an executable Spring Boot JAR
RUN mvn clean package spring-boot:repackage -DskipTests


# -------------------------------
# Runtime stage
# -------------------------------

# Use a small lightweight Java runtime image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory inside the runtime container
WORKDIR /app

# Copy the built JAR from the build container into the runtime container
COPY --from=builder /app/target/demo-0.0.1.jar app.jar

# Tell Docker that this container will listen on port 8080
EXPOSE 8080

# Command that runs when the container starts
# It runs the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
