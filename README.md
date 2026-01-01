# Sherlock AI Documentation

Official documentation for [Sherlock AI](https://github.com/pranawmishra/sherlock-ai) - Performance monitoring and logging utilities for Python.

## Documentation Site

Visit the live documentation at: [docs.sherlockai.dev](https://docs.sherlockai.dev)

## Local Development

### Prerequisites

- Python 3.8 or higher
- [uv](https://github.com/astral-sh/uv) (recommended) or pip

### Setup

1. Clone the repository:
```bash
git clone https://github.com/pranawmishra/sherlockai-docs.git
cd sherlockai-docs
```

2. Install dependencies:

**Quick setup with uv (recommended):**
```bash
./setup.sh
```

**Or manually with uv:**
```bash
uv sync
```

**Or using pip:**
```bash
pip install -r requirements.txt
```

### Build and Serve Locally

Serve the documentation locally with live reload:

**Using uv:**
```bash
uv run mkdocs serve
```

**Or using mkdocs directly:**
```bash
mkdocs serve
```

Then open http://localhost:8000 in your browser.

### Build Static Site

Build the static HTML site:

**Using uv:**
```bash
uv run mkdocs build
```

**Or using mkdocs directly:**
```bash
mkdocs build
```

The built site will be in the `site/` directory.

## Deployment

The documentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch.

### Manual Deployment

To manually deploy:

**Using uv:**
```bash
uv run mkdocs gh-deploy
```

**Or using mkdocs directly:**
```bash
mkdocs gh-deploy
```

## Project Structure

```
sherlockai-docs/
├── docs/                      # Documentation source files
│   ├── index.md              # Home page
│   ├── installation.md       # Installation guide
│   ├── quick-start.md        # Quick start guide
│   ├── features/             # Feature documentation
│   ├── configuration/        # Configuration guides
│   ├── examples/             # Usage examples
│   ├── api-reference/        # API reference
│   ├── advanced/             # Advanced topics
│   ├── guides/               # How-to guides
│   └── log-output-format.md  # Log format reference
├── mkdocs.yml                # MkDocs configuration
├── requirements.txt          # Python dependencies
├── CNAME                     # Custom domain configuration
└── .github/
    └── workflows/
        └── deploy-docs.yml   # GitHub Actions workflow
```

## Configuration

The documentation is built with:

- **MkDocs**: Static site generator
- **Material for MkDocs**: Modern documentation theme
- **GitHub Pages**: Hosting platform
- **Custom Domain**: docs.sherlockai.dev

## Contributing

To contribute to the documentation:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with `mkdocs serve`
5. Submit a pull request

## Links

- **Main Project**: [github.com/pranawmishra/sherlock-ai](https://github.com/pranawmishra/sherlock-ai)
- **PyPI Package**: [pypi.org/project/sherlock-ai](https://pypi.org/project/sherlock-ai/)
- **Documentation**: [docs.sherlockai.dev](https://docs.sherlockai.dev)
- **Issues**: [github.com/pranawmishra/sherlock-ai/issues](https://github.com/pranawmishra/sherlock-ai/issues)

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Pranaw Mishra** - [pranawmishra73@gmail.com](mailto:pranawmishra73@gmail.com)
