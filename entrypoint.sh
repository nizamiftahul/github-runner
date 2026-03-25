#!/bin/bash

set -e

echo "🚀 Starting GitHub Actions Runner"
echo "=================================="

# Configuration
RUNNER_URL="${RUNNER_URL:-https://github.com/ksatu}"
RUNNER_TOKEN="${RUNNER_TOKEN}"
RUNNER_NAME="${RUNNER_NAME:-github-runner-$(hostname)}"
RUNNER_WORK="${RUNNER_WORK:-_work}"
RUNNER_GROUP="${RUNNER_GROUP:-default}"

# Check token
if [ -z "$RUNNER_TOKEN" ]; then
    echo "❌ ERROR: RUNNER_TOKEN is not set"
    echo "Set it with: docker run -e RUNNER_TOKEN=... myrunner"
    exit 1
fi

echo "📍 Configuration:"
echo "  URL: $RUNNER_URL"
echo "  Name: $RUNNER_NAME"
echo "  Work directory: $RUNNER_WORK"
echo "  Group: $RUNNER_GROUP"
echo ""

# Configure runner (hanya jika belum configured)
if [ ! -f ".runner" ]; then
    echo "⚙️  Configuring runner..."
    
    ./config.sh \
        --url "$RUNNER_URL" \
        --token "$RUNNER_TOKEN" \
        --name "$RUNNER_NAME" \
        --work "$RUNNER_WORK" \
        --runnergroup "$RUNNER_GROUP" \
        --labels "${RUNNER_LABELS:-docker,linux}" \
        --unattended \
        --replace
    
    echo "✅ Runner configured"
else
    echo "✅ Runner already configured"
fi

# Run the runner
echo ""
echo "🏃 Running GitHub Actions Runner..."
exec ./run.sh