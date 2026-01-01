# JSON Logging

Sherlock AI supports structured JSON logging for better log parsing, analysis, and integration with log aggregation systems. JSON format makes it easy to query, filter, and analyze logs programmatically.

## Enabling JSON Format

### Function-Based API

```python
from sherlock_ai import sherlock_ai

# Enable JSON format (creates .json files)
sherlock_ai(format_type="json")
```

### Class-Based API

```python
from sherlock_ai import SherlockAI

logger_manager = SherlockAI()
logger_manager.setup("json")  # Creates app.json, errors.json, etc.
```

### Configuration Object

```python
from sherlock_ai import LoggingConfig, sherlock_ai

config = LoggingConfig(
    log_format_type="json",  # or "log" for standard format
    logs_dir="json_logs"
)

sherlock_ai(config)
```

## Log Output Comparison

### Standard Format

```
2025-07-15 20:51:19 - aa580b62 - ApiLogger - INFO - Request started
2025-07-15 20:51:19 - aa580b62 - PerformanceLogger - INFO - PERFORMANCE | myapp.api_call | SUCCESS | 0.234s
```

### JSON Format

```json
{"timestamp": "2025-07-15 20:51:19", "level": "INFO", "logger": "ApiLogger", "message": "Request started", "request_id": "aa580b62", "module": "myapp", "function": "api_call", "line": 42, "thread": 13672, "thread_name": "MainThread", "process": 22008}

{"timestamp": "2025-07-15 20:51:19", "level": "INFO", "logger": "PerformanceLogger", "message": "PERFORMANCE | myapp.api_call | SUCCESS | 0.234s", "request_id": "aa580b62", "module": "performance", "function": "log_performance", "line": 89, "thread": 13672, "thread_name": "MainThread", "process": 22008}
```

## JSON Log Structure

Each JSON log entry contains:

```json
{
  "timestamp": "2025-07-15 20:51:19",
  "level": "INFO",
  "logger": "ApiLogger",
  "message": "Request started",
  "request_id": "aa580b62",
  "module": "myapp",
  "function": "api_call",
  "line": 42,
  "thread": 13672,
  "thread_name": "MainThread",
  "process": 22008
}
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `timestamp` | string | ISO format timestamp |
| `level` | string | Log level (INFO, DEBUG, WARNING, ERROR, CRITICAL) |
| `logger` | string | Logger name |
| `message` | string | Log message content |
| `request_id` | string | Request ID (if set) |
| `module` | string | Module name where log originated |
| `function` | string | Function name where log originated |
| `line` | integer | Line number in source file |
| `thread` | integer | Thread ID |
| `thread_name` | string | Thread name |
| `process` | integer | Process ID |

## Reading JSON Logs

### Python

```python
import json

def load_json_logs(filename):
    logs = []
    with open(filename, 'r') as f:
        for line in f:
            if line.strip():
                logs.append(json.loads(line.strip()))
    return logs

# Usage
logs = load_json_logs('logs/api.json')
for log in logs:
    print(f"[{log['timestamp']}] {log['level']}: {log['message']}")
```

### Filtering Logs

```python
# Filter by level
errors = [log for log in logs if log['level'] == 'ERROR']

# Filter by request_id
request_logs = [log for log in logs if log['request_id'] == 'aa580b62']

# Filter by time range
from datetime import datetime
start_time = datetime(2025, 7, 15, 20, 0, 0)
time_filtered = [
    log for log in logs 
    if datetime.strptime(log['timestamp'], '%Y-%m-%d %H:%M:%S') >= start_time
]
```

### Aggregation

```python
from collections import Counter

# Count logs by level
level_counts = Counter(log['level'] for log in logs)
print(f"Errors: {level_counts['ERROR']}")
print(f"Warnings: {level_counts['WARNING']}")

# Count logs by logger
logger_counts = Counter(log['logger'] for log in logs)
for logger, count in logger_counts.most_common():
    print(f"{logger}: {count}")
```

## Integration with Log Aggregation

### Elasticsearch

```python
from elasticsearch import Elasticsearch
import json

es = Elasticsearch(['localhost:9200'])

# Index logs
with open('logs/app.json', 'r') as f:
    for line in f:
        if line.strip():
            log = json.loads(line)
            es.index(index='sherlock-logs', document=log)
```

### Splunk

```python
import requests
import json

SPLUNK_URL = "http://localhost:8088/services/collector"
SPLUNK_TOKEN = "your-hec-token"

with open('logs/app.json', 'r') as f:
    for line in f:
        if line.strip():
            log = json.loads(line)
            requests.post(
                SPLUNK_URL,
                headers={"Authorization": f"Splunk {SPLUNK_TOKEN}"},
                json={"event": log}
            )
```

### CloudWatch Logs

```python
import boto3
import json
import time

logs_client = boto3.client('logs')
log_group = '/aws/sherlock-ai'
log_stream = 'application'

with open('logs/app.json', 'r') as f:
    log_events = []
    for line in f:
        if line.strip():
            log = json.loads(line)
            log_events.append({
                'timestamp': int(time.time() * 1000),
                'message': json.dumps(log)
            })
    
    logs_client.put_log_events(
        logGroupName=log_group,
        logStreamName=log_stream,
        logEvents=log_events
    )
