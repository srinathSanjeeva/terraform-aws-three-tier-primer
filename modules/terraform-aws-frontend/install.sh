#!/bin/bash
#VM Startup Script
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo docker pull sanjeevas/backend-node-app:latest
sudo docker run -d -p 80:3000 sanjeevas/frontend-node-app:latest

