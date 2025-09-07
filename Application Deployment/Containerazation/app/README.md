# Build image
docker build -t flask-rds-app .

# Run locally (replace env vars with your RDS values)
docker run -d -p 5000:5000 \
  -e DB_HOST=mydb.xxxxx.rds.amazonaws.com \
  -e DB_NAME=mydb \
  -e DB_USER=dbuser \
  -e DB_PASS=securepassword \
  flask-rds-app
