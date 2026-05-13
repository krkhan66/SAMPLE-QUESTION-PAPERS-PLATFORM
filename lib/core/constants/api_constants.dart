class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.samplepapers.com/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String papersEndpoint = '/papers';
  static const String subjectsEndpoint = '/subjects';
  static const String categoriesEndpoint = '/categories';
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String favoritesEndpoint = '/favorites';
  static const String searchEndpoint = '/search';

  static const String loginPath = '$authEndpoint/login';
  static const String registerPath = '$authEndpoint/register';
  static const String refreshTokenPath = '$authEndpoint/refresh';
  static const String forgotPasswordPath = '$authEndpoint/forgot-password';
  static const String resetPasswordPath = '$authEndpoint/reset-password';
  static const String profilePath = '$usersEndpoint/profile';
  static const String updateProfilePath = '$usersEndpoint/update-profile';

  static const String pageKey = 'page';
  static const String limitKey = 'limit';
  static const String searchKey = 'q';
  static const String subjectKey = 'subject';
  static const String categoryKey = 'category';
  static const String yearKey = 'year';
  static const String examTypeKey = 'exam_type';
  static const String sortByKey = 'sort_by';
  static const String orderKey = 'order';

  static const int defaultPageSize = 20;
}
