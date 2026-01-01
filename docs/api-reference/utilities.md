# Utilities Reference

Complete reference for utility functions.

## Request ID Functions

### set_request_id(request_id=None)

Set request ID for current context.

**Parameters:**
- `request_id` (str, optional): Custom request ID. If None, generates one.

**Returns:** str - The request ID that was set

**Example:**
```python
from sherlock_ai import set_request_id

# Auto-generate ID
request_id = set_request_id()  # Returns: "a1b2c3d4"

# Custom ID
request_id = set_request_id("req-12345")  # Returns: "req-12345"
```

### get_request_id()

Get current request ID.

**Returns:** str - Current request ID or None

**Example:**
```python
from sherlock_ai import get_request_id

current_id = get_request_id()
```

## Logger Functions

### list_available_loggers()

List all available logger names.

**Returns:** List[str] - List of logger names

**Example:**
```python
from sherlock_ai import list_available_loggers

loggers = list_available_loggers()
print(f"Available: {loggers}")
```

### LoggerNames

Constants for available logger names.

**Attributes:**
- `LoggerNames.API` - API logger name
- `LoggerNames.DATABASE` - Database logger name
- `LoggerNames.SERVICES` - Services logger name
- `LoggerNames.PERFORMANCE` - Performance logger name

**Example:**
```python
from sherlock_ai import get_logger, LoggerNames

api_logger = get_logger(LoggerNames.API)
db_logger = get_logger(LoggerNames.DATABASE)
```

## Introspection Functions

### get_logging_stats()

Get current logging statistics.

**Returns:** Dict[str, Any] - Statistics dictionary

**Example:**
```python
from sherlock_ai import get_logging_stats

stats = get_logging_stats()
print(f"Configured: {stats['is_configured']}")
print(f"Handlers: {stats['handlers']}")
print(f"Log directory: {stats['logs_dir']}")
```

### get_current_config()

Get current logging configuration.

**Returns:** Optional[LoggingConfig] - Current configuration

**Example:**
```python
from sherlock_ai import get_current_config

config = get_current_config()
if config:
    print(f"Console enabled: {config.console_enabled}")
    print(f"Log files: {list(config.log_files.keys())}")
```

## Context Managers

### PerformanceTimer

Context manager for timing code blocks.

**Parameters:**
- `name` (str, required): Name for the operation
- `min_duration` (float, default=0.0): Only log if >= this value

**Example:**
```python
from sherlock_ai.performance import PerformanceTimer

with PerformanceTimer("database_query"):
    result = db.query("SELECT * FROM users")
```

### MemoryTracker

Context manager for tracking memory usage.

**Parameters:**
- `name` (str, required): Name for the operation
- `min_duration` (float, default=0.0): Only log if >= this value
- `trace_malloc` (bool, default=True): Use tracemalloc

**Example:**
```python
from sherlock_ai import MemoryTracker

with MemoryTracker("data_processing"):
    data = process_large_dataset()
```

### ResourceTracker

Context manager for tracking system resources.

**Parameters:**
- `name` (str, required): Name for the operation
- `min_duration` (float, default=0.0): Only log if >= this value
- `include_io` (bool, default=True): Include I/O stats
- `include_network` (bool, default=False): Include network stats

**Example:**
```python
from sherlock_ai import ResourceTracker

with ResourceTracker("api_call", include_network=True):
    response = requests.get("https://api.example.com")
```

