# Retrofit trong Flutter

Tài liệu này giải thích cách sử dụng Retrofit với mô hình MVP App của chúng ta.

## Tổng quan

Retrofit là một thư viện để tạo HTTP client trong Flutter/Dart dựa trên các annotation. Nó giúp chúng ta viết code gọi API một cách ngắn gọn và tự động sinh code để thực hiện các cuộc gọi API.

## Cấu trúc

Trong dự án của chúng ta, chúng ta có:

1. **auth_api.dart**: Interface Retrofit với các annotation (@RestApi, @POST, @GET, etc.)
2. **auth_models.dart**: Các model sử dụng JSON annotation
3. **auth_service.dart**: Service sử dụng AuthApi để thực hiện các cuộc gọi API

## Tạo code với build_runner

Để tạo code cho Retrofit và JSON serialization:

```bash
# Chạy script được cung cấp
./scripts/generate_retrofit.sh

# Hoặc chạy trực tiếp
flutter pub run build_runner build --delete-conflicting-outputs
```

## Chuyển đổi sang Retrofit

### Trước khi áp dụng Retrofit

```dart
Future<User> login(String email, String password) async {
  final response = await dio.post('/auth/login', data: {
    'email': email,
    'password': password,
  });
  
  return User.fromJson(response.data);
}
```

### Sau khi áp dụng Retrofit

1. **Định nghĩa API interface**:

```dart
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;
  
  @POST('/auth/login')
  Future<Map<String, dynamic>> login(@Body() LoginRequest request);
}
```

2. **Model với JSON annotation**:

```dart
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) => 
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
```

3. **Sử dụng trong Service**:

```dart
Future<LoginResponse> login(String email, String password) async {
  final request = LoginRequest(email: email, password: password);
  final response = await _authApi.login(request);
  return LoginResponse.fromJson(response['data']);
}
```

## Cách chuyển đổi sang Retrofit

1. Tạo các file model với annotation @JsonSerializable
2. Tạo API interface với annotation @RestApi
3. Chạy build_runner để sinh code
4. Cập nhật service để sử dụng API interface đã sinh

## Lợi ích của Retrofit

- Code ngắn gọn, dễ đọc hơn
- Giảm lỗi khi gọi API
- Dễ dàng thay đổi endpoint
- Tách biệt giữa định nghĩa API và implementation
- Tự động serialize/deserialize JSON

## Lưu ý

- Luôn chạy build_runner sau khi thay đổi các file có annotation
- Thêm @JsonKey(name: 'ten_field') nếu tên field trong JSON khác với tên field trong Dart
- Sử dụng @Headers, @Query, @Path, etc. để tùy chỉnh request
