# Features Overview

Sherlock AI provides comprehensive monitoring and analysis capabilities for Python applications. Each feature is designed to work independently or in combination with others for complete observability.

## Core Features

### Performance Monitoring
Track execution times of functions and code blocks with the `@log_performance` decorator and `PerformanceTimer` context manager.

[Learn more →](performance-monitoring.md)

### Memory Monitoring
Monitor Python memory usage with detailed heap analysis and tracemalloc integration using `@monitor_memory`.

[Learn more →](memory-monitoring.md)

### Resource Monitoring
Track comprehensive system resources including CPU, memory, I/O, and network usage with `@monitor_resources`.

[Learn more →](resource-monitoring.md)

### Error Analysis
AI-powered error analysis with automatic probable cause detection and MongoDB storage using `@sherlock_error_handler`.

[Learn more →](error-analysis.md)

### Code Analysis
Automatically detect and refactor hardcoded values in your code using `@hardcoded_value_detector`.

[Learn more →](code-analysis.md)

### Auto-Instrumentation
Zero-code setup for popular frameworks like FastAPI, automatically instrumenting routes with monitoring decorators.

[Learn more →](auto-instrumentation.md)

## Feature Comparison

| Feature | Decorator | Context Manager | Async Support | Storage Options |
|---------|-----------|-----------------|---------------|-----------------|
| Performance Monitoring | ✓ | ✓ | ✓ | Log files |
| Memory Monitoring | ✓ | ✓ | ✓ | Log files |
| Resource Monitoring | ✓ | ✓ | ✓ | Log files |
| Error Analysis | ✓ | ✗ | ✓ | MongoDB, API |
| Code Analysis | ✓ | ✗ | ✓ | File system |
| Auto-Instrumentation | ✓ | ✗ | ✓ | All supported |

## Combined Usage

Features can be stacked for comprehensive monitoring:

```python
from sherlock_ai import log_performance, monitor_memory, monitor_resources
from sherlock_ai.monitoring import sherlock_error_handler
from sherlock_ai import hardcoded_value_detector

@log_performance
@monitor_memory(trace_malloc=True)
@monitor_resources(include_io=True)
@sherlock_error_handler
@hardcoded_value_detector
def comprehensive_function():
    # This function will be monitored for:
    # - Execution time (performance)
    # - Memory usage (memory)
    # - System resources (CPU, I/O, etc.)
    # - Error analysis (AI-powered)
    # - Hardcoded value detection
    data = process_large_dataset()
    save_to_database(data)
    return len(data)
```

## Next Steps

Explore each feature in detail to understand how to use them effectively in your application:

1. Start with [Performance Monitoring](performance-monitoring.md) for basic tracking
2. Add [Memory Monitoring](memory-monitoring.md) for memory-intensive operations
3. Use [Resource Monitoring](resource-monitoring.md) for comprehensive system analysis
4. Enable [Error Analysis](error-analysis.md) for AI-powered debugging
5. Try [Code Analysis](code-analysis.md) to improve code quality
6. Set up [Auto-Instrumentation](auto-instrumentation.md) for zero-code monitoring

