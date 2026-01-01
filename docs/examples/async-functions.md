# Async Functions

Monitor asynchronous functions and coroutines with Sherlock AI.

## Basic Async Monitoring

```python
from sherlock_ai import sherlock_ai, log_performance
import httpx
import asyncio

sherlock_ai()

@log_performance
async def fetch_data(url: str):
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        return response.json()

# Usage
asyncio.run(fetch_data("https://api.example.com/data"))
```

## Combined Async Monitoring

```python
from sherlock_ai import log_performance, monitor_memory, monitor_resources

@log_performance
@monitor_memory
@monitor_resources
async def process_async_data():
    data = await fetch_large_dataset()
    processed = await transform_data(data)
    return processed
```

## Async Context Managers

```python
from sherlock_ai.performance import PerformanceTimer
from sherlock_ai import MemoryTracker

async def async_pipeline():
    with PerformanceTimer("data_fetch"):
        data = await fetch_data()
    
    with MemoryTracker("data_processing"):
        result = await process_data(data)
    
    return result
```

## FastAPI Async Routes

```python
from fastapi import FastAPI
from sherlock_ai import SherlockAI, LoggingConfig

config = LoggingConfig(auto_instrument=True)
logging_manager = SherlockAI(config=config)
logging_manager.setup()

app = FastAPI()

@app.get("/async-data")
async def get_async_data():
    # Automatically monitored
    data = await fetch_external_api()
    return {"data": data}
```

