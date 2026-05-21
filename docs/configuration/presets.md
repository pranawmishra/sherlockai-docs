# Configuration Patterns

Sherlock AI uses `LoggingConfig` directly for all configuration. This page shows ready-to-use patterns for common environments and use cases.

## Environment Patterns

### Development

Debug-level logging with human-readable text format:

```python
from sherlock_ai import SherlockAI, LoggingConfig

config = LoggingConfig(
    log_format_type="log",   # human-readable .log files
    console_level="DEBUG",
    root_level="DEBUG"
)
SherlockAI(config).setup()
```

**Features:**
- Debug-level console and file output
- Human-readable `.log` files (easier to `tail -f` locally)
- All default log files enabled

### Production

Structured JSON format with larger rotation limits:

```python
from sherlock_ai import SherlockAI, LoggingConfig, LogFileConfig

config = LoggingConfig(
    log_format_type="json",        # structured JSON files
    console_level="WARNING",
    log_files={
        "app": LogFileConfig(
            "app",
            max_bytes=50*1024*1024,   # 50MB
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
        ),
        "monitoring": LogFileConfig("monitoring"),
        "error_insights": LogFileConfig("error_insights"),
        "performance_insights": LogFileConfig("performance_insights"),
    }
)
SherlockAI(config).setup()
```

**Features:**
- JSON format for log aggregation (Elasticsearch, Splunk, CloudWatch)
- INFO-level logging with reduced console noise
- Larger file sizes for fewer rotations

### Minimal

Console + basic app log only — good for simple scripts or testing:

```python
from sherlock_ai import SherlockAI, LoggingConfig, LogFileConfig

config = LoggingConfig(
    log_files={
        "app": LogFileConfig("app"),
        "errors": LogFileConfig("errors", level="ERROR"),
    }
)
SherlockAI(config).setup()
```

**Features:**
- Only essential log files
- Minimal disk usage
- Console output enabled

### Performance Focus

Only log performance data — useful for benchmarking:

```python
from sherlock_ai import SherlockAI, LoggingConfig, LogFileConfig, LoggerConfig

config = LoggingConfig(
    console_enabled=False,
    log_files={
        "performance": LogFileConfig("performance"),
    },
    loggers={
        "performance": LoggerConfig(
            "PerformanceLogger",
            log_files=["performance"],
            propagate=False
        )
    }
)
SherlockAI(config).setup()
```

**Features:**
- Performance log file only
- No console output (cleaner for benchmarking)
- Dedicated to performance metrics

## Custom File Names

Specify your own file names by passing base filenames — paths are automatically expanded:

```python
from sherlock_ai import SherlockAI, LoggingConfig, LogFileConfig

config = LoggingConfig(
    logs_dir="logs",
    log_format_type="json",
    log_files={
        "app": LogFileConfig("application"),      # → logs/application.json
        "errors": LogFileConfig("error_tracking"), # → logs/error_tracking.json
        "performance": LogFileConfig("metrics"),   # → logs/metrics.json
    }
)
SherlockAI(config).setup()
```

## Environment-Based Selection

Choose a pattern based on an environment variable:

```python
import os
from sherlock_ai import SherlockAI, LoggingConfig, LogFileConfig

env = os.getenv("ENVIRONMENT", "development")

if env == "production":
    config = LoggingConfig(
        log_format_type="json",
        console_level="WARNING",
        log_files={
            "app": LogFileConfig("app", max_bytes=50*1024*1024, backup_count=10),
            "errors": LogFileConfig("errors", level="ERROR", max_bytes=50*1024*1024),
            "performance": LogFileConfig("performance"),
            "monitoring": LogFileConfig("monitoring"),
            "error_insights": LogFileConfig("error_insights"),
            "performance_insights": LogFileConfig("performance_insights"),
        }
    )
elif env == "staging":
    config = LoggingConfig(
        log_format_type="json",
        console_level="DEBUG"   # More verbose than prod for debugging
    )
elif env == "testing":
    config = LoggingConfig(
        logs_dir="test_logs",
        console_enabled=False,
        log_files={"app": LogFileConfig("app")}
    )
else:
    # Development
    config = LoggingConfig(
        log_format_type="log",
        console_level="DEBUG",
        root_level="DEBUG"
    )

SherlockAI(config).setup()
```

## Modifying a Configuration

Build a base config then adjust it:

```python
from sherlock_ai import SherlockAI, LoggingConfig, LogFileConfig

# Start with production-style settings
config = LoggingConfig(
    log_format_type="json",
    console_level="WARNING",
)

# Then tune specific values
config.console_level = "INFO"
config.log_files["app"].max_bytes = 100 * 1024 * 1024  # 100MB

SherlockAI(config).setup()
```

## Pattern Comparison

| Pattern | Console Level | Format | Log Files | Use Case |
|---------|--------------|--------|-----------|----------|
| Development | DEBUG | `.log` | All (default) | Local development |
| Production | WARNING | `.json` | App, Errors, Performance + insights | Production |
| Minimal | INFO | `.json` | App, Errors only | Simple apps / tests |
| Performance Only | Disabled | `.json` | Performance only | Benchmarking |

## Best Practices

### 1. Build Your Own Helper

Create a module-level factory so your config is centralised:

```python
from sherlock_ai import LoggingConfig, LogFileConfig

def get_logging_config(env: str = "development") -> LoggingConfig:
    if env == "production":
        return LoggingConfig(
            log_format_type="json",
            console_level="WARNING",
        )
    return LoggingConfig(
        log_format_type="log",
        console_level="DEBUG",
        root_level="DEBUG",
    )
```

### 2. Use Environment Variables

```python
import os
config = LoggingConfig(
    logs_dir=os.getenv("LOG_DIR", "logs"),
    console_level=os.getenv("LOG_LEVEL", "INFO"),
    log_format_type=os.getenv("LOG_FORMAT", "json")
)
```

### 3. Use Minimal Config for Testing

```python
# In test setup
from sherlock_ai import SherlockAI, LoggingConfig, LogFileConfig

SherlockAI(LoggingConfig(
    console_enabled=False,
    log_files={"app": LogFileConfig("app")}
)).setup()
```

## Next Steps

- [Custom Configuration](custom-config.md) - Build your own configuration from scratch
- [JSON Logging](json-logging.md) - Use JSON format
- [Log Management](log-management.md) - Manage log files and rotation
- [Examples](../examples/index.md) - See configurations in action
