# Logging Introspection

Query current logging configuration and statistics at runtime.

## Get Logging Statistics

```python
from sherlock_ai import sherlock_ai, get_logging_stats

sherlock_ai()

stats = get_logging_stats()
print(f"Configured: {stats['is_configured']}")
print(f"Active handlers: {stats['handlers']}")
print(f"Log directory: {stats['logs_dir']}")
```

## Get Current Configuration

```python
from sherlock_ai import sherlock_ai, get_current_config

sherlock_ai()

config = get_current_config()
if config:
    print(f"Console enabled: {config.console_enabled}")
    print(f"Console level: {config.console_level}")
    print(f"Log files: {list(config.log_files.keys())}")
    
    for name, log_file in config.log_files.items():
        print(f"{name}: enabled={log_file.enabled}, level={log_file.level}")
```

## Class-Based Statistics

```python
from sherlock_ai import SherlockAI

logger_manager = SherlockAI()
logger_manager.setup()

stats = logger_manager.get_stats()
print(f"Configuration: {stats}")
```

## Use Cases

- Monitor logging health
- Debug configuration issues
- Dynamic configuration adjustments
- Logging dashboards

