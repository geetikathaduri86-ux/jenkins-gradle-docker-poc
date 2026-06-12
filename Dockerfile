# ==========================================
# Stage 1: Build the application using Gradle
# ==========================================
FROM gradle:8-jdk17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the entire project into the container
COPY . .

# Build the application jar file, skipping tests to speed up the PoC
RUN ./gradlew clean bootJar --no-daemon -x test

# ==========================================
# Stage 2: Create the lightweight runtime image
# ==========================================
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy only the compiled JAR file from Stage 1
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose port 8080 (the default Spring Boot port)
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
