# Providers

Sherlock AI supports multiple providers for different integrations and AI-powered features. Configure providers to customize how Sherlock AI interacts with external services.

## Available Providers

### LLM Providers

Configure AI language models for intelligent features like error analysis, performance insights, and code analysis.

[Learn more about LLM Providers →](llm-providers.md)

**Supported:**

- **Groq** (default) - Fast inference with open-source models
- **Azure OpenAI** - Enterprise-grade OpenAI models on Azure

---

## Why Multiple Providers?

Sherlock AI's provider system gives you flexibility to:

- ✅ Choose the best service for your infrastructure
- ✅ Use enterprise solutions or open-source alternatives
- ✅ Switch providers without changing your code
- ✅ Support different environments (dev, staging, production)

## Getting Started

1. Choose your provider based on your needs
2. Configure environment variables
3. Sherlock AI automatically uses the configured provider

## Provider Configuration

Each provider has its own configuration requirements. Check the individual provider documentation for setup instructions.

## Coming Soon

More provider integrations are planned:

- Additional LLM providers
- Monitoring backends
- Log aggregation services
- And more!

## Next Steps

- [LLM Providers](llm-providers.md) - Configure AI language models
- [Configuration](../configuration/index.md) - General configuration options
- [Error Analysis](../features/error-analysis.md) - Use AI-powered error analysis
