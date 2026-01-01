# Configuration Reference

Complete reference for configuration classes.

## LoggingConfig

Main configuration class.

**Parameters:**
- `logs_dir` (str, default="logs"): Directory for log files
- `log_format` (str): Log message format string
- `date_format` (str, default="%Y-%m-%d %H:%M:%S"): Date format
- `console_enabled` (bool, default=True): Enable console output
- `console_level` (str/int, default=INFO): Console log level
- `root_level` (str/int, default=INFO): Root logger level
- `log_format_type` (str, default="log"): "log" or "json"
- `log_files` (dict): Log file configurations
- `loggers` (dict): Logger configurations
- `external_loggers` (dict): External library log levels

## LogFileConfig

Log file configuration.

**Parameters:**
- `filename` (str, required): Base filename or full path
- `level` (str/int, default=INFO): Log level
- `max_bytes` (int, default=10MB): Max file size before rotation
- `backup_count` (int, default=5): Number of backups to keep
- `encoding` (str, default="utf-8"): File encoding
- `enabled` (bool, default=True): Whether file is enabled

## LoggerConfig

Logger configuration.

**Parameters:**
- `name` (str, required): Logger name
- `level` (str/int, default=INFO): Logger level
- `log_files` (list): List of log file names
- `propagate` (bool, default=True): Propagate to parent
- `enabled` (bool, default=True): Whether logger is enabled

## LoggingPresets

Pre-configured setups.

**Methods:**

### development()
Development environment preset.
```python
config = LoggingPresets.development()
```

### production()
Production environment preset.
```python
config = LoggingPresets.production()
```

### minimal()
Minimal setup preset.
```python
config = LoggingPresets.minimal()
```

### performance_only()
Performance monitoring only.
```python
config = LoggingPresets.performance_only()
```

### custom_files(file_configs)
Custom file names.
```python
config = LoggingPresets.custom_files({
    "app": "logs/application.log",
    "errors": "logs/errors.log"
})
```

