# Log Management

Manage log files, rotation, sizing, and cleanup with Sherlock AI's flexible log management features.

## File Rotation

### Automatic Rotation

Log files automatically rotate when they reach the configured size:

```python
from sherlock_ai import LoggingConfig, LogFileConfig, sherlock_ai

config = LoggingConfig(
    log_files={
        "app": LogFileConfig(
            "app",
            max_bytes=10*1024*1024,  # Rotate at 10MB
            backup_count=5            # Keep 5 backup files
        )
    }
)

sherlock_ai(config)
```

**Result:**
```
logs/
├── app.log          # Current log file
├── app.log.1        # Most recent backup
├── app.log.2
├── app.log.3
├── app.log.4
└── app.log.5        # Oldest backup (will be deleted on next rotation)
```

### Custom Rotation Settings

Different rotation settings for different log files:

```python
config = LoggingConfig(
    log_files={
        "app": LogFileConfig(
            "app",
            max_bytes=50*1024*1024,   # 50MB
            backup_count=10
        ),
        "errors": LogFileConfig(
            "errors",
            level="ERROR",
            max_bytes=25*1024*1024,   # 25MB (errors are typically smaller)
            backup_count=20           # Keep more error history
        ),
        "performance": LogFileConfig(
            "performance",
            max_bytes=100*1024*1024,  # 100MB (lots of performance data)
            backup_count=5
        )
    }
)
```

## Enable/Disable Log Files

### At Initialization

```python
config = LoggingConfig(
    log_files={
        "app": LogFileConfig("app", enabled=True),
        "api": LogFileConfig("api", enabled=False),      # Disabled
        "services": LogFileConfig("services", enabled=False)  # Disabled
    }
)
```

### Runtime Configuration

```python
from sherlock_ai import LoggingConfig, sherlock_ai

# Start with default configuration
config = LoggingConfig()

# Disable specific log files
config.log_files["api"].enabled = False
config.log_files["services"].enabled = False

# Enable errors with higher retention
config.log_files["errors"].enabled = True
config.log_files["errors"].backup_count = 15

# Apply the modified configuration
sherlock_ai(config)
```

## Log Levels

### Per-File Log Levels

```python
config = LoggingConfig(
    log_files={
        "app": LogFileConfig("app", level="INFO"),
        "errors": LogFileConfig("errors", level="ERROR"),  # Only errors
        "debug": LogFileConfig("debug", level="DEBUG"),    # Everything
        "performance": LogFileConfig("performance", level="INFO")
    }
)
```

### Console vs File Levels

```python
config = LoggingConfig(
    console_level="WARNING",  # Only warnings and errors to console
    log_files={
        "app": LogFileConfig("app", level="INFO")  # All info+ to file
    }
)
```

## Custom Log Directories

### Single Directory

```python
config = LoggingConfig(
    logs_dir="application_logs",
    log_files={
        "app": LogFileConfig("app"),
        "errors": LogFileConfig("errors", level="ERROR")
    }
)
# Creates: application_logs/app.log, application_logs/errors.log
```

### Multiple Directories

```python
config = LoggingConfig(
    log_files={
        "app": LogFileConfig("logs/app.log"),
        "errors": LogFileConfig("errors/critical.log"),
        "api": LogFileConfig("/var/log/myapp/api.log")  # Absolute path
    }
)
```

## Disk Space Management

### Calculate Log Space Usage

```python
import os

def get_log_directory_size(logs_dir="logs"):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(logs_dir):
        for filename in filenames:
            filepath = os.path.join(dirpath, filename)
            total_size += os.path.getsize(filepath)
    return total_size

# Get size in MB
size_mb = get_log_directory_size() / (1024 * 1024)
print(f"Log directory size: {size_mb:.2f}MB")
```

### Plan Storage Requirements

```python
# Calculate maximum disk usage
def calculate_max_log_usage(config):
    total_size = 0
    for log_file in config.log_files.values():
        if log_file.enabled:
            # Current file + all backups
            max_size = log_file.max_bytes * (log_file.backup_count + 1)
            total_size += max_size
    return total_size

# Example
config = LoggingConfig(
    log_files={
        "app": LogFileConfig("app", max_bytes=50*1024*1024, backup_count=10),
        "errors": LogFileConfig("errors", max_bytes=25*1024*1024, backup_count=20)
    }
)

max_usage = calculate_max_log_usage(config)
print(f"Maximum disk usage: {max_usage / (1024*1024):.2f}MB")
# Output: Maximum disk usage: 1075.00MB (50MB * 11 + 25MB * 21)
```

