#!/bin/bash

# Update the system
apt update -y

# Install Docker
apt install -y docker.io

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add user to docker group
usermod -a -G docker ubuntu

# Install Docker Compose (optional)
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Pull and run the Flask app container
docker pull ${docker_image}

docker run -d \
  --name flask-app \
  --restart unless-stopped \
  -p 5000:5000 \
  ${docker_image}

# Optional: Install and enable Nginx
apt install -y nginx
systemctl start nginx
systemctl enable nginx

# Create a health check script
cat > /home/ubuntu/check_app.sh << 'EOF'
#!/bin/bash
if curl -f http://localhost:5000 > /dev/null 2>&1; then
    echo "Flask app is running ✅"
else
    echo "Flask app is not responding ❌"
    echo "Attempting to restart container..."
    docker restart flask-app
fi
EOF

chmod +x /home/ubuntu/check_app.sh
chown ubuntu:ubuntu /home/ubuntu/check_app.sh

# Set up a cron job for the ubuntu user
echo "*/5 * * * * /home/ubuntu/check_app.sh >> /home/ubuntu/check_app.log 2>&1" | crontab -u ubuntu -

# Log deployment info
echo "$(date): Flask app deployment completed" >> /var/log/flask-app-deploy.log
echo "Docker image: ${docker_image}" >> /var/log/flask-app-deploy.log
echo "Deployment script executed successfully!" >> /var/log/flask-app-deploy.log