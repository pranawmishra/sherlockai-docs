# Resource Monitoring

Monitor comprehensive system resources including CPU, memory, I/O, and network usage during function execution. The `@monitor_resources` decorator and `ResourceTracker` context manager provide complete visibility into your application's resource consumption.

## Decorator Usage

### Basic Example

```python
from sherlock_ai import monitor_resources

@monitor_resources
def resource_intensive_function():
    # Monitors CPU, memory, and threads
    result = sum(i * i for i in range(1000000))
    return result

# Logs: RESOURCES | my_module.resource_intensive_function | SUCCESS | 0.156s | CPU: 25.4% | Memory: 128.45MB (+5.23MB) | Threads: 12
```

### With I/O Monitoring

Include disk I/O statistics:

```python
@monitor_resources(include_io=True)
def file_processing():
    with open('large_file.txt', 'r') as f:
        data = f.read()
    processed = process_data(data)
    with open('output.txt', 'w') as f:
        f.write(processed)
    return len(processed)

# Logs: RESOURCES | my_module.file_processing | SUCCESS | 0.234s | CPU: 15.2% | Memory: 95.67MB (+0.12MB) | Threads: 8 | I/O: R:45.23MB W:12.34MB
```

### With Network Monitoring

Include network statistics:

```python
import requests

@monitor_resources(include_io=True, include_network=True)
def api_call_function():
    # Monitors CPU, memory, I/O, network, and threads
    response = requests.get("https://api.example.com/data")
    return response.json()

# Logs: RESOURCES | my_module.api_call_function | SUCCESS | 0.523s | CPU: 10.5% | Memory: 85.34MB (+2.15MB) | Threads: 10 | I/O: R:1.23MB W:0.05MB | Network: Sent:2.34KB Recv:125.67KB
```

### Async Functions

Works seamlessly with async/await:

```python
import httpx

@monitor_resources(include_network=True)
async def async_api_call():
    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.example.com/data")
        return response.json()
```

## Context Manager

Monitor specific code blocks:

```python
from sherlock_ai import ResourceTracker

def database_operation():
    # Setup
    config = load_config()
    
    # Monitor only this block
    with ResourceTracker("database_operation", include_io=True):
        connection = database.connect()
        result = connection.execute("SELECT * FROM large_table")
        connection.close()
    
    # Processing
    return process_result(result)

# Logs: RESOURCES | database_operation | SUCCESS | 0.145s | CPU: 20.3% | Memory: 112.56MB (+3.45MB) | Threads: 9 | I/O: R:25.67MB W:0.12MB
```

## Parameters

### `@monitor_resources` Decorator

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `min_duration` | float | 0.0 | Only log if execution time >= this value in seconds |
| `log_level` | str | "INFO" | Log level to use (INFO, DEBUG, WARNING, etc.) |
| `include_io` | bool | True | Include disk I/O statistics |
| `include_network` | bool | False | Include network statistics |

### `ResourceTracker` Context Manager

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | str | Required | Name identifier for the operation |
| `min_duration` | float | 0.0 | Only log if execution time >= this value in seconds |
| `include_io` | bool | True | Include I/O statistics |
| `include_network` | bool | False | Include network statistics |

## Log Output Format

Resource logs follow this format:

```
{timestamp} - {request_id} - MonitoringLogger - {level} - RESOURCES | {function_name} | {STATUS} | {execution_time}s | CPU: {cpu_percent}% | Memory: {memory_usage} ({memory_change}) | Threads: {thread_count} | I/O: R:{read_bytes} W:{write_bytes} | Network: Sent:{sent_bytes} Recv:{recv_bytes}
```

### Examples

```
2025-07-05 19:19:11 - 07ca74ed - MonitoringLogger - INFO - RESOURCES | tests.test_fastapi.health_check | SUCCESS | 0.144s | CPU: 59.3% | Memory: 57.66MB (+1.63MB) | Threads: 9 | I/O: R:0.00B W:414.00B

2025-07-05 21:13:03 - 2c4774b0 - MonitoringLogger - INFO - RESOURCES | api_handler | SUCCESS | 0.156s | CPU: 25.4% | Memory: 128.45MB (+5.23MB) | Threads: 12 | I/O: R:2.34MB W:1.12MB

2025-07-05 19:25:30 - - - MonitoringLogger - INFO - RESOURCES | database_query | SUCCESS | 0.089s | CPU: 15.2% | Memory: 95.67MB (+0.12MB) | Threads: 8

2025-07-05 20:15:45 - a1b2c3d4 - MonitoringLogger - INFO - RESOURCES | api_call | SUCCESS | 0.523s | CPU: 10.5% | Memory: 85.34MB (+2.15MB) | Threads: 10 | I/O: R:1.23MB W:0.05MB | Network: Sent:2.34KB Recv:125.67KB
```

## Understanding Resource Metrics

### CPU Usage

Percentage of CPU time used by the process during execution:

```python
@monitor_resources
def cpu_intensive():
    # Heavy computation
    result = [i**2 for i in range(10000000)]
# CPU: 85.3% - high CPU usage during computation
```

### Memory Usage

Current memory and change during execution:

