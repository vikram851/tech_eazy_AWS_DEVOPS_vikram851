# 📦 Zero Mile Delivery - DevOps EC2 Automation with Terraform (us-east-1)

This is a complete and working Terraform project to provision an EC2 instance on AWS inside a custom VPC, with automatic app deployment and secure SSH access.

---

## ✅ Project Summary

| Feature | Included |
|--------|----------|
| Custom VPC (`vpc01`) | ✅ |
| Subnet (`vijaysubnet-01`) | ✅ |
| Internet Gateway (`igw01`) | ✅ |
| Route Table (`rt01`) + Route | ✅ |
| EC2 Instance (Ubuntu + t2.micro) | ✅ |
| IAM Role + S3 Upload Policy | ✅ |
| SSH Access + Public IP | ✅ |
| App Deployment (Spring Boot via GitHub repo) | ✅ |
| Output Public IP & SSH Command | ✅ |

---

## 📁 Project Structure

```
zero-mile-devops/
├── main.tf
├── variables.tf
├── outputs.tf
├── scripts/
│   └── init.sh.tpl
├── .gitignore
├── README.md
```

---

## ⚙️ Usage Instructions

### 🔐 Step 1: Set up AWS Credentials Securely
Use environment variables or AWS CLI profile — **DO NOT** hardcode credentials.

```bash
aws configure --profile devops
```

OR use `.env`:
```bash
export AWS_ACCESS_KEY_ID="<your-access-key>"
export AWS_SECRET_ACCESS_KEY="<your-secret-key>"
export AWS_DEFAULT_REGION="us-east-1"
```

---

### 🚀 Step 2: Deploy Infrastructure
```bash
terraform init
terraform apply -auto-approve
```

---

### 🔎 Step 3: Access EC2 and Verify App
- SSH into your instance:
```bash
ssh -i path/to/vijay123key.pem ubuntu@<EC2_PUBLIC_IP>
```
- Check logs:
```bash
cat /var/log/cloud-init-output.log
cat /app/logs/app.log
```
- Open your browser:
```url
http://<EC2_PUBLIC_IP>/hello
```
✅ You should see: `Hello from Spring MVC!`

---

## 🧾 Output Variables
```hcl
output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "ssh_command" {
  value = "ssh -i path/to/vijay123key.pem ubuntu@${aws_instance.app_server.public_ip}"
}
```

---

## 📤 Git Submission Instructions

1. Create a GitHub repo (e.g., `zero-mile-devops`)
2. Push your files:
```bash
git init
git add .
git commit -m "Zero Mile EC2 Terraform deployment"
git remote add origin <your-repo-url>
git push -u origin main
```
3. Create a feature branch for PR:
```bash
git checkout -b feature/auto-ec2
git push origin feature/auto-ec2
```
4. Create Pull Request on GitHub.

---

## 📎 Required Files

### 1. `main.tf`
Contains all Terraform resources: VPC, subnet, IGW, route, EC2, IAM, etc.

### 2. `variables.tf`
Declares all variables like AMI ID, key name, bucket name.

### 3. `outputs.tf`
Prints EC2 IP and SSH command.

### 4. `scripts/init.sh.tpl`
Startup script to install Java, Maven, clone repo, and start the Spring Boot app.

### 5. `.gitignore`
```bash
*.tfstate
*.tfstate.backup
.terraform/
*.pem
```

### 6. `README.md`
Includes usage instructions and summary (this file).

---

## ✅ Final Test Checklist

- [x] EC2 instance is launched
- [x] Public IP is assigned
- [x] SSH access using `.pem` works
- [x] App runs and accessible on `/hello`
- [x] All Terraform code is pushed to GitHub
- [x] PR is created and submitted

---
