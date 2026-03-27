 CI/CD Pipeline Design and Implementation for Node.js Application

Overview

This project demonstrates the design and implementation of a fully automated Continuous Integration and Continuous Delivery (CI/CD) pipeline for a Node.js application using modern DevOps practices.

The pipeline automates the complete lifecycle:

* Code integration
* Build and testing
* Security validation
* Containerization
* Deployment to EC2
* Notification

The implementation follows key DevOps principles such as fast feedback loops, automated quality gates, immutable artifacts, and zero-downtime deployment using a blue-green strategy.

---

## Architecture Overview

```
Developer → GitHub Repository → GitHub Actions (CI/CD)
        → Docker Build → Docker Hub
        → AWS EC2 (Docker + Nginx)
        → Blue-Green Deployment
        → Notification (Slack)
```

---

## Tools and Technologies Used

| Category         | Tools                         |
| ---------------- | ----------------------------- |
| Version Control  | Git, GitHub                   |
| CI/CD            | GitHub Actions                |
| Backend          | Node.js (Express)             |
| Containerization | Docker                        |
| Registry         | Docker Hub                    |
| Cloud Platform   | AWS EC2                       |
| Reverse Proxy    | Nginx                         |
| Security         | npm audit, Trivy              |
| Code Quality     | ESLint                        |
| Notifications    | Slack Webhooks                |
| Operating System | Linux (Amazon Linux / Ubuntu) |

---

## CI/CD Pipeline Stages

### 1. Source Stage

Triggered on:

* Push to main branch
* Pull requests

```yaml
on:
  push:
    branches: ["main"]
  pull_request:
```

This ensures continuous integration for every code change.

---

### 2. Build Stage

Dependencies are installed using:

```bash
npm ci
```

This ensures clean and reproducible builds.

---

### 3. Test Stage

The following checks are executed:

```bash
npm test
npx eslint .
```

Includes:

* Unit tests
* Static code analysis

This stage acts as a quality gate to prevent faulty code from progressing.

---

### 4. Security Scan Stage

Security checks are performed using:

```bash
npm audit
```

Optional:

* Trivy for filesystem and container scanning

This helps identify vulnerabilities early in the pipeline.

---

### 5. Containerization Stage

Docker image is built using:

```bash
docker build -t <username>/assessment:test .
```

Image is pushed to Docker Hub:

```bash
docker push <username>/assessment:test
```

Containerization ensures consistency across environments.

---

### 6. Deploy Stage

Deployment is performed on AWS EC2 using SSH.

Deployment steps:

```bash
docker pull <username>/assessment:test
docker rm -f assessment || true
docker run -d -p 3000:3000 --name assessment <username>/assessment:test
```

This ensures automated deployment without manual intervention.

---

### Blue-Green Deployment Strategy

To achieve zero downtime, a blue-green deployment strategy is used.

| Version | Port | Container        |
| ------- | ---- | ---------------- |
| Blue    | 3000 | assessment       |
| Green   | 3001 | assessment-green |

Process:

1. Deploy new version on alternate port
2. Perform health check using `/health`
3. Switch traffic via Nginx
4. Remove old container



---

### 7. Notification Stage

Pipeline status notifications are sent using Slack webhooks:

```bash
curl -X POST -H 'Content-type: application/json' \
--data '{"text":"CI/CD Pipeline Status: SUCCESS"}' \
$SLACK_WEBHOOK
```

This provides visibility into pipeline execution.

---

## Infrastructure Setup

### EC2 Configuration

* AWS EC2 instance
* Operating system: Amazon Linux or Ubuntu
* Installed software:

  * Docker
  * Nginx

---

### Nginx Configuration

Reverse proxy configuration:

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://127.0.0.1:3000;
    }
}


This routes external traffic to the Node.js application running inside Docker.



## Project Structure


.
├── .github/workflows/
│   └── ci-cd.yml
├── app.js
├── package.json
├── Dockerfile
├── scripts/
│   └── deploy.sh
├── README.md


## Security Best Practices Implemented

* Secrets stored securely using GitHub Secrets
* No credentials stored in source code
* Dependency vulnerability scanning
* Container image scanning
* Principle of least privilege followed



## DevOps Best Practices Followed

* Automated CI/CD pipeline
* Immutable artifacts (Docker images)
* Fail-fast approach
* Health checks implemented
* Zero-downtime deployment strategy
* Version-controlled infrastructure and configuration


## How to Run Locally


npm install
npm start


Access the application:

http://localhost:3000

## End-to-End Pipeline Flow

1. Developer pushes code to repository
2. Pipeline is triggered automatically
3. Dependencies are installed
4. Tests and lint checks are executed
5. Security scan is performed
6. Docker image is built and pushed
7. Application is deployed to EC2
8. Traffic is routed through Nginx
9. Notification is sent

---

## Challenges Faced and Solutions

| Challenge                   | Solution                                         |
| --------------------------- | ------------------------------------------------ |
| ESLint configuration issues | Installed required dependencies and fixed config |
| YAML syntax errors          | Corrected indentation and structure              |
| Docker container conflicts  | Implemented container cleanup strategy           |
| Disk space issues           | Used Docker cleanup commands                     |
| Nginx configuration errors  | Fixed server block placement                     |







