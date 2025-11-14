#!/usr/bin/env -S pkgx +convert bash

set -euo pipefail

SRC="$1"
OUTDIR="favicons"

mkdir -p "$OUTDIR"

# Common raster favicon sizes
SIZES=(
  16
  32
  48
  64
  128
  256
  512
)

echo "Generating PNG favicons..."
for SZ in "${SIZES[@]}"; do
  convert "$SRC" -resize "${SZ}x${SZ}" "$OUTDIR/favicon-${SZ}.png"
done

echo "Generating favicon.ico (16,32,48)..."
convert \
  "$OUTDIR/favicon-16.png" \
  "$OUTDIR/favicon-32.png" \
  "$OUTDIR/favicon-48.png" \
  "$OUTDIR/favicon.ico"

# Optional: Apple touch icons, which want larger sizes
echo "Generating Apple touch icons..."
APPLE_SIZES=(
  180
  152
  167
  120
)

for SZ in "${APPLE_SIZES[@]}"; do
  convert "$SRC" -resize "${SZ}x${SZ}" "$OUTDIR/apple-touch-icon-${SZ}.png"
done

# Optional: Android / PWA icons
echo "Generating Android / PWA icons..."
ANDROID_SIZES=(
  192
  256
  384
  512
)

for SZ in "${ANDROID_SIZES[@]}"; do
  convert "$SRC" -resize "${SZ}x${SZ}" "$OUTDIR/android-chrome-${SZ}.png"
done

echo "Done. Favicons written to $OUTDIR/"
