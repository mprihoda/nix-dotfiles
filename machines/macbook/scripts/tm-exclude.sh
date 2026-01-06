#!/bin/bash
# PURPOSE: Exclude developer build artifacts and caches from Time Machine backups.
# PURPOSE: Run periodically to catch new projects. Requires sudo for fixed-path exclusions.

set -euo pipefail

DEVEL_ROOT="$HOME/Devel"
MAX_DEPTH=4  # 3 levels of nesting + 1 for the pattern directory itself

# Global caches - fixed paths, excluded once
GLOBAL_EXCLUDES=(
    "$HOME/Library/Caches"
    "$HOME/Downloads"
    "$HOME/.m2/repository"
    "$HOME/.ivy2/cache"
    "$HOME/.sbt/boot"
    "$HOME/.sbt/1.0/zinc"
    "$HOME/.mill"
    "$HOME/.bloop"
    "$HOME/.npm"
    "$HOME/.yarn/cache"
    "$DEVEL_ROOT/thirdparty"
)

# Docker paths - added if Docker is detected
DOCKER_EXCLUDES=(
    "$HOME/.docker"
    "$HOME/Library/Containers/com.docker.docker"
    "$HOME/Library/Group Containers/group.com.docker"
)

# Build output patterns to find in DEVEL_ROOT
BUILD_PATTERNS=(
    "target"
    "out"
    ".bloop"
    ".metals"
    ".bsp"
    "dist"
    "node_modules"
    ".terraform"
)

exclude_path() {
    local path="$1"
    if [[ -d "$path" ]]; then
        if sudo tmutil addexclusion -p "$path" 2>/dev/null; then
            echo "Excluded: $path"
        else
            echo "Failed:   $path" >&2
        fi
    fi
}

echo "=== Global caches ==="
for path in "${GLOBAL_EXCLUDES[@]}"; do
    exclude_path "$path"
done

echo ""
echo "=== Docker (if present) ==="
if command -v docker &>/dev/null || [[ -d "$HOME/.docker" ]]; then
    for path in "${DOCKER_EXCLUDES[@]}"; do
        exclude_path "$path"
    done
else
    echo "Docker not detected, skipping"
fi

echo ""
echo "=== Build outputs in $DEVEL_ROOT ==="
for pattern in "${BUILD_PATTERNS[@]}"; do
    while IFS= read -r -d '' dir; do
        exclude_path "$dir"
    done < <(find "$DEVEL_ROOT" -maxdepth "$MAX_DEPTH" -name "$pattern" -type d -print0 2>/dev/null)
done

echo ""
echo "Done."
