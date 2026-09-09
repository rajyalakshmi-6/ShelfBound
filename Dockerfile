# Multi-stage Dockerfile for ShelfBound (Java Servlets / JSP on Tomcat 10)

# ====================================================
# Stage 1: Build the WAR with Maven
# ====================================================
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B || true

# Copy source code and build the WAR file
COPY src ./src
RUN mvn clean package -DskipTests

# ====================================================
# Stage 2: Production Apache Tomcat 10 on JDK 21
# ====================================================
FROM tomcat:10.1-jdk21-temurin

# Clean up default Tomcat apps (docs, examples, manager, etc.)
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy Bookstore.war as ROOT.war so the website is served at root "/"
COPY --from=build /app/target/Bookstore.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat HTTP port
EXPOSE 8080

# Start Tomcat in foreground
CMD ["catalina.sh", "run"]