#!/bin/bash
echo "Building and testing Nginx web app locally..."
docker build -t nginx-webapp:latest .
docker run -d --name nginx-local -p 8080:80 nginx-webapp:latest
echo "Container started. Access at: http://localhost:8080"
echo "Health check: http://localhost:8080/health"
echo "Press Ctrl+C to stop and remove container"
echo "To stop manually: docker stop nginx-local && docker rm nginx-local"