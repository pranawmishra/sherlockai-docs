# Classes Reference

Complete reference for all Sherlock AI classes.

## SherlockAI

Advanced logging management class.

**Constructor:**
```python
SherlockAI(config: Optional[LoggingConfig] = None)
```

**Methods:**

### setup(format_type="log")
Set up logging configuration.
```python
logger_manager = SherlockAI()
logger_manager.setup("json")
```

### reconfigure(new_config)
Change configuration without restart.
```python
logger_manager.reconfigure(new_config)
```

### cleanup()
Clean up handlers and resources.
```python
logger_manager.cleanup()
```

### get_stats()
Get current logging statistics.
```python
stats = logger_manager.get_stats()
```

## CodeAnalyzer

Code analysis utilities.

**Constructor:**
```python
CodeAnalyzer(api_key: Optional[str] = None, constants_file: str = "constants.py")
```

**Methods:**

### detect_hardcoded_values(source_code)
Detect hardcoded values in source code.
```python
values = analyzer.detect_hardcoded_values(source)
```

### suggest_constant_name(value, value_type, context)
Suggest constant name for a value.
```python
name = analyzer.suggest_constant_name("https://api.com", "url", "fetch_data")
```

## MongoManager

MongoDB storage management.

**Constructor:**
```python
MongoManager(mongo_uri: Optional[str] = None)
```

**Methods:**

### save(data)
Save data to MongoDB.
```python
mongo.save(error_data)
```

**Properties:**

### enabled
Check if MongoDB is configured.
```python
if mongo.enabled:
    mongo.save(data)
```

## ApiClient

HTTP client for data ingestion.

**Constructor:**
```python
ApiClient()  # Uses environment variables
```

**Methods:**

### post_error_insights(data)
Send error insights to backend.
```python
api_client.post_error_insights(error_data)
```

### post_performance_insights(data)
Send performance insights to backend.
```python
api_client.post_performance_insights(perf_data)
```

## ResourceMonitor

Resource monitoring utilities.

**Static Methods:**

### capture_resources()
Capture current resource snapshot.
```python
snapshot = ResourceMonitor.capture_resources()
```

### capture_memory()
Capture memory snapshot.
```python
memory = ResourceMonitor.capture_memory()
```

### format_bytes(bytes_val)
Format bytes in human-readable format.
```python
formatted = ResourceMonitor.format_bytes(1024*1024*512)  # "512.00MB"
```

