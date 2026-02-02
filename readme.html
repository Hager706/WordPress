# WordPress High Availability Architecture on AWS

## Overview

This project demonstrates a highly available, scalable, and containerized WordPress deployment on AWS using:

- Docker & Docker Compose
- Nginx as a Load Balancer
- Amazon EFS for persistent storage
- Amazon EC2 Auto Scaling Group
- Custom AMI for automated deployment

**Key Features:**
- Traffic load-balanced across multiple WordPress containers
- Zero data loss during container replacement
- Auto-healing EC2 instances
- Session persistence for WordPress authentication
- Shared storage for media uploads

---

## Architecture

### Components

**Application EC2 Instance:**
- Docker Engine
- Docker Compose
- 2 WordPress containers (ports 8080, 8089)
- 1 Nginx container (port 80, load balancer)
- EFS mounted at `/mnt/efs`

**Database EC2 Instance:**
- MySQL 8.0 running as a container
- Port 3306 exposed to Application security group

**Amazon EFS:**
- Persistent storage for `wp-content/uploads`
- Shared across all WordPress containers

**Auto Scaling Group:**
- Desired capacity: 1
- Min: 1, Max: 1
- Auto-heals failed instances

---

## Prerequisites

- AWS Account
- VPC with public and private subnets
- Security Groups configured:
  - Application SG: Allow 80, 8080, 8089, 22
  - Database SG: Allow 3306 from Application SG
  - EFS SG: Allow 2049 from Application SG

---

## Deployment Guide

### Step 1: Database EC2 Setup

#### 1.1 Launch EC2 Instance
- AMI: Amazon Linux 2023
- Instance Type: t3.micro (or larger)
- Security Group: Database SG (port 3306 open to Application SG)

#### 1.2 Install Docker
```bash
sudo dnf update -y
sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
```

#### 1.3 Run MySQL Container
```bash
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=rootpass123 \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wp_user \
  -e MYSQL_PASSWORD=wp_password \
  -p 3306:3306 \
  --restart always \
  mysql:8.0
```

#### 1.4 Verify Database
```bash
docker ps
docker logs mysql
docker exec -it mysql mysql -u wp_user -p
```

---

### Step 2: Amazon EFS Configuration

#### 2.1 Create EFS File System
1. Navigate to EFS in AWS Console
2. Create new file system in same VPC as EC2
3. Configure security group (allow NFS port 2049)
4. Create Access Point (optional but recommended)

#### 2.2 Note EFS Details
- File System ID: `fs-XXXXXXXXX`
- Access Point ID: `fsap-XXXXXXXXX` (if using)

---

### Step 3: Application EC2 Setup

#### 3.1 Launch EC2 Instance
- AMI: Amazon Linux 2023
- Instance Type: t3.small (or larger)
- Security Group: Application SG
- Storage: 20GB+ EBS volume

#### 3.2 Install Dependencies
```bash
sudo dnf update -y
sudo dnf install -y docker amazon-efs-utils
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

#### 3.3 Mount EFS
```bash
# Create mount directory
sudo mkdir -p /mnt/efs

# Add to fstab for automatic mounting
echo "fs-XXXXXXXXX:/ /mnt/efs efs _netdev,tls,iam 0 0" | sudo tee -a /etc/fstab

# If using Access Point:
# echo "fs-XXXXXXXXX:/ /mnt/efs efs _netdev,tls,accesspoint=fsap-XXXXXXXXX 0 0" | sudo tee -a /etc/fstab

# Mount EFS
sudo mount -a

# Set permissions (www-data user ID is 33)
sudo chown -R 33:33 /mnt/efs
sudo chmod -R 775 /mnt/efs

# Verify mount
df -h | grep efs
```

---

### Step 4: Docker Compose Configuration

#### 4.1 Create Project Directory
```bash
sudo mkdir -p /opt/wordpress/nginx
cd /opt/wordpress
```

#### 4.2 Create docker-compose.yml

Replace `<DB_PRIVATE_IP>` with your Database EC2 private IP address.
```bash
sudo cat > docker-compose.yml << 'EOF'
version: "3.9"

