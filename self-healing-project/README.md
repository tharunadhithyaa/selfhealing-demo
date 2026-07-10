# 🚀 Intelligent Self-Healing CI/CD Platform

> **A beginner-friendly DevOps demonstration project for BCA Final Year**

Automated CI/CD pipeline with Docker containerization and a self-healing monitoring script that automatically recovers crashed containers.

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture Diagram](#-architecture-diagram)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Git Commands](#-git-commands)
- [Docker Commands](#-docker-commands)
- [Running Jenkins](#-running-jenkins)
- [Running the Self-Healing Script](#-running-the-self-healing-script)
- [Testing the Project (Demo Flow)](#-testing-the-project-demo-flow)
- [Expected Output](#-expected-output)
- [Project Structure](#-project-structure)
- [Future Enhancements](#-future-enhancements)

---

## 🎯 Project Overview

This project demonstrates core DevOps concepts through a practical, easy-to-understand implementation:

| Concept | Tool | Purpose |
|---------|------|---------|
| **Version Control** | Git & GitHub | Track code changes |
| **CI/CD Pipeline** | Jenkins | Automate build & deploy |
| **Containerization** | Docker | Package the application |
| **Web Server** | nginx | Serve the website |
| **Self-Healing** | Bash Script | Auto-recover crashed containers |

### How It Works

1. **Developer** writes code and pushes to GitHub
2. **Jenkins** detects the push and runs the pipeline
3. **Docker** builds an image and runs a container
4. **nginx** serves the website on port 80
5. **heal.sh** continuously monitors and restarts the container if it crashes

---

## 🏗 Architecture Diagram

```
┌─────────────┐
│  Developer   │
│  (You!)      │
└──────┬──────┘
       │  git push
       ▼
┌─────────────┐
│    GitHub    │
│  (Remote)    │
└──────┬──────┘
       │  webhook trigger
       ▼
┌─────────────┐
│   Jenkins    │
│  (CI/CD)     │
└──────┬──────┘
       │  docker build & run
       ▼
┌─────────────┐       ┌─────────────────┐
│   Docker     │◄──────│  heal.sh         │
│  Container   │       │  (Self-Healing)  │
│  (nginx)     │       │  Monitors every  │
│              │       │  10 seconds      │
└──────┬──────┘       └─────────────────┘
       │
       ▼
┌─────────────┐
│   Website   │
│  Port 80    │
└─────────────┘
```

---

## 📦 Prerequisites

Before starting, make sure you have these installed:

| Software | Version | Check Command |
|----------|---------|--------------|
| **Git** | 2.x+ | `git --version` |
| **Docker** | 20.x+ | `docker --version` |
| **Jenkins** | 2.x+ | Open `http://localhost:8080` |

### Installing Docker (Ubuntu/Linux)

```bash
# Update packages
sudo apt update

# Install Docker
sudo apt install docker.io -y

# Start Docker service
sudo systemctl start docker

# Add your user to the docker group (avoids using sudo)
sudo usermod -aG docker $USER

# Log out and log back in for the group change to take effect
```

### Installing Jenkins (Ubuntu/Linux)

```bash
# Install Java (Jenkins requires Java)
sudo apt install openjdk-17-jdk -y

# Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repository
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
```

---

## 🛠 Installation & Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/self-healing-project.git
cd self-healing-project
```

### Step 2: Build the Docker Image

```bash
docker build -t mywebsite .
```

### Step 3: Run the Container

```bash
docker run -d -p 80:80 --name mywebsite mywebsite
```

### Step 4: Open the Website

Open your browser and visit:

```
http://localhost
```

---

## 📝 Git Commands

Here are the Git commands you'll use throughout this project:

```bash
# Initialize a new Git repository (first time only)
git init

# Add all files to staging
git add .

# Commit with a message
git commit -m "Initial commit: DevOps demo project"

# Add your GitHub repository as remote (first time only)
git remote add origin https://github.com/YOUR_USERNAME/self-healing-project.git

# Push code to GitHub
git push -u origin main

# After making changes, repeat:
git add .
git commit -m "Updated website content"
git push
```

---

## 🐳 Docker Commands

### Essential Commands

```bash
# Build the Docker image
docker build -t mywebsite .

# Run a container from the image
docker run -d -p 80:80 --name mywebsite mywebsite

# Check running containers
docker ps

# Check ALL containers (including stopped)
docker ps -a

# Stop the container
docker stop mywebsite

# Start a stopped container
docker start mywebsite

# Remove the container
docker rm mywebsite

# Remove the image
docker rmi mywebsite

# View container logs
docker logs mywebsite
```

### Quick Rebuild & Redeploy

```bash
# Stop, remove, rebuild, and run in one sequence
docker stop mywebsite || true
docker rm mywebsite || true
docker build -t mywebsite .
docker run -d -p 80:80 --name mywebsite mywebsite
```

---

## ⚙ Running Jenkins

### Step 1: Access Jenkins

Open your browser and go to:

```
http://localhost:8080
```

### Step 2: Get the Initial Admin Password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 3: Create a Pipeline Job

1. Click **"New Item"**
2. Enter a name: `self-healing-pipeline`
3. Select **"Pipeline"**
4. Click **"OK"**

### Step 4: Configure the Pipeline

1. Scroll to the **"Pipeline"** section
2. Change **Definition** to: `Pipeline script from SCM`
3. Select **SCM**: `Git`
4. Enter your **Repository URL**: `https://github.com/YOUR_USERNAME/self-healing-project.git`
5. Set **Branch**: `*/main`
6. **Script Path**: `Jenkinsfile`
7. Click **"Save"**

### Step 5: Run the Pipeline

Click **"Build Now"** to trigger the pipeline manually.

For automatic triggers, configure a **GitHub Webhook**:
- In GitHub → Repository → Settings → Webhooks
- Payload URL: `http://YOUR_JENKINS_IP:8080/github-webhook/`
- Content type: `application/json`

---

## 🛡 Running the Self-Healing Script

### Start the Script

```bash
# Make it executable (first time only)
chmod +x heal.sh

# Run the self-healing monitor
bash heal.sh
```

### What You'll See

```
2026-07-10 10:30:00 [INFO] ============================================
2026-07-10 10:30:00 [INFO] Self-Healing Monitor Started
2026-07-10 10:30:00 [INFO] Container: mywebsite
2026-07-10 10:30:00 [INFO] Check Interval: 10s
2026-07-10 10:30:00 [INFO] ============================================
2026-07-10 10:30:00 [INFO] Checking container...
2026-07-10 10:30:00 [INFO] Container is healthy.
```

### Stop the Script

Press `Ctrl + C`

---

## 🧪 Testing the Project (Demo Flow)

This is the recommended sequence for your project demonstration:

### Demo Step 1: Show the Website

```bash
# Build and run
docker build -t mywebsite .
docker run -d -p 80:80 --name mywebsite mywebsite

# Open http://localhost in a browser
```

### Demo Step 2: Start the Self-Healing Script

Open a **second terminal**:

```bash
bash heal.sh
```

You should see:
```
[INFO] Container is healthy.
```

### Demo Step 3: Simulate a Crash

In a **third terminal**, stop the container:

```bash
docker stop mywebsite
```

### Demo Step 4: Watch the Recovery

Back in the second terminal (where heal.sh is running), you'll see:

```
[WARNING] Container stopped.
[WARNING] Attempting to restart container...
[SUCCESS] Container recovered successfully.
```

### Demo Step 5: Verify

Refresh `http://localhost` — the website is back online!

### Demo Step 6: Simulate a Deletion (Advanced)

```bash
# Completely remove the container
docker stop mywebsite
docker rm mywebsite
```

The script will detect this and create a brand new container:

```
[WARNING] Container does not exist. Creating new container...
[SUCCESS] Container recovered successfully.
```

---

## 📊 Expected Output

### Jenkins Pipeline Output

```
Stage 1: Checking out code...        ✅
Stage 2: Building Docker image...    ✅
Stage 3: Stopping old container...   ✅
Stage 4: Removing old container...   ✅
Stage 5: Starting new container...   ✅
DEPLOYMENT SUCCESSFUL!
```

### Self-Healing Script Output

```
2026-07-10 10:30:00 [INFO] Checking container...
2026-07-10 10:30:00 [INFO] Container is healthy.
2026-07-10 10:30:10 [INFO] Checking container...
2026-07-10 10:30:10 [WARNING] Container stopped.
2026-07-10 10:30:10 [WARNING] Attempting to restart container...
2026-07-10 10:30:11 [SUCCESS] Container recovered successfully.
2026-07-10 10:30:21 [INFO] Checking container...
2026-07-10 10:30:21 [INFO] Container is healthy.
```

---

## 📁 Project Structure

```
self-healing-project/
│
├── index.html       # Main website page
├── style.css        # Styling for the website
├── script.js        # Minimal JavaScript (deployment time display)
├── Dockerfile       # Docker image configuration
├── Jenkinsfile      # Jenkins CI/CD pipeline definition
├── heal.sh          # Self-healing monitoring script
└── README.md        # Project documentation (this file)
```

| File | Purpose | Technology |
|------|---------|-----------|
| `index.html` | Website structure & content | HTML5 |
| `style.css` | Visual design & responsiveness | CSS3 |
| `script.js` | Deployment time display | JavaScript |
| `Dockerfile` | Container image definition | Docker |
| `Jenkinsfile` | CI/CD pipeline stages | Jenkins |
| `heal.sh` | Container monitoring & recovery | Bash |
| `README.md` | Project documentation | Markdown |

---

## 🚀 Future Enhancements

These are improvements that can be added in future versions:

| Enhancement | Description |
|-------------|-------------|
| **Prometheus** | Add metrics collection for container health |
| **Grafana** | Create visual dashboards for monitoring |
| **Alertmanager** | Send email/SMS alerts on failures |
| **Slack Notifications** | Notify team on deployment success/failure |
| **Docker Compose** | Manage multi-container setups |
| **Kubernetes** | Orchestrate containers at scale |
| **HTTPS/SSL** | Add secure HTTPS with Let's Encrypt |
| **Health Endpoint** | Add an HTTP health check endpoint |
| **Log Rotation** | Rotate log files to prevent disk usage |
| **Multi-Environment** | Deploy to staging before production |

---

## 📄 License

This project is created for educational purposes as part of a BCA Final Year project.

---

> **Built with ❤️ using HTML, CSS, Docker, Jenkins & Bash**
