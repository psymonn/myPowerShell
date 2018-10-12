http://localhost:8080/me/configure

curl -user admin:eb4fa00a67267495c9d747d6c7524b88  http://localhost:8080/api/json?pretty=true
curl -user admin:eb4fa00a67267495c9d747d6c7524b88  "http://localhost:8080/api/json?pretty=true&tree=jobs[name,color]"
curl -user admin:eb4fa00a67267495c9d747d6c7524b88  "http://localhost:8080/api/json?pretty=true&tree=jobs[name,color]{1}"

download:
curl -user "admin:eb4fa00a67267495c9d747d6c7524b88"  "http://localhost:8080/job/Project Template Generate pipeline/config.xml" -o config.xml
curl -user "admin:eb4fa00a67267495c9d747d6c7524b88" "http://localhost:8080/job/WebSite/api/json/config.xml" -o config.xml
upload:
curl -X POST -user "admin:eb4fa00a67267495c9d747d6c7524b88"  "http://localhost:8080/job/Project Template Generate pipeline/config.xml" -d "@config.xml"

http://localhost:8080/api/xml?tree=jobs[Project%20Template%20Generate%20pipeline]{0,10}


http://localhost:8080/job/Project%20Template%20Generate%20pipeline/api/json?pretty=true

invoke-restmethod -uri http://localhost:8080/api/json?pretty=true

Invoke-WebRequest -uri http://localhost:8080/api/json?pretty=true


