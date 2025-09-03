#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Setting up environment files for MVP App...${NC}\n"

# Function to create environment file
create_env_file() {
    local filename=$1
    local env_name=$2
    
    echo -e "${YELLOW}📝 Creating $filename...${NC}"
    
    cat > "$filename" << 'EOF'
# =============================================================================
# ENVIRONMENT CONFIGURATION - $env_name
# =============================================================================
# Generated automatically - Edit with your actual values
# Never commit actual .env files to version control!

# =============================================================================
# APP CONFIGURATION
# =============================================================================
APP_NAME=MVP App
APP_VERSION=1.0.0
APP_BUILD_NUMBER=1
APP_ENVIRONMENT=$env_name

# =============================================================================
# API CONFIGURATION
# =============================================================================
API_BASE_URL=https://api.example.com
API_VERSION=v1
API_TIMEOUT=30000
API_RETRY_ATTEMPTS=3
API_RETRY_DELAY=1000

# =============================================================================
# FEATURE FLAGS
# =============================================================================
ENABLE_ANALYTICS=false
ENABLE_CRASHLYTICS=false
ENABLE_PUSH_NOTIFICATIONS=false
ENABLE_BIOMETRIC_AUTH=false
ENABLE_DARK_MODE=true
ENABLE_DYNAMIC_COLORS=true

# =============================================================================
# SOCIAL LOGIN
# =============================================================================
GOOGLE_CLIENT_ID=your_google_client_id_here
GOOGLE_CLIENT_SECRET=your_google_client_secret_here
FACEBOOK_APP_ID=your_facebook_app_id_here
FACEBOOK_CLIENT_TOKEN=your_facebook_client_token_here
APPLE_CLIENT_ID=your_apple_client_id_here
APPLE_TEAM_ID=your_apple_team_id_here

# =============================================================================
# PAYMENT GATEWAYS
# =============================================================================
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_key_here
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_here
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here
PAYPAL_CLIENT_ID=your_paypal_client_id_here
PAYPAL_CLIENT_SECRET=your_paypal_client_secret_here
PAYPAL_MODE=sandbox

# =============================================================================
# ANALYTICS & MONITORING
# =============================================================================
FIREBASE_PROJECT_ID=your_firebase_project_id_here
FIREBASE_APP_ID=your_firebase_app_id_here
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_MESSAGING_SENDER_ID=your_firebase_sender_id_here
MIXPANEL_TOKEN=your_mixpanel_token_here
AMPLITUDE_API_KEY=your_amplitude_api_key_here

# =============================================================================
# ERROR REPORTING & MONITORING
# =============================================================================
SENTRY_DSN=your_sentry_dsn_here
SENTRY_ENVIRONMENT=$env_name
BUGSNAG_API_KEY=your_bugsnag_api_key_here
ROLLBAR_ACCESS_TOKEN=your_rollbar_access_token_here

# =============================================================================
# PUSH NOTIFICATIONS
# =============================================================================
FCM_SERVER_KEY=your_fcm_server_key_here
FCM_SENDER_ID=your_fcm_sender_id_here
ONESIGNAL_APP_ID=your_onesignal_app_id_here
ONESIGNAL_REST_API_KEY=your_onesignal_rest_api_key_here

# =============================================================================
# STORAGE & CACHE
# =============================================================================
MAX_CACHE_SIZE=100
CACHE_TIMEOUT=3600
IMAGE_CACHE_TIMEOUT=604800
MAX_FILE_SIZE=10485760

# =============================================================================
# SECURITY
# =============================================================================
ENCRYPTION_KEY=your_encryption_key_here
JWT_SECRET=your_jwt_secret_here
SESSION_TIMEOUT=86400
PIN_CODE_LENGTH=6
MAX_LOGIN_ATTEMPTS=5
LOGIN_LOCKOUT_DURATION=900

# =============================================================================
# SUPPORT & CONTACT
# =============================================================================
SUPPORT_EMAIL=support@example.com
SUPPORT_PHONE=+84 123 456 789
SUPPORT_WEBSITE=https://support.example.com
ADMIN_EMAIL=admin@example.com
FEEDBACK_EMAIL=feedback@example.com

# =============================================================================
# LEGAL & COMPLIANCE
# =============================================================================
PRIVACY_POLICY_URL=https://example.com/privacy
TERMS_OF_SERVICE_URL=https://example.com/terms
COOKIE_POLICY_URL=https://example.com/cookies
GDPR_COMPLIANT=true
CCPA_COMPLIANT=false

# =============================================================================
# SOCIAL MEDIA
# =============================================================================
FACEBOOK_URL=https://facebook.com/yourapp
TWITTER_URL=https://twitter.com/yourapp
INSTAGRAM_URL=https://instagram.com/yourapp
LINKEDIN_URL=https://linkedin.com/company/yourapp
YOUTUBE_URL=https://youtube.com/yourapp

# =============================================================================
# APP STORE LINKS
# =============================================================================
APP_STORE_ID=your_app_store_id_here
PLAY_STORE_ID=your_play_store_id_here
APP_STORE_URL=https://apps.apple.com/app/id
PLAY_STORE_URL=https://play.google.com/store/apps/details?id=

# =============================================================================
# DEEP LINKING
# =============================================================================
DEEP_LINK_SCHEME=mvpapp
DEEP_LINK_HOST=example.com
UNIVERSAL_LINK_DOMAIN=example.com

# =============================================================================
# LOCALIZATION
# =============================================================================
DEFAULT_LOCALE=vi
SUPPORTED_LOCALES=vi,en
FALLBACK_LOCALE=en

# =============================================================================
# PERFORMANCE & OPTIMIZATION
# =============================================================================
ENABLE_IMAGE_CACHING=true
ENABLE_NETWORK_CACHING=true
ENABLE_COMPRESSION=true
MAX_CONCURRENT_REQUESTS=5
REQUEST_TIMEOUT=30000

# =============================================================================
# DEBUG & DEVELOPMENT
# =============================================================================
DEBUG_MODE=true
LOG_LEVEL=debug
SHOW_DEBUG_BANNER=true
ENABLE_LOGGING=true
ENABLE_PERFORMANCE_OVERLAY=false
ENABLE_SEMANTICS_OVERLAY=false

# =============================================================================
# TESTING
# =============================================================================
TEST_MODE=false
MOCK_API_ENABLED=false
TEST_USER_EMAIL=test@example.com
TEST_USER_PASSWORD=testpassword123

# =============================================================================
# THIRD PARTY INTEGRATIONS
# =============================================================================
SLACK_WEBHOOK_URL=your_slack_webhook_url_here
DISCORD_WEBHOOK_URL=your_discord_webhook_url_here
TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here
ZENDESK_DOMAIN=your_zendesk_domain_here
INTERCOM_APP_ID=your_intercom_app_id_here

# =============================================================================
# CUSTOM CONFIGURATION
# =============================================================================
# Add your custom environment variables below
CUSTOM_FEATURE_FLAG=false
CUSTOM_API_ENDPOINT=https://custom-api.example.com
CUSTOM_TIMEOUT=5000
EOF

    echo -e "${GREEN}✅ Created $filename${NC}"
}

