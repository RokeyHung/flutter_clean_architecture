class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  
  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';
  
  // Other endpoints
  static const String uploadImage = '/upload/image';
  static const String uploadFile = '/upload/file';
  
  // Example endpoints for your app
  static const String posts = '/posts';
  static const String createPost = '/posts';
  static const String updatePost = '/posts/{id}';
  static const String deletePost = '/posts/{id}';
  
  // Helper method to replace path parameters
  static String replacePathParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
} 