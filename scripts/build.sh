#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT=${1:-development}
PLATFORM=${2:-android}
BUILD_TYPE=${3:-debug}
OUTPUT_DIR="builds"

# Function to print usage
print_usage() {
    echo -e "${BLUE}🚀 MVP App Build Script${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  $0 [ENVIRONMENT] [PLATFORM] [BUILD_TYPE]"
    echo ""
    echo -e "${YELLOW}Parameters:${NC}"
    echo -e "  ENVIRONMENT: development, staging, production (default: development)"
    echo -e "  PLATFORM: android, ios, web, all (default: android)"
    echo -e "  BUILD_TYPE: debug, release, profile (default: debug)"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo -e "  $0                    # Build development for android debug"
    echo -e "  $0 staging            # Build staging for android debug"
    echo -e "  $0 production ios     # Build production for ios debug"
    echo -e "  $0 staging web release # Build staging for web release"
    echo -e "  $0 production all release # Build production for all platforms release"
    echo ""
    echo -e "${YELLOW}Available combinations:${NC}"
    echo -e "  • Development builds: debug only"
    echo -e "  • Staging builds: debug, profile, release"
    echo -e "  • Production builds: profile, release only"
}

# Function to validate parameters
validate_params() {
    # Validate environment
    case $ENVIRONMENT in
        "development"|"staging"|"production")
            ;;
        *)
            echo -e "${RED}❌ Invalid environment: $ENVIRONMENT${NC}"
            echo -e "${YELLOW}Valid environments: development, staging, production${NC}"
            exit 1
            ;;
    esac

    # Validate platform
    case $PLATFORM in
        "android"|"ios"|"web"|"all")
            ;;
        *)
            echo -e "${RED}❌ Invalid platform: $PLATFORM${NC}"
            echo -e "${YELLOW}Valid platforms: android, ios, web, all${NC}"
            exit 1
            ;;
    esac

    # Validate build type
    case $BUILD_TYPE in
        "debug"|"profile"|"release")
            ;;
        *)
            echo -e "${RED}❌ Invalid build type: $BUILD_TYPE${NC}"
            echo -e "${YELLOW}Valid build types: debug, profile, release${NC}"
            exit 1
            ;;
    esac

    # Validate environment + build type combinations
    if [ "$ENVIRONMENT" = "development" ] && [ "$BUILD_TYPE" != "debug" ]; then
        echo -e "${RED}❌ Development environment only supports debug builds${NC}"
        exit 1
    fi

    if [ "$ENVIRONMENT" = "production" ] && [ "$BUILD_TYPE" = "debug" ]; then
        echo -e "${RED}❌ Production environment does not support debug builds${NC}"
        exit 1
    fi
}

# Function to check prerequisites
check_prerequisites() {
    echo -e "${BLUE}🔍 Checking prerequisites...${NC}"
    
    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
        exit 1
    fi
    
    # Check Flutter version
    FLUTTER_VERSION=$(flutter --version | grep -o "Flutter [0-9]\+\.[0-9]\+\.[0-9]\+" | head -1)
    echo -e "${GREEN}✅ $FLUTTER_VERSION detected${NC}"
    
    # Check if we're in a Flutter project
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}❌ Not in a Flutter project directory${NC}"
        exit 1
    fi
    
    # Check if environment files exist
    if [ ! -f ".env.$ENVIRONMENT" ] && [ "$ENVIRONMENT" != "development" ]; then
        echo -e "${YELLOW}⚠️  .env.$ENVIRONMENT not found, using .env${NC}"
    fi
    
    echo -e "${GREEN}✅ Prerequisites check passed${NC}"
}

# Function to setup environment
setup_environment() {
    echo -e "${BLUE}🔧 Setting up environment: $ENVIRONMENT${NC}"
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR/$ENVIRONMENT"
    
    # Set Flutter environment
    export FLUTTER_ENVIRONMENT=$ENVIRONMENT
    
    echo -e "${GREEN}✅ Environment setup completed${NC}"
}

# Function to build Android
build_android() {
    local build_type=$1
    local output_path="$OUTPUT_DIR/$ENVIRONMENT/android"
    
    echo -e "${BLUE}🤖 Building Android ($build_type)...${NC}"
    
    mkdir -p "$output_path"
    
    case $build_type in
        "debug")
            flutter build apk --debug --dart-define=ENVIRONMENT=$ENVIRONMENT
            cp build/app/outputs/flutter-apk/app-debug.apk "$output_path/app-debug.apk"
            ;;
        "profile")
            flutter build apk --profile --dart-define=ENVIRONMENT=$ENVIRONMENT
            cp build/app/outputs/flutter-apk/app-profile.apk "$output_path/app-profile.apk"
            ;;
        "release")
            flutter build apk --release --dart-define=ENVIRONMENT=$ENVIRONMENT
            cp build/app/outputs/flutter-apk/app-release.apk "$output_path/app-release.apk"
            ;;
    esac
    
    echo -e "${GREEN}✅ Android build completed: $output_path${NC}"
}

