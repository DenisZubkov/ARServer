# ARServer

Example of ARServer with Swift 5 and MySQL 8

* Start MySQL Server in Docker
  ```bash
  docker run --name MySQL -e MYSQL_ROOT_PASSWORD='...' -e MYSQL_ROOT_HOST=% -d -p 3306:3306 -p 33060:33060 mysql
  docker exec -it MySQL mysql -uroot -p
  create database ardb;
  create user aruser@'%' identified by 'arpassword';
  grant all privileges on ardb.* to aruser@'%';
  flush privileges;
  quit
  ```
  
* Run ARServer in Docker from Swift image
  ```bash
  docker run -p 8088:8088 -it --name ARServer -w/ARServer swift bash
  git clone https://github.com/DenisZubkov/ARServer.git .
  cat Sources/Application/Routes/ORMRoutes.swift | sed s/78.47.113.172/YOUR-MYSQL-SERVER-IP/ > ORMRoutes.swift.temp
  rm Sources/Application/Routes/ORMRoutes.swift && mv ORMRoutes.swift.temp Sources/Application/Routes/ORMRoutes.swift
  apt update && apt -y upgrade
  apt -y install openssl libssl-dev libmysqlclient-dev libcurl4-openssl-dev
  swift build -c release
  exit
  ```
  
* Create arserver image
  ```bash
  docker commit ARServer arserver
  docker rm ARServer
  ```
  
* Run new ARServer in Docker from arserver image
  ```bash
  docker run --name ARServer -p8088:8088 -d -w/ARServer arserver swift run -c release
  ```
  
* Create new user
  ```bash
  curl -X POST \
      localhost:8080/user \
      -H 'content-type: application/json' \
      -d '{
        "username": "John Smith",
        "password": "johnsmith5",
        "salt": ""
    }'
  ```
  
  * Get all users: http://localhost:8080/user
  
* Create new object
  ```bash
  curl -X POST \
      localhost:8080/object \
      -H 'content-type: application/json' \
      -d '{
        "user": "John Smith",
        "url": "https://apple.com",
        "date": 105285600
    }'
  ```
  
  * Get all objects: http://localhost:8080/object
