# FastAPI Integration

Complete FastAPI application example with Sherlock AI monitoring.

## Auto-Instrumentation Setup

```python
# main.py
from fastapi import FastAPI, HTTPException
from sherlock_ai import SherlockAI, LoggingConfig, get_logger
from pydantic import BaseModel
import os

# Initialize Sherlock AI BEFORE creating app
config = LoggingConfig(
    auto_instrument=True,
    log_format_type="json",
    logs_dir="api_logs"
)
logging_manager = SherlockAI(config=config)
logging_manager.setup()

logger = get_logger(__name__)

# Create FastAPI app
app = FastAPI(title="Sherlock AI Demo API")

class Item(BaseModel):
    name: str
    value: int

@app.get("/")
def read_root():
    logger.info("Root endpoint accessed")
    return {"message": "Welcome to Sherlock AI Demo"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.post("/items")
def create_item(item: Item):
    logger.info(f"Creating item: {item.name}")
    return {"item": item, "id": 123}

@app.get("/error")
def trigger_error():
    # This error will be automatically analyzed
    raise HTTPException(status_code=500, detail="Test error")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

## Manual Decorators Setup

```python
from fastapi import FastAPI
from sherlock_ai import sherlock_ai, get_logger, log_performance, monitor_memory

sherlock_ai()
logger = get_logger(__name__)

app = FastAPI()

@app.get("/monitored")
@log_performance
@monitor_memory
def monitored_endpoint():
    logger.info("Monitored endpoint called")
    return {"status": "ok"}
```

## Complete Production Example

```python
# app/main.py
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
from sherlock_ai import SherlockAI, LoggingConfig, LoggingPresets, get_logger, set_request_id
import os

# Environment-based configuration
env = os.getenv("ENVIRONMENT", "development")

if env == "production":
    config = LoggingPresets.production()
    config.auto_instrument = True
    config.log_format_type = "json"
else:
    config = LoggingPresets.development()
    config.auto_instrument = True

logging_manager = SherlockAI(config=config)
logging_manager.setup()

logger = get_logger(__name__)

app = FastAPI(title="Production API")

# Request ID middleware
@app.middleware("http")
async def request_id_middleware(request: Request, call_next):
    request_id = request.headers.get("X-Request-ID", set_request_id())
    response = await call_next(request)
    response.headers["X-Request-ID"] = request_id
    return response

# Exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception: {exc}")
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"}
    )

@app.get("/")
def read_root():
    return {"message": "API is running"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=(env != "production")
    )
```

Run with: `python -m app.main`

