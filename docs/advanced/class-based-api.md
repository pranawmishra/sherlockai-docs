# Class-Based API

Advanced logging management using the `SherlockAI` class for instance-based configuration and runtime control.

## Basic Usage

```python
from sherlock_ai import SherlockAI, get_logger

# Initialize with class-based approach
logger_manager = SherlockAI()
logger_manager.setup()

# Get a logger
logger = get_logger(__name__)

@log_performance
def my_function():
    logger.info("Processing with class-based setup")
    return "result"
```

## With Custom Configuration

```python
from sherlock_ai import SherlockAI, LoggingConfig, LogFileConfig

config = LoggingConfig(
    logs_dir="custom_logs",
    log_format_type="json",
    log_files={
        "app": LogFileConfig("application", max_bytes=50*1024*1024)
    }
)

logger_manager = SherlockAI(config=config)
logger_manager.setup()
```

## Runtime Reconfiguration

```python
from sherlock_ai import SherlockAI, LoggingPresets

# Initial setup
logger_manager = SherlockAI()
logger_manager.setup()

# Later, change configuration without restart
logger_manager.reconfigure(LoggingPresets.production())
```

## Context Manager

```python
from sherlock_ai import SherlockAI, LoggingConfig

# Temporary configuration
with SherlockAI(LoggingConfig(logs_dir="temp_logs")) as temp_logger:
    # Use temporary logging configuration
    logger.info("This uses temporary config")
# Automatically cleaned up
```

## Singleton Pattern

```python
from sherlock_ai import SherlockAI

# Get or create singleton instance
logger_manager = SherlockAI.get_instance()
```

[Learn more about runtime reconfiguration →](runtime-reconfiguration.md)

