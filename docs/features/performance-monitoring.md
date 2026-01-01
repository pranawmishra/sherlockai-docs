# Performance Monitoring

Track execution times of functions and code blocks with minimal overhead. The `@log_performance` decorator and `PerformanceTimer` context manager make it easy to identify slow operations and optimize your code.

## Decorator Usage

### Basic Example

```python
from sherlock_ai import log_performance, get_logger

logger = get_logger(__name__)

@log_performance
def process_data():
    # Your code here
    data = fetch_from_database()
    result = transform_data(data)
    return result

# Logs: PERFORMANCE | my_module.process_data | SUCCESS | 0.234s
```

### With Parameters

Configure the decorator for specific needs:

```python
@log_performance(min_duration=0.1, include_args=True, log_level="DEBUG")
def slow_database_query(user_id, limit=10):
    # Only logs if execution time >= 0.1 seconds
    # Includes function arguments in the log
    query = f"SELECT * FROM users WHERE id={user_id} LIMIT {limit}"
    return execute_query(query)

# Logs: PERFORMANCE | my_module.slow_database_query | SUCCESS | 0.156s | Args: ('user123',) | Kwargs: {'limit': 10}
```

### Async Functions

Works seamlessly with async/await:

```python
import httpx

@log_performance
async def async_api_call():
    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.example.com/data")
        return response.json()

# Usage
result = await async_api_call()
# Logs: PERFORMANCE | my_module.async_api_call | SUCCESS | 0.523s
```

## Context Manager

Monitor specific code blocks without decorating entire functions:

```python
from sherlock_ai.performance import PerformanceTimer

def complex_operation():
    # Some initialization
    config = load_config()
    
    # Monitor only this block
    with PerformanceTimer("database_operation"):
        connection = database.connect()
        result = connection.execute("SELECT * FROM large_table")
        connection.close()
    
    # More processing
    return process_result(result)

# Logs: PERFORMANCE | database_operation | SUCCESS | 0.234s
```

### With Minimum Duration

Only log if execution exceeds a threshold:

```python
with PerformanceTimer("cache_check", min_duration=0.01):
    # Only logs if this takes more than 10ms
    value = cache.get(key)
```

## Manual Time Logging

For more control, use the low-level API:

```python
from sherlock_ai.performance import log_execution_time
import time

def custom_operation():
    start_time = time.time()
    try:
        # Your code here
        result = complex_calculation()
        log_execution_time("complex_calculation", start_time, success=True)
        return result
    except Exception as e:
        log_execution_time("complex_calculation", start_time, success=False, error=str(e))
        raise
```

## Parameters

### `@log_performance` Decorator

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `min_duration` | float | 0.0 | Only log if execution time >= this value in seconds |
| `include_args` | bool | False | Include function arguments in the log |
| `log_level` | str | "INFO" | Log level to use (INFO, DEBUG, WARNING, etc.) |

### `PerformanceTimer` Context Manager

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | str | Required | Name identifier for the operation |
| `min_duration` | float | 0.0 | Only log if execution time >= this value in seconds |

### `log_execution_time` Function

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | str | Required | Name identifier for the operation |
| `start_time` | float | Required | Start time from `time.time()` |
| `success` | bool | True | Whether the operation succeeded |
| `error` | str | None | Error message if operation failed |

## Log Output Format

Performance logs follow this format:

```
{timestamp} - {request_id} - PerformanceLogger - {level} - PERFORMANCE | {function_name} | {STATUS} | {execution_time}s | {additional_info}
```

### Examples

```
2025-07-05 19:19:11 - 07ca74ed - PerformanceLogger - INFO - PERFORMANCE | tests.test_fastapi.health_check | SUCCESS | 0.262s

2025-07-05 21:13:03 - 2c4774b0 - PerformanceLogger - INFO - PERFORMANCE | my_module.api_call | ERROR | 2.456s | Connection timeout

2025-07-05 19:20:15 - - - PerformanceLogger - INFO - PERFORMANCE | database_query | SUCCESS | 0.089s | Args: ('user123',) | Kwargs: {'limit': 10}
```

## Best Practices

### 1. Use Minimum Duration for Frequent Operations

For functions called frequently, set a minimum duration to avoid log noise:

```python
@log_performance(min_duration=0.05)  # Only log if > 50ms
def cache_lookup(key):
    return cache.get(key)
```

### 2. Include Arguments for Debugging

Enable `include_args` when you need to correlate performance with input:

```python
@log_performance(include_args=True)
def process_user_request(user_id, action):
    # If this is slow, you'll know which user and action
    return perform_action(user_id, action)
```

### 3. Use Context Managers for Partial Monitoring

When you only want to monitor part of a function:

```python
def full_operation():
    setup()  # Don't monitor this
    
    with PerformanceTimer("critical_section"):
        # Only monitor this expensive part
        result = expensive_operation()
    
    cleanup()  # Don't monitor this
    return result
```

### 4. Combine with Other Decorators

Stack with memory and resource monitoring for comprehensive insights:

```python
from sherlock_ai import log_performance, monitor_memory, monitor_resources

@log_performance
@monitor_memory
@monitor_resources(include_io=True)
def comprehensive_monitoring():
    # Full monitoring of this function
    return process_large_dataset()
```

## Use Cases

- **API Endpoint Monitoring**: Track response times for all API endpoints
- **Database Query Optimization**: Identify slow queries
- **Algorithm Benchmarking**: Compare performance of different implementations
- **Microservices**: Track execution times across service boundaries
- **Batch Processing**: Monitor job execution times
- **Cache Performance**: Measure cache hit/miss latencies

## Next Steps

- [Memory Monitoring](memory-monitoring.md) - Track memory usage alongside performance
- [Resource Monitoring](resource-monitoring.md) - Monitor CPU, I/O, and network
- [Configuration](../configuration/index.md) - Customize log output and rotation
- [Examples](../examples/index.md) - See real-world integration examples

