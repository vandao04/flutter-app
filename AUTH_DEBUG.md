# Authentication Service Debug Guide

## API Response Formats

### Current Known Formats

#### Error Response (400 Bad Request)
```json
{
    "success": false,
    "statusCode": 400,
    "error": "InvalidCredentialsException",
    "message": "Thông tin đăng nhập không chính xác. Vui lòng thử lại."
}
```

### Expected Success Response Format
We need to test with valid credentials to see the actual success response format.
Possible formats could be:

#### Option 1: Direct token response
```json
{
    "success": true,
    "data": {
        "accessToken": "eyJ...",
        "refreshToken": "eyJ...",
        "tokenType": "Bearer",
        "expiresIn": 3600,
        "user": {
            "id": "123",
            "email": "user@example.com",
            "name": "User Name"
        }
    }
}
```

#### Option 2: Flat token response
```json
{
    "accessToken": "eyJ...",
    "refreshToken": "eyJ...",
    "tokenType": "Bearer", 
    "expiresIn": 3600,
    "user": {
        "id": "123",
        "email": "user@example.com", 
        "name": "User Name"
    }
}
```

## Testing Steps

1. Use valid credentials to test successful login
2. Check console logs for actual response structure
3. Update LoginResponse model if needed
4. Update AuthService parsing logic accordingly

## Debug Commands

To see detailed API responses:
```bash
flutter logs --verbose
```

To test with specific credentials, modify the login form or create a test script.

## Current Implementation

The AuthService now:
1. Checks for `success: false` in response and treats as error
2. Attempts to parse as LoginResponse for success cases
3. Provides detailed error logging for debugging
4. Handles various error response formats

## Next Steps

1. Test with valid credentials
2. Update models based on actual API response
3. Implement proper token storage and refresh logic
