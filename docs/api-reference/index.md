# API Reference

Complete API documentation for Sherlock AI.

## Core Functions

### sherlock_ai()

Initialize logging configuration.

```python
from sherlock_ai import sherlock_ai, LoggingConfig, LoggingPresets

# Default configuration
sherlock_ai()

# With preset
sherlock_ai(LoggingPresets.production())

# With format type
sherlock_ai(format_type="json")

# With custom config
config = LoggingConfig(...)
sherlock_ai(config)
```

### get_logger()

Get a logger instance.

```python
from sherlock_ai import get_logger, LoggerNames

logger = get_logger(__name__)
logger = get_logger(LoggerNames.API)
```

## Decorators

[View Decorators Reference →](decorators.md)

- `@log_performance` - Track execution times
- `@monitor_memory` - Monitor memory usage
- `@monitor_resources` - Monitor system resources
- `@sherlock_error_handler` - AI-powered error analysis
- `@hardcoded_value_detector` - Detect hardcoded values
- `@sherlock_performance_insights` - Performance analysis

## Classes

[View Classes Reference →](classes.md)

- `SherlockAI` - Main logging manager class
- `CodeAnalyzer` - Code analysis utilities
- `MongoManager` - MongoDB storage
- `ApiClient` - HTTP client for data ingestion
- `ResourceMonitor` - Resource monitoring utilities

## Configuration

[View Configuration Reference →](configuration.md)

- `LoggingConfig` - Main configuration class
- `LogFileConfig` - Log file configuration
- `LoggerConfig` - Logger configuration
- `LoggingPresets` - Pre-configured setups

## Utilities

[View Utilities Reference →](utilities.md)

- `set_request_id()` - Set request ID
- `get_request_id()` - Get current request ID
- `list_available_loggers()` - List available loggers
- `get_logging_stats()` - Get logging statistics
- `get_current_config()` - Get current configuration

