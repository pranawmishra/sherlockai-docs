# Production Deployment

Best practices for deploying Sherlock AI in production environments.

## Configuration

Use production preset with customizations:

```python
from sherlock_ai import SherlockAI, LoggingPresets
import os

config = LoggingPresets.production()
config.auto_instrument = True
config.log_format_type = "json"  # JSON for log aggregation
config.logs_dir = "/var/log/myapp"

# Add MongoDB for error insights
os.environ["MONGO_URI"] = os.getenv("MONGO_URI")
os.environ["SHERLOCK_AI_API_KEY"] = os.getenv("SHERLOCK_AI_API_KEY")

logger_manager = SherlockAI(config=config)
logger_manager.setup()
```

## Docker Setup

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Create logs directory
RUN mkdir -p /var/log/myapp

# Environment variables
ENV ENVIRONMENT=production
ENV MONGO_URI=mongodb://mongo:27017
ENV SHERLOCK_AI_API_KEY=your-api-key

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Docker Compose

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - ENVIRONMENT=production
      - MONGO_URI=mongodb://mongo:27017
      - SHERLOCK_AI_API_KEY=${SHERLOCK_AI_API_KEY}
    volumes:
      - ./logs:/var/log/myapp
    depends_on:
      - mongo
  
  mongo:
    image: mongo:latest
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db

volumes:
  mongodb_data:
```

## Log Rotation

Configure appropriate rotation for production:

```python
from sherlock_ai import LoggingConfig, LogFileConfig

config = LoggingConfig(
    logs_dir="/var/log/myapp",
    log_format_type="json",
    log_files={
        "app": LogFileConfig(
            "application",
            max_bytes=100*1024*1024,  # 100MB
            backup_count=20           # 2GB total
        ),
        "errors": LogFileConfig(
            "errors",
            level="ERROR",
            max_bytes=50*1024*1024,
            backup_count=30
        )
    }
)
```

## Monitoring

Monitor log file sizes:

```bash
# Add to cron or monitoring script
du -sh /var/log/myapp/*
```

## Environment Variables

```bash
# .env for production
ENVIRONMENT=production
LOG_DIR=/var/log/myapp
LOG_LEVEL=INFO
MONGO_URI=mongodb://production-mongo:27017
SHERLOCK_AI_API_KEY=production-api-key
```

## Health Checks

```python
from sherlock_ai import get_logging_stats

@app.get("/health/logging")
def logging_health():
    stats = get_logging_stats()
    return {
        "configured": stats["is_configured"],
        "handlers": stats["handlers"],
        "logs_dir": stats["logs_dir"]
    }
```

