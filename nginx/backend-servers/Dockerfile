FROM python:3.9-alpine

WORKDIR /app

# Instalar curl para health checks
RUN apk add --no-cache curl

COPY *.py ./

EXPOSE 8001 8002 8003

CMD ["python", "slow-app.py", "8001"]