#!/bin/bash

set -e

echo "REPO: $GITHUB_REPOSITORY"
echo "ACTOR: $GITHUB_ACTOR"

echo '# Install Requirements'
pip install -r requirements.txt
echo '# Build site'
nikola build
echo '# Publish to GitHub Pages'
nikola github_deploy
echo '# Done'