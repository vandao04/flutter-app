#!/bin/bash

# Usage information
usage() {
  echo "Usage: $0 [environment] [options]"
  echo "Environment:"
  echo "  dev, development    Run in development mode"
  echo "  staging             Run in staging mode"
  echo "  prod, production    Run in production mode"
  echo "Options:"
  echo "  -p, --platform      Specify platform (ios, android, web, macos, linux, windows)"
  echo "  -d, --device        Specify device ID or name (default: first available device)"
  echo "  -b, --build         Build the app instead of running it"
  echo "  -h, --help          Show this help message"
  echo "Example:"
  echo "  $0 dev -p ios       Run in development mode on iOS"
  echo "  $0 staging -d emulator-5554    Run in staging mode on specific Android emulator"
}

# Check for help flag as the first argument
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  usage
  exit 0
fi

# Default values
ENVIRONMENT=${1:-development}
PLATFORM=""
DEVICE=""
BUILD_MODE=false

# Shift the first argument (environment)
shift 2>/dev/null || true

# Parse command line options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--platform)
      PLATFORM="$2"
      shift 2
      ;;
    -d|--device)
      DEVICE="$2"
      shift 2
      ;;
    -b|--build)
      BUILD_MODE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "❌ Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

# Setup paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_PARAMS=""

# Function to load environment variables from a file
load_env_file() {
  if [ ! -f "$1" ]; then
    echo "Warning: Environment file $1 not found"
    return
  fi
  
  echo "Loading environment from $1"
  while IFS= read -r line || [ -n "$line" ]; do
    # Skip comments and empty lines
    [[ "$line" =~ ^# ]] && continue
    [[ -z "$line" ]] && continue
    
    # Extract key and value
    if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
      key="${BASH_REMATCH[1]}"
      value="${BASH_REMATCH[2]}"
      
      # Remove quotes if present
      value="${value#\"}"
      value="${value%\"}"
      value="${value#\'}"
      value="${value%\'}"
      
      # Add to flutter parameters
      ENV_PARAMS="$ENV_PARAMS --dart-define=$key=$value"
    fi
  done < "$1"
}

# Check if flutter is installed
if ! command -v flutter &> /dev/null; then
  echo "❌ Flutter is not installed or not in PATH"
  exit 1
fi

# Function to check available devices
check_devices() {
  # Get the list of available devices
  DEVICES=$(flutter devices)
  
  # Check if no devices are available
  if [[ $DEVICES == *"No devices available"* ]]; then
    echo "❌ No devices available. Please connect a device or start an emulator/simulator."
    exit 1
  fi
  
  echo "Available devices:"
  echo "$DEVICES"
}

# Common .env file (shared between all environments)
COMMON_ENV_FILE="$PROJECT_ROOT/.env"

# Platform-specific arguments
PLATFORM_ARGS=""
if [ -n "$PLATFORM" ]; then
  case "$PLATFORM" in
    ios)
      PLATFORM_ARGS="$PLATFORM_ARGS -d ios"
      ;;
    android)
      PLATFORM_ARGS="$PLATFORM_ARGS -d android"
      ;;
    web)
      PLATFORM_ARGS="$PLATFORM_ARGS -d web"
      ;;
    macos)
      PLATFORM_ARGS="$PLATFORM_ARGS -d macos"
      ;;
    linux)
      PLATFORM_ARGS="$PLATFORM_ARGS -d linux"
      ;;
    windows)
      PLATFORM_ARGS="$PLATFORM_ARGS -d windows"
      ;;
    *)
      echo "❌ Invalid platform: $PLATFORM"
      echo "Supported platforms: ios, android, web, macos, linux, windows"
      exit 1
      ;;
  esac
fi

# Device-specific arguments
DEVICE_ARGS=""
if [ -n "$DEVICE" ]; then
  DEVICE_ARGS="$DEVICE_ARGS -d $DEVICE"
fi

# Process environment and load environment variables
case $ENVIRONMENT in
  "dev"|"development")
    ENV_FILE="$PROJECT_ROOT/.env.development"
    echo "🚀 Setting up DEVELOPMENT environment..."
    ENV_NAME="development"
    # Load the common env file first
    load_env_file "$COMMON_ENV_FILE"
    # Then load environment specific file (will override common values)
    load_env_file "$ENV_FILE"
    ;;
  "staging")
    ENV_FILE="$PROJECT_ROOT/.env.staging"
    echo "🚀 Setting up STAGING environment..."
    ENV_NAME="staging"
    load_env_file "$COMMON_ENV_FILE"
    load_env_file "$ENV_FILE"
    ;;
  "prod"|"production")
    ENV_FILE="$PROJECT_ROOT/.env.production"
    echo "🚀 Setting up PRODUCTION environment..."
    ENV_NAME="production"
    load_env_file "$COMMON_ENV_FILE"
    load_env_file "$ENV_FILE"
    ;;
  *)
    echo "❌ Invalid environment: $ENVIRONMENT"
    usage
    exit 1
    ;;
esac

# Ensure ENVIRONMENT is set correctly regardless of env file
ENV_PARAMS="$ENV_PARAMS --dart-define=ENVIRONMENT=$ENV_NAME"

# Either build or run the application
if [ "$BUILD_MODE" = true ]; then
  # Building the app
  echo "🔨 Building app in $ENV_NAME mode..."
  if [ -n "$PLATFORM" ]; then
    flutter build $PLATFORM $ENV_PARAMS
  else
    echo "❌ Platform must be specified for build mode"
    echo "Example: $0 $ENVIRONMENT -b -p ios"
    exit 1
  fi
else
  # Running the app
  echo "🚀 Running app in $ENV_NAME mode..."
  
  # Check available devices if no specific device is provided
  if [ -z "$PLATFORM" ] && [ -z "$DEVICE" ]; then
    check_devices
  fi
  
  # Run the app with the collected parameters
  # For iOS and macOS targets, we need to specify the workspace and scheme
  if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "macos" ]]; then
    # For iOS, specify that we want to use the Runner scheme
    echo "Using specific Runner scheme for Apple platforms..."
    
    # For iOS or macOS
    flutter run \
      $PLATFORM_ARGS $DEVICE_ARGS \
      --target lib/main.dart \
      $ENV_PARAMS
  else
    # For other platforms, use standard command
    flutter run $PLATFORM_ARGS $DEVICE_ARGS --target lib/main.dart $ENV_PARAMS
  fi
fi
