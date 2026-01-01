# Examples

Real-world examples and integration patterns for Sherlock AI. These examples demonstrate practical usage scenarios with complete, runnable code.

## Example Categories

### FastAPI Integration
Complete FastAPI application with auto-instrumentation and manual decorators.

[View example →](fastapi-integration.md)

### Async Functions
Monitor asynchronous functions and coroutines.

[View example →](async-functions.md)

### MongoDB Storage
Store error insights and performance data in MongoDB.

[View example →](mongodb-storage.md)

### API Client Integration
HTTP-based data ingestion to centralized backend.

[View example →](api-client.md)

### Combined Monitoring
Use multiple decorators together for comprehensive monitoring.

[View example →](combined-monitoring.md)

## Quick Examples

### Basic Monitoring

```python
from sherlock_ai import sherlock_ai, get_logger, log_performance

sherlock_ai()
logger = get_logger(__name__)

@log_performance
def process_data(data):
    logger.info(f"Processing {len(data)} items")
    result = sum(data)
    return result

result = process_data([1, 2, 3, 4, 5])
```

### Error Analysis

```python
from sherlock_ai.monitoring import sherlock_error_handler
import os

os.environ["MONGO_URI"] = "mongodb://localhost:27017"

@sherlock_error_handler
def risky_operation():
    result = 1 / 0  # AI analyzes this error
    return result
```

### Memory Monitoring

```python
from sherlock_ai import monitor_memory

@monitor_memory(trace_malloc=True)
def allocate_memory():
    data = [i * i for i in range(1000000)]
    return len(data)
```

## Complete Application Examples

Explore detailed, production-ready examples:

- **[FastAPI Integration](fastapi-integration.md)** - Full web application setup
- **[Async Functions](async-functions.md)** - Async/await patterns
- **[MongoDB Storage](mongodb-storage.md)** - Error insight storage
- **[API Client](api-client.md)** - Centralized monitoring
- **[Combined Monitoring](combined-monitoring.md)** - Multiple features together

## Next Steps

- [Features](../features/index.md) - Learn about available features
- [Configuration](../configuration/index.md) - Configure Sherlock AI

