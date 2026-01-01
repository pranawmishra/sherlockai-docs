# Error Analysis

AI-powered error analysis with automatic probable cause detection and storage. The `@sherlock_error_handler` decorator automatically analyzes errors using LLM and stores insights in MongoDB or sends them to a centralized backend API.

## Decorator Usage

### Basic Example

```python
from sherlock_ai.monitoring import sherlock_error_handler
import os

# Optional: Set up MongoDB connection
os.environ["MONGO_URI"] = "mongodb://localhost:27017"

@sherlock_error_handler
def risky_function():
    # Any errors will be automatically analyzed and stored
    result = 1 / 0  # This will trigger error analysis
    return result

# When an error occurs:
# 1. Error is caught and analyzed by AI for probable cause
# 2. Insight is stored in MongoDB (sherlock-meta.error-insights collection)
# 3. Detailed information is logged
# 4. Error is re-raised for normal handling
```

### With Other Decorators

Combine with performance monitoring:

```python
from sherlock_ai import log_performance
from sherlock_ai.monitoring import sherlock_error_handler

@log_performance
@sherlock_error_handler
def monitored_function():
    # Tracks both performance AND analyzes errors
    try:
        result = complex_operation()
        return result
    except Exception as e:
        # Error will be analyzed before being raised
        raise
```

### Async Functions

Works with async/await:

```python
@sherlock_error_handler
async def async_operation():
    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.example.com")
        if response.status_code != 200:
            raise ValueError(f"API returned {response.status_code}")
        return response.json()
```

## Storage Options

### MongoDB Storage

Store error insights in MongoDB:

```python
import os

# Configure MongoDB
os.environ["MONGO_URI"] = "mongodb://localhost:27017"

@sherlock_error_handler
def function_with_errors():
    # Errors stored in: database: sherlock-meta, collection: error-insights
    raise ValueError("Something went wrong")
```

Error insights are stored with:
- Function name and module
- Error message and type
- Stack trace
- AI-generated probable cause
- Timestamp
- Request ID (if available)

### API Client Storage

Send error insights to centralized backend:

```python
import os

# Configure API client
os.environ["SHERLOCK_AI_API_KEY"] = "your-api-key-here"

@sherlock_error_handler
def function_with_errors():
    # Errors sent to: POST /v1/logs/injest-error-insights
    raise ValueError("Something went wrong")
```

### Manual Storage

Use the storage clients directly:

```python
from sherlock_ai.storage import MongoManager, ApiClient

# MongoDB
mongo = MongoManager("mongodb://localhost:27017")
error_data = {
    "function_name": "my_function",
    "error_message": "Division by zero",
    "stack_trace": "...",
    "probable_cause": "AI analysis result"
}
mongo.save(error_data)

# API Client
api_client = ApiClient()
api_client.post_error_insights(error_data)
```

## Error Insight Format

Stored error insights include:

```json
{
    "timestamp": "2025-01-01T12:34:56",
    "function_name": "my_module.risky_function",
    "error_type": "ZeroDivisionError",
    "error_message": "division by zero",
    "stack_trace": "Traceback (most recent call last):\n  File ...",
    "probable_cause": "The function attempts to divide by zero on line 42. This occurs because the divisor variable is not validated before the operation.",
    "request_id": "a1b2c3d4",
    "module": "my_module",
    "line_number": 42
}
```

## AI-Powered Analysis

The error handler uses LLM to analyze:

1. **Error Context**: Function name, line number, error type
2. **Stack Trace**: Full traceback analysis
3. **Code Context**: Surrounding code (if available)
4. **Probable Cause**: Human-readable explanation

Example analysis output:

```
Probable Cause: The function attempts to divide by zero on line 42. 
This occurs because the 'count' variable is initialized to 0 and 
never modified before being used as a divisor. Consider adding 
validation to check if count > 0 before the division operation.
```

## Configuration

### MongoDB Configuration

```python
from sherlock_ai.storage import MongoManager

# Initialize with custom URI
mongo = MongoManager("mongodb://user:pass@localhost:27017/custom_db")

# Check if MongoDB is available
if mongo.enabled:
    print("MongoDB storage is configured")
```

### API Client Configuration