# Function to customize environment file
customize_env_file() {
    local filename=$1
    local env_name=$2
    
    echo -e "${YELLOW}🔧 Customizing $filename for $env_name environment...${NC}"
    
    case $env_name in
        "development")
            # Development specific settings
            sed -i '' 's|API_BASE_URL=https://api.example.com|API_BASE_URL=https://dev-api.example.com|g' "$filename"
            sed -i '' 's|ENABLE_ANALYTICS=false|ENABLE_ANALYTICS=false|g' "$filename"
            sed -i '' 's|ENABLE_CRASHLYTICS=false|ENABLE_CRASHLYTICS=false|g' "$filename"
            sed -i '' 's|DEBUG_MODE=true|DEBUG_MODE=true|g' "$filename"
            sed -i '' 's|LOG_LEVEL=debug|LOG_LEVEL=debug|g' "$filename"
            ;;
        "staging")
            # Staging specific settings
            sed -i '' 's|API_BASE_URL=https://api.example.com|API_BASE_URL=https://staging-api.example.com|g' "$filename"
            sed -i '' 's|ENABLE_ANALYTICS=false|ENABLE_ANALYTICS=true|g' "$filename"
            sed -i '' 's|ENABLE_CRASHLYTICS=false|ENABLE_CRASHLYTICS=true|g' "$filename"
            sed -i '' 's|DEBUG_MODE=true|DEBUG_MODE=false|g' "$filename"
            sed -i '' 's|LOG_LEVEL=debug|LOG_LEVEL=info|g' "$filename"
            ;;
        "production")
            # Production specific settings
            sed -i '' 's|API_BASE_URL=https://api.example.com|API_BASE_URL=https://api.example.com|g' "$filename"
            sed -i '' 's|ENABLE_ANALYTICS=false|ENABLE_ANALYTICS=true|g' "$filename"
            sed -i '' 's|ENABLE_CRASHLYTICS=false|ENABLE_CRASHLYTICS=true|g' "$filename"
            sed -i '' 's|DEBUG_MODE=true|DEBUG_MODE=false|g' "$filename"
            sed -i '' 's|LOG_LEVEL=debug|LOG_LEVEL=error|g' "$filename"
            ;;
    esac
    
    echo -e "${GREEN}✅ Customized $filename for $env_name${NC}"
}

# Create .env.example
echo -e "${BLUE}📋 Creating .env.example template...${NC}"
create_env_file ".env.example" "template"

# Create .env (development)
echo -e "${BLUE}🔧 Creating .env for development...${NC}"
create_env_file ".env" "development"
customize_env_file ".env" "development"

# Create .env.staging
echo -e "${BLUE}🔧 Creating .env.staging for staging...${NC}"
create_env_file ".env.staging" "staging"
customize_env_file ".env.staging" "staging"

# Create .env.production
echo -e "${BLUE}🔧 Creating .env.production for production...${NC}"
create_env_file ".env.production" "production"
customize_env_file ".env.production" "production"

# Create .gitignore entry
echo -e "${BLUE}🔒 Updating .gitignore...${NC}"
if ! grep -q ".env" .gitignore; then
    echo "" >> .gitignore
    echo "# Environment files" >> .gitignore
    echo ".env" >> .gitignore
    echo ".env.staging" >> .gitignore
    echo ".env.production" >> .gitignore
    echo "!.env.example" >> .gitignore
    echo -e "${GREEN}✅ Added environment files to .gitignore${NC}"
else
    echo -e "${YELLOW}⚠️  Environment files already in .gitignore${NC}"
fi

echo -e "\n${GREEN}🎉 Environment setup completed!${NC}"
echo -e "\n${YELLOW}📝 Next steps:${NC}"
echo -e "1. Edit .env files with your actual values"
echo -e "2. Never commit .env files to version control"
echo -e "3. Use .env.example as a template for team members"
echo -e "4. Run './scripts/generate_code.sh' to generate code"
echo -e "5. Run 'flutter run' to start the app"
echo -e "\n${BLUE}🔧 Available environment files:${NC}"
echo -e "  • .env.example (template - safe to commit)"
echo -e "  • .env (development - edit with your values)"
echo -e "  • .env.staging (staging - edit with your values)"
echo -e "  • .env.production (production - edit with your values)"
