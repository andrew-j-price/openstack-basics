#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io cgroup-lite
sudo docker run -d -p 80:5000 -p 5000:5000 --restart=always andrewprice/flask:v2
