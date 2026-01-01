# Runtime Reconfiguration

Change logging configuration without restarting your application.

## Basic Reconfiguration

```python
from sherlock_ai import SherlockAI, LoggingConfig, LoggingPresets

# Initial setup
logger_manager = SherlockAI()
logger_manager.setup()

# Change to production configuration
logger_manager.reconfigure(LoggingPresets.production())

# Change to debug mode
logger_manager.reconfigure(LoggingPresets.development())
```

## Custom Reconfiguration

```python
new_config = LoggingConfig(
    console_level="DEBUG",
    logs_dir="new_logs_dir",
    log_files={
        "app": LogFileConfig("app", max_bytes=100*1024*1024)
    }
)

logger_manager.reconfigure(new_config)
```

## Dynamic Configuration

```python
import os

def update_logging_level():
    level = os.getenv("LOG_LEVEL", "INFO")
    config = LoggingConfig(console_level=level)
    logger_manager.reconfigure(config)

# Can be called anytime
update_logging_level()
```

## Use Cases

- Switch between development and production modes
- Temporarily enable debug logging
- Change log file locations
- Adjust log levels based on load

