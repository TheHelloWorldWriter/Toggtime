#!/bin/bash
#
# Build the Toggtime release ZIP archive.
# Run from the repo root: ./scripts/build-release.sh
#

set -e

VERSION="1.0.0"
ARCHIVE="dist/toggtime-${VERSION}-dos.zip"

EXE="SRC/TOGGTIME.EXE"
README="dist/README.TXT"
LICENSE="dist/LICENSE.TXT"

if [ ! -f "$EXE" ]; then
  echo "Error: $EXE not found. Compile Toggtime in Turbo Pascal first."
  exit 1
fi

if [ ! -f "$README" ]; then
  echo "Error: $README not found."
  exit 1
fi

if [ ! -f "$LICENSE" ]; then
  echo "Error: $LICENSE not found."
  exit 1
fi

rm -f "$ARCHIVE"

zip -j "$ARCHIVE" "$EXE" "$README" "$LICENSE"

echo ""
echo "Created $ARCHIVE"
