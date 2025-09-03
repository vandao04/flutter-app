# MVP App

A Flutter application built with Clean Architecture, Riverpod, Retrofit, and Freezed.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode
- Git

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd mvp_app

# Install dependencies
flutter pub get

# Generate code (Freezed, Retrofit, JSON)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## 🌍 Running Different Environments

### Using Script (Recommended)
```bash
# Make script executable
chmod +x scripts/run_env.sh

# Display help and options
./scripts/run_env.sh --help

# Run in development mode (default)
./scripts/run_env.sh dev

# Run in staging mode
./scripts/run_env.sh staging

# Run in production mode
./scripts/run_env.sh prod
```

### Advanced Script Usage
```bash
# Specify platform (ios, android, web, macos, linux, windows)
./scripts/run_env.sh dev -p ios

# Specify device by ID
./scripts/run_env.sh staging -d CFB72B2E-0137-4D66-977D-C782A5B576C2

# Build instead of run (requires platform)
./scripts/run_env.sh prod -b -p android

# Combined example: Run on specific iOS device in staging mode
./scripts/run_env.sh staging -p ios -d CFB72B2E-0137-4D66-977D-C782A5B576C2
```

### Manual Commands (Alternative)
```bash
# Development
flutter run --dart-define=ENVIRONMENT=development \
  --dart-define=API_BASE_URL=https://dev-api.example.com \
  --dart-define=ENABLE_LOGGING=true \
  --dart-define=ENABLE_ANALYTICS=false

# Staging
flutter run --dart-define=ENVIRONMENT=staging \
  --dart-define=API_BASE_URL=https://staging-api.example.com \
  --dart-define=ENABLE_LOGGING=true \
  --dart-define=ENABLE_ANALYTICS=true

# Production
flutter run --dart-define=ENVIRONMENT=production \
  --dart-define=API_BASE_URL=https://api.example.com \
  --dart-define=ENABLE_LOGGING=false \
  --dart-define=ENABLE_ANALYTICS=true
```

### Environment Files Configuration
The app uses .env files for environment configuration:

1. `.env` - Common variables for all environments
2. `.env.development` - Development-specific variables
3. `.env.staging` - Staging-specific variables
4. `.env.production` - Production-specific variables

Variables in environment-specific files override common variables. Key environment variables:

```
# API Configuration
API_BASE_URL=https://api.example.com
API_VERSION=v1

# Debug & Development
DEBUG_MODE=true
LOG_LEVEL=debug
ENABLE_LOGGING=true
```

#### Setting Up Environment Files

1. Create or modify environment files:

```bash
# Copy example environment file
cp .env.example .env.development
cp .env.example .env.staging
cp .env.example .env.production

# Edit with your values
nano .env.development
```

2. Update the necessary values for each environment:
   - Development: Use local or development API endpoints
   - Staging: Use staging servers with test data
   - Production: Use production servers with real data

3. The script automatically loads:
   - First: Common variables from `.env`
   - Then: Environment-specific variables which override common values

You can see the current environment in the console when the app starts:
```
🚀 ===== APP STARTUP =====
Current environment: development
API URL: https://dev-api.example.com
Logging enabled: true
Analytics enabled: false
========================
```

## 🏗️ Architecture

### Clean Architecture Layers
- **Core**: App configuration, error handling, network setup
- **Features**: User management, authentication, etc.
- **Shared**: Common widgets, utilities, and components

### Key Technologies
- **State Management**: Riverpod
- **HTTP Client**: Dio + Retrofit
- **Code Generation**: Freezed, JSON Serializable
- **Architecture**: Clean Architecture with Feature-based structure

## 📱 Features

- User authentication and management
- Clean and modern UI
- Error handling and loading states
- Network connectivity management
- Multi-environment support

## 🔧 Development

### Code Generation
```bash
# Generate all code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter packages pub run build_runner watch
```

### Project Structure
```
lib/
├── core/           # App configuration, providers, routing
├── features/       # Feature modules
│   ├── home/      # Home feature
│   └── user/      # User management feature
└── shared/        # Shared components and utilities
```

### Environment Structure
```
/
├── .env                # Common variables for all environments
├── .env.development    # Development environment specific variables
├── .env.staging        # Staging environment specific variables
├── .env.production     # Production environment specific variables
└── scripts/
    └── run_env.sh      # Script to run app with environment variables
```

## 🚀 Deployment

### Build Commands Using Script (Recommended)
```bash
# Android (Production)
./scripts/run_env.sh prod -p android -b

# iOS (Production)
./scripts/run_env.sh prod -p ios -b

# Web (Production)
./scripts/run_env.sh prod -p web -b
```

### Alternative Build Commands
```bash
# Android
flutter build apk --release --dart-define=ENVIRONMENT=production

# iOS
flutter build ios --release --dart-define=ENVIRONMENT=production

# Web
flutter build web --dart-define=ENVIRONMENT=production
```

### Environment Variables
Configure your environment by:
1. Modifying the appropriate `.env` files
2. Using the `scripts/run_env.sh` script with environment parameters
3. Passing `--dart-define` parameters directly to Flutter commands

## 📚 Dependencies

### Core Dependencies
- `flutter_riverpod`: State management
- `dio`: HTTP client
- `retrofit`: Type-safe HTTP client
- `freezed_annotation`: Immutable data classes
- `dartz`: Functional programming utilities

### Dev Dependencies
- `build_runner`: Code generation
- `freezed`: Code generation for Freezed
- `retrofit_generator`: Code generation for Retrofit
- `json_serializable`: JSON serialization

## 🐛 Troubleshooting

### Common Issues
1. **Code not generated**: Run `flutter packages pub run build_runner build --delete-conflicting-outputs`
2. **Environment not detected**: Check your `.env` files and ensure `scripts/run_env.sh` is loading them correctly
3. **Build errors**: Clean and regenerate code with `flutter clean && flutter pub get`
4. **"Target file 'App' not found"**: Use `-p` flag to specify platform and `-d` flag to specify device
5. **iOS simulator issues**: Specify device ID with `-d` flag (e.g., `./scripts/run_env.sh staging -d CFB72B2E-0137-4D66-977D-C782A5B576C2`)

### Debug Information
The app prints environment information on startup. Check the console for:
- Current environment
- API configuration
- Feature flags status

### Running Script Troubleshooting
If you encounter issues with the `run_env.sh` script:
```bash
# Make sure the script is executable
chmod +x scripts/run_env.sh

# Check available devices
flutter devices

# Try specifying exact platform and device
./scripts/run_env.sh staging -p ios -d <device-id>

# Check script help for more options
./scripts/run_env.sh --help
```

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Contact

For questions and support, please contact the development team.