```python
@monitor_resources
def memory_allocation():
    data = [0] * 10000000  # Allocates memory
# Memory: 128.45MB (+40.23MB) - shows increase
```

### Thread Count

Number of threads in the process:

```python
from concurrent.futures import ThreadPoolExecutor

@monitor_resources
def multithreaded_operation():
    with ThreadPoolExecutor(max_workers=5) as executor:
        results = executor.map(process_item, items)
# Threads: 15 - includes main thread + workers + system threads
```

### I/O Statistics

Disk read and write operations:

```python
@monitor_resources(include_io=True)
def file_operations():
    data = open('file.txt').read()  # Read
    open('output.txt', 'w').write(data)  # Write
# I/O: R:45.23MB W:45.23MB
```

### Network Statistics

Network send and receive operations (when `include_network=True`):

```python
@monitor_resources(include_network=True)
def api_request():
    response = requests.post("https://api.example.com", json=large_payload)
# Network: Sent:125.67KB Recv:45.23KB
```

## Resource Monitoring Utilities

Access low-level resource monitoring:

```python
from sherlock_ai import ResourceMonitor

# Capture current resource snapshot
snapshot = ResourceMonitor.capture_resources()
if snapshot:
    print(f"CPU: {snapshot.cpu_percent}%")
    print(f"Memory: {ResourceMonitor.format_bytes(snapshot.memory_rss)}")
    print(f"Threads: {snapshot.num_threads}")

# Capture memory snapshot
memory_snapshot = ResourceMonitor.capture_memory()
print(f"Current memory: {ResourceMonitor.format_bytes(memory_snapshot.current_size)}")

# Format bytes in human-readable format
formatted = ResourceMonitor.format_bytes(1024 * 1024 * 512)  # "512.00MB"
```

## Best Practices

### 1. Selective Monitoring

Enable only the metrics you need:

```python
# Basic monitoring - CPU, memory, threads
@monitor_resources
def basic_function():
    pass

# With I/O - for file operations
@monitor_resources(include_io=True)
def file_function():
    pass

# Full monitoring - for network operations
@monitor_resources(include_io=True, include_network=True)
def network_function():
    pass
```

### 2. Minimum Duration Threshold

Avoid noise from quick operations:

```python
@monitor_resources(min_duration=0.1)  # Only log if > 100ms
def frequent_operation():
    return quick_calculation()
```

### 3. Target Critical Sections

Use context managers for specific blocks:

```python
def complex_pipeline():
    setup()  # Don't monitor
    
    with ResourceTracker("processing", include_io=True):
        # Monitor only the resource-intensive part
        result = process_large_dataset()
    
    cleanup()  # Don't monitor
    return result
```

### 4. Combine with Other Monitoring

Get comprehensive insights:

```python
from sherlock_ai import log_performance, monitor_memory, monitor_resources

@log_performance
@monitor_memory(trace_malloc=True)
@monitor_resources(include_io=True)
def comprehensive_monitoring():
    # Tracks time, memory, AND system resources
    return process_large_dataset()
```

## Use Cases

- **Performance Profiling**: Identify CPU and memory bottlenecks
- **I/O Optimization**: Monitor disk read/write patterns
- **Network Analysis**: Track API call network usage
- **Capacity Planning**: Understand resource consumption patterns
- **Multithreading Analysis**: Monitor thread creation and usage
- **Database Operations**: Track I/O during database queries
- **File Processing**: Monitor resource usage in ETL pipelines
- **API Monitoring**: Track resource consumption per endpoint

## Performance Considerations

### Network Monitoring Overhead

Network monitoring adds minimal overhead but requires `psutil` with network support:

```python
# Only enable when needed
@monitor_resources(include_network=True)  # Adds ~1-2% overhead
def api_operation():
    pass
```

### I/O Monitoring

I/O monitoring is lightweight and enabled by default:

```python
@monitor_resources(include_io=True)  # Minimal overhead
def file_operation():
    pass
```

### High-Frequency Operations

For operations called very frequently:

```python
# Use minimum duration to reduce log volume
@monitor_resources(min_duration=0.05)
def frequent_cache_operation():
    return cache.get(key)
```

## Troubleshooting

### High CPU Usage

If you see unexpected CPU usage:
- Check for inefficient algorithms
- Look for unnecessary loops or computations
- Consider caching or optimization

### High Memory with Low Memory Change

If memory is high but change is small:
- The baseline process memory is high
- Consider process restart or memory cleanup
- Check for memory leaks in earlier operations

### No I/O Statistics

If I/O shows 0.00B:
- Operation might be using cache
- I/O might be too small to measure
- Check that `include_io=True` is set

### Network Statistics Not Available

If network monitoring fails:
- Ensure `psutil` is properly installed
- Check that the platform supports network monitoring
- Some systems require elevated privileges

## Next Steps

- [Performance Monitoring](performance-monitoring.md) - Track execution times
- [Memory Monitoring](memory-monitoring.md) - Monitor memory usage
- [Examples](../examples/combined-monitoring.md) - Combined monitoring examples
- [API Reference](../api-reference/decorators.md) - Complete decorator reference

