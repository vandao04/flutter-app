#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${PURPLE}🚀 MVP App - Complete Project Setup${NC}"
echo -e "${PURPLE}=====================================${NC}\n"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print step
print_step() {
    echo -e "\n${BLUE}🔧 $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to print info
print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Step 1: Check prerequisites
print_step "Checking prerequisites..."

# Check Flutter
if ! command_exists flutter; then
    print_error "Flutter is not installed!"
    print_info "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | grep -o "Flutter [0-9]\+\.[0-9]\+\.[0-9]\+" | head -1)
print_success "Flutter detected: $FLUTTER_VERSION"

# Check Flutter doctor
print_info "Running Flutter doctor..."
flutter doctor

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    print_error "Not in a Flutter project directory!"
    exit 1
fi

print_success "Prerequisites check completed"

# Step 2: Install dependencies
print_step "Installing Flutter dependencies..."
flutter pub get
if [ $? -eq 0 ]; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Step 3: Setup environment files
print_step "Setting up environment files..."

# Make setup script executable
chmod +x scripts/setup_env.sh

# Run environment setup
./scripts/setup_env.sh

if [ $? -eq 0 ]; then
    print_success "Environment files created successfully"
else
    print_error "Failed to create environment files"
    exit 1
fi

# Step 4: Generate code
print_step "Generating code with build_runner..."

# Make generate script executable
chmod +x scripts/generate_code.sh

# Run code generation
./scripts/generate_code.sh

if [ $? -eq 0 ]; then
    print_success "Code generation completed successfully"
else
    print_error "Code generation failed"
    exit 1
fi

# Step 5: Make build script executable
print_step "Setting up build scripts..."
chmod +x scripts/build.sh
print_success "Build scripts are ready"

# Step 6: Create additional directories
print_step "Creating project structure..."

# Create test directories
mkdir -p test/unit/features/user
mkdir -p test/unit/core
mkdir -p test/widget
mkdir -p test/integration
mkdir -p test/helpers

# Create assets directories
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/fonts
mkdir -p assets/translations

# Create documentation directories
mkdir -p docs/api
mkdir -p docs/architecture
mkdir -p docs/deployment

print_success "Project structure created"

# Step 7: Create basic test files
print_step "Creating basic test files..."

# Create test helper
cat > test/helpers/test_helpers.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Test helper for Riverpod
class TestProviderContainer extends ProviderContainer {
  TestProviderContainer([List<Override> overrides = const []]) : super(overrides: overrides);
}

// Test helper for common test setup
class TestSetup {
  static ProviderContainer createTestContainer([List<Override> overrides = const []]) {
    return TestProviderContainer(overrides);
  }
}
EOF

# Create basic user test
cat > test/unit/features/user/user_model_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:mvp_app/features/user/data/models/user_model.dart';

void main() {
  group('User Model Tests', () {
    test('should create User from JSON', () {
      // TODO: Add your tests here
      expect(true, isTrue);
    });

    test('should convert User to JSON', () {
      // TODO: Add your tests here
      expect(true, isTrue);
    });
  });
}
EOF

print_success "Basic test files created"

# Step 8: Create documentation files
print_step "Creating documentation files..."

# Create API documentation template
cat > docs/api/README.md << 'EOF'
# API Documentation

## Authentication Endpoints

### POST /auth/login
Login with email and password

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "user": {
    "id": "123",
    "email": "user@example.com",
    "name": "User Name"
  },
  "accessToken": "jwt_token_here",
  "refreshToken": "refresh_token_here"
}
```

## User Endpoints

### GET /users
Get list of users with pagination

**Query Parameters:**
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)
- `search`: Search query

### GET /users/{id}
Get user by ID

### PUT /users/{id}
Update user

### DELETE /users/{id}
Delete user
EOF

# Create architecture documentation
cat > docs/architecture/README.md << 'EOF'
# Architecture Documentation

## Clean Architecture Overview

This project follows Clean Architecture principles with the following layers:

### 1. Presentation Layer
- **Pages**: UI screens and widgets
- **Providers**: State management with Riverpod
- **Controllers**: Business logic for UI

### 2. Domain Layer
- **Entities**: Business objects
- **Use Cases**: Business logic
- **Repository Interfaces**: Data access contracts

### 3. Data Layer
- **Models**: Data transfer objects (DTOs)
- **Repository Implementations**: Data access logic
- **Data Sources**: API, local storage, etc.

### 4. Core Layer
- **Network**: HTTP client, API interfaces
- **Error Handling**: Centralized error management
- **Configuration**: App settings and environment

## State Management

We use Riverpod for state management with the following patterns:

- **Provider**: Read-only state
- **StateNotifierProvider**: Mutable state with business logic
- **FutureProvider**: Async operations
- **StreamProvider**: Real-time data streams

## Network Layer

- **Retrofit**: Type-safe API client generation
- **Dio**: HTTP client with interceptors
- **Error Handling**: Centralized error mapping
- **Retry Logic**: Automatic retry for failed requests
EOF

print_success "Documentation files created"

# Step 9: Create deployment guide
print_step "Creating deployment guide..."

cat > docs/deployment/README.md << 'EOF'
# Deployment Guide

## Environment Setup

### 1. Development
```bash
# Use .env file
flutter run --dart-define=ENVIRONMENT=development
```

### 2. Staging
```bash
# Use .env.staging file
flutter run --dart-define=ENVIRONMENT=staging
```

### 3. Production
```bash
# Use .env.production file
flutter run --dart-define=ENVIRONMENT=production
```

## Build Commands

### Android
```bash
# Development
./scripts/build.sh development android debug

