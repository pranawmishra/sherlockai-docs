# Memory Monitoring

Track Python memory usage with detailed heap analysis and tracemalloc integration. The `@monitor_memory` decorator and `MemoryTracker` context manager help identify memory leaks and optimize memory-intensive operations.

## Decorator Usage

### Basic Example

```python
from sherlock_ai import monitor_memory

@monitor_memory
def memory_intensive_function():
    # Allocate memory
    data = [i * i for i in range(1000000)]
    processed = sum(data)
    return processed

# Logs: MEMORY | my_module.memory_intensive_function | SUCCESS | 0.245s | Current: 45.67MB | Change: +12.34MB | Traced: 38.92MB (Peak: 52.18MB)
```

### Advanced Tracking with tracemalloc

Enable detailed Python memory tracking:

```python
@monitor_memory(trace_malloc=True, min_duration=0.1)
def critical_memory_function():
    # Only logs if execution time >= 0.1 seconds
    # Includes detailed Python memory tracking
    large_dict = {i: str(i) * 100 for i in range(10000)}
    return len(large_dict)

# Logs: MEMORY | my_module.critical_memory_function | SUCCESS | 0.261s | Current: 57.66MB | Change: +1.64MB | Traced: 24.33KB (Peak: 30.33KB)
```

### Async Functions

Works with async/await:

```python
@monitor_memory(trace_malloc=True)
async def async_data_processing():
    # Process data asynchronously
    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.example.com/large-data")
        data = response.json()
        # Process large dataset
        return process_data(data)
```

## Context Manager

Monitor memory usage in specific code blocks:

```python
from sherlock_ai import MemoryTracker

def data_pipeline():
    # Initialization
    config = load_config()
    
    # Monitor this specific block
    with MemoryTracker("data_processing"):
        # Your memory-intensive code here
        data = load_large_dataset()
        processed = process_data(data)
    
    # Cleanup
    save_results(processed)

# Logs: MEMORY | data_processing | SUCCESS | 1.234s | Current: 125.45MB | Change: +45.23MB | Traced: 42.18MB (Peak: 48.92MB)
```

### With Minimum Duration

Only log if execution or memory change exceeds thresholds:

```python
with MemoryTracker("cache_operation", min_duration=0.01, trace_malloc=True):
    # Only logs if this takes more than 10ms
    cache.set(key, large_value)
```

## Parameters

### `@monitor_memory` Decorator

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `min_duration` | float | 0.0 | Only log if execution time >= this value in seconds |
| `log_level` | str | "INFO" | Log level to use (INFO, DEBUG, WARNING, etc.) |
| `trace_malloc` | bool | True | Use tracemalloc for detailed Python memory tracking |

### `MemoryTracker` Context Manager

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | str | Required | Name identifier for the operation |
| `min_duration` | float | 0.0 | Only log if execution time >= this value in seconds |
| `trace_malloc` | bool | True | Use tracemalloc for detailed tracking |

## Log Output Format

Memory logs follow this format:

```
{timestamp} - {request_id} - MonitoringLogger - {level} - MEMORY | {function_name} | {STATUS} | {execution_time}s | Current: {current_memory} | Change: {memory_change} | Traced: {traced_memory} (Peak: {peak_memory})
```

### Examples

```
2025-07-05 19:19:11 - 07ca74ed - MonitoringLogger - INFO - MEMORY | tests.test_fastapi.health_check | SUCCESS | 0.261s | Current: 57.66MB | Change: +1.64MB | Traced: 24.33KB (Peak: 30.33KB)

2025-07-05 21:15:22 - - - MonitoringLogger - INFO - MEMORY | data_processor | SUCCESS | 0.245s | Current: 45.67MB | Change: +12.34MB

2025-07-05 19:20:15 - 2c4774b0 - MonitoringLogger - INFO - MEMORY | load_large_file | SUCCESS | 2.156s | Current: 256.89MB | Change: +128.45MB | Traced: 125.67MB (Peak: 145.23MB)
```

