# Quick Start

Get up and running with Sherlock AI in minutes.

## Basic Setup

The simplest way to get started:

```python
from sherlock_ai import sherlock_ai, get_logger, log_performance
import time

# Initialize logging (call once at application startup)
sherlock_ai()

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
from sherlock_ai import sherlock_ai, get_logger, log_performance, hardcoded_value_detector
from sherlock_ai.monitoring import sherlock_error_handler
import time

# Initialize logging
sherlock_ai()
logger = get_logger(__name__)

@log_performance
@hardcoded_value_detector
@sherlock_error_handler
def my_function():
    # Your code here - hardcoded values will be automatically detected
    # Errors will be automatically analyzed and stored in MongoDB
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
- Automatically refactor any hardcoded values to constants
- Analyze any errors with AI-powered insights

## Class-Based Setup (Advanced)

For more control, use the class-based API:

```python
from sherlock_ai import SherlockAI, get_logger, log_performance

# Initialize with class-based approach
logger_manager = SherlockAI()
logger_manager.setup()

# Get a logger for your module
logger = get_logger(__name__)

@log_performance
def my_function():
    logger.info("Processing with class-based setup")
    return "result"

# Later, reconfigure without restart
from sherlock_ai import LoggingPresets
logger_manager.reconfigure(LoggingPresets.development())

# Or use as context manager
with SherlockAI() as temp_logger:
    # Temporary logging configuration
    logger.info("This uses temporary configuration")
# Automatically cleaned up
```

## Using Logger Name Constants

Use predefined logger names with autocomplete support:

```python
from sherlock_ai import sherlock_ai, get_logger, LoggerNames, list_available_loggers

# Initialize logging
sherlock_ai()

# Use predefined logger names with autocomplete support
api_logger = get_logger(LoggerNames.API)
db_logger = get_logger(LoggerNames.DATABASE)
service_logger = get_logger(LoggerNames.SERVICES)

# Discover available loggers programmatically
available_loggers = list_available_loggers()
print(f"Available loggers: {available_loggers}")

# Use the loggers
api_logger.info("API request received")        # → logs/api.log
db_logger.info("Database query executed")     # → logs/database.log
service_logger.info("Service operation done") # → logs/services.log
```

## Advanced Configuration

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
from sherlock_ai.performance import PerformanceTimer

with PerformanceTimer("database_operation"):
    # Your code block here
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

# Works automatically with async functions
result = await async_api_call()
```

## Default Log Files

When you call `sherlock_ai()`, it automatically creates a `logs/` directory with these files:

- `app.log` - All INFO+ level logs from root logger
- `errors.log` - Only ERROR+ level logs from any logger
- `api.log` - Logs from `app.api` logger
- `database.log` - Logs from `app.core.dbConnection` logger
- `services.log` - Logs from `app.services` logger
- `performance.log` - Performance monitoring logs

## What's Next?

Now that you have the basics, explore more features:

- **[Performance Monitoring](features/performance-monitoring.md)** - Track execution times
- **[Memory Monitoring](features/memory-monitoring.md)** - Monitor memory usage
- **[Resource Monitoring](features/resource-monitoring.md)** - Track CPU, I/O, and network
- **[Error Analysis](features/error-analysis.md)** - AI-powered error insights
- **[Configuration](configuration/index.md)** - Customize your setup
- **[Examples](examples/index.md)** - Real-world integration examples

