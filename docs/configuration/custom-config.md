# Custom Configuration

Build completely custom logging configurations tailored to your application's specific needs. This guide covers all configuration options and how to create sophisticated logging setups.

## Basic Custom Configuration

```python
from sherlock_ai import sherlock_ai, LoggingConfig, LogFileConfig, LoggerConfig

config = LoggingConfig(
    logs_dir="my_app_logs",
    console_level="INFO",
    log_files={
        "app": LogFileConfig("application"),
        "errors": LogFileConfig("errors", level="ERROR")
    }
)

sherlock_ai(config)
```

## Complete Custom Configuration

```python
from sherlock_ai import LoggingConfig, LogFileConfig, LoggerConfig, sherlock_ai

config = LoggingConfig(
    # Directory configuration
    logs_dir="application_logs",
    
    # Format configuration
    log_format="%(asctime)s - %(request_id)s - %(name)s - %(levelname)s - %(message)s",
    date_format="%Y-%m-%d %H:%M:%S",
    
    # Console configuration
    console_enabled=True,
    console_level="DEBUG",
    
    # Root logger level
    root_level="INFO",
    
    # Log files
    log_files={
        "application": LogFileConfig(
            "app",
            level="INFO",
            max_bytes=50*1024*1024,  # 50MB
            backup_count=10,
            encoding="utf-8",
            enabled=True
        ),
        "errors": LogFileConfig(
            "errors",
            level="ERROR",
            max_bytes=25*1024*1024,  # 25MB
            backup_count=15
        ),
        "performance": LogFileConfig(
            "perf",
            level="INFO",
            max_bytes=100*1024*1024,  # 100MB
            backup_count=5
        ),
        "api": LogFileConfig("api_requests"),
        "database": LogFileConfig("db_operations")
    },
    
    # Loggers
    loggers={
        "api": LoggerConfig(
            "mycompany.api",
            level="INFO",
            log_files=["application", "api"],
            propagate=True,
            enabled=True
        ),
        "database": LoggerConfig(
            "mycompany.db",
            level="INFO",
            log_files=["application", "database"]
        ),
        "performance": LoggerConfig(
            "PerformanceLogger",
            level="INFO",
            log_files=["performance"],
            propagate=False
        )
    },
    
    # External loggers
    external_loggers={
        "uvicorn": "INFO",
        "sqlalchemy.engine": "WARNING"
    }
)

sherlock_ai(config)
```

## Configuration Components

### LoggingConfig Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `logs_dir` | str | "logs" | Directory for log files |
| `log_format` | str | Standard format | Log message format string |
| `date_format` | str | "%Y-%m-%d %H:%M:%S" | Date format for timestamps |
| `console_enabled` | bool | True | Enable console output |
| `console_level` | str/int | INFO | Console log level |
| `root_level` | str/int | INFO | Root logger level |
| `log_files` | dict | Default files | Log file configurations |
| `loggers` | dict | Default loggers | Logger configurations |
| `external_loggers` | dict | {} | External library log levels |

### LogFileConfig Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `filename` | str | Required | Base filename or full path |
| `level` | str/int | INFO | Log level for this file |
| `max_bytes` | int | 10MB | Maximum file size before rotation |
| `backup_count` | int | 5 | Number of backup files to keep |
| `encoding` | str | "utf-8" | File encoding |
| `enabled` | bool | True | Whether this file is enabled |

### LoggerConfig Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | str | Required | Logger name |
| `level` | str/int | INFO | Logger level |
| `log_files` | list | [] | List of log file names |
| `propagate` | bool | True | Propagate to parent loggers |
| `enabled` | bool | True | Whether this logger is enabled |

## Simplified vs Full Path Configuration

### Simplified (Recommended)

Automatic path expansion - just specify base names:

```python
config = LoggingConfig(
    logs_dir="logs",
    log_format_type="json",
    log_files={
        "app": LogFileConfig("application"),      # → logs/application.json
        "errors": LogFileConfig("error_log"),     # → logs/error_log.json
        "api": LogFileConfig("api_requests"),     # → logs/api_requests.json
    }
)
```

### Full Paths

Specify complete file paths:

```python
config = LoggingConfig(
    log_files={
        "app": LogFileConfig("logs/custom/app.log"),
        "errors": LogFileConfig("/var/log/myapp/errors.log")
    }
)
```

## Real-World Examples

### Microservice Configuration

```python
from sherlock_ai import LoggingConfig, LogFileConfig, LoggerConfig, sherlock_ai

config = LoggingConfig(
    logs_dir="service_logs",
    log_format_type="json",  # JSON for log aggregation
    console_level="INFO",
    log_files={
        "app": LogFileConfig("application", max_bytes=100*1024*1024),
        "errors": LogFileConfig("errors", level="ERROR", backup_count=20),
        "api": LogFileConfig("api_requests", backup_count=15),
        "performance": LogFileConfig("performance_metrics"),
    },
    loggers={
        "api": LoggerConfig("service.api", log_files=["app", "api"]),
        "business": LoggerConfig("service.business", log_files=["app"]),
        "performance": LoggerConfig("PerformanceLogger", log_files=["performance"])
    },
    external_loggers={
        "uvicorn": "WARNING",
        "httpx": "WARNING"
    }
)

sherlock_ai(config)
```

