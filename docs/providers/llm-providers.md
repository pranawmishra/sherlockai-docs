# LLM Provider Configuration

Sherlock AI supports multiple LLM (Large Language Model) providers for AI-powered features like error analysis, performance insights, and code analysis. Choose the provider that best fits your infrastructure and requirements.

## Overview

LLM providers power these features:

- **Error Analysis**: AI-powered error cause detection
- **Performance Insights**: Intelligent performance bottleneck analysis
- **Code Analysis**: Smart constant naming suggestions

## Supported Providers

### Groq (Default)

Fast inference with open-source models. Great for development and production use.

**Pros:**

- ⚡ Very fast inference
- 🆓 Generous free tier
- 🔓 Open-source models
- 🚀 Simple setup (1 environment variable)

### Azure OpenAI

Enterprise-grade OpenAI models hosted on Azure infrastructure.

**Pros:**

- 🏢 Enterprise SLA and support
- 🔐 Advanced security (VNet, private endpoints)
- 🌍 Regional deployment options
- 🤖 Access to latest GPT models

---

## Quick Setup

### Using Groq (Default)

Groq is the default provider and requires only an API key:

```python
import os

# Set Groq API key
os.environ["GROQ_API_KEY"] = "your-groq-api-key"
```

**Environment Variables:**
```bash
export GROQ_API_KEY="your-groq-api-key"
```

**Get API Key:**

