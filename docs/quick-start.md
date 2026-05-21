# Quick Start

Get up and running with Sherlock AI in minutes.

## Basic Setup

The simplest way to get started:

```python
from sherlock_ai import SherlockAI, get_logger, log_performance
import time

# Initialize logging once at application startup
logger_manager = SherlockAI()
logger_manager.setup()

# Get a logger for your module
logger = get_logger(__name__)

@log_performance
def my_function():
    time.sleep(1)
    logger.info("Processing completed")
    return "result"

# This will log: PERFORMANCE | my_module.my_function | SUCCESS | 1.003s
result = my_function()
```

## With Error Handling and Code Analysis

Add more features with decorators:

```python
from sherlock_ai import SherlockAI, get_logger, log_performance, hardcoded_value_detector
from sherlock_ai.monitoring import sherlock_error_handler
import time

# Initialize logging
logger_manager = SherlockAI()
logger_manager.setup()

logger = get_logger(__name__)

@log_performance
@hardcoded_value_detector
@sherlock_error_handler
def my_function():
    # Hardcoded values are automatically detected
    # Errors are automatically analyzed and stored in MongoDB
    try:
        time.sleep(1)
        logger.info("Processing completed")
        return "result"
    except Exception as e:
        logger.error(f"Error: {e}")
        raise

result = my_function()
```

This will:
- Log performance metrics: `PERFORMANCE | my_module.my_function | SUCCESS | 1.003s`
- Automatically detect hardcoded values
- Analyze any errors with AI-powered insights

## Custom Configuration

Configure format type, log directory, or any other option via `LoggingConfig`:

```python
from sherlock_ai import SherlockAI, LoggingConfig, get_logger, log_performance

# JSON format (default) — creates .json log files
logger_manager = SherlockAI(LoggingConfig(log_format_type="json"))
logger_manager.setup()

# Standard text format — creates .log files
logger_manager = SherlockAI(LoggingConfig(log_format_type="log"))
logger_manager.setup()

logger = get_logger(__name__)
```

## Runtime Reconfiguration

Change the configuration without restarting:

```python
from sherlock_ai import SherlockAI, LoggingConfig

logger_manager = SherlockAI()
logger_manager.setup()

# Switch to a debug configuration at runtime
debug_config = LoggingConfig(
    console_level="DEBUG",
    root_level="DEBUG"
)
logger_manager.reconfigure(debug_config)
```

## Using Logger Name Constants

Use predefined logger names with autocomplete support:

```python
from sherlock_ai import SherlockAI, get_logger, LoggerNames, list_available_loggers

logger_manager = SherlockAI()
logger_manager.setup()

# Use predefined logger names
performance_logger = get_logger(LoggerNames.PERFORMANCE)
monitoring_logger  = get_logger(LoggerNames.MONITORING)
error_logger       = get_logger(LoggerNames.ERRORINSIGHTS)

# Discover available loggers programmatically
available_loggers = list_available_loggers()
print(f"Available loggers: {available_loggers}")

performance_logger.info("Performance data")   # → logs/performance.json
monitoring_logger.info("Resource snapshot")   # → logs/monitoring.json
```

## Advanced Configuration — Decorated Functions

Configure performance monitoring with custom parameters:

```python
@log_performance(min_duration=0.1, include_args=True, log_level="DEBUG")
def slow_database_query(user_id, limit=10):
    # Only logs if execution time >= 0.1 seconds
    # Includes function arguments in the log
    pass
```

## Context Manager for Code Blocks

Monitor specific code blocks:

```python
from sherlock_ai import PerformanceTimer

with PerformanceTimer("database_operation"):
    result = database.query("SELECT * FROM users")

# Logs: PERFORMANCE | database_operation | SUCCESS | 0.234s
```

## Async Function Support

Works automatically with async functions:

```python
import httpx

@log_performance
async def async_api_call():
    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.example.com")
        return response.json()

result = await async_api_call()
```

## Default Log Files

When you call `SherlockAI().setup()`, it automatically creates a `logs/` directory with these files (`.json` by default, `.log` when `log_format_type="log"`):

| File | Purpose | Logger |
|------|---------|--------|
| `app.json` | All INFO+ logs from the root logger | Root logger |
| `errors.json` | ERROR+ logs from any logger | All loggers |
| `performance.json` | Performance monitoring | `PerformanceLogger` |
| `monitoring.json` | Memory and resource monitoring | `MonitoringLogger` |
| `error_insights.json` | AI-generated error analysis | `ErrorInsightsLogger` |
| `performance_insights.json` | AI-generated performance analysis | `PerformanceInsightsLogger` |

## What's Next?

Now that you have the basics, explore more features:

- **[Performance Monitoring](features/performance-monitoring.md)** - Track execution times
- **[Memory Monitoring](features/memory-monitoring.md)** - Monitor memory usage
- **[Resource Monitoring](features/resource-monitoring.md)** - Track CPU, I/O, and network
- **[Error Analysis](features/error-analysis.md)** - AI-powered error insights
- **[Configuration](configuration/index.md)** - Customize your setup
- **[Examples](examples/index.md)** - Real-world integration examples

