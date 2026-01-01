# Installation

## Requirements

- Python >= 3.8
- **psutil** >= 5.8.0 (for memory and resource monitoring)
- **astor** >= 0.8.1 (for AST to source code conversion in code analysis)
- **groq** >= 0.30.0 (for LLM-based analysis and constant naming)
- **pymongo** >= 4.0.0 (for MongoDB error insight storage)
- **requests** >= 2.32.4 (for HTTP-based API client integration)

## Install from PyPI

Install Sherlock AI using pip:

```bash
pip install sherlock-ai
```

## Install from Source

If you want to install from source for development:

```bash
git clone https://github.com/pranawmishra/sherlock-ai.git
cd sherlock-ai
pip install -e .
```

## Verify Installation

Verify that Sherlock AI is installed correctly:

```python
import sherlock_ai
print(sherlock_ai.__version__)
```

## Optional Dependencies

### MongoDB Support

For error insight storage with MongoDB:

```bash
pip install pymongo
```

Set up your MongoDB connection:

```python
import os
os.environ["MONGO_URI"] = "mongodb://localhost:27017"
```

### API Client Support

For HTTP-based data ingestion to centralized backend services:

```bash
pip install requests
```

Configure your API key:

```python
import os
os.environ["SHERLOCK_AI_API_KEY"] = "your-api-key-here"
```

### Code Analysis Support

For automatic hardcoded value detection and refactoring:

```bash
pip install astor groq
```

Set up your Groq API key for intelligent constant naming:

```python
import os
os.environ["GROQ_API_KEY"] = "your-groq-api-key"
```

## What's Next?

- [Quick Start Guide](quick-start.md) - Get started with basic usage
- [Configuration](configuration/index.md) - Learn about configuration options
- [Features](features/index.md) - Explore all available features

