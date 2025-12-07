#!/bin/zsh

# Git Push Script for FilmStudioPilot
# This script stages, commits, and pushes changes to the repository

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the repository root
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

echo "${BLUE}=== FilmStudioPilot Git Push Script ===${NC}\n"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "${YELLOW}Current branch: ${CURRENT_BRANCH}${NC}\n"

# Check for uncommitted changes
if [ -z "$(git status --porcelain)" ]; then
    echo "${YELLOW}No changes to commit${NC}"
    exit 0
fi

# Show status
echo "${BLUE}Current status:${NC}"
git status --short
echo ""

# Ask for commit message
echo "${YELLOW}Enter commit message (or press Enter for default):${NC}"
read -r COMMIT_MESSAGE

if [ -z "$COMMIT_MESSAGE" ]; then
    COMMIT_MESSAGE="Update: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "${YELLOW}Using default message: ${COMMIT_MESSAGE}${NC}"
fi

# Stage all changes
echo "\n${BLUE}Staging all changes...${NC}"
git add -A

# Show what will be committed
echo "\n${BLUE}Changes to be committed:${NC}"
git status --short

# Confirm commit
echo "\n${YELLOW}Commit these changes? (y/n)${NC}"
read -r CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "${RED}Commit cancelled${NC}"
    exit 1
fi

# Commit
echo "\n${BLUE}Committing changes...${NC}"
git commit -m "$COMMIT_MESSAGE"

if [ $? -eq 0 ]; then
    echo "${GREEN}✓ Commit successful${NC}"
else
    echo "${RED}✗ Commit failed${NC}"
    exit 1
fi

# Check if remote exists
REMOTE_EXISTS=$(git remote | grep -c origin || echo "0")
if [ "$REMOTE_EXISTS" -eq 0 ]; then
    echo "${YELLOW}No remote 'origin' found. Skipping push.${NC}"
    exit 0
fi

# Get remote URL
REMOTE_URL=$(git remote get-url origin)
echo "\n${BLUE}Remote: ${REMOTE_URL}${NC}"

# Ask to push
echo "\n${YELLOW}Push to ${CURRENT_BRANCH}? (y/n)${NC}"
read -r PUSH_CONFIRM

if [ "$PUSH_CONFIRM" != "y" ] && [ "$PUSH_CONFIRM" != "Y" ]; then
    echo "${YELLOW}Push cancelled${NC}"
    exit 0
fi

# Push
echo "\n${BLUE}Pushing to origin/${CURRENT_BRANCH}...${NC}"
git push -u origin "$CURRENT_BRANCH"

if [ $? -eq 0 ]; then
    echo "${GREEN}✓ Push successful${NC}"
    echo "\n${GREEN}=== All done! ===${NC}"
else
    echo "${RED}✗ Push failed${NC}"
    exit 1
fi