services:
  wordpress1:
    image: wordpress:latest
    container_name: wordpress1
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: <DB_PRIVATE_IP>:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wp_user
      WORDPRESS_DB_PASSWORD: wp_password
    volumes:
      - /mnt/efs:/var/www/html/wp-content/uploads
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 10s
      retries: 5
    restart: always

  wordpress2:
    image: wordpress:latest
    container_name: wordpress2
    ports:
      - "8089:80"
    environment:
      WORDPRESS_DB_HOST: <DB_PRIVATE_IP>:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wp_user
      WORDPRESS_DB_PASSWORD: wp_password
    volumes:
      - /mnt/efs:/var/www/html/wp-content/uploads
    depends_on:
      wordpress1:
        condition: service_healthy
    restart: always

  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "80:80"
    depends_on:
      - wordpress1
      - wordpress2
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    restart: always
EOF
```

#### 4.3 Create Nginx Configuration
```bash
sudo cat > nginx/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream wordpress_backend {
        ip_hash;
        server wordpress1:80;
        server wordpress2:80;
    }
    
    server {
        listen 80;
        
        location / {
            proxy_pass http://wordpress_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
            
            # Cookie handling for session persistence
            proxy_cookie_domain localhost $host;
            proxy_cookie_path / /;
            
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            
            # Timeouts
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;
        }
    }
}
EOF
```

**Note:** `ip_hash` directive ensures session persistence, routing users to the same backend container based on their IP address. This is critical for WordPress authentication.

---

### Step 5: Launch the Stack
```bash
cd /opt/wordpress
sudo docker-compose up -d

# Verify containers are running
docker ps

# Check logs
docker-compose logs -f
```

Expected output:
```
CONTAINER ID   IMAGE              COMMAND                  STATUS
xxxxxxxxxx     nginx:latest       "nginx -g 'daemon of…"   Up 2 minutes
xxxxxxxxxx     wordpress:latest   "docker-entrypoint.s…"   Up 2 minutes (healthy)
xxxxxxxxxx     wordpress:latest   "docker-entrypoint.s…"   Up 2 minutes
```

---

### Step 6: WordPress Installation

1. Access WordPress installation: `http://<EC2_PUBLIC_IP>`
2. Complete WordPress setup wizard:
   - Site Title: Your choice
   - Username: `admin`
   - Password: Strong password
   - Email: Your email
3. Set WordPress URLs:
   - Go to **Settings → General**
   - Set both URLs to: `http://<EC2_PUBLIC_IP>`
   - Save changes

---

### Step 7: Testing

#### 7.1 Load Balancing Test
```bash
# Access wordpress1 container
docker exec -it wordpress1 bash
echo "CONTAINER-1" > /var/www/html/container.txt
exit

# Access wordpress2 container
docker exec -it wordpress2 bash
echo "CONTAINER-2" > /var/www/html/container.txt
exit

# Test load balancing (same IP will always go to same container due to ip_hash)
curl http://localhost/container.txt

# Clean up test file
docker exec wordpress1 rm /var/www/html/container.txt
docker exec wordpress2 rm /var/www/html/container.txt
```

#### 7.2 EFS Persistence Test
```bash
# Upload an image via WordPress Media Library

# Verify file on EFS
ls -lh /mnt/efs/

# Restart containers
docker-compose restart

# Verify image still accessible in WordPress
# Check EFS mount
df -h | grep efs
```

#### 7.3 Database Connection Test
```bash
docker exec wordpress1 php -r "echo mysqli_connect('<DB_PRIVATE_IP>', 'wp_user', 'wp_password', 'wordpress') ? 'Connected' : 'Failed';"
```

#### 7.4 Health Check Test
```bash
# Check container health status
docker ps

# Test health endpoint
curl -I http://localhost:8080/
curl -I http://localhost:8089/
```

---

### Step 8: Create Custom AMI

#### 8.1 Prepare Instance
```bash
# Ensure all services are running
docker ps
df -h | grep efs

# Stop containers (optional, depends on your AMI strategy)
# cd /opt/wordpress
# docker-compose down
```

#### 8.2 Create AMI

1. AWS Console → EC2 → Instances
2. Select your Application EC2 instance
3. Actions → Image and templates → Create image
4. Image name: `wordpress-ha-v1`
5. Description: WordPress HA with Docker, Compose, EFS mount
6. Click **Create image**
7. Wait for AMI to become available

---

### Step 9: Launch Template

#### 9.1 Create Launch Template

1. AWS Console → EC2 → Launch Templates → Create launch template
2. Template name: `wordpress-ha-template`
3. AMI: Select your custom AMI (`wordpress-ha-v1`)
4. Instance type: t3.small
5. Key pair: Your SSH key
6. Security groups: Application SG
7. Advanced details → User data:
```bash
#!/bin/bash
set -euxo pipefail

# Start Docker
systemctl start docker
systemctl enable docker

# Mount EFS
mount -a

# Set EFS permissions
chown -R 33:33 /mnt/efs
chmod -R 775 /mnt/efs

# Start WordPress stack
cd /opt/wordpress
docker-compose up -d

# Log completion
echo "WordPress HA stack started at $(date)" >> /var/log/wordpress-startup.log
```

8. Click **Create launch template**

---

### Step 10: Auto Scaling Group

#### 10.1 Create Auto Scaling Group

1. AWS Console → EC2 → Auto Scaling Groups → Create Auto Scaling group
2. Name: `wordpress-ha-asg`
3. Launch template: Select `wordpress-ha-template`
4. VPC: Your VPC
5. Subnets: Select public subnets
6. Health checks: EC2
7. Health check grace period: 300 seconds
8. Group size:
   - Desired capacity: 1
   - Minimum capacity: 1
   - Maximum capacity: 1