```python
from sherlock_ai.storage import ApiClient

# Required: API key
os.environ["SHERLOCK_AI_API_KEY"] = "your-api-key"

# Optional: Custom base URL
os.environ["SHERLOCK_AI_API_BASE_URL"] = "https://your-backend.com/api/v1"

# Initialize
api_client = ApiClient()
```

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MONGO_URI` | No | None | MongoDB connection string |
| `SHERLOCK_AI_API_KEY` | For API | None | API authentication key |
| `SHERLOCK_AI_API_BASE_URL` | No | http://localhost:8000/v1/logs | API base URL |
| `GROQ_API_KEY` | No | None | Groq API key for LLM analysis |

## Best Practices

### 1. Use with Critical Functions

Apply to functions where errors need detailed analysis:

```python
@sherlock_error_handler
def critical_payment_processing():
    # Errors here need thorough investigation
    process_payment(amount, card_details)
```

### 2. Combine with Logging

Use with standard logging for complete visibility:

```python
from sherlock_ai import get_logger
from sherlock_ai.monitoring import sherlock_error_handler

logger = get_logger(__name__)

@sherlock_error_handler
def monitored_function():
    try:
        logger.info("Starting operation")
        result = risky_operation()
        logger.info("Operation completed")
        return result
    except Exception as e:
        logger.error(f"Operation failed: {e}")
        raise  # Error will be analyzed before re-raising
```

### 3. Don't Catch Errors Inside

Let the decorator handle error catching:

```python
# ❌ Don't do this
@sherlock_error_handler
def bad_example():
    try:
        risky_operation()
    except Exception:
        pass  # Decorator won't see this error

# ✅ Do this instead
@sherlock_error_handler
def good_example():
    risky_operation()  # Let decorator catch and analyze
```

### 4. Use for Production Monitoring

Enable in production for automatic error tracking:

```python
import os

if os.getenv("ENVIRONMENT") == "production":
    os.environ["MONGO_URI"] = os.getenv("PROD_MONGO_URI")
    os.environ["SHERLOCK_AI_API_KEY"] = os.getenv("PROD_API_KEY")

@sherlock_error_handler
def production_function():
    # Errors automatically tracked in production
    return process_data()
```

## Use Cases

- **Production Error Tracking**: Automatic error collection and analysis
- **Debugging**: AI-powered insights into error causes
- **Error Pattern Recognition**: Identify recurring issues
- **Microservices**: Distributed error tracking with request IDs
- **API Monitoring**: Track and analyze API errors
- **Data Pipeline Failures**: Analyze ETL pipeline errors
- **Critical Operations**: Deep analysis for payment, auth, etc.

## Error Handling Flow

```
Function Call
    ↓
Decorator Wraps Execution
    ↓
Error Occurs
    ↓
Capture Error Details (type, message, traceback)
    ↓
Extract Function Context (name, module, line)
    ↓
AI Analysis (probable cause using LLM)
    ↓
Store Insight (MongoDB or API)
    ↓
Log Error Details
    ↓
Re-raise Original Error
    ↓
Normal Error Handling
```

## Limitations

### LLM API Required

Error analysis requires LLM API access:
- Groq API (default)
- Configure with `GROQ_API_KEY` environment variable
- Without API key, basic error logging still works

### Storage Optional

Storage is optional:
- Without MongoDB or API client, errors are still logged
- Configure storage for persistent error tracking
- Use both storage options for redundancy

### Performance Impact

AI analysis adds latency:
- Only occurs on errors (not normal execution)
- Async analysis recommended for high-traffic apps
- Consider rate limiting for error analysis

## Troubleshooting

### No Insights Stored

If error insights aren't being stored:

1. Check MongoDB connection:
```python
from sherlock_ai.storage import MongoManager
mongo = MongoManager()
print(f"MongoDB enabled: {mongo.enabled}")
```

2. Check API client configuration:
```python
import os
print(f"API Key set: {'SHERLOCK_AI_API_KEY' in os.environ}")
```

### AI Analysis Failing

If LLM analysis fails:

1. Verify Groq API key is set
2. Check API rate limits
3. Errors are still logged even if analysis fails

### Errors Not Being Caught

Ensure errors are not caught before decorator:

```python
# ✅ Correct
@sherlock_error_handler
def function():
    risky_operation()  # Error caught by decorator

# ❌ Incorrect
@sherlock_error_handler
def function():
    try:
        risky_operation()
    except:
        pass  # Decorator never sees error
```

## Next Steps

- [MongoDB Storage](../examples/mongodb-storage.md) - MongoDB integration examples
- [API Client](../examples/api-client.md) - HTTP-based storage examples
- [Performance Insights](../api-reference/decorators.md#sherlock_performance_insights) - Related decorator
- [Configuration](../configuration/index.md) - Environment configuration

