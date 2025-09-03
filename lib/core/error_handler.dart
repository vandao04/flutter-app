class AppError implements Exception {
  final String message;
  AppError(this.message, String s);

  @override
  String toString() => message;
}