9. No scaling policies (fixed capacity for HA only)
10. Add tags:
    - Key: `Name`, Value: `WordPress-HA-Instance`
11. Create Auto Scaling group

#### 10.2 Verify ASG
```bash
# Check ASG launched instance
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wordpress-ha-asg

# SSH to new instance and verify
ssh ec2-user@<NEW_INSTANCE_IP>
docker ps
df -h | grep efs
```

---

## Monitoring and Maintenance

### Container Logs
```bash
# View all logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View specific container logs
docker logs wordpress1
docker logs wordpress2
docker logs nginx
```

### Restart Services
```bash
# Restart specific container
docker restart wordpress1

# Restart all containers
cd /opt/wordpress
docker-compose restart

# Rebuild and restart
docker-compose up -d --force-recreate
```

### Update WordPress
```bash
cd /opt/wordpress

# Pull latest images
docker-compose pull

# Restart with new images
docker-compose up -d
```

### EFS Monitoring
```bash
# Check EFS mount
df -h | grep efs

# Check EFS usage
du -sh /mnt/efs

# Verify permissions
ls -ld /mnt/efs
```

---

## Troubleshooting

### Issue: Cannot login to WordPress

**Solution:**
```bash
# Reset password via database
docker exec -it mysql mysql -u wp_user -pwp_password wordpress

# Run this SQL:
UPDATE wp_users SET user_pass = MD5('newpassword123') WHERE user_login = 'admin';
EXIT;
```

### Issue: EFS not mounting

**Solution:**
```bash
# Check EFS mount helper
sudo yum install -y amazon-efs-utils

# Manually mount
sudo mount -t efs -o tls fs-XXXXXXXXX:/ /mnt/efs

# Check mount
mount | grep efs
```

### Issue: Containers not starting

**Solution:**
```bash
# Check Docker service
sudo systemctl status docker

# Check logs
docker-compose logs

# Rebuild containers
docker-compose down
docker-compose up -d --force-recreate
```

### Issue: Database connection failed

**Solution:**
```bash
# Test connectivity
telnet <DB_PRIVATE_IP> 3306

# Check database container
docker exec -it mysql mysql -u wp_user -p

# Verify security group rules
```

---

## Security Best Practices

1. **Use strong passwords** for database and WordPress admin
2. **Restrict security groups**:
   - Database SG: Only allow Application SG
   - Application SG: Only allow necessary ports
3. **Enable HTTPS** with SSL/TLS certificate (use ALB or nginx SSL)
4. **Regular backups**:
   - Database snapshots
   - EFS backups
   - AMI backups
5. **Update regularly**:
   - WordPress core
   - Docker images
   - System packages
6. **Use IAM roles** instead of access keys
7. **Enable CloudWatch monitoring**

---

## Cost Optimization

- Use t3/t4g instances with burstable performance
- Consider Reserved Instances for long-term usage
- Use EFS Infrequent Access storage class for older uploads
- Implement lifecycle policies for EFS
- Use Spot Instances for non-production environments

---

## Architecture Diagram
```
                                    ┌─────────────────┐
                                    │   Internet      │
                                    └────────┬────────┘
                                             │
                                    ┌────────▼────────┐
                                    │   Application   │
                                    │   Load Balancer │
                                    │     (Nginx)     │
                                    └────────┬────────┘
                                             │
                         ┌───────────────────┼───────────────────┐
                         │                   │                   │
                  ┌──────▼──────┐    ┌──────▼──────┐   ┌───────▼───────┐
                  │ WordPress1  │    │ WordPress2  │   │  Auto Scaling │
                  │ Container   │    │ Container   │   │     Group     │
                  └──────┬──────┘    └──────┬──────┘   └───────────────┘
                         │                   │
                         └───────────┬───────┘
                                     │
                         ┌───────────▼───────────┐
                         │      Amazon EFS       │
                         │  (Shared Storage)     │
                         └───────────────────────┘
                                     │
                         ┌───────────▼───────────┐
                         │   MySQL Container     │
                         │   (Database EC2)      │
                         └───────────────────────┘
```

---

## Conclusion

This architecture provides:

- **High Availability**: Auto Scaling Group replaces failed instances
- **Load Balancing**: Traffic distributed across WordPress containers
- **Data Persistence**: EFS ensures uploaded files survive instance replacement
- **Session Persistence**: `ip_hash` maintains user sessions
- **Scalability**: Easy to increase container count or instance size
- **Disaster Recovery**: Custom AMI enables quick recovery

---

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please submit pull requests or open issues for improvements.

## Author

Your Name - [GitHub Profile](https://github.com/yourusername)
