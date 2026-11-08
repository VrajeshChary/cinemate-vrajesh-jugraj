#!/bin/bash
set -e

echo "=========================================="
echo "🎬 CINEMATE - Vercel Flutter Web Build"
echo "=========================================="

# 1. Clone Flutter SDK if not present in build cache
if [ ! -d "flutter" ]; then
  echo "==> Downloading Flutter SDK (stable channel)..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter
else
  echo "==> Using cached Flutter SDK..."
fi

# 2. Add Flutter to PATH
export PATH="$(pwd)/flutter/bin:$PATH"

# 3. Enable Flutter Web & precache artifacts
echo "==> Configuring Flutter Web..."
flutter config --enable-web --no-analytics
flutter precache --web

# 4. Show Flutter version in build logs
flutter --version

# 5. Fetch dependencies
echo "==> Running flutter pub get..."
flutter pub get

# 6. Build Flutter Web release
echo "==> Compiling Flutter Web for Production..."
flutter build web --release --base-href /

echo "=========================================="
echo "✅ Build Successful! Output ready in build/web"
echo "=========================================="
