# -------------------------------
# Build stage
# -------------------------------
FROM maven:3.9.6-eclipse-temurin-17 AS builder
# Set working directory
WORKDIR /app
# Copy pom.xml first (for caching dependencies)
COPY app/pom.xml .
# Download dependencies
RUN mvn dependency:resolve
# Copy the source code
COPY app/src ./src
# Build the Spring Boot jar (repackage makes it executable)
RUN mvn clean package spring-boot:repackage -DskipTests

# -------------------------------
# Runtime stage
# -------------------------------
FROM eclipse-temurin:17-jre-alpine
# Set working directory in container
WORKDIR /app
# Copy the fat jar from the builder
COPY --from=builder /app/target/demo-0.0.1.jar app.jar
# Expose port 8080
EXPOSE 8080
# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
