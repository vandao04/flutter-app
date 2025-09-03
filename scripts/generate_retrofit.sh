#!/bin/bash

# Generate Retrofit code và JSON serialization

echo "🚀 Bắt đầu tạo code cho Retrofit và JSON serialization..."

# Build cho Retrofit API và JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs

# In thông báo kết thúc
echo "✅ Đã tạo xong các file cho Retrofit và JSON serialization!"
echo "📁 Kiểm tra các file được tạo:"
echo "  - auth_api.g.dart (Retrofit implementation)"
echo "  - auth_models.g.dart (JSON serialization)"
