# Deployment Instructions

## Quick Start

### 1. Install Dependencies

**Using uv (recommended - much faster):**
```bash
uv sync
```

**Or using pip:**
```bash
pip install -r requirements.txt
```

### 2. Test Locally

**Using uv:**
```bash
uv run mkdocs serve
```

**Or using mkdocs directly:**
```bash
mkdocs serve
```

Open http://localhost:8000 in your browser to preview the documentation.

### 3. Build Static Site

**Using uv:**
```bash
uv run mkdocs build
```

**Or using mkdocs directly:**
```bash
mkdocs build
```

The built site will be in the `site/` directory.

## Deploy to GitHub Pages

### Automatic Deployment (Recommended)

The documentation is configured to automatically deploy when you push to the `main` branch:

1. Commit your changes:
```bash
git add .
git commit -m "Update documentation"
```

2. Push to main:
```bash
git push origin main
```

3. GitHub Actions will automatically build and deploy to GitHub Pages

4. Your docs will be live at: https://docs.sherlockai.dev

### Manual Deployment

Alternatively, deploy manually:

**Using uv:**
```bash
uv run mkdocs gh-deploy
```

**Or using mkdocs directly:**
```bash
mkdocs gh-deploy
```

## GitHub Pages Setup

Ensure GitHub Pages is configured:

1. Go to your repository settings
2. Navigate to "Pages" section
3. Source: Deploy from a branch
4. Branch: `gh-pages` / `root`
5. Custom domain: `docs.sherlockai.dev`

## CNAME Configuration

The `CNAME` file in the root directory contains:
```
docs.sherlockai.dev
```

This tells GitHub Pages to use your custom domain.

## DNS Configuration

Ensure your DNS is configured with these records:

```
Type: CNAME
Name: docs
Value: <your-github-username>.github.io
```

## Verify Deployment

After deployment:

1. Visit https://docs.sherlockai.dev
2. Check that all pages load correctly
3. Test navigation and search functionality
4. Verify that the theme is applied correctly

## Troubleshooting

### Build Fails

If the build fails:

1. Check `mkdocs.yml` for syntax errors
2. Verify all linked files exist
3. Run `mkdocs build --strict` to see detailed errors

### Custom Domain Not Working

1. Verify CNAME file exists in root
2. Check DNS configuration
3. Wait for DNS propagation (can take up to 24 hours)
4. Check GitHub Pages settings

### Navigation Not Working

1. Verify `nav` section in `mkdocs.yml`
2. Check that all paths match actual file locations
3. Ensure file paths use forward slashes

## Documentation Structure

```
docs/
├── index.md                          # Home page
├── installation.md                   # Installation guide
├── quick-start.md                    # Quick start guide
├── features/                         # Feature documentation
│   ├── index.md
│   ├── performance-monitoring.md
│   ├── memory-monitoring.md
│   ├── resource-monitoring.md
│   ├── error-analysis.md
│   ├── code-analysis.md
│   └── auto-instrumentation.md
├── configuration/                    # Configuration guides
│   ├── index.md
│   ├── presets.md
│   ├── custom-config.md
│   ├── json-logging.md
│   └── log-management.md
├── examples/                         # Usage examples
│   ├── index.md
│   ├── fastapi-integration.md
│   ├── async-functions.md
│   ├── mongodb-storage.md
│   ├── api-client.md
│   └── combined-monitoring.md
├── api-reference/                    # API reference
│   ├── index.md
│   ├── decorators.md
│   ├── classes.md
│   ├── configuration.md
│   └── utilities.md
├── advanced/                         # Advanced topics
│   ├── class-based-api.md
│   ├── runtime-reconfiguration.md
│   ├── request-tracking.md
│   └── introspection.md
├── guides/                           # How-to guides
│   ├── fastapi-setup.md
│   ├── production-deployment.md
│   └── troubleshooting.md
└── log-output-format.md              # Log format reference
```

## Next Steps

1. Install dependencies: `uv sync` (or `pip install -r requirements.txt`)
2. Test locally: `uv run mkdocs serve` (or `mkdocs serve`)
3. Commit and push to main branch
4. Verify deployment at https://docs.sherlockai.dev

## Support

For issues or questions:
- GitHub Issues: https://github.com/pranawmishra/sherlock-ai/issues
- Email: pranawmishra73@gmail.com

