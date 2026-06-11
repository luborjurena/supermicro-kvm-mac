#!/bin/zsh
# Launch an ATEN/Supermicro iKVM viewer from a launch.jnlp file on Apple Silicon.
# Usage: ./run-jnlp.sh [path-to-launch.jnlp]   (default: ~/Downloads/launch.jnlp)
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
JNLP="${1:-$HOME/Downloads/launch.jnlp}"

# Resolve an x86_64 Java 8 (the ATEN viewer + natives/*.jnilib are x86_64, so on
# Apple Silicon this runs under Rosetta 2). Override with IKVM_JAVA=/path/to/java.
if [[ -n "$IKVM_JAVA" ]]; then
  JAVA="$IKVM_JAVA"
elif [[ -x "$DIR/jdk8u492-b09-jre/Contents/Home/bin/java" ]]; then
  JAVA="$DIR/jdk8u492-b09-jre/Contents/Home/bin/java"   # bundled JRE, if present
elif [[ -n "$JAVA_HOME" && -x "$JAVA_HOME/bin/java" ]]; then
  JAVA="$JAVA_HOME/bin/java"
elif JAVA="$(command -v java)"; then
  :
else
  echo "No Java found. Install an x86_64 Java 8 (e.g. Temurin 8 from" >&2
  echo "https://adoptium.net/) and point IKVM_JAVA or JAVA_HOME at it." >&2
  exit 1
fi

ARGS=($(sed -n 's/.*<argument>\(.*\)<\/argument>.*/\1/p' "$JNLP"))
echo "Connecting to ${ARGS[1]} ..."
exec "$JAVA" -Xmx128M -Djava.library.path="$DIR/natives" \
  -cp "$DIR/iKVM.jar" tw.com.aten.ikvm.KVMMain "${ARGS[@]}"
