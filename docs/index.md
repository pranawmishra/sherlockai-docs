# Sherlock AI

A Python package for performance monitoring and logging utilities that helps you track execution times and debug your applications with ease.

## Overview

Sherlock AI provides a comprehensive suite of tools for monitoring, logging, and analyzing Python applications. Whether you're building APIs, data pipelines, or any Python application, Sherlock AI helps you understand performance characteristics, track errors, and maintain code quality.

## Key Features

- 🎯 **Performance Decorators**: Easy-to-use decorators for tracking function execution times
- 🧠 **Memory Monitoring**: Track Python memory usage with detailed heap and tracemalloc integration
- 📊 **Resource Monitoring**: Monitor CPU, memory, I/O, and network usage during function execution
- ⏱️ **Context Managers**: Monitor code block execution with simple context managers
- 🔧 **Advanced Configuration System**: Complete control over logging with dataclass-based configuration
- ⚡ **Simplified Configuration**: Auto-expanding file paths - just specify base names instead of full paths
- 🎛️ **Configuration Presets**: Pre-built setups for development, production, and testing environments
- 🔄 **Async/Sync Support**: Works seamlessly with both synchronous and asynchronous functions
- 📈 **Request Tracking**: Built-in request ID tracking for distributed systems
- 📁 **Flexible Log Management**: Enable/disable log files, custom directories, and rotation settings
- 🏷️ **Logger Name Constants**: Easy access to available logger names with autocomplete support
- 🔍 **Logger Discovery**: Programmatically discover available loggers in your application
- 🐛 **Development-Friendly**: Optimized for FastAPI auto-reload and development environments
- 🎨 **Modular Architecture**: Clean, focused modules for different monitoring aspects
- 🏗️ **Class-Based Architecture**: Advanced `SherlockAI` class for instance-based logging management
- 🔄 **Runtime Reconfiguration**: Change logging settings without application restart
- 🧹 **Resource Management**: Automatic cleanup and context manager support
- 🔍 **Logging Introspection**: Query current logging configuration and statistics
- 📋 **JSON Format Support**: Choose between standard log format or structured JSON output for better parsing and analysis
- 🔍 **Code Analysis**: Automatic detection and refactoring of hardcoded values using AST parsing and LLM suggestions
- 🗄️ **MongoDB Integration**: Automatic error insights storage with MongoDB support
- 🌐 **API Client Integration**: HTTP-based data ingestion to centralized backend services
- 🚨 **Error Analysis**: AI-powered error analysis with automatic probable cause detection
- 💡 **Performance Insights**: AI-powered performance analysis that intelligently extracts user-defined function source code
- 🔄 **Auto-Instrumentation**: Zero-code setup for popular frameworks like FastAPI, automatically instrumenting routes with monitoring decorators

## Quick Start

### Installation

```bash
pip install sherlock-ai
```

### Basic Usage

```python
from sherlock_ai import SherlockAI, get_logger, log_performance
import time

# Initialize logging (call once at application startup)
SherlockAI().setup()

# Get a logger for your module
logger = get_logger(__name__)

@log_performance
def my_function():
    time.sleep(1)
    logger.info("Processing completed")
    return "result"

# This will log: PERFORMANCE | my_module.my_function | SUCCESS | 1.003s
result = my_function()
```

## What's Next?

<div class="grid cards" markdown>

- :material-download: **[Installation](installation.md)**

    ---
    
    Install Sherlock AI and learn about requirements

- :material-rocket-launch: **[Quick Start](quick-start.md)**

    ---
    
    Get up and running in minutes with basic examples

- :material-lightning-bolt: **[Features](features/index.md)**

    ---
    
    Explore performance, memory, and resource monitoring

- :material-cog: **[Configuration](configuration/index.md)**

    ---
    
    Learn how to configure Sherlock AI for your needs

- :material-code-braces: **[Examples](examples/index.md)**

    ---
    
    Real-world examples and integration patterns

- :material-api: **[API Reference](api-reference/index.md)**

    ---
    
    Complete API documentation and reference

</div>

## Use Cases

- **API Performance Monitoring**: Track response times for your web APIs
- **Memory Leak Detection**: Monitor memory usage patterns to identify potential leaks
- **Resource Optimization**: Analyze CPU, memory, and I/O usage
- **Database Query Optimization**: Monitor slow database operations
- **Microservices Debugging**: Trace execution times across service boundaries
- **Production Monitoring**: Get insights into application performance characteristics
- **Error Analysis & Debugging**: AI-powered error analysis with automatic storage
- **Code Quality Improvement**: Automatically detect and refactor hardcoded values

## Authors

**Pranaw Mishra** - [pranawmishra73@gmail.com](mailto:pranawmishra73@gmail.com)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/pranawmishra/sherlock-ai/blob/main/LICENSE) file for details.

## Links

- **Homepage**: [https://github.com/pranawmishra/sherlock-ai](https://github.com/pranawmishra/sherlock-ai)
- **Repository**: [https://github.com/pranawmishra/sherlock-ai](https://github.com/pranawmishra/sherlock-ai)
- **Issues**: [https://github.com/pranawmishra/sherlock-ai/issues](https://github.com/pranawmishra/sherlock-ai/issues)
- **PyPI**: [https://pypi.org/project/sherlock-ai/](https://pypi.org/project/sherlock-ai/)