```

## JSON with Monitoring

### Performance Monitoring

```json
{
  "timestamp": "2025-07-15 20:51:19",
  "level": "INFO",
  "logger": "PerformanceLogger",
  "message": "PERFORMANCE | myapp.api_call | SUCCESS | 0.234s",
  "request_id": "aa580b62",
  "module": "performance",
  "function": "log_performance",
  "line": 89
}
```

### Memory Monitoring

```json
{
  "timestamp": "2025-07-15 20:51:19",
  "level": "INFO",
  "logger": "MonitoringLogger",
  "message": "MEMORY | myapp.process_data | SUCCESS | 0.245s | Current: 45.67MB | Change: +12.34MB | Traced: 38.92MB (Peak: 52.18MB)",
  "request_id": "aa580b62",
  "module": "monitoring",
  "function": "monitor_memory"
}
```

### Resource Monitoring

```json
{
  "timestamp": "2025-07-15 20:51:19",
  "level": "INFO",
  "logger": "MonitoringLogger",
  "message": "RESOURCES | myapp.api_handler | SUCCESS | 0.156s | CPU: 25.4% | Memory: 128.45MB (+5.23MB) | Threads: 12 | I/O: R:2.34MB W:1.12MB",
  "request_id": "aa580b62",
  "module": "monitoring",
  "function": "monitor_resources"
}
```

## Configuration Examples

### Production with JSON

```python
from sherlock_ai import LoggingConfig, LogFileConfig, sherlock_ai

config = LoggingConfig(
    logs_dir="production_logs",
    log_format_type="json",  # JSON format
    console_level="INFO",
    log_files={
        "app": LogFileConfig("application", max_bytes=100*1024*1024),
        "errors": LogFileConfig("errors", level="ERROR", backup_count=20),
        "performance": LogFileConfig("performance", backup_count=15)
    }
)

sherlock_ai(config)

# Creates:
# production_logs/application.json
# production_logs/errors.json
# production_logs/performance.json
```

### Development with JSON

```python
from sherlock_ai import LoggingPresets, sherlock_ai

# Use development preset with JSON format
config = LoggingPresets.development()
config.log_format_type = "json"

sherlock_ai(config)
```

## Parsing Performance Logs

Extract performance metrics from JSON logs:

```python
import json
import statistics

def analyze_performance(log_file):
    durations = []
    errors = 0
    
    with open(log_file, 'r') as f:
        for line in f:
            if line.strip():
                log = json.loads(line)
                if log['logger'] == 'PerformanceLogger':
                    # Extract duration from message
                    # Format: "PERFORMANCE | function | STATUS | 0.234s"
                    parts = log['message'].split('|')
                    status = parts[2].strip()
                    duration_str = parts[3].strip().rstrip('s')
                    duration = float(duration_str)
                    
                    durations.append(duration)
                    if status == 'ERROR':
                        errors += 1
    
    return {
        'count': len(durations),
        'errors': errors,
        'avg': statistics.mean(durations) if durations else 0,
        'median': statistics.median(durations) if durations else 0,
        'min': min(durations) if durations else 0,
        'max': max(durations) if durations else 0
    }

# Usage
stats = analyze_performance('logs/performance.json')
print(f"Total requests: {stats['count']}")
print(f"Errors: {stats['errors']}")
print(f"Average duration: {stats['avg']:.3f}s")
print(f"Median duration: {stats['median']:.3f}s")
```

## Best Practices

### 1. Use JSON for Production

JSON is ideal for production environments:

```python
import os

if os.getenv("ENV") == "production":
    config = LoggingConfig(log_format_type="json")
else:
    config = LoggingConfig(log_format_type="log")
```

### 2. Structured Log Aggregation

Use JSON with log aggregation tools:

```python
# Optimized for Elasticsearch, Splunk, etc.
config = LoggingConfig(
    log_format_type="json",
    logs_dir="/var/log/myapp"
)
```

### 3. Performance Analysis

Parse JSON logs for performance insights:

```python
# Easy to parse and analyze
logs = load_json_logs('logs/performance.json')
slow_requests = [log for log in logs if '| SUCCESS |' in log['message'] and float(log['message'].split('|')[-1].strip().rstrip('s')) > 1.0]
```

### 4. Request Tracing

Use request_id for distributed tracing:

```python
# Filter by request ID
def get_request_trace(logs, request_id):
    return [log for log in logs if log.get('request_id') == request_id]

trace = get_request_trace(logs, 'aa580b62')
for log in trace:
    print(f"{log['timestamp']} - {log['logger']} - {log['message']}")
```

## Advantages of JSON Format

1. **Machine Readable**: Easy to parse programmatically
2. **Structured Data**: Consistent field structure
3. **Query-Friendly**: Simple to filter and aggregate
4. **Integration**: Works with log aggregation tools
5. **Analysis**: Statistical analysis is straightforward
6. **Debugging**: Quick filtering by request ID or other fields

## Next Steps

- [Log Management](log-management.md) - Manage JSON log files
- [Examples](../examples/index.md) - See JSON logging in action
- [Advanced](../advanced/introspection.md) - Query logging configuration
- [API Reference](../api-reference/configuration.md) - Configuration API