### Data Pipeline Configuration

```python
config = LoggingConfig(
    logs_dir="pipeline_logs",
    console_level="INFO",
    log_files={
        "pipeline": LogFileConfig("pipeline", max_bytes=200*1024*1024),
        "errors": LogFileConfig("errors", level="ERROR"),
        "data_quality": LogFileConfig("quality_checks"),
        "performance": LogFileConfig("performance")
    },
    loggers={
        "ingestion": LoggerConfig("pipeline.ingestion", log_files=["pipeline"]),
        "transform": LoggerConfig("pipeline.transform", log_files=["pipeline"]),
        "quality": LoggerConfig("pipeline.quality", log_files=["data_quality"])
    }
)
```

### Web Application Configuration

```python
config = LoggingConfig(
    logs_dir="webapp_logs",
    log_format_type="json",
    console_level="INFO",
    log_files={
        "app": LogFileConfig("application", max_bytes=50*1024*1024),
        "errors": LogFileConfig("errors", level="ERROR"),
        "api": LogFileConfig("api_requests"),
        "security": LogFileConfig("security_events"),
        "performance": LogFileConfig("performance")
    },
    loggers={
        "api": LoggerConfig("webapp.api", log_files=["app", "api"]),
        "auth": LoggerConfig("webapp.auth", log_files=["app", "security"]),
        "db": LoggerConfig("webapp.database", log_files=["app"])
    },
    external_loggers={
        "uvicorn": "INFO",
        "sqlalchemy.engine": "WARNING"
    }
)
```

## Advanced Patterns

### Separate Error Logging

Log errors to multiple destinations:

```python
config = LoggingConfig(
    log_files={
        "app": LogFileConfig("app", level="INFO"),
        "errors": LogFileConfig("errors", level="ERROR"),
        "critical": LogFileConfig("critical", level="CRITICAL")
    }
)
```

### Performance-Only Logger

Isolate performance logs:

```python
config = LoggingConfig(
    loggers={
        "performance": LoggerConfig(
            "PerformanceLogger",
            log_files=["performance"],
            propagate=False  # Don't send to root logger
        )
    }
)
```

### Conditional Configuration

Configure based on conditions:

```python
import os

is_production = os.getenv("ENV") == "production"

config = LoggingConfig(
    console_enabled=not is_production,
    console_level="WARNING" if is_production else "DEBUG",
    log_files={
        "app": LogFileConfig(
            "app",
            max_bytes=100*1024*1024 if is_production else 10*1024*1024,
            backup_count=20 if is_production else 5
        )
    }
)
```

## Configuration Validation

Sherlock AI validates your configuration:

```python
from sherlock_ai import LoggingConfig, LogFileConfig

# This will raise validation errors
try:
    config = LoggingConfig(
        log_files={
            "app": LogFileConfig(
                "app",
                max_bytes=-1,  # ❌ Invalid: must be positive
                backup_count=0  # ❌ Warning: no backups
            )
        }
    )
except ValueError as e:
    print(f"Configuration error: {e}")
```

## Best Practices

### 1. Start Simple

Begin with basic configuration and add complexity as needed:

```python
# Start simple
config = LoggingConfig(
    logs_dir="logs",
    log_files={"app": LogFileConfig("app")}
)

# Add more as needed
config.log_files["errors"] = LogFileConfig("errors", level="ERROR")
config.log_files["api"] = LogFileConfig("api")
```

### 2. Use Meaningful Names

Choose descriptive file and logger names:

```python
# ✅ Good
config = LoggingConfig(
    log_files={
        "application": LogFileConfig("app"),
        "user_activities": LogFileConfig("user_activity"),
        "security_events": LogFileConfig("security")
    }
)

# ❌ Avoid
config = LoggingConfig(
    log_files={
        "log1": LogFileConfig("l1"),
        "log2": LogFileConfig("l2")
    }
)
```

### 3. Plan File Sizes

Consider your logging volume:

```python
# High-traffic application
config = LoggingConfig(
    log_files={
        "app": LogFileConfig(
            "app",
            max_bytes=100*1024*1024,  # 100MB
            backup_count=20            # 2GB total
        )
    }
)

# Low-traffic application
config = LoggingConfig(
    log_files={
        "app": LogFileConfig(
            "app",
            max_bytes=10*1024*1024,   # 10MB
            backup_count=5             # 50MB total
        )
    }
)
```

### 4. External Logger Management

Control third-party library logging:

```python
config = LoggingConfig(
    external_loggers={
        "uvicorn": "INFO",           # Keep uvicorn logs
        "httpx": "WARNING",          # Reduce httpx verbosity
        "sqlalchemy.engine": "ERROR", # Only SQL errors
        "boto3": "CRITICAL"          # Silence AWS SDK
    }
)
```

## Next Steps

- [Configuration Presets](presets.md) - Start with presets
- [JSON Logging](json-logging.md) - Use JSON format
- [Log Management](log-management.md) - Manage files and rotation
- [API Reference](../api-reference/configuration.md) - Complete API documentation

