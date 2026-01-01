#!/bin/bash

# Sherlock AI Documentation Setup Script
# This script sets up the documentation environment using uv

echo "🔍 Setting up Sherlock AI Documentation..."

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ uv is not installed. Please install it first:"
    echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

echo "✅ uv found"

# Sync dependencies
echo "📦 Installing dependencies with uv..."
uv sync

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
    echo ""
    echo "🎉 Setup complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Start local server: uv run mkdocs serve"
    echo "  2. Build docs:        uv run mkdocs build"
    echo "  3. Deploy:            uv run mkdocs gh-deploy"
    echo ""
    echo "Documentation will be available at: http://localhost:8000"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi
