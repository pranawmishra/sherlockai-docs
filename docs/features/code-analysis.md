# Code Analysis

Automatically detect and refactor hardcoded values in your code using AST parsing and LLM-powered suggestions. The `@hardcoded_value_detector` decorator helps improve code maintainability by identifying magic numbers, strings, and URLs that should be constants.

## Decorator Usage

### Basic Example

```python
from sherlock_ai import hardcoded_value_detector

@hardcoded_value_detector
def api_handler():
    url = "https://api.example.com"
    timeout = 30
    message = "Processing request"
    return requests.get(url, timeout=timeout)

# Automatically creates constants.py with:
# API_URL = "https://api.example.com"
# TIMEOUT_SECONDS = 30
# PROCESSING_MESSAGE = "Processing request"
# And updates your function to use these constants
```

### With Other Decorators

Combine with monitoring decorators:

```python
from sherlock_ai import log_performance, hardcoded_value_detector
from sherlock_ai.monitoring import sherlock_error_handler

@log_performance
@hardcoded_value_detector
@sherlock_error_handler
def comprehensive_function():
    # Performance monitored, hardcoded values detected, errors analyzed
    max_retries = 3
    api_endpoint = "https://api.example.com/data"
    for attempt in range(max_retries):
        try:
            return fetch_data(api_endpoint)
        except Exception as e:
            if attempt == max_retries - 1:
                raise
```

## Manual Code Analysis

Use the CodeAnalyzer class for custom analysis:

```python
from sherlock_ai.analysis import CodeAnalyzer

# Initialize with optional Groq API key for intelligent naming
analyzer = CodeAnalyzer(api_key="your-groq-api-key")

# Detect hardcoded values in source code
with open('my_file.py', 'r') as f:
    source = f.read()

hardcoded_values = analyzer.detect_hardcoded_values(source)
for value, value_type, node in hardcoded_values:
    constant_name = analyzer.suggest_constant_name(value, value_type, "my_function")
    analyzer.append_to_constants_file(constant_name, value)
    print(f"Found: {value} → Suggested: {constant_name}")
```

## What Gets Detected

### String Literals

```python
@hardcoded_value_detector
def example():
    # Detected
    message = "Hello, World"  # → HELLO_WORLD_MESSAGE
    error_msg = "Connection failed"  # → CONNECTION_FAILED_ERROR_MSG
    
    # Not detected (common patterns)
    empty = ""  # Ignored
    space = " "  # Ignored
    name = "id"  # Too short, ignored
```

### Numeric Values

```python
@hardcoded_value_detector
def example():
    # Detected
    timeout = 30  # → TIMEOUT_SECONDS
    max_size = 1024  # → MAX_SIZE
    rate = 0.95  # → RATE_VALUE
    
    # Not detected (common patterns)
    zero = 0  # Ignored
    one = 1  # Ignored
    negative_one = -1  # Ignored
```

### URLs

```python
@hardcoded_value_detector
def example():
    # Detected
    api_url = "https://api.example.com"  # → API_URL
    endpoint = "https://service.com/v1/data"  # → ENDPOINT_URL
```

## Constants File Management

### Default Location

Constants are written to `constants.py` in the current directory:

```python
# constants.py (auto-generated)
API_URL = "https://api.example.com"
TIMEOUT_SECONDS = 30
MAX_RETRIES = 3
PROCESSING_MESSAGE = "Processing request"
```

### Custom Constants File

Specify a custom location:

```python
from sherlock_ai.analysis import CodeAnalyzer

analyzer = CodeAnalyzer(constants_file="config/constants.py")

@hardcoded_value_detector(analyzer=analyzer)
def my_function():
    value = 42
```

## Constant Naming

### Intelligent Naming (with LLM)

When Groq API key is configured:

```python
import os
os.environ["GROQ_API_KEY"] = "your-api-key"

@hardcoded_value_detector
def example():
    timeout = 30  # → LLM suggests: REQUEST_TIMEOUT_SECONDS
    url = "https://api.example.com"  # → LLM suggests: PRIMARY_API_ENDPOINT
```

### Heuristic Naming (fallback)

Without LLM, uses heuristic rules:

```python
# No GROQ_API_KEY set
@hardcoded_value_detector
def example():
    timeout = 30  # → TIMEOUT_VALUE
    url = "https://api.example.com"  # → URL_VALUE
    message = "Hello"  # → MESSAGE_VALUE
```

## Code Refactoring

### Before

```python
@hardcoded_value_detector
def process_request():
    url = "https://api.example.com"
    timeout = 30
    max_retries = 3
    
    for i in range(max_retries):
        try:
            response = requests.get(url, timeout=timeout)
            return response.json()
        except requests.Timeout:
            if i == max_retries - 1:
                raise
```

### After

```python
# constants.py (created automatically)
API_URL = "https://api.example.com"
TIMEOUT_SECONDS = 30
MAX_RETRIES = 3

# Original file (updated automatically)
from constants import API_URL, TIMEOUT_SECONDS, MAX_RETRIES

def process_request():
    for i in range(MAX_RETRIES):
        try:
            response = requests.get(API_URL, timeout=TIMEOUT_SECONDS)
            return response.json()
        except requests.Timeout:
            if i == MAX_RETRIES - 1:
                raise
```

