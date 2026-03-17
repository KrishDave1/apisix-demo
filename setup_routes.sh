#!/bin/bash

# APISIX setup script with explanations of key concepts
# APISIX uses a REST API (Admin API) to configure routes, upstreams, and plugins dynamically without restarting.

# 1. UPSTREAMS
# An Upstream represents your backend service (e.g., our Spring Boot apps). 
# By defining an Upstream separately, multiple routes can share the same backend, and APISIX can perform load balancing/health checks on it.
echo "Creating Upstream for Hostel Service..."
curl -s -i http://127.0.0.1:9180/apisix/admin/upstreams/1 \
-H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
    "type": "roundrobin",
    "nodes": {
        "host.docker.internal:8081": 1
    }
}'
echo -e "\n\n"

echo "Creating Upstream for Exam Service..."
curl -s -i http://127.0.0.1:9180/apisix/admin/upstreams/2 \
-H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
    "type": "roundrobin",
    "nodes": {
        "host.docker.internal:8082": 1
    }
}'
echo -e "\n\n"

# 2. ROUTES
# A Route matches the client's request based on criteria like URI, HTTP methods, headers, etc.
# Once a match is found, the Route forwards the request to the specified Upstream.
echo "Creating Route for Hostel Service..."
curl -s -i http://127.0.0.1:9180/apisix/admin/routes/1 \
-H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
    "uri": "/hostel/*",
    "upstream_id": 1,
    "desc": "Routes traffic to the Hostel SpringBoot Service"
}'
echo -e "\n\n"

echo "Creating Route for Exam Service..."
curl -s -i http://127.0.0.1:9180/apisix/admin/routes/2 \
-H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
    "uri": "/exam/*",
    "upstream_id": 2,
    "desc": "Routes traffic to the Exam SpringBoot Service"
}'
echo -e "\n\n"

echo "APISIX configuration complete! You can view these configurations in the APISIX Dashboard at http://localhost:9000"
