# Log Output Format

Understanding Sherlock AI's log output formats and structure.

## Standard Log Format

The default log format follows this pattern:

```
{timestamp} - {request_id} - {logger_name} - {log_level} - {message}
```

### Example

```
2025-07-15 20:51:19 - aa580b62 - ApiLogger - INFO - Request started
```

### Components

- **timestamp**: Date and time (`%Y-%m-%d %H:%M:%S`)
- **request_id**: Request ID (or `-` if not set)
- **logger_name**: Name of the logger
- **log_level**: INFO, DEBUG, WARNING, ERROR, CRITICAL
- **message**: The log message content

## JSON Log Format

Structured JSON format for better parsing and analysis:

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

## Performance Logs

### Standard Format

```
PERFORMANCE | {function_name} | {STATUS} | {execution_time}s | {additional_info}
```

### Examples

```
2025-07-05 19:19:11 - 07ca74ed - PerformanceLogger - INFO - PERFORMANCE | tests.test_fastapi.health_check | SUCCESS | 0.262s

2025-07-05 21:13:03 - 2c4774b0 - PerformanceLogger - INFO - PERFORMANCE | my_module.api_call | ERROR | 2.456s | Connection timeout

2025-07-05 19:20:15 - - - PerformanceLogger - INFO - PERFORMANCE | database_query | SUCCESS | 0.089s | Args: ('user123',) | Kwargs: {'limit': 10}
```

### With Arguments

When `include_args=True`:

```
PERFORMANCE | my_module.slow_query | SUCCESS | 0.156s | Args: ('user123',) | Kwargs: {'limit': 10}
```

## Memory Monitoring Logs

### Format

```
MEMORY | {function_name} | {STATUS} | {execution_time}s | Current: {current_memory} | Change: {memory_change} | Traced: {traced_memory} (Peak: {peak_memory})
```

### Examples

```
2025-07-05 19:19:11 - 07ca74ed - MonitoringLogger - INFO - MEMORY | tests.test_fastapi.health_check | SUCCESS | 0.261s | Current: 57.66MB | Change: +1.64MB | Traced: 24.33KB (Peak: 30.33KB)

2025-07-05 21:15:22 - - - MonitoringLogger - INFO - MEMORY | data_processor | SUCCESS | 0.245s | Current: 45.67MB | Change: +12.34MB

2025-07-05 19:20:15 - 2c4774b0 - MonitoringLogger - INFO - MEMORY | load_large_file | SUCCESS | 2.156s | Current: 256.89MB | Change: +128.45MB | Traced: 125.67MB (Peak: 145.23MB)
```

### Components

- **Current**: Total process memory (RSS)
- **Change**: Memory difference during execution
- **Traced**: Python object memory (when `trace_malloc=True`)
- **Peak**: Peak memory during execution

## Resource Monitoring Logs

### Format

```
RESOURCES | {function_name} | {STATUS} | {execution_time}s | CPU: {cpu_percent}% | Memory: {memory_usage} ({memory_change}) | Threads: {thread_count} | I/O: R:{read_bytes} W:{write_bytes} | Network: Sent:{sent_bytes} Recv:{recv_bytes}
```

### Examples

```
2025-07-05 19:19:11 - 07ca74ed - MonitoringLogger - INFO - RESOURCES | tests.test_fastapi.health_check | SUCCESS | 0.144s | CPU: 59.3% | Memory: 57.66MB (+1.63MB) | Threads: 9 | I/O: R:0.00B W:414.00B

2025-07-05 21:13:03 - 2c4774b0 - MonitoringLogger - INFO - RESOURCES | api_handler | SUCCESS | 0.156s | CPU: 25.4% | Memory: 128.45MB (+5.23MB) | Threads: 12 | I/O: R:2.34MB W:1.12MB

2025-07-05 19:25:30 - - - MonitoringLogger - INFO - RESOURCES | database_query | SUCCESS | 0.089s | CPU: 15.2% | Memory: 95.67MB (+0.12MB) | Threads: 8

2025-07-05 20:15:45 - a1b2c3d4 - MonitoringLogger - INFO - RESOURCES | api_call | SUCCESS | 0.523s | CPU: 10.5% | Memory: 85.34MB (+2.15MB) | Threads: 10 | I/O: R:1.23MB W:0.05MB | Network: Sent:2.34KB Recv:125.67KB
```

### Components

- **CPU**: CPU usage percentage
- **Memory**: Current memory and change
- **Threads**: Number of threads
- **I/O**: Disk read/write (when `include_io=True`)
- **Network**: Network send/receive (when `include_network=True`)

## Request ID in Logs

### With Request ID

```
2025-07-05 19:19:11 - 07ca74ed - PerformanceLogger - INFO - PERFORMANCE | api_call | SUCCESS | 0.234s
```

### Without Request ID

```
2025-07-05 19:19:11 - - - PerformanceLogger - INFO - PERFORMANCE | api_call | SUCCESS | 0.234s
```

## Setting Request IDs

```python
from sherlock_ai import set_request_id

# Auto-generate
request_id = set_request_id()

# Custom ID
request_id = set_request_id("req-12345")
```

## Parsing Logs

### Parse Standard Format

```python
import re

pattern = r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) - ([^ ]+) - ([^ ]+) - (\w+) - (.+)'

with open('logs/app.log', 'r') as f:
    for line in f:
        match = re.match(pattern, line)
        if match:
            timestamp, request_id, logger, level, message = match.groups()
            print(f"Level: {level}, Message: {message}")
```

### Parse JSON Format

```python
import json

with open('logs/app.json', 'r') as f:
    for line in f:
        if line.strip():
            log = json.loads(line)
            print(f"{log['level']}: {log['message']}")
```

### Parse Performance Logs

```python
import re

pattern = r'PERFORMANCE \| ([^ ]+) \| (\w+) \| ([\d.]+)s'

with open('logs/performance.log', 'r') as f:
    for line in f:
        match = re.search(pattern, line)
        if match:
            function, status, duration = match.groups()
            print(f"{function}: {duration}s ({status})")
```

## Custom Log Formats

You can customize the log format:

```python
from sherlock_ai import LoggingConfig

config = LoggingConfig(
    log_format="%(asctime)s | %(name)s | %(levelname)s | %(message)s",
    date_format="%Y-%m-%d %H:%M:%S"
)
```

## Next Steps

- [Configuration](configuration/index.md) - Configure log formats
- [JSON Logging](configuration/json-logging.md) - Use JSON format
- [Examples](examples/index.md) - See logs in action