# Staging
./scripts/build.sh staging android release

# Production
./scripts/build.sh production android release
```

### iOS
```bash
# Development
./scripts/build.sh development ios debug

# Staging
./scripts/build.sh staging ios release

# Production
./scripts/build.sh production ios release
```

### Web
```bash
# Development
./scripts/build.sh development web debug

# Staging
./scripts/build.sh staging web release

# Production
./scripts/build.sh production web release
```

## CI/CD Setup

### GitHub Actions Example
```yaml
name: Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.0'
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze
```

## App Store Deployment

### Android
1. Build release APK: `./scripts/build.sh production android release`
2. Test on device
3. Upload to Google Play Console

### iOS
1. Build release: `./scripts/build.sh production ios release`
2. Archive in Xcode
3. Upload to App Store Connect
EOF

print_success "Deployment guide created"

# Step 10: Create .gitignore entries
print_step "Updating .gitignore..."

# Add common Flutter ignores if not present
if ! grep -q "build/" .gitignore; then
    echo "" >> .gitignore
    echo "# Flutter build outputs" >> .gitignore
    echo "build/" >> .gitignore
    echo "*.lock" >> .gitignore
    echo ".dart_tool/" >> .gitignore
    echo ".flutter-plugins" >> .gitignore
    echo ".flutter-plugins-dependencies" >> .gitignore
fi

# Add generated files to .gitignore
if ! grep -q "*.g.dart" .gitignore; then
    echo "" >> .gitignore
    echo "# Generated files" >> .gitignore
    echo "*.g.dart" >> .gitignore
    echo "*.freezed.dart" >> .gitignore
    echo "*.gr.dart" >> .gitignore
fi

# Add IDE files to .gitignore
if ! grep -q ".idea/" .gitignore; then
    echo "" >> .gitignore
    echo "# IDE files" >> .gitignore
    echo ".idea/" >> .gitignore
    echo "*.iml" >> .gitignore
    echo ".vscode/" >> .gitignore
fi

print_success ".gitignore updated"

# Step 11: Final setup
print_step "Finalizing setup..."

# Create a quick start script
cat > quick_start.sh << 'EOF'
#!/bin/bash

echo "🚀 Quick Start for MVP App"
echo "=========================="
echo ""
echo "1. Setup environment:"
echo "   ./scripts/setup_env.sh"
echo ""
echo "2. Generate code:"
echo "   ./scripts/generate_code.sh"
echo ""
echo "3. Run the app:"
echo "   flutter run"
echo ""
echo "4. Build for different environments:"
echo "   ./scripts/build.sh staging android release"
echo "   ./scripts/build.sh production ios release"
echo ""
echo "5. Run tests:"
echo "   flutter test"
echo ""
echo "6. Analyze code:"
echo "   flutter analyze"
echo ""
echo "📚 Check docs/ folder for detailed documentation"
echo "🔧 Check scripts/ folder for automation scripts"
EOF

chmod +x quick_start.sh

print_success "Quick start script created"

# Final summary
echo -e "\n${GREEN}🎉 Project setup completed successfully!${NC}"
echo -e "\n${BLUE}📋 What was created:${NC}"
echo -e "  ✅ Environment files (.env, .env.staging, .env.production)"
echo -e "  ✅ Code generation setup"
echo -e "  ✅ Build scripts for all platforms"
echo -e "  ✅ Test structure and basic tests"
echo -e "  ✅ Documentation (API, Architecture, Deployment)"
echo -e "  ✅ Project structure directories"
echo -e "  ✅ Updated .gitignore"
echo -e "  ✅ Quick start script"

echo -e "\n${YELLOW}🚀 Next steps:${NC}"
echo -e "1. Edit environment files with your actual values"
echo -e "2. Customize API endpoints in lib/core/network/api_interfaces.dart"
echo -e "3. Add your business logic in domain layer"
echo -e "4. Create UI screens in presentation layer"
echo -e "5. Add tests for your features"
echo -e "6. Run './quick_start.sh' for a quick overview"

echo -e "\n${CYAN}📚 Available scripts:${NC}"
echo -e "  • ./scripts/setup_env.sh - Setup environment files"
echo -e "  • ./scripts/generate_code.sh - Generate code with build_runner"
echo -e "  • ./scripts/build.sh - Build for different environments"
echo -e "  • ./quick_start.sh - Quick start guide"

echo -e "\n${PURPLE}🎯 Your MVP App is ready to use!${NC}"
echo -e "${PURPLE}Happy coding! 🚀${NC}"