# Function to build iOS
build_ios() {
    local build_type=$1
    local output_path="$OUTPUT_DIR/$ENVIRONMENT/ios"
    
    echo -e "${BLUE}🍎 Building iOS ($build_type)...${NC}"
    
    mkdir -p "$output_path"
    
    case $build_type in
        "debug")
            flutter build ios --debug --dart-define=ENVIRONMENT=$ENVIRONMENT
            echo -e "${YELLOW}⚠️  iOS debug build completed. Use Xcode to run on device/simulator${NC}"
            ;;
        "profile")
            flutter build ios --profile --dart-define=ENVIRONMENT=$ENVIRONMENT
            echo -e "${YELLOW}⚠️  iOS profile build completed. Use Xcode to archive${NC}"
            ;;
        "release")
            flutter build ios --release --dart-define=ENVIRONMENT=$ENVIRONMENT
            echo -e "${YELLOW}⚠️  iOS release build completed. Use Xcode to archive${NC}"
            ;;
    esac
    
    echo -e "${GREEN}✅ iOS build completed: $output_path${NC}"
}

# Function to build Web
build_web() {
    local build_type=$1
    local output_path="$OUTPUT_DIR/$ENVIRONMENT/web"
    
    echo -e "${BLUE}🌐 Building Web ($build_type)...${NC}"
    
    mkdir -p "$output_path"
    
    case $build_type in
        "debug")
            flutter build web --debug --dart-define=ENVIRONMENT=$ENVIRONMENT
            ;;
        "profile")
            flutter build web --profile --dart-define=ENVIRONMENT=$ENVIRONMENT
            ;;
        "release")
            flutter build web --release --dart-define=ENVIRONMENT=$ENVIRONMENT
            ;;
    esac
    
    # Copy web build to output directory
    cp -r build/web/* "$output_path/"
    
    echo -e "${GREEN}✅ Web build completed: $output_path${NC}"
}

# Function to run tests
run_tests() {
    echo -e "${BLUE}🧪 Running tests...${NC}"
    
    # Run unit tests
    flutter test --coverage
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Tests passed${NC}"
    else
        echo -e "${RED}❌ Tests failed${NC}"
        exit 1
    fi
}

# Function to analyze code
analyze_code() {
    echo -e "${BLUE}🔍 Analyzing code...${NC}"
    
    flutter analyze
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Code analysis passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Code analysis found issues${NC}"
    fi
}

# Function to clean build
clean_build() {
    echo -e "${BLUE}🧹 Cleaning build...${NC}"
    
    flutter clean
    flutter pub get
    
    echo -e "${GREEN}✅ Build cleaned${NC}"
}

# Function to generate code
generate_code() {
    echo -e "${BLUE}🔨 Generating code...${NC}"
    
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Code generation completed${NC}"
    else
        echo -e "${RED}❌ Code generation failed${NC}"
        exit 1
    fi
}

# Function to show build summary
show_build_summary() {
    echo -e "\n${GREEN}🎉 Build completed successfully!${NC}"
    echo -e "\n${BLUE}📊 Build Summary:${NC}"
    echo -e "  • Environment: ${CYAN}$ENVIRONMENT${NC}"
    echo -e "  • Platform: ${CYAN}$PLATFORM${NC}"
    echo -e "  • Build Type: ${CYAN}$BUILD_TYPE${NC}"
    echo -e "  • Output Directory: ${CYAN}$OUTPUT_DIR/$ENVIRONMENT${NC}"
    
    echo -e "\n${BLUE}📁 Build Outputs:${NC}"
    if [ -d "$OUTPUT_DIR/$ENVIRONMENT" ]; then
        find "$OUTPUT_DIR/$ENVIRONMENT" -type f -name "*.apk" -o -name "*.ipa" -o -name "*.html" | while read file; do
            echo -e "  • ${CYAN}$file${NC}"
        done
    fi
    
    echo -e "\n${YELLOW}🚀 Next steps:${NC}"
    case $PLATFORM in
        "android")
            echo -e "  • Install APK: adb install $OUTPUT_DIR/$ENVIRONMENT/android/*.apk"
            ;;
        "ios")
            echo -e "  • Open Xcode and run on device/simulator"
            ;;
        "web")
            echo -e "  • Serve web build: cd $OUTPUT_DIR/$ENVIRONMENT/web && python3 -m http.server 8000"
            ;;
        "all")
            echo -e "  • Check all platform outputs in $OUTPUT_DIR/$ENVIRONMENT/"
            ;;
    esac
}

# Main execution
main() {
    echo -e "${PURPLE}🚀 MVP App Build Script${NC}"
    echo -e "${PURPLE}========================${NC}\n"
    
    # Show usage if help requested
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        print_usage
        exit 0
    fi
    
    echo -e "${BLUE}📋 Build Configuration:${NC}"
    echo -e "  • Environment: ${CYAN}$ENVIRONMENT${NC}"
    echo -e "  • Platform: ${CYAN}$PLATFORM${NC}"
    echo -e "  • Build Type: ${CYAN}$BUILD_TYPE${NC}"
    echo ""
    
    # Validate parameters
    validate_params
    
    # Check prerequisites
    check_prerequisites
    
    # Setup environment
    setup_environment
    
    # Clean and generate code
    clean_build
    generate_code
    
    # Run tests and analysis
    run_tests
    analyze_code
    
    # Build based on platform
    case $PLATFORM in
        "android")
            build_android $BUILD_TYPE
            ;;
        "ios")
            build_ios $BUILD_TYPE
            ;;
        "web")
            build_web $BUILD_TYPE
            ;;
        "all")
            build_android $BUILD_TYPE
            build_ios $BUILD_TYPE
            build_web $BUILD_TYPE
            ;;
    esac
    
    # Show build summary
    show_build_summary
}

# Run main function
main "$@"
