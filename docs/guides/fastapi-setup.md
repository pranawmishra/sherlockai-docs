# FastAPI Setup Guide

Step-by-step guide for integrating Sherlock AI with FastAPI applications.

## Step 1: Install Sherlock AI

```bash
pip install sherlock-ai
```

## Step 2: Initialize Before App Creation

```python
# main.py
from fastapi import FastAPI
from sherlock_ai import SherlockAI, LoggingConfig, get_logger

# IMPORTANT: Initialize BEFORE creating app
config = LoggingConfig(
    auto_instrument=True,
    log_format_type="json"
)
logging_manager = SherlockAI(config=config)
logging_manager.setup()

logger = get_logger(__name__)

# Now create your app
app = FastAPI()
```

## Step 3: Add Request ID Middleware

```python
from fastapi import Request
from sherlock_ai import set_request_id

@app.middleware("http")
async def request_id_middleware(request: Request, call_next):
    request_id = request.headers.get("X-Request-ID", set_request_id())
    response = await call_next(request)
    response.headers["X-Request-ID"] = request_id
    return response
```

## Step 4: Define Your Routes

```python
@app.get("/")
def read_root():
    logger.info("Root endpoint accessed")
    return {"message": "Welcome"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
```

## Step 5: Run Your Application

```bash
uvicorn main:app --reload
```

## Development vs Production

```python
import os

env = os.getenv("ENVIRONMENT", "development")

if env == "production":
    from sherlock_ai import LoggingPresets
    config = LoggingPresets.production()
    config.auto_instrument = True
else:
    config = LoggingConfig(
        auto_instrument=True,
        console_level="DEBUG"
    )
```

## Testing the Setup

```python
# Test that monitoring works
import requests

response = requests.get("http://localhost:8000/health")
print(response.json())

# Check logs directory
# logs/application.json (or .log)
# logs/performance.json
# logs/errors.json
```

[See complete example →](../examples/fastapi-integration.md)

