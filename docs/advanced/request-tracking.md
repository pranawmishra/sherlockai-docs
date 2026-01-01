# Request Tracking

Track requests across distributed systems with request IDs.

## Setting Request IDs

```python
from sherlock_ai import set_request_id, get_request_id

# Auto-generate request ID
request_id = set_request_id()  # Returns: "a1b2c3d4"

# Custom request ID
request_id = set_request_id("req-12345")

# Get current request ID
current_id = get_request_id()
```

## FastAPI Integration

```python
from fastapi import FastAPI, Request
from sherlock_ai import SherlockAI, LoggingConfig, set_request_id

config = LoggingConfig(auto_instrument=True)
logger_manager = SherlockAI(config=config)
logger_manager.setup()

app = FastAPI()

@app.middleware("http")
async def request_id_middleware(request: Request, call_next):
    # Get from header or generate
    request_id = request.headers.get("X-Request-ID", set_request_id())
    
    response = await call_next(request)
    
    # Return in response header
    response.headers["X-Request-ID"] = request_id
    return response
```

## Log Output with Request ID

All logs include the request ID:

```
2025-01-01 12:34:56 - a1b2c3d4 - ApiLogger - INFO - Request started
2025-01-01 12:34:56 - a1b2c3d4 - PerformanceLogger - INFO - PERFORMANCE | api_call | SUCCESS | 0.234s
```

## Distributed Tracing

Pass request IDs between services:

```python
import httpx

def call_downstream_service():
    request_id = get_request_id()
    
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://downstream-service.com/api",
            headers={"X-Request-ID": request_id}
        )
    
    return response.json()
```

