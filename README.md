# APISIX Demo: Microservices Project Overview

This project is a demonstration of a microservices architecture using **Spring Boot** for the backend services and **Apache APISIX** as the API Gateway. It is designed to understand how multiple independent services can be stitched together and accessed through a single entry point.

## 🏗️ Architecture

The architecture consists of three main components:

1.  **API Gateway (Apache APISIX):** The front door for all incoming requests. It receives HTTP requests and routes them to the appropriate backend service based on the URL path.
2.  **Hostel Service (Spring Boot):** A microservice responsible for hostel-related operations. It runs on port `8081`.
3.  **Exam Service (Spring Boot):** A microservice responsible for exam-related operations. It runs on port `8082`.

All traffic flows through the APISIX Gateway (running on port `9080`), which acts as a reverse proxy to the backend Spring Boot services.

## 📂 Key Code Files & Project Structure

Here is a breakdown of the important files and directories in this repository and what they do:

### 1. Spring Boot Microservices
These are the actual applications that handle the business logic.

*   `hostel-service/`
    *   **Description:** A standard Maven-based Spring Boot application.
    *   **Important File:** `src/main/java/com/example/hostel_service/HostelController.java`
        *   This is the REST controller. It defines an endpoint at `GET /hostel/students` that returns a simple list of student names.
    *   **Important File:** `src/main/resources/application.properties`
        *   Configures the property `server.port=8081`, ensuring this service starts on port 8081.

*   `exam-service/`
    *   **Description:** A standard Maven-based Spring Boot application.
    *   **Important File:** `src/main/java/com/example/exam_service/ExamController.java`
        *   This is the REST controller. It defines an endpoint at `GET /exam/schedule` that returns a simple schedule.
    *   **Important File:** `src/main/resources/application.properties`
        *   Configures the property `server.port=8082`, ensuring this service starts on port 8082.

### 2. API Gateway Infrastructure (APISIX)
This folder contains the Docker configuration to run the Apache APISIX Gateway, its Dashboard, and etcd (its database).

*   `apisix-docker/example/docker-compose.yml`
    *   **Description:** The heart of the Gateway deployment. This file defines the Docker containers necessary to run the gateway:
        1.  `apisix`: The actual API Gateway process.
        2.  `etcd`: A distributed key-value store. APISIX uses etcd to store all its routing rules and configurations.
        3.  `apisix-dashboard`: A web-based UI for managing APISIX routing visually.

*   `apisix-docker/example/apisix_dashboard_conf/conf.yaml`
    *   **Description:** The configuration file for the APISIX dashboard. Crucially, it tells the Dashboard container how to connect to the `etcd` database container so it can read and write routing rules.

### 3. Routing Configuration
*   `setup_routes.sh`
    *   **Description:** A bash script containing `curl` commands. APISIX is managed dynamically via a REST API (called the Admin API). This script automates the process of sending HTTP `PUT` requests to the Admin API to configure:
        *   **Upstreams:** Telling APISIX where our backend services live (`host.docker.internal:8081` and `8082`).
        *   **Routes:** Telling APISIX that requests to `/hostel/*` go to Upstream 1, and `/exam/*` go to Upstream 2.

## 🚀 How to Run and Test

1.  **Start the Microservices:** Open a terminal in the `hostel-service` directory and run `./mvnw spring-boot:run`. Do the same in the `exam-service` directory.
2.  **Start the Gateway:** Navigate to `apisix-docker/example/` and run `docker compose -p docker-apisix up -d`.
3.  **Configure Routes:** In the root directory, run `./setup_routes.sh` to populate the routing rules.
4.  **Test:**
    *   Direct test (bypassing gateway): `curl http://localhost:8081/hostel/students`
    *   Gateway test: `curl http://localhost:9080/hostel/students` (Notice the port change! APISIX successfully forwarded your request).

For a detailed explanation of APISIX concepts and routing, please read [APISIX_README.md](./APISIX_README.md).
