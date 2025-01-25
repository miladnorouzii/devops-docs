DIND stands for "Docker-in-Docker," which refers to running a Docker daemon inside a Docker container. 
This setup is often used in CI/CD pipelines, development environments, or testing scenarios where you 
need to build, run, or manage Docker containers from within a containerized environment.




Example:

docker run --privileged --name dind-container -d docker:dind

docker exec -it dind-container docker ps

image: docker:latest

services:
  - docker:dind

script:
  - docker build -t my-image .
  - docker run my-image