1. Visit [console.groq.com](https://console.groq.com)
2. Sign up for a free account
3. Generate an API key
4. Set the environment variable

---

### Using Azure OpenAI

To use Azure OpenAI instead of Groq:

```python
import os

# Configure Azure OpenAI
os.environ["LLM_PROVIDER"] = "azure_openai"
os.environ["AZURE_OPENAI_API_KEY"] = "your-azure-key"
os.environ["AZURE_OPENAI_ENDPOINT"] = "https://your-resource.openai.azure.com/"
os.environ["AZURE_OPENAI_DEPLOYMENT_NAME"] = "gpt-4-turbo"
```

**Environment Variables:**
```bash
# Required
export LLM_PROVIDER="azure_openai"
export AZURE_OPENAI_API_KEY="your-azure-openai-key"
export AZURE_OPENAI_ENDPOINT="https://your-resource.openai.azure.com/"
export AZURE_OPENAI_DEPLOYMENT_NAME="gpt-4-turbo"

# Optional (defaults to 2024-02-15-preview)
export AZURE_OPENAI_API_VERSION="2024-02-15-preview"
```

**Setup Steps:**

1. Create an Azure OpenAI resource in Azure Portal
2. Deploy a model (e.g., gpt-4, gpt-4-turbo)
3. Get your endpoint URL and API key
4. Set the environment variables

---

## Provider Comparison

| Feature | Groq | Azure OpenAI |
|---------|------|--------------|
| Setup Complexity | Simple (1 env var) | Moderate (4 env vars) |
| Cost | Pay-per-use | Enterprise pricing |
| Models | Open-source models | GPT-3.5, GPT-4, GPT-4 Turbo |
| Performance | Very fast inference | Standard OpenAI performance |
| Enterprise Features | Basic | Advanced (VNet, Private endpoints) |
| Free Tier | Yes | No |
| Best For | Development, fast iteration | Enterprise, compliance needs |

---

## Configuration Reference

### Groq Configuration

| Environment Variable | Required | Default | Description |
|---------------------|----------|---------|-------------|
| `GROQ_API_KEY` | Yes | None | Your Groq API key |

### Azure OpenAI Configuration

| Environment Variable | Required | Default | Description |
|---------------------|----------|---------|-------------|
| `LLM_PROVIDER` | Yes | "groq" | Set to "azure_openai" |
| `AZURE_OPENAI_API_KEY` | Yes | None | Azure OpenAI API key |
| `AZURE_OPENAI_ENDPOINT` | Yes | None | Azure OpenAI endpoint URL |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | Yes | None | Deployment/model name |
| `AZURE_OPENAI_API_VERSION` | No | "2024-02-15-preview" | API version |

---

## Using with Features

### Error Analysis

```python
from sherlock_ai.monitoring import sherlock_error_handler
import os

# Configure your provider
os.environ["GROQ_API_KEY"] = "your-api-key"

@sherlock_error_handler
def risky_function():
    # Errors automatically analyzed with configured LLM
    result = 1 / 0
    return result
```

### Code Analysis

```python
from sherlock_ai import hardcoded_value_detector
import os

# Configure your provider
os.environ["GROQ_API_KEY"] = "your-api-key"

@hardcoded_value_detector
def my_function():
    # LLM suggests intelligent constant names
    url = "https://api.example.com"
    timeout = 30
    return fetch_data(url, timeout)
```

### Performance Insights

```python
from sherlock_ai.monitoring import sherlock_performance_insights
import os

# Configure your provider
os.environ["GROQ_API_KEY"] = "your-api-key"

@sherlock_performance_insights
def slow_function():
    # LLM analyzes performance bottlenecks
    return expensive_computation()
```

---

## Environment-Specific Configuration

### Development

```python
import os

# Use Groq for fast development
os.environ["GROQ_API_KEY"] = os.getenv("DEV_GROQ_KEY")
```

### Production

```python
import os

env = os.getenv("ENVIRONMENT", "development")

if env == "production":
    # Use Azure OpenAI in production
    os.environ["LLM_PROVIDER"] = "azure_openai"
    os.environ["AZURE_OPENAI_API_KEY"] = os.getenv("PROD_AZURE_KEY")
    os.environ["AZURE_OPENAI_ENDPOINT"] = os.getenv("PROD_AZURE_ENDPOINT")
    os.environ["AZURE_OPENAI_DEPLOYMENT_NAME"] = "gpt-4-turbo"
else:
    # Use Groq for development
    os.environ["GROQ_API_KEY"] = os.getenv("DEV_GROQ_KEY")
```

---

## Troubleshooting

### Provider Not Responding

**Groq:**

- Verify API key is set: `echo $GROQ_API_KEY`
- Check rate limits at console.groq.com
- Ensure internet connectivity

**Azure OpenAI:**

- Verify all 4 required environment variables are set
- Check endpoint URL format (must include https://)
- Verify deployment name matches Azure Portal
- Check Azure OpenAI resource is not paused

### API Key Invalid

```python
# Test your provider connection
import os
from sherlock_ai.monitoring import sherlock_error_handler

# This will show if provider is working
@sherlock_error_handler
def test_provider():
    raise ValueError("Test error")

test_provider()
# Check logs for successful AI analysis
```

### No AI Analysis in Logs

If you don't see AI-generated insights:

1. Verify environment variables are set **before** importing sherlock_ai
2. Check that decorators are properly applied
3. Look for provider error messages in logs
4. Ensure the decorated function actually raises an error

---

## Best Practices

### 1. Use Environment Variables

Don't hardcode API keys in your code:

```python
# ❌ Bad
os.environ["GROQ_API_KEY"] = "gsk_abc123..."

# ✅ Good
os.environ["GROQ_API_KEY"] = os.getenv("GROQ_API_KEY")
```

### 2. Different Providers per Environment

```python
# Development: Fast and free
if os.getenv("ENV") == "dev":
    os.environ["GROQ_API_KEY"] = os.getenv("GROQ_KEY")

# Production: Enterprise features
elif os.getenv("ENV") == "prod":
    os.environ["LLM_PROVIDER"] = "azure_openai"
    # ... Azure config
```

### 3. Graceful Fallback

LLM features are optional - if provider fails, Sherlock AI continues logging without AI analysis.

### 4. Cost Management

Monitor your usage:

- **Groq**: Check console.groq.com for usage
- **Azure OpenAI**: Monitor in Azure Portal

---

## Coming Soon

Additional LLM providers planned:

- OpenAI (direct)
- Anthropic Claude
- Local models (Ollama)
- AWS Bedrock

---

## Next Steps

- [Error Analysis](../features/error-analysis.md) - AI-powered error insights
- [Code Analysis](../features/code-analysis.md) - Intelligent code analysis
- [Configuration](../configuration/index.md) - General configuration
- [Troubleshooting](../guides/troubleshooting.md) - Common issues
