#!/bin/bash
set -e
# Define your submodules (make sure these are added as submodules in your repository)
repos=("libglibutil" "libgbinder" "gbinder-python" "waydroid" "waydroid-sensors")
changed=0
for repo in "${repos[@]}"; do
if [ -d "$repo" ]; then
    echo "Checking submodule: $repo"
    cd "$repo"
    git fetch origin
    # Get the latest commit hash from the remote default branch.
    NEW_HASH=$(git rev-parse origin/HEAD)
    LOCAL_HASH=$(git rev-parse HEAD)
    if [ "$NEW_HASH" != "$LOCAL_HASH" ]; then
    echo "Submodule '$repo' updated: $LOCAL_HASH -> $NEW_HASH"
    git checkout $NEW_HASH
    changed=1
    else
    echo "Submodule '$repo' is up-to-date."
    fi
    cd ..
else
    echo "Submodule directory '$repo' not found. Skipping."
fi
done

if [ $changed -eq 1 ]; then
echo "Changes detected. Updating the main repository with new submodule pointers..."
git add .
git commit -m "Update submodules to latest commits" || echo "Nothing to commit"
git push origin HEAD
else
echo "No submodule updates found."
fi