This application creates a secure web application using NGINX and Flask.
- The Flask website has 2 endpoints, / and /health.
- NGINX is the reverse proxy for the website.

This application features security hardening as a beyond-lecture capability. It protects against attacks like clickjacking and MIME type spoofing.

Deployment Commands:
terraform init
terraform validate
terraform plan
terrform apply

Test Commands:
docker network inspect app-net					(Verify docker network)
curl http://localhost:8080/health				(Verify /health endpoint)
curl http://localhost:8080/					(Verify / endpoint)
docker exec nginx-proxy wget -qO- http://flask-app:5000/health	(Verify connection between NGINX and Flask)
curl http://localhost:5000/					(Verify Flask port privacy, test should fail)
curl -I http://localhost:8080					(Verify security header)
