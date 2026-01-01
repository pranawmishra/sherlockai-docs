# Configuration Presets

Sherlock AI provides pre-built configuration presets for common scenarios. These presets are ready-to-use configurations that follow best practices for different environments.

## Available Presets

### Development Preset

Optimized for development with debug-level logging:

```python
from sherlock_ai import sherlock_ai, LoggingPresets

sherlock_ai(LoggingPresets.development())
```

**Features:**
- Debug-level console output
- All log files enabled
- Detailed logging for debugging
- Suitable for local development

**Configuration:**
```python
LoggingConfig(
    console_level="DEBUG",
    root_level="DEBUG",
    log_files={
        "app": LogFileConfig("app"),
        "errors": LogFileConfig("errors", level="ERROR"),
        "api": LogFileConfig("api"),
        "database": LogFileConfig("database"),
        "services": LogFileConfig("services"),
        "performance": LogFileConfig("performance")
    }
)
```

### Production Preset

Optimized for production with performance and stability:

```python
from sherlock_ai import sherlock_ai, LoggingPresets

sherlock_ai(LoggingPresets.production())
```

**Features:**
- INFO-level logging (less verbose)
- Larger file sizes for fewer rotations
- More backup files
- Optimized for performance

**Configuration:**
```python
LoggingConfig(
    console_level="INFO",
    root_level="INFO",
    log_files={
        "app": LogFileConfig(
            "app",
            max_bytes=50*1024*1024,  # 50MB
            backup_count=10
        ),
        "errors": LogFileConfig(
            "errors",
            level="ERROR",
            max_bytes=50*1024*1024,
            backup_count=10
        ),
        "performance": LogFileConfig(
            "performance",
            max_bytes=50*1024*1024,
            backup_count=10
        )
    }
)
```

### Minimal Preset

Basic setup with only essential logging:

```python
from sherlock_ai import sherlock_ai, LoggingPresets

sherlock_ai(LoggingPresets.minimal())
```

**Features:**
- Only app log file
- INFO-level logging
- Console output enabled
- Minimal disk usage

**Configuration:**
```python
LoggingConfig(
    console_level="INFO",
    log_files={
        "app": LogFileConfig("app")
    }
)
```

### Performance Only Preset

Focus on performance monitoring:

```python
from sherlock_ai import sherlock_ai, LoggingPresets

sherlock_ai(LoggingPresets.performance_only())
```

**Features:**
- Only performance log file
- No console output (cleaner for benchmarking)
- Dedicated to performance metrics

**Configuration:**
```python
LoggingConfig(
    console_enabled=False,
    log_files={
        "performance": LogFileConfig("performance")
    },
    loggers={
        "performance": LoggerConfig(
            "PerformanceLogger",
            log_files=["performance"],
            propagate=False
        )
    }
)
```

## Custom File Names

Create a preset with custom file names:

```python
from sherlock_ai import LoggingPresets

# Use custom file names
config = LoggingPresets.custom_files({
    "app": "logs/application.log",
    "performance": "logs/metrics.log",
    "errors": "logs/error_tracking.log"
})

from sherlock_ai import sherlock_ai
sherlock_ai(config)
```

## Modifying Presets

Start with a preset and customize it:

```python
from sherlock_ai import sherlock_ai, LoggingPresets

# Start with production preset
config = LoggingPresets.production()

# Customize as needed
config.console_level = "WARNING"
config.log_files["app"].max_bytes = 100*1024*1024  # 100MB
config.log_files["api"].enabled = True  # Enable API logs

# Apply the modified configuration
sherlock_ai(config)
```

## Environment-Based Presets

Use different presets based on environment:

```python
import os
from sherlock_ai import sherlock_ai, LoggingPresets

env = os.getenv("ENVIRONMENT", "development")

if env == "production":
    sherlock_ai(LoggingPresets.production())
elif env == "staging":
    # Production settings with debug for staging
    config = LoggingPresets.production()
    config.console_level = "DEBUG"
    sherlock_ai(config)
elif env == "testing":
    # Minimal for testing
    sherlock_ai(LoggingPresets.minimal())
else:
    # Development
    sherlock_ai(LoggingPresets.development())
```

## Preset Comparison

| Preset | Console Level | Log Files | File Size | Backups | Use Case |
|--------|--------------|-----------|-----------|---------|----------|
| Development | DEBUG | All | 10MB | 5 | Local development |
| Production | INFO | App, Errors, Performance | 50MB | 10 | Production |
| Minimal | INFO | App only | 10MB | 5 | Simple apps |
| Performance Only | Disabled | Performance only | 10MB | 5 | Benchmarking |

## Best Practices

### 1. Start with a Preset

Always start with the closest preset:

```python
# For production
config = LoggingPresets.production()
# Then customize
config.console_level = "WARNING"
```

### 2. Environment Variables

Use environment variables for flexibility:

```python
env = os.getenv("ENV", "development")
preset = getattr(LoggingPresets, env)()
sherlock_ai(preset)
```

### 3. Testing Configuration

Use minimal preset for testing:

```python
# In test setup
sherlock_ai(LoggingPresets.minimal())
```

### 4. Custom Presets

Create your own preset functions:

```python
from sherlock_ai import LoggingConfig, LogFileConfig

def my_custom_preset():
    return LoggingConfig(
        logs_dir="custom_logs",
        console_level="INFO",
        log_files={
            "app": LogFileConfig("application", max_bytes=25*1024*1024),
            "errors": LogFileConfig("errors", level="ERROR")
        }
    )

# Use it
from sherlock_ai import sherlock_ai
sherlock_ai(my_custom_preset())
```

## Next Steps

- [Custom Configuration](custom-config.md) - Build your own configuration from scratch
- [JSON Logging](json-logging.md) - Use JSON format with presets
- [Log Management](log-management.md) - Manage log files and rotation
- [Examples](../examples/index.md) - See presets in action

