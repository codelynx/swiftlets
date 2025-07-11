# Docker Deployment Summary

Date: January 11, 2025

## Deployment Status: ✅ SUCCESS

The optimized Docker container has been successfully deployed to your EC2 instance.

## Deployment Details

- **Container**: `swiftlets-static:latest` (433MB)
- **Running on**: Port 8081 (internally 8080)
- **Nginx proxy**: Port 8080 → Port 8081
- **Docker status**: Running with auto-restart enabled

## Access Information

### Internal (from EC2):
```bash
curl http://localhost:8080/
```
✅ Working

### External Access:
- **URL**: http://ec2-3-92-76-113.compute-1.amazonaws.com:8080/
- **Status**: May require AWS Security Group update to allow port 8080

## What Was Done

1. **Built optimized container** using Swift slim runtime (13% smaller)
2. **Transferred to EC2** (136MB compressed)
3. **Installed Docker** on EC2 instance
4. **Cleaned up disk space** (removed old deployments)
5. **Deployed container** with auto-restart
6. **Container is running** behind nginx proxy

## Container Management

### View logs:
```bash
ssh -i ~/.ssh/kyoshikawa-ec2-dev.pem ubuntu@ec2-3-92-76-113.compute-1.amazonaws.com \
  "sudo docker logs swiftlets"
```

### Restart container:
```bash
ssh -i ~/.ssh/kyoshikawa-ec2-dev.pem ubuntu@ec2-3-92-76-113.compute-1.amazonaws.com \
  "sudo docker restart swiftlets"
```

### Update deployment:
1. Build new image locally
2. Save and transfer: `docker save swiftlets-static | gzip > update.tar.gz`
3. Load on EC2: `sudo docker load < update.tar.gz`
4. Restart: `sudo docker restart swiftlets`

## Next Steps

To enable external access on port 8080:
1. Go to AWS EC2 Console
2. Find your instance's Security Group
3. Add inbound rule: Custom TCP, Port 8080, Source 0.0.0.0/0
4. Save rules

The site should then be accessible at:
http://ec2-3-92-76-113.compute-1.amazonaws.com:8080/