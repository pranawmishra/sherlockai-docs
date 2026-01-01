# Combined Monitoring

Use multiple Sherlock AI features together for comprehensive monitoring.

## Complete Monitoring Stack

```python
from sherlock_ai import sherlock_ai, log_performance, monitor_memory, monitor_resources, hardcoded_value_detector
from sherlock_ai.monitoring import sherlock_error_handler

sherlock_ai()

@log_performance
@monitor_memory(trace_malloc=True)
@monitor_resources(include_io=True)
@sherlock_error_handler
@hardcoded_value_detector
def comprehensive_function():
    # This function is monitored for:
    # - Execution time (performance)
    # - Memory usage (memory)
    # - System resources (CPU, I/O, etc.)
    # - Error analysis (AI-powered)
    # - Hardcoded value detection
    data = process_large_dataset()
    save_to_database(data)
    return len(data)
```

## FastAPI with Full Monitoring

```python
from fastapi import FastAPI
from sherlock_ai import SherlockAI, LoggingConfig, get_logger
import os

os.environ["MONGO_URI"] = "mongodb://localhost:27017"
os.environ["SHERLOCK_AI_API_KEY"] = "your-api-key"

config = LoggingConfig(
    auto_instrument=True,
    log_format_type="json"
)
logging_manager = SherlockAI(config=config)
logging_manager.setup()

logger = get_logger(__name__)

app = FastAPI()

@app.post("/process")
def process_data(data: dict):
    # Automatically monitored with all features
    logger.info("Processing data")
    result = complex_processing(data)
    return {"result": result}
```

## Data Pipeline Example

```python
from sherlock_ai import sherlock_ai, log_performance, monitor_memory, monitor_resources
from sherlock_ai.monitoring import sherlock_error_handler

sherlock_ai()

@log_performance
@monitor_memory
@sherlock_error_handler
def extract_data():
    return fetch_from_source()

@log_performance
@monitor_resources(include_io=True)
@sherlock_error_handler
def transform_data(data):
    return process(data)

@log_performance
@monitor_memory
@monitor_resources(include_io=True)
@sherlock_error_handler
def load_data(data):
    save_to_database(data)

# Run pipeline
data = extract_data()
transformed = transform_data(data)
load_data(transformed)
```

