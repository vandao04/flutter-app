#!/bin/bash

echo "🧹 Cleaning previous generated files..."
flutter packages pub run build_runner clean

echo "🔨 Generating code with build_runner..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "✅ Code generation completed!"
echo "📁 Generated files:"
find . -name "*.g.dart" -o -name "*.freezed.dart" | head -20

echo ""
echo "🚀 Ready to run the app!"
