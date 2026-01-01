# Decorators Reference

Complete reference for all Sherlock AI decorators.

## @log_performance

Track execution times of functions.

**Parameters:**
- `min_duration` (float, default=0.0): Only log if execution time >= this value in seconds
- `include_args` (bool, default=False): Include function arguments in log
- `log_level` (str, default="INFO"): Log level to use

**Example:**
```python
@log_performance(min_duration=0.1, include_args=True, log_level="DEBUG")
def my_function(arg1, arg2):
    pass
```

## @monitor_memory

Monitor memory usage during function execution.

**Parameters:**
- `min_duration` (float, default=0.0): Only log if execution time >= this value
- `log_level` (str, default="INFO"): Log level to use
- `trace_malloc` (bool, default=True): Use tracemalloc for detailed tracking

**Example:**
```python
@monitor_memory(trace_malloc=True, min_duration=0.1)
def memory_function():
    pass
```

## @monitor_resources

Monitor comprehensive system resources.

**Parameters:**
- `min_duration` (float, default=0.0): Only log if execution time >= this value
- `log_level` (str, default="INFO"): Log level to use
- `include_io` (bool, default=True): Include I/O statistics
- `include_network` (bool, default=False): Include network statistics

**Example:**
```python
@monitor_resources(include_io=True, include_network=True)
def resource_function():
    pass
```

## @sherlock_error_handler

AI-powered error analysis with automatic storage.

**Parameters:** None

**Example:**
```python
@sherlock_error_handler
def risky_function():
    pass
```

## @hardcoded_value_detector

Detect and refactor hardcoded values.

**Parameters:**
- `analyzer` (CodeAnalyzer, optional): Custom analyzer instance

**Example:**
```python
@hardcoded_value_detector
def my_function():
    pass
```

## @sherlock_performance_insights

AI-powered performance analysis.

**Parameters:** None

**Example:**
```python
@sherlock_performance_insights
def slow_function():
    pass
```

