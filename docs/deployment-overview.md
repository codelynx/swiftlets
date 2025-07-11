# Swiftlets Deployment Overview

This document provides a comprehensive overview of all deployment options for Swiftlets applications.

## Deployment Methods Comparison

| Method | Setup Time | Scalability | Cost | Maintenance | Best For |
|--------|------------|-------------|------|-------------|----------|
| **Container** | Medium | Excellent | Variable | Low | Modern cloud platforms, Kubernetes |
| **EC2** | High | Manual | Predictable | Medium | Traditional hosting, full control |
| **Lambda** | Low | Automatic | Pay-per-use | Very Low | Low-traffic, serverless |

## 1. Container Deployment (Recommended)

### Overview
Uses Docker to create optimized containers for Swiftlets applications.

### Approaches
1. **Optimized Docker Build** (Recommended)
   - Multi-stage builds for smaller images
   - Swift slim runtime (433MB vs 500MB+)
   - Production-ready with all dependencies
   
2. **Full Docker Build**
   - Complete Swift development image
   - Includes build tools
   - Better for development environments

### Quick Start
```bash
# Build optimized container
./deploy/docker/build-optimized-container.sh swiftlets-site

# Run locally
docker run -p 8080:8080 swiftlets-optimized:latest

# Deploy to EC2
docker save swiftlets-optimized:latest | gzip > swiftlets.tar.gz
scp swiftlets.tar.gz ubuntu@ec2-host:~/
```

### Deployment Targets
- ✅ Kubernetes (EKS, GKE, AKS)
- ✅ Docker Swarm
- ✅ AWS ECS/Fargate
- ✅ Google Cloud Run
- ✅ Azure Container Instances
- ✅ Any Docker host

## 2. EC2 Direct Deployment

### Overview
Traditional deployment to AWS EC2 instances with systemd service management.

### Components
- Ubuntu 22.04 LTS base
- Swift runtime installation
- Nginx reverse proxy
- systemd service management
- Automated deployment scripts

### Quick Start
```bash
# On EC2 instance
./deploy/ec2/setup-instance.sh

# From local machine
./deploy/ec2/deploy.sh ec2-host sites/my-site
```

### Features
- ✅ Zero-downtime deployments
- ✅ Automatic backups
- ✅ Service monitoring
- ✅ Log rotation
- ✅ SSL/TLS support

## 3. AWS Lambda Deployment (Experimental)

### Overview
Serverless deployment using AWS Lambda with custom Swift runtime.

### Architecture
- Lambda adapter wraps Swiftlets
- API Gateway for HTTP routing
- Pay-per-request pricing
- Automatic scaling

### Quick Start
```bash
# Build Lambda package
./deploy/lambda/build-lambda.sh swiftlets-site

# Deploy with SAM
cd deploy/lambda/build
./deploy.sh my-stack us-east-1
```

### Considerations
- ⚠️ Cold start latency
- ⚠️ 15-minute execution limit
- ⚠️ Experimental status

## Choosing a Deployment Method

### Use Containers When:
- You need consistent deployments across environments
- You're using Kubernetes or container orchestration
- You want easy horizontal scaling
- You need multi-cloud portability

### Use EC2 When:
- You need full control over the environment
- You have existing EC2 infrastructure
- You need persistent storage
- You want predictable monthly costs

### Use Lambda When:
- You have variable or low traffic
- You want zero infrastructure management
- You need automatic scaling
- Cost optimization is critical

## Security Best Practices

### All Deployments
- Use environment variables for secrets
- Enable HTTPS/TLS
- Regular security updates
- Implement proper logging

### Container-Specific
- Run as non-root user
- Use minimal base images
- Scan for vulnerabilities
- Sign container images

### EC2-Specific
- Configure security groups
- Use IAM roles
- Enable auto-updates
- Implement fail2ban

### Lambda-Specific
- Least-privilege IAM policies
- VPC configuration if needed
- Environment encryption

## Monitoring and Observability

### Metrics to Track
- Request latency
- Error rates
- CPU/Memory usage
- Active connections

### Recommended Tools
- **Container**: Prometheus + Grafana
- **EC2**: CloudWatch + Custom Metrics
- **Lambda**: CloudWatch Logs + X-Ray

## CI/CD Integration

### GitHub Actions
```yaml
# Example workflow
name: Deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build and Deploy
        run: |
          ./deploy/container/build-full-container.sh
          ./deploy/container/push-to-registry.sh
```

### GitLab CI/CD
```yaml
# .gitlab-ci.yml
deploy:
  stage: deploy
  script:
    - ./deploy/container/build-full-container.sh
    - ./deploy/container/push-to-registry.sh
```

## Cost Estimation

### Container (ECS Fargate)
- vCPU: $0.04/hour
- Memory: $0.004/GB/hour
- Example: 0.5 vCPU + 1GB = ~$30/month

### EC2 (t3.small)
- On-demand: ~$15/month
- Reserved: ~$10/month
- Plus bandwidth costs

### Lambda
- Requests: $0.20/million
- Duration: $0.0000166667/GB-second
- Free tier: 1M requests/month

## Migration Between Methods

### From EC2 to Container
1. Build container from existing site
2. Test locally
3. Deploy to container platform
4. Update DNS

### From Container to Lambda
1. Build Lambda adapter
2. Package with SAM
3. Deploy to Lambda
4. Configure API Gateway

## Support and Resources

- [Docker Deployment Guide](./container-deployment.md)
- [EC2 Deployment Guide](./aws-ec2-deployment.md)
- [Docker Deployment Summary](./DOCKER-DEPLOYMENT-SUMMARY.md)
- [Deploy Directory](../deploy/) - All deployment scripts
- [GitHub Issues](https://github.com/codelynx/swiftlets/issues) - Community support