#!/bin/bash
set -e

# Configuration
SOURCE_BRANCH="main"
NEW_BRANCH="prime-rewrite-$(date +%s)"

# 1. Validation
if ! command -v git-prime-commit &> /dev/null; then
    echo "Error: git-prime-commit is not in your PATH."
    exit 1
fi

# Ensure we have the source branch
if ! git show-ref --verify --quiet refs/heads/$SOURCE_BRANCH; then
    echo "Error: Branch '$SOURCE_BRANCH' not found. Are you in the right repo?"
    exit 1
fi

echo "Reading history from '$SOURCE_BRANCH'..."

# 2. Get the list of commits (Explicitly from main, not HEAD)
COMMITS=($(git rev-list --reverse $SOURCE_BRANCH))
TOTAL=${#COMMITS[@]}

if [ "$TOTAL" -eq 0 ]; then
    echo "Error: No commits found on $SOURCE_BRANCH."
    exit 1
fi

echo "Found $TOTAL commits to mine."
echo "Creating new clean branch: $NEW_BRANCH"

# 3. Create a fresh orphan branch (start from scratch)
git checkout --orphan "$NEW_BRANCH"
git rm -rf . > /dev/null 2>&1

# 4. The Mining Loop
count=0
for commit in "${COMMITS[@]}"; do
    ((count++))
    
    # Get the original message, strip any previous Nonce headers (case insensitive)
    MSG=$(git show -s --format=%B "$commit" | grep -v -i "prime-nonce:")
    
    echo "---------------------------------------------------"
    echo "Processing [$count/$TOTAL] ${commit:0:7}"
    
    # Force the Index (staging area) to match the target commit exactly
    git checkout -f "$commit" -- . > /dev/null 2>&1
    
    # Stage any deletions that 'checkout' might have missed if files were removed
    git add -A
    
    # Create the prime commit
    git prime-commit "$MSG"
done

echo ""
echo "==================================================="
echo "DONE! All $TOTAL commits are now prime."
echo "==================================================="
echo "To apply this change:"
echo "  1. git checkout main"
echo "  2. git reset --hard $NEW_BRANCH"
echo "  3. git push --force"
