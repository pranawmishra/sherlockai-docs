# Auto-Instrumentation

Zero-code setup for popular frameworks like FastAPI. Sherlock AI can automatically instrument your routes with monitoring decorators, similar to how Sentry works, providing comprehensive monitoring without modifying each endpoint.

## How It Works

When auto-instrumentation is enabled, Sherlock AI "monkey-patches" the framework's routing methods at startup. This means it automatically wraps your endpoint functions with monitoring decorators at runtime, without you needing to manually add decorators to each route.

**Automatically Applied Decorators:**
- `@log_performance` - Track execution times
- `@monitor_memory` - Monitor memory usage
- `@monitor_resources` - Track CPU, I/O, and network
- `@sherlock_error_handler` - AI-powered error analysis

## FastAPI Integration

### Basic Setup

```python
# main.py
from fastapi import FastAPI
from sherlock_ai import SherlockAI, LoggingConfig, get_logger

# 1. Initialize Sherlock AI with auto-instrumentation BEFORE creating the app
config = LoggingConfig(
    auto_instrument=True,  # Enable auto-instrumentation (default)
    log_format_type="json"  # Use JSON format for structured logging (default)
)
logging_manager = SherlockAI(config=config)
logging_manager.setup()

logger = get_logger(__name__)

# 2. Create your FastAPI app as usual
app = FastAPI()

# 3. Define routes WITHOUT any manual decorators
@app.get("/health")
def health_check():
    # This endpoint is now automatically monitored for:
    # - Performance
    # - Memory Usage
    # - Resource Consumption
    # - Error Insights
    logger.info("Health check endpoint was called.")
    return {"status": "healthy"}

@app.get("/error")
def trigger_error():
    # Errors in this endpoint will be captured automatically
    result = 1 / 0
    return {"result": result}

@app.post("/process")
async def process_data(data: dict):
    # Async endpoints are also automatically monitored
    logger.info(f"Processing data: {data}")
    result = await process_async(data)
    return {"result": result}
```

### Configuration Options

```python
from sherlock_ai import SherlockAI, LoggingConfig

# Full configuration
config = LoggingConfig(
    auto_instrument=True,           # Enable auto-instrumentation
    log_format_type="json",         # "json" or "log"
    logs_dir="application_logs",    # Custom log directory
    console_level="INFO"            # Console log level
)

logging_manager = SherlockAI(config=config)
logging_manager.setup()
```

### Disable Auto-Instrumentation

If you prefer manual decorator control:

```python
config = LoggingConfig(
    auto_instrument=False  # Disable auto-instrumentation
)
logging_manager = SherlockAI(config=config)
logging_manager.setup()

# Now manually add decorators
from sherlock_ai import log_performance

@app.get("/manual")
@log_performance
def manual_endpoint():
    return {"status": "ok"}
```

## What Gets Monitored

### Performance Metrics

Every endpoint automatically logs execution time:

```
PERFORMANCE | main.health_check | SUCCESS | 0.002s
PERFORMANCE | main.process_data | SUCCESS | 0.145s
PERFORMANCE | main.trigger_error | ERROR | 0.001s | division by zero
```

### Memory Usage

Memory consumption per request:

```
MEMORY | main.process_data | SUCCESS | 0.145s | Current: 95.67MB | Change: +2.34MB | Traced: 1.45MB (Peak: 1.89MB)
```

### Resource Consumption

CPU, I/O, and thread usage:

```
RESOURCES | main.process_data | SUCCESS | 0.145s | CPU: 15.2% | Memory: 95.67MB (+2.34MB) | Threads: 8 | I/O: R:1.23MB W:0.45MB
```

### Error Analysis

Automatic AI-powered error insights:

```json
{
  "function_name": "main.trigger_error",
  "error_type": "ZeroDivisionError",
  "error_message": "division by zero",
  "probable_cause": "Attempting division by zero on line 42...",
  "timestamp": "2025-01-01T12:34:56"
}
```

## Timing Requirements

**Important:** Initialize Sherlock AI BEFORE creating your FastAPI app:

```python
# ✅ CORRECT - Initialize before app creation
logging_manager = SherlockAI(config=config)
logging_manager.setup()
app = FastAPI()

# ❌ INCORRECT - Too late, routes already registered
app = FastAPI()
logging_manager = SherlockAI(config=config)
logging_manager.setup()
```

## Log Output Formats

### Standard Format

```
2025-01-01 12:34:56 - a1b2c3d4 - PerformanceLogger - INFO - PERFORMANCE | main.health_check | SUCCESS | 0.002s
```

### JSON Format (Recommended)

```json
{
  "timestamp": "2025-01-01 12:34:56",
  "level": "INFO",
  "logger": "PerformanceLogger",
  "message": "PERFORMANCE | main.health_check | SUCCESS | 0.002s",
  "request_id": "a1b2c3d4",
  "module": "main",
  "function": "health_check",
  "line": 42,
  "thread": 13672,
  "process": 22008
}
```

## Request ID Tracking

Auto-instrumentation integrates with request ID tracking:

