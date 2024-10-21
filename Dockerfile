# Use an official Tomcat image for the final stage
FROM tomcat:9.0.50-jdk11-openjdk AS base

ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

# Set environment variables for SDKMAN installation
ENV SDKMAN_DIR="/usr/local/sdkman"
ENV GRADLE_VERSION="7.5"
ENV SDKMAN_VERSION="5.14.2+737"

# Install dependencies
RUN apt-get update && apt-get install -y curl unzip zip \
    && rm -rf /var/lib/apt/lists/*

# Install SDKMAN and use it to install Gradle
RUN curl -s "https://get.sdkman.io" | bash \
    && chmod +x "$SDKMAN_DIR/bin/sdkman-init.sh" \
    && bash -c "source $SDKMAN_DIR/bin/sdkman-init.sh && sdk install gradle $GRADLE_VERSION"

ENV PATH="$SDKMAN_DIR/candidates/gradle/current/bin:$PATH"

# Install PostgreSQL client
RUN apt-get update && \
    apt-get install -y postgresql-client

# Set the working directory
WORKDIR /app

# Copy the source code into the container
COPY . .

# Set environment variables for the application
RUN echo "export POSTGRES_USER=${POSTGRES_USER}" >> variables.sh \
    && echo "export POSTGRES_PASSWORD=${POSTGRES_PASSWORD}" >> variables.sh \
    && echo "export POSTGRES_DB=${POSTGRES_DB}" >> variables.sh \
    && echo "export POSTGRES_IP=${POSTGRES_IP}" >> variables.sh \
    && echo "export REDIS_IP=${REDIS_IP}" >> variables.sh \
    && echo "export MONGO_IP=${MONGO_IP}" >> variables.sh 

# Make entry_point.sh executable
RUN chmod +x entry_point.sh

# Make variables.sh executable
RUN chmod +x variables.sh

# Make pgsql_restore.sh executable
RUN chmod +x scripts/pgsql_restore.sh

# Build the application using Gradle without integration tests
RUN gradle clean build -x test

# Set the working directory
WORKDIR /usr/local/tomcat/webapps

# Copy the built WAR file from the build stage
RUN cp /app/build/libs/*.war ./ROOT.war

# Set the working directory
WORKDIR /app

# Run entry point file
CMD ["/app/entry_point.sh"]
