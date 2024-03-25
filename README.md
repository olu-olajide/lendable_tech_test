# Dockerized Nginx Website Deployment on AWS EC2

## Table of Contents

- [Project Overview](#project-overview)
- [Scenario](#scenario)
- [Problem Statement](#problem-statement)
- [Solution](#solution)
    - [Step 1: Verify Nginx Configuration](#step-1-verify-nginx-configuration)
    - [Step 2: Examine and Update the Dockerfile](#step-2-examine-and-update-the-dockerfile)
    - [Step 3: Building and Running the Docker Container](#step-3-building-and-running-the-docker-container)
    - [Step 4: Automate Deployment with Terraform](#step-4-automate-deployment-with-terraform)
- [Documentation and Commentary](#documentation-and-commentary)
- [Findings and Recommendations](#findings-and-recommendations)
- [Future Work](#future-work)
- [Quick Start](#quick-start)
- [Acknowledgments](#acknowledgments)

## Project Overview

This project automates the deployment of a Dockerized Nginx web server onto AWS EC2 instances using Terraform. It replaces a manual deployment process involving Apache HTTPD, aiming for increased efficiency and cost-effectiveness.

## Scenario

Our initial website setup on EC2 with Apache HTTPD required manual source updates and configurations—a time-consuming process. Seeking improvements, we transitioned to a Dockerized environment with Nginx.

## Problem Statement

Transitioning to Docker with Nginx, we encountered issues where containers exited unexpectedly, preventing the web server from staying up and serving the website content.

## Solution

### Step 1: Verify Nginx Configuration

Ensured the Nginx configuration was correct to serve our website content from the `/www` directory within the Docker container.

### Step 2: Examine and Update the Dockerfile

Adjusted the Dockerfile with the necessary changes for user permissions, correct ENTRYPOINT syntax, and included the website content within the Docker image.

### Step 3: Building and Running the Docker Container

Built the Docker image and ran it without volume mounting to simplify debugging, ensuring the website was correctly served.

### Step 4: Automate Deployment with Terraform

Developed Terraform scripts to provision EC2 instances and manage the deployment process across multiple servers.

## Documentation and Commentary

Detailed documentation and rationale behind each decision were maintained throughout the project, emphasizing the importance of process understanding alongside results.

## Findings and Recommendations

### Performance Optimization

- Employed multi-stage Docker builds and optimized Nginx configurations for better performance.

### Security Enhancements

- Implemented HTTPS in Nginx, restricted SSH access, and utilized AWS IAM roles and policies for enhanced security.

### Cost Management

- Explored auto-scaling and AWS Reserved/Spot Instances for cost-effective resource management.

### Scalability

- Suggested Elastic Load Balancers, Auto Scaling Groups, and container orchestration for scalability.

## Future Work

### CI/CD Pipeline Integration

- Aim to integrate CI/CD pipelines for automated deployments and explore blue-green deployment strategies.

### Monitoring and Logging

- Plan to set up CloudWatch for monitoring and establish centralized logging for improved diagnostics.

## Quick Start

To quickly start with this project:

    ```bash
    git clone https://github.com/olu-olajide/lendable_tech_test.git
    cd yourproject
    terraform init
    terraform apply

## Acknowledgments

Thanks to the open-source community for providing resources and documentation that supported the project's completion.
