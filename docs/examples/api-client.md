# API Client Integration

HTTP-based data ingestion to centralized backend services.

## Setup

```python
import os
os.environ["SHERLOCK_AI_API_KEY"] = "your-api-key-here"
```

## Error Insights

```python
from sherlock_ai.monitoring import sherlock_error_handler

@sherlock_error_handler
def monitored_function():
    # Errors sent to: POST /v1/logs/injest-error-insights
    result = complex_operation()
    return result
```

## Performance Insights

```python
from sherlock_ai.monitoring import sherlock_performance_insights

@sherlock_performance_insights
def slow_function():
    # Performance data sent to: POST /v1/logs/injest-performance-insights
    return heavy_computation()
```

## Manual Submission

```python
from sherlock_ai.storage import ApiClient

api_client = ApiClient()

error_data = {
    "function_name": "my_function",
    "error_message": "Error occurred",
    "stack_trace": "...",
    "probable_cause": "Analysis"
}

api_client.post_error_insights(error_data)
```

## Complete Example

```python
import os
from sherlock_ai import sherlock_ai, log_performance
from sherlock_ai.monitoring import sherlock_error_handler, sherlock_performance_insights

os.environ["SHERLOCK_AI_API_KEY"] = "your-api-key"
sherlock_ai()

@log_performance
@sherlock_error_handler
@sherlock_performance_insights
def api_monitored_function():
    return process_data()
```