## CodeAnalyzer Class

### Methods

#### `detect_hardcoded_values(source_code)`

Detect hardcoded values in Python source code.

**Parameters:**
- `source_code` (str): Python source code to analyze

**Returns:**
- List of tuples: `(value, value_type, ast_node)`

```python
analyzer = CodeAnalyzer()
hardcoded = analyzer.detect_hardcoded_values(source_code)
for value, value_type, node in hardcoded:
    print(f"{value_type}: {value}")
```

#### `suggest_constant_name(value, value_type, context)`

Suggest a constant name for a hardcoded value.

**Parameters:**
- `value`: The hardcoded value
- `value_type` (str): Type of value ("string", "number", "url")
- `context` (str): Context where value was found (e.g., function name)

**Returns:**
- str: Suggested constant name

```python
name = analyzer.suggest_constant_name("https://api.example.com", "url", "fetch_data")
# Returns: "API_ENDPOINT" or similar
```

#### `append_to_constants_file(constant_name, value)`

Add a constant to the constants file.

**Parameters:**
- `constant_name` (str): Name of the constant
- `value`: Value to assign

```python
analyzer.append_to_constants_file("API_URL", "https://api.example.com")
```

#### `modify_function_code(source_code, replacements, file_path)`

Refactor code to use constants.

**Parameters:**
- `source_code` (str): Original source code
- `replacements` (dict): Mapping of values to constant names
- `file_path` (str): Path to the file being modified

```python
replacements = {"https://api.example.com": "API_URL", 30: "TIMEOUT"}
analyzer.modify_function_code(source_code, replacements, "my_module.py")
```

## Configuration

### Constructor Parameters

```python
from sherlock_ai.analysis import CodeAnalyzer

analyzer = CodeAnalyzer(
    api_key="your-groq-api-key",  # Optional: for intelligent naming
    constants_file="constants.py"   # Optional: custom constants file path
)
```

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `GROQ_API_KEY` | No | None | Groq API key for LLM-powered naming |

## Best Practices

### 1. Run on Existing Code

Apply to existing functions to clean up hardcoded values:

```python
@hardcoded_value_detector
def legacy_function():
    # This function has many hardcoded values
    db_host = "localhost"
    db_port = 5432
    timeout = 30
    # ... more hardcoded values
```

### 2. Use in Development

Enable during development to catch hardcoded values early:

```python
import os

if os.getenv("ENVIRONMENT") == "development":
    from sherlock_ai import hardcoded_value_detector
    
    @hardcoded_value_detector
    def new_feature():
        # Automatically detects hardcoded values during development
        pass
```

### 3. Review Generated Constants

Always review the generated constants file:

```python
# constants.py
# Review these names and adjust if needed
API_URL = "https://api.example.com"
TIMEOUT_SECONDS = 30  # Consider renaming to REQUEST_TIMEOUT_SECONDS
```

### 4. Combine with Code Reviews

Use as part of code review process:

```python
# Before committing
@hardcoded_value_detector
def new_function():
    # Check for any hardcoded values before review
    pass
```

## Use Cases

- **Code Quality Improvement**: Systematically eliminate magic numbers and strings
- **Legacy Code Modernization**: Refactor old code with hardcoded values
- **Configuration Extraction**: Identify values that should be configurable
- **Maintenance**: Make code more maintainable by using named constants
- **Documentation**: Constants serve as self-documenting code
- **Testing**: Easier to mock and test with named constants

## Limitations

### AST-Based Detection

Only detects values in the AST:
- Cannot detect values in comments
- Cannot detect values in docstrings (intentionally)
- Cannot detect dynamically generated values

### Heuristic Filtering

Some values are intentionally ignored:
- Empty strings, single characters
- Common numbers (0, 1, -1)
- Very short strings (< 3 characters)
- Common patterns (None, True, False)

### Manual Review Required

Always review suggestions:
- Not all hardcoded values need to be constants
- Some values are intentionally literal
- Context matters for naming

## Troubleshooting

### Constants File Not Created

If `constants.py` isn't created:

1. Check file permissions in the directory
2. Verify the decorator is actually executed
3. Check that hardcoded values were detected

### Constants Not Being Used

If refactoring doesn't occur:

1. Check that the source file is writable
2. Verify the function contains detectable hardcoded values
3. Look for AST parsing errors in logs

### Poor Constant Names

If generated names are not ideal:

1. Set `GROQ_API_KEY` for intelligent naming
2. Manually edit `constants.py` after generation
3. Provide better context in function names

## Next Steps

- [Error Analysis](error-analysis.md) - AI-powered error insights
- [Configuration](../configuration/index.md) - Configure analysis behavior
- [Examples](../examples/index.md) - See real-world examples
- [API Reference](../api-reference/classes.md#codeanalyzer) - Complete API reference