```python
from sherlock_ai import set_request_id

@app.middleware("http")
async def add_request_id(request, call_next):
    # Set request ID for all monitoring
    request_id = request.headers.get("X-Request-ID", set_request_id())
    response = await call_next(request)
    response.headers["X-Request-ID"] = request_id
    return response

# All monitoring logs will include the request ID
```

## Selective Monitoring

### Exclude Specific Routes

If you need to exclude certain routes from monitoring:

```python
from fastapi import FastAPI
from sherlock_ai import SherlockAI, LoggingConfig

# Enable auto-instrumentation
config = LoggingConfig(auto_instrument=True)
logging_manager = SherlockAI(config=config)
logging_manager.setup()

app = FastAPI()

# This route is automatically monitored
@app.get("/monitored")
def monitored_endpoint():
    return {"status": "monitored"}

# To exclude a route, disable auto-instrumentation and use manual control
# (Currently all routes are monitored when auto_instrument=True)
```

## Production Deployment

### With Uvicorn

```python
# main.py
from fastapi import FastAPI
from sherlock_ai import SherlockAI, LoggingConfig, LoggingPresets
import os

# Use environment-specific presets
env = os.getenv("ENVIRONMENT", "development")

if env == "production":
    config = LoggingPresets.production()
    config.auto_instrument = True
else:
    config = LoggingPresets.development()
    config.auto_instrument = True

logging_manager = SherlockAI(config=config)
logging_manager.setup()

app = FastAPI()

# Define routes...

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=(env != "production")
    )
```

### With Docker

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Environment variables for monitoring
ENV ENVIRONMENT=production
ENV MONGO_URI=mongodb://mongo:27017
ENV SHERLOCK_AI_API_KEY=your-api-key

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Best Practices

### 1. Initialize Early

Always initialize before app creation:

```python
# Initialize Sherlock AI first
logging_manager = SherlockAI(config=config)
logging_manager.setup()

# Then create app
app = FastAPI()
```

### 2. Use JSON Format

JSON format is better for log aggregation:

```python
config = LoggingConfig(
    auto_instrument=True,
    log_format_type="json"  # Better for parsing and analysis
)
```

### 3. Configure Storage

Set up MongoDB or API client for error insights:

```python
import os

# Production configuration
os.environ["MONGO_URI"] = "mongodb://production-mongo:27017"
os.environ["SHERLOCK_AI_API_KEY"] = "production-api-key"

config = LoggingConfig(auto_instrument=True)
logging_manager = SherlockAI(config=config)
logging_manager.setup()
```

### 4. Add Request ID Middleware

Enable distributed tracing:

```python
from sherlock_ai import set_request_id

@app.middleware("http")
async def request_id_middleware(request, call_next):
    request_id = request.headers.get("X-Request-ID", set_request_id())
    response = await call_next(request)
    response.headers["X-Request-ID"] = request_id
    return response
```

## Use Cases

- **Microservices**: Monitor all endpoints without code changes
- **Rapid Development**: Get monitoring without adding decorators
- **Legacy APIs**: Add monitoring to existing FastAPI apps
- **Production Debugging**: Comprehensive monitoring in production
- **Performance Analysis**: Track performance across all endpoints
- **Error Tracking**: Automatic error analysis for all routes

## Comparison: Manual vs Auto-Instrumentation

### Manual Decorators

```python
from sherlock_ai import log_performance, monitor_memory
from sherlock_ai.monitoring import sherlock_error_handler

@app.get("/endpoint1")
@log_performance
@monitor_memory
@sherlock_error_handler
def endpoint1():
    pass

@app.get("/endpoint2")
@log_performance
@monitor_memory
@sherlock_error_handler
def endpoint2():
    pass

# Need to add decorators to EVERY endpoint
```

### Auto-Instrumentation

```python
from sherlock_ai import SherlockAI, LoggingConfig

# One-time setup
config = LoggingConfig(auto_instrument=True)
logging_manager = SherlockAI(config=config)
logging_manager.setup()

app = FastAPI()

# All endpoints automatically monitored
@app.get("/endpoint1")
def endpoint1():
    pass

@app.get("/endpoint2")
def endpoint2():
    pass
```

## Supported Frameworks

### Currently Supported

- **FastAPI** - Full support with automatic route instrumentation

### Coming Soon

- Flask
- Django
- Starlette
- Quart

## Troubleshooting

### Monitoring Not Working

If auto-instrumentation doesn't work:

1. Ensure Sherlock AI is initialized BEFORE app creation
2. Check that `auto_instrument=True` in config
3. Verify logs directory exists and is writable

### Duplicate Logs

If you see duplicate log entries:

1. Make sure you're not calling `sherlock_ai()` multiple times
2. Don't mix auto-instrumentation with manual decorators
3. Check for multiple initialization in dev reload

### Performance Impact

Auto-instrumentation adds minimal overhead:

- ~1-2ms per request for basic monitoring
- ~5-10ms per request with memory tracking
- Async operations have negligible impact

## Next Steps

- [FastAPI Setup Guide](../guides/fastapi-setup.md) - Detailed FastAPI integration
- [Configuration](../configuration/index.md) - Configure monitoring behavior
- [Examples](../examples/fastapi-integration.md) - Complete FastAPI examples
- [Production Deployment](../guides/production-deployment.md) - Deploy to production

