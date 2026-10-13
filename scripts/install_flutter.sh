#!/usr/bin/env bash
# Installs the latest stable Flutter SDK into $FLUTTER_HOME (default: $HOME/flutter).
# Uses the release archive rather than `git clone`, and fills in the SDK version
# metadata if Flutter can't derive it from git (e.g. in restricted environments).
set -euo pipefail

FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"
BASE=https://storage.googleapis.com/flutter_infra_release/releases

RELEASE=$(curl -fsSL "$BASE/releases_linux.json" | node -e '
  let s = "";
  process.stdin.on("data", d => (s += d)).on("end", () => {
    const j = JSON.parse(s);
    const r = j.releases.find(r => r.hash === j.current_release.stable);
    console.log(JSON.stringify({ archive: r.archive, version: r.version }));
  });
')
ARCHIVE=$(node -p "JSON.parse(process.argv[1]).archive" "$RELEASE")
VERSION=$(node -p "JSON.parse(process.argv[1]).version" "$RELEASE")

if [ ! -x "$FLUTTER_HOME/bin/flutter" ]; then
  echo "Downloading Flutter $VERSION"
  mkdir -p "$(dirname "$FLUTTER_HOME")"
  curl -fsSL "$BASE/$ARCHIVE" | tar -xJ -C "$(dirname "$FLUTTER_HOME")"
fi

# First run builds the tool and writes bin/cache/flutter.version.json.
"$FLUTTER_HOME/bin/flutter" --version >/dev/null 2>&1 || true

VERSION_FILE="$FLUTTER_HOME/bin/cache/flutter.version.json"
if [ -f "$VERSION_FILE" ]; then
  node -e '
    const fs = require("fs");
    const [file, version] = process.argv.slice(1);
    const v = JSON.parse(fs.readFileSync(file, "utf8"));
    if (v.frameworkVersion === "0.0.0-unknown" || v.flutterVersion === "0.0.0-unknown") {
      Object.assign(v, {
        frameworkVersion: version,
        flutterVersion: version,
        channel: "stable",
        repositoryUrl: "https://github.com/flutter/flutter.git",
      });
      fs.writeFileSync(file, JSON.stringify(v, null, 2));
      console.log(`Set Flutter SDK version metadata to ${version}`);
    }
  ' "$VERSION_FILE" "$VERSION"
fi

"$FLUTTER_HOME/bin/flutter" --version
