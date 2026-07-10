# ============================================
# DOCKERFILE - Self-Healing CI/CD Platform
# ============================================
# This Dockerfile creates a lightweight web
# server image using nginx on Alpine Linux.
#
# It copies our website files (HTML, CSS, JS)
# into nginx's default serving directory.
#
# Usage:
#   docker build -t mywebsite .
#   docker run -d -p 80:80 --name mywebsite mywebsite
# ============================================

# Step 1: Use nginx on Alpine Linux as the base image
# Alpine is a tiny Linux distribution (~5MB), making
# our final image very small and fast to download.
FROM nginx:alpine

# Step 2: Copy all website files into nginx's
# default directory. Nginx automatically serves
# files from /usr/share/nginx/html.
COPY index.html /usr/share/nginx/html/
COPY style.css  /usr/share/nginx/html/
COPY script.js  /usr/share/nginx/html/

# Step 3: Expose port 80
# This tells Docker that the container will listen
# on port 80 (the standard HTTP port).
EXPOSE 80

# Note: We do NOT need a CMD instruction here
# because the nginx:alpine base image already
# includes a default CMD that starts nginx.
