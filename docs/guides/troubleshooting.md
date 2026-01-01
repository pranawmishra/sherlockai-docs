# Troubleshooting

Common issues and solutions for Sherlock AI.

## Installation Issues

### Import Error

**Problem:** `ModuleNotFoundError: No module named 'sherlock_ai'`

**Solution:**
```bash
pip install sherlock-ai
# or
pip install --upgrade sherlock-ai
```

### Dependencies Missing

**Problem:** Missing dependencies for optional features

**Solution:**
```bash
# For MongoDB support
pip install pymongo

# For code analysis
pip install astor groq

# For API client
pip install requests
```

## Configuration Issues

### Logs Not Created

**Problem:** Log files not appearing in logs directory

**Solution:**
1. Check directory permissions
2. Verify configuration:
```python
from sherlock_ai import get_logging_stats
stats = get_logging_stats()
print(stats)
```

### Duplicate Logs

**Problem:** Seeing duplicate log entries

**Solution:**
- Don't call `sherlock_ai()` multiple times
- In FastAPI with reload, initialize only once

### Auto-Instrumentation Not Working

**Problem:** FastAPI routes not being monitored

**Solution:**
```python
# Initialize BEFORE creating app
logging_manager = SherlockAI(config=config)
logging_manager.setup()

# THEN create app
app = FastAPI()
```

## Monitoring Issues

### Performance Logs Missing

**Problem:** No performance logs appearing

**Solution:**
- Ensure `@log_performance` decorator is applied
- Check that performance log file is enabled:
```python
config = get_current_config()
print(config.log_files["performance"].enabled)
```

### Memory Monitoring Not Detailed

**Problem:** Memory logs don't show traced memory

**Solution:**
```python
# Enable tracemalloc
@monitor_memory(trace_malloc=True)
def my_function():
    pass
```

## Storage Issues

### MongoDB Connection Failed

**Problem:** Error insights not being stored

**Solution:**
```python
import os
from sherlock_ai.storage import MongoManager

os.environ["MONGO_URI"] = "mongodb://localhost:27017"

# Verify connection
mongo = MongoManager()
print(f"MongoDB enabled: {mongo.enabled}")
```

### API Client Authentication Failed

**Problem:** HTTP 401 when sending insights

**Solution:**
```python
import os

# Set API key
os.environ["SHERLOCK_AI_API_KEY"] = "your-valid-api-key"

# Verify
print(os.getenv("SHERLOCK_AI_API_KEY"))
```

## Performance Issues

### High Memory Usage

**Problem:** tracemalloc causing high memory usage

**Solution:**
```python
# Disable tracemalloc in production
@monitor_memory(trace_malloc=False)
def my_function():
    pass
```

### Slow Performance

**Problem:** Monitoring adds too much overhead

**Solution:**
1. Use `min_duration` to reduce logging:
```python
@log_performance(min_duration=0.1)  # Only log > 100ms
def frequent_function():
    pass
```

2. Disable unused monitoring:
```python
config = LoggingConfig()
config.log_files["api"].enabled = False
config.log_files["services"].enabled = False
```

## File System Issues

### Disk Space Full

**Problem:** Running out of disk space

**Solution:**
1. Reduce log file sizes:
```python
config.log_files["app"].max_bytes = 10*1024*1024  # 10MB
config.log_files["app"].backup_count = 3
```

2. Clean up old logs:
```bash
find /var/log/myapp -name "*.log.*" -mtime +7 -delete
```

### Permission Denied

**Problem:** Cannot write to logs directory

**Solution:**
```bash
# Fix permissions
sudo chown -R your_user:your_group /var/log/myapp
sudo chmod -R 755 /var/log/myapp
```

## Getting Help

If you encounter issues not covered here:

1. Check the [GitHub Issues](https://github.com/pranawmishra/sherlock-ai/issues)
2. Enable debug logging:
```python
config = LoggingConfig(console_level="DEBUG")
```
3. Check logging statistics:
```python
from sherlock_ai import get_logging_stats
print(get_logging_stats())
```