## Understanding Memory Metrics

### Current Memory

The total memory currently used by the Python process (RSS - Resident Set Size).

```python
@monitor_memory
def example():
    pass
# Current: 57.66MB - total memory used by the process
```

### Memory Change

The difference in memory usage before and after function execution.

```python
@monitor_memory
def allocate_memory():
    data = [0] * 10000000  # Allocates ~40MB
# Change: +40.23MB - memory increase from this function
```

### Traced Memory (tracemalloc)

When `trace_malloc=True`, shows memory allocated specifically by Python objects during execution.

```python
@monitor_memory(trace_malloc=True)
def create_objects():
    objects = [{"id": i} for i in range(100000)]
# Traced: 8.45MB (Peak: 10.23MB) - Python object memory
```

## Best Practices

### 1. Enable tracemalloc for Detailed Tracking

For memory leak investigation:

```python
@monitor_memory(trace_malloc=True)
def investigate_memory_leak():
    # tracemalloc shows exact Python object allocations
    return process_data()
```

### 2. Use Minimum Duration Thresholds

Avoid noise from quick operations:

```python
@monitor_memory(min_duration=0.1)  # Only log if > 100ms
def frequent_operation():
    # Only logs if slow or memory-intensive
    return quick_calculation()
```

### 3. Monitor Critical Sections Only

Use context managers for targeted monitoring:

```python
def full_pipeline():
    config = load_config()  # Don't monitor
    
    with MemoryTracker("model_training"):
        # Monitor only the memory-intensive part
        model = train_large_model(data)
    
    save_model(model)  # Don't monitor
```

### 4. Combine with Performance Monitoring

Get complete insights:

```python
from sherlock_ai import log_performance, monitor_memory

@log_performance
@monitor_memory(trace_malloc=True)
def comprehensive_monitoring():
    # Tracks both time AND memory
    return process_large_dataset()
```

## Memory Monitoring Utilities

Access low-level memory monitoring:

```python
from sherlock_ai import ResourceMonitor

# Capture current memory snapshot
memory_snapshot = ResourceMonitor.capture_memory()
print(f"Current memory: {ResourceMonitor.format_bytes(memory_snapshot.current_size)}")
print(f"Memory change: {ResourceMonitor.format_bytes(memory_snapshot.size_diff)}")

# Format bytes in human-readable format
formatted = ResourceMonitor.format_bytes(1024 * 1024 * 512)  # "512.00MB"
```

## Use Cases

- **Memory Leak Detection**: Monitor memory growth over time
- **ML Model Training**: Track memory during model training
- **Data Processing**: Monitor memory in ETL pipelines
- **Cache Management**: Optimize cache size based on memory usage
- **Image/Video Processing**: Monitor memory in media processing
- **Large Dataset Operations**: Track memory when handling large datasets

## Troubleshooting

### High Memory Usage

If you see unexpectedly high memory usage:

1. Enable `trace_malloc=True` to see Python object allocations
2. Look for the "Peak" value - it shows the maximum memory used
3. Check for large data structures that aren't being garbage collected

### Memory Not Decreasing

If memory doesn't decrease after function exit:

- Python doesn't always return memory to OS immediately
- Enable tracemalloc to see if Python objects are properly freed
- Use `gc.collect()` to force garbage collection for testing

### tracemalloc Overhead

tracemalloc adds ~10-20% overhead:

- Use `trace_malloc=True` only when needed
- Disable in production for high-frequency operations
- Enable temporarily for debugging memory issues

## Next Steps

- [Resource Monitoring](resource-monitoring.md) - Monitor CPU, I/O, and network alongside memory
- [Performance Monitoring](performance-monitoring.md) - Track execution times
- [Examples](../examples/index.md) - See real-world memory monitoring examples
- [API Reference](../api-reference/decorators.md) - Complete decorator reference

