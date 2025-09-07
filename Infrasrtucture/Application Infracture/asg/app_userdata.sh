#!/bin/bash
# Update system
dnf update -y

# Install nginx
dnf install -y nginx

# Enable and start nginx service
systemctl enable nginx
systemctl start nginx

# Create a simple test page
echo "<html><head><title>Webapp</title></head><body><h1>Hello from webapp instance </h1></body></html>" > /usr/share/nginx/html/index.html