# MongoDB Storage

Store error insights and performance data in MongoDB.

## Setup

```python
import os
os.environ["MONGO_URI"] = "mongodb://localhost:27017"
```

## Error Insights Storage

```python
from sherlock_ai.monitoring import sherlock_error_handler

@sherlock_error_handler
def risky_function():
    result = 1 / 0
    return result

# Error automatically stored in: sherlock-meta.error-insights
```

## Manual Storage

```python
from sherlock_ai.storage import MongoManager

mongo = MongoManager("mongodb://localhost:27017")

error_data = {
    "function_name": "my_function",
    "error_message": "Division by zero",
    "stack_trace": "...",
    "probable_cause": "AI analysis result"
}

mongo.save(error_data)
```

## Complete Example

```python
from sherlock_ai import sherlock_ai, log_performance
from sherlock_ai.monitoring import sherlock_error_handler
import os

os.environ["MONGO_URI"] = "mongodb://localhost:27017"
sherlock_ai()

@log_performance
@sherlock_error_handler
def process_with_mongodb():
    # Errors stored automatically
    try:
        result = risky_operation()
        return result
    except Exception as e:
        raise
```

