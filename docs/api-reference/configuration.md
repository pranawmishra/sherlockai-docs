# Configuration Reference

Complete reference for configuration classes.

## LoggingConfig

Main configuration class.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `logs_dir` | str | `"logs"` | Directory for log files |
| `log_format_type` | str | `"json"` | `"json"` for JSON format, `"log"` for text format |
| `log_format` | str | Standard format | Log message format string (text format only) |
| `date_format` | str | `"%Y-%m-%d %H:%M:%S"` | Date format for timestamps |
| `console_enabled` | bool | `True` | Enable console output |
| `console_level` | str/int | `INFO` | Console log level |
| `root_level` | str/int | `INFO` | Root logger level |
| `auto_instrument` | bool | `True` | Auto-instrument FastAPI routes |
| `auto_trace_functions` | bool | `False` | Trace all function calls automatically |
| `auto_frameworks` | list | `["fastapi"]` | Frameworks to auto-instrument |
| `auto_exclude_modules` | list | `["sys","os","logging"]` | Modules excluded from function tracing |
| `auto_min_duration` | float | `0.0` | Min duration (s) for auto-traced function logs |
| `monitor_resources` | bool | `False` | Enable resource monitoring globally |
| `monitor_memory` | bool | `False` | Enable memory monitoring globally |
| `log_performance_enabled` | bool | `True` | Enable performance logging |
| `performance_insights` | bool | `True` | Enable AI-powered performance insights |
| `log_files` | dict | Default files | Map of log file key → `LogFileConfig` |
| `loggers` | dict | Default loggers | Map of logger key → `LoggerConfig` |
| `external_loggers` | dict | `{}` | External library log levels (e.g. `{"uvicorn": "WARNING"}`) |

### Default log files

When `log_files` is not provided, these files are created automatically (extension determined by `log_format_type`):

| Key | Filename | Level | Logger |
|-----|----------|-------|--------|
| `app` | `app.json` / `app.log` | INFO | Root logger |
| `errors` | `errors.json` / `errors.log` | ERROR | All loggers |
| `performance` | `performance.json` / `performance.log` | INFO | `PerformanceLogger` |
| `monitoring` | `monitoring.json` / `monitoring.log` | INFO | `MonitoringLogger` |
| `error_insights` | `error_insights.json` / `error_insights.log` | INFO | `ErrorInsightsLogger` |
| `performance_insights` | `performance_insights.json` / `performance_insights.log` | INFO | `PerformanceInsightsLogger` |

### Filename auto-expansion

If a `LogFileConfig.filename` has no path separator, it is automatically expanded to `{logs_dir}/{filename}{extension}` where `extension` is `.json` or `.log` based on `log_format_type`.

---

## LogFileConfig

Log file configuration.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `filename` | str | required | Base filename or full path |
| `level` | str/int | `INFO` | Log level for this file |
| `max_bytes` | int | `10 * 1024 * 1024` (10 MB) | Maximum file size before rotation |
| `backup_count` | int | `5` | Number of rotated backup files to keep |
| `encoding` | str | `"utf-8"` | File encoding |
| `enabled` | bool | `True` | Whether this file is active |

---

## LoggerConfig

Individual logger configuration.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | str | required | Logger name (used with `logging.getLogger(name)`) |
| `level` | str/int | `INFO` | Logger level |
| `log_files` | list | `[]` | List of `log_files` keys this logger writes to |
| `propagate` | bool | `True` | Propagate messages to parent loggers |
| `enabled` | bool | `True` | Whether this logger is active |

---

## SherlockAI

Main class for setting up and managing the logging framework.

```python
from sherlock_ai import SherlockAI, LoggingConfig

logger_manager = SherlockAI(config=LoggingConfig(...))
logger_manager.setup()
```

### Methods

#### `__init__(config=None)`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `config` | `LoggingConfig` | `None` | Configuration to use. Defaults to `LoggingConfig()` if not provided. |

#### `setup() → LoggingConfig`

Applies the configuration: creates log directory, sets up file handlers, attaches error capture, and optionally enables auto-instrumentation.

Returns the `LoggingConfig` that was applied.

#### `reconfigure(new_config: LoggingConfig)`

Tears down existing handlers and applies `new_config` — no restart needed.

#### `cleanup()`

Closes all handlers and resets the logging setup.

#### `get_stats() → dict`

Returns a snapshot of the current logging state:

```python
{
    "is_configured": True,
    "handlers": ["console", "app", "errors", "performance", ...],
    "log_files": ["app", "errors", "performance", ...],
    "logs_dir": "logs",
    "console_enabled": True,
    "format_type": "json"
}
```

#### `get_instance() → SherlockAI` _(classmethod)_

Returns (or creates) the global singleton instance.

---

## Module-Level Helpers

### `get_logger(name=None) → logging.Logger`

Returns a standard `logging.Logger`. Pass `__name__` for module-scoped loggers or a `LoggerNames` constant for a named logger.

### `get_current_config() → LoggingConfig | None`

Returns the `LoggingConfig` of the singleton instance if it has been set up, otherwise `None`.

### `get_logging_stats() → dict`

Convenience wrapper around `SherlockAI.get_instance().get_stats()`.

---

## LoggerNames

Constants for the built-in logger names:

```python
from sherlock_ai import LoggerNames

LoggerNames.API                  # "ApiLogger"
LoggerNames.DATABASE             # "DatabaseLogger"
LoggerNames.SERVICES             # "ServiceLogger"
LoggerNames.PERFORMANCE          # "PerformanceLogger"
LoggerNames.MONITORING           # "MonitoringLogger"
LoggerNames.ERRORINSIGHTS        # "ErrorInsightsLogger"
LoggerNames.PERFORMANCEINSIGHTS  # "PerformanceInsightsLogger"
LoggerNames.AUTO_INSTRUMENTATION # "AutoInstrumentationLogger"
```

Use with `get_logger()`:

```python
from sherlock_ai import get_logger, LoggerNames

perf_logger = get_logger(LoggerNames.PERFORMANCE)
```

### `list_available_loggers() → list[str]`

Returns all `LoggerNames` values as a list.
