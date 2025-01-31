public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}



FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app
COPY src /app/src
COPY pom.xml /app
RUN mvn clean package


FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/helloworld.jar /app/helloworld.jar
CMD ["java", "-jar", "helloworld.jar"]


version: '3.8'
services:
  hello-world:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: hello-world-container
    ports:
      - "8080:8080" 


my-java-app/
├── src/
│   └── HelloWorld.java
├── pom.xml
├── Dockerfile
└── docker-compose.yml


cd my-java-app

docker-compose up --build


git init
git add .
git commit -m "Initial commit: Java Hello World with Docker"
git branch -M main
git remote add origin https://github.com/your-username/your-repo-name.git
git push -u origin main


1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/your-repo-name.git


cd your-repo-name
docker-compose up --build


---





