#!/bin/bash

set -e

echo "REPO: $GITHUB_REPOSITORY"
echo "ACTOR: $GITHUB_ACTOR"

echo "==> Preparing..."
src_branch="$(python -c 'import conf; print(conf.GITHUB_SOURCE_BRANCH)')"
dest_branch="$(python -c 'import conf; print(conf.GITHUB_DEPLOY_BRANCH)')"

git remote add ghpages "https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git fetch ghpages $dest_branch
git checkout -b $dest_branch --track ghpages/$dest_branch || true
git pull ghpages $dest_branch || true
git checkout $src_branch

# Override config so that ghp-import does the right thing.
printf '\n\nGITHUB_REMOTE_NAME = "ghpages"\nGITHUB_COMMIT_SOURCE = False\n' >> conf.py

echo "==> Installing requirements..."
if [[ -f "requirements.txt" ]]; then
    # Since people might type just 'nikola', we force ghp-import2 to be installed.
    pip install -r requirements.txt ghp-import2
else
    pip install "Nikola[extras]"
fi

echo "==> Building site..."
nikola build
echo "==> Publishing..."
nikola github_deploy
echo "==> Done!"
