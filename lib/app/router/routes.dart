class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String category = '/category';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String contentDetail = '/content/:id';

  static String contentDetailPath(String id) => '/content/$id';
}
