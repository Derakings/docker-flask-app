# Flask Docker App - DevOps Pipeline

A production-ready DevOps pipeline that deploys a Flask application to AWS using Docker, Terraform, and Application Load Balancer.

## 🎯 What This Project Does

Transforms a simple Flask app into a scalable, cloud-deployed application with:
- **Docker** containerization
- **AWS VPC** with load balancer  
- **Terraform** Infrastructure as Code
- **Automated deployment** scripts

## 🏗️ Architecture

```
Flask App → Docker → DockerHub → Terraform → AWS VPC → ALB → EC2
```

**Infrastructure:**
- Custom VPC (10.0.0.0/16) with 2 public subnets
- Application Load Balancer with health checks
- EC2 instance (t2.micro) running Dockerized Flask app
- Security groups with proper access controls

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| **App** | Flask + Gunicorn |
| **Container** | Docker |
| **Infrastructure** | Terraform + AWS |
| **Load Balancer** | AWS ALB |
| **Compute** | EC2 (t2.micro) |

## 📁 Project Structure

```
docker-flask-app/
├── app.py                    # Flask application
├── Dockerfile               # Container config
├── docker-build-push.sh     # Build automation
├── deploy.sh               # Full deployment
└── terraform/              # Infrastructure as Code
    ├── main.tf             # Provider setup
    ├── vpc.tf              # Network infrastructure
    ├── security_groups.tf  # Access controls
    ├── load_balancer.tf    # ALB configuration
    ├── compute.tf          # EC2 instances
    └── variables.tf        # Configuration
```

## 🚀 Quick Deploy

1. **Configure AWS credentials**
2. **Create terraform.tfvars** from example
3. **Deploy infrastructure:**
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

## 🎯 Perfect For

- **Learning DevOps** and cloud architecture
- **Portfolio projects** demonstrating skills
- **Startup MVPs** needing quick deployment
- **Interview preparation** with practical examples

## 📊 What You Get

✅ **Production-ready** AWS infrastructure  
✅ **Scalable** load balancer setup  
✅ **Secure** VPC with proper networking  
✅ **Automated** deployment workflow  
✅ **Professional** Terraform code structure  

**Ready to deploy Flask apps with enterprise-grade infrastructure!** 🚀