## Log File Cleanup

### Manual Cleanup

```python
import os
import glob
from datetime import datetime, timedelta

def cleanup_old_logs(logs_dir="logs", days_old=30):
    """Delete log files older than specified days."""
    cutoff = datetime.now() - timedelta(days=days_old)
    
    for log_file in glob.glob(f"{logs_dir}/*.log*"):
        file_time = datetime.fromtimestamp(os.path.getmtime(log_file))
        if file_time < cutoff:
            os.remove(log_file)
            print(f"Deleted: {log_file}")

# Clean up logs older than 30 days
cleanup_old_logs(days_old=30)
```

### Archive Old Logs

```python
import shutil
from datetime import datetime

def archive_logs(logs_dir="logs", archive_dir="logs/archive"):
    """Archive logs to a separate directory."""
    os.makedirs(archive_dir, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    archive_name = f"logs_archive_{timestamp}"
    shutil.make_archive(archive_name, 'zip', logs_dir)
    shutil.move(f"{archive_name}.zip", archive_dir)
    
    print(f"Archived to: {archive_dir}/{archive_name}.zip")

# Create archive
archive_logs()
```

## Environment-Specific Settings

### Development

```python
dev_config = LoggingConfig(
    logs_dir="dev_logs",
    log_files={
        "app": LogFileConfig(
            "app",
            max_bytes=10*1024*1024,  # 10MB (smaller for dev)
            backup_count=3           # Fewer backups
        ),
        "errors": LogFileConfig("errors", level="ERROR")
    }
)
```

### Production

```python
prod_config = LoggingConfig(
    logs_dir="/var/log/myapp",
    log_files={
        "app": LogFileConfig(
            "app",
            max_bytes=100*1024*1024,  # 100MB
            backup_count=20           # More history
        ),
        "errors": LogFileConfig(
            "errors",
            level="ERROR",
            max_bytes=50*1024*1024,
            backup_count=30
        ),
        "performance": LogFileConfig(
            "performance",
            max_bytes=200*1024*1024,
            backup_count=15
        )
    }
)
```

## Best Practices

### 1. Plan Disk Usage

Calculate maximum disk usage before deployment:

```python
# High-traffic application
config = LoggingConfig(
    log_files={
        "app": LogFileConfig("app", max_bytes=100*1024*1024, backup_count=20),
        # Maximum: 2.1GB (100MB * 21)
    }
)
```

### 2. Separate Error Logs

Keep errors in dedicated files with longer retention:

```python
config = LoggingConfig(
    log_files={
        "app": LogFileConfig("app", backup_count=5),
        "errors": LogFileConfig("errors", level="ERROR", backup_count=30)
    }
)
```

### 3. Performance Log Rotation

Performance logs can be large - configure appropriately:

```python
config = LoggingConfig(
    log_files={
        "performance": LogFileConfig(
            "performance",
            max_bytes=200*1024*1024,  # 200MB
            backup_count=10           # 2GB total
        )
    }
)
```

### 4. Disable Unused Logs

Save disk space by disabling unnecessary log files:

```python
config = LoggingConfig()
config.log_files["api"].enabled = False
config.log_files["services"].enabled = False
config.log_files["database"].enabled = False
```

### 5. Use Monitoring

Monitor log file sizes and rotation:

```python
import os

def check_log_health(logs_dir="logs"):
    for filename in os.listdir(logs_dir):
        filepath = os.path.join(logs_dir, filename)
        size = os.path.getsize(filepath)
        size_mb = size / (1024 * 1024)
        print(f"{filename}: {size_mb:.2f}MB")

check_log_health()
```

## Troubleshooting

### Logs Not Rotating

If logs aren't rotating:

1. Check max_bytes setting
2. Verify write permissions
3. Ensure backup_count > 0

### Disk Space Issues

If running out of disk space:

1. Reduce max_bytes or backup_count
2. Disable unused log files
3. Implement automatic cleanup
4. Archive old logs to external storage

### Missing Log Files

If log files aren't created:

1. Check directory permissions
2. Verify logs_dir exists
3. Ensure enabled=True
4. Check for configuration errors

## Next Steps

- [Configuration Presets](presets.md) - Pre-configured setups
- [Custom Configuration](custom-config.md) - Build custom configs
- [JSON Logging](json-logging.md) - Use JSON format
- [Production Deployment](../guides/production-deployment.md) - Deploy to production

