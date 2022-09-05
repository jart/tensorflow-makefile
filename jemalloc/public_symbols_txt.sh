#!/bin/bash
set -euo pipefail
cat <<'EOF' > jemalloc/include/jemalloc/internal/public_symbols.txt
free:jemalloc_free
malloc:jemalloc_malloc
posix_memalign:jemalloc_posix_memalign
realloc:jemalloc_realloc
EOF