#!/bin/sh

set -e

PLUGIN_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PLUGIN_ROOT"

echo "🔍 Checking pubspec.yaml for version..."
PLUGIN_VERSION=$(grep '^version: ' pubspec.yaml | awk '{print $2}' | tr -d '\r\n')
if [ -z "$PLUGIN_VERSION" ]; then
  echo "❌ Could not find version in pubspec.yaml"
  exit 1
fi
echo "✅ Version found: $PLUGIN_VERSION"

echo "🔍 Checking if version $PLUGIN_VERSION already exists on pub.dev..."
PLUGIN_NAME=$(grep '^name: ' pubspec.yaml | awk '{print $2}' | tr -d '\r\n')
if curl -s "https://pub.dev/api/packages/$PLUGIN_NAME" | grep -q "\"version\":\"$PLUGIN_VERSION\""; then
  echo "❌ Version $PLUGIN_VERSION is already published on pub.dev"
  echo "   You cannot republish the same version. Please bump the version in pubspec.yaml"
  exit 1
fi
echo "✅ Version $PLUGIN_VERSION is not yet published"

echo "📖 Verifying CHANGELOG.md contains version..."
if ! grep -Eq "##[[:space:]]*(\[?v?$PLUGIN_VERSION\]?)" CHANGELOG.md; then
  echo "❌ CHANGELOG.md does not contain a version entry for $PLUGIN_VERSION"
  echo "   (Expected something like '## $PLUGIN_VERSION' or '## [v$PLUGIN_VERSION]')"
  exit 1
fi
echo "✅ CHANGELOG.md has an entry for version $PLUGIN_VERSION"

echo "🔍 Checking publish_to configuration..."
if grep -q "^publish_to:[[:space:]]*['\"]none['\"]" pubspec.yaml; then
  echo "❌ Package is marked as private (publish_to: 'none')"
  echo "   Remove or comment out the 'publish_to' field to publish to pub.dev"
  exit 1
fi
if grep -q "^publish_to:[[:space:]]*none" pubspec.yaml; then
  echo "❌ Package is marked as private (publish_to: none)"
  echo "   Remove or comment out the 'publish_to' field to publish to pub.dev"
  exit 1
fi
echo "✅ Package is configured for pub.dev publishing"

echo "🧪 Running dry-run publish..."
set +e  # Temporarily disable exit on error
flutter pub publish --dry-run
DRY_RUN_EXIT=$?
set -e  # Re-enable exit on error

if [ $DRY_RUN_EXIT -eq 65 ]; then
  echo "⚠️  Dry-run completed with warnings (usually okay - may be due to modified files or minor issues)"
elif [ $DRY_RUN_EXIT -ne 0 ]; then
  echo "❌ Dry-run failed with exit code $DRY_RUN_EXIT"
  exit $DRY_RUN_EXIT
else
  echo "✅ Dry-run completed successfully"
fi

echo "📦 Validating example project..."
if [ ! -d "example" ]; then
  echo "❌ No example/ directory found"
  exit 1
fi

cd example
flutter clean
flutter pub get

echo "📦 Installing CocoaPods in example/ios..."
cd ios
export LANG=en_US.UTF-8
set +e  # Temporarily disable exit on error
pod install
POD_EXIT=$?
set -e  # Re-enable exit on error
if [ $POD_EXIT -ne 0 ]; then
  echo "⚠️  CocoaPods install had issues (exit code $POD_EXIT), but continuing..."
fi
cd ..

echo "🚀 Ready to publish version $PLUGIN_VERSION to pub.dev"
printf "Are you sure you want to publish? (y/N): "
read confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "❌ Publishing cancelled."
  exit 1
fi

cd "$PLUGIN_ROOT"
echo "📤 Publishing to pub.dev..."
set +e  # Temporarily disable exit on error
flutter pub publish --force
PUBLISH_EXIT=$?
set -e  # Re-enable exit on error

if [ $PUBLISH_EXIT -ne 0 ]; then
  echo "❌ Publishing failed with exit code $PUBLISH_EXIT"
  if [ $PUBLISH_EXIT -eq 65 ]; then
    echo "   Common issues:"
    echo "   - Package marked as private: Check 'publish_to' field in pubspec.yaml"
    echo "   - Not logged in: Run 'flutter pub login'"
    echo "   - Package already published: Version may already exist on pub.dev"
  else
    echo "   Make sure you're logged in: flutter pub login"
  fi
  exit $PUBLISH_EXIT
fi

echo "🔖 Tagging release with v$PLUGIN_VERSION..."
set +e  # Temporarily disable exit on error
git tag "v$PLUGIN_VERSION" 2>/dev/null
TAG_EXIT=$?
set -e  # Re-enable exit on error

if [ $TAG_EXIT -eq 0 ]; then
  echo "✅ Created tag v$PLUGIN_VERSION"
  git push origin "v$PLUGIN_VERSION" || {
    echo "⚠️  Failed to push tag, but you can push it manually: git push origin v$PLUGIN_VERSION"
  }
elif git rev-parse "v$PLUGIN_VERSION" >/dev/null 2>&1; then
  echo "⚠️  Tag v$PLUGIN_VERSION already exists, skipping tag creation"
  git push origin "v$PLUGIN_VERSION" || {
    echo "⚠️  Failed to push tag, but tag already exists locally"
  }
else
  echo "❌ Failed to create tag v$PLUGIN_VERSION"
  exit 1
fi

echo "✅ Plugin version $PLUGIN_VERSION successfully published and tagged!"
