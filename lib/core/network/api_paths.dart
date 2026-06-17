import 'package:healthlive/core/constants/api_constants.dart';

class ApiPaths {
  ApiPaths._();

  static const String _prefix = ApiConstants.apiVersionPrefix;

  static const String home = '$_prefix/home';
  static const String dailyTip = '$_prefix/daily-tip';
  static const String contents = '$_prefix/contents';
  static const String search = '$_prefix/contents/search';
  static const String favorites = '$_prefix/favorites';
  static const String login = '$_prefix/auth/login';
  static const String refresh = '$_prefix/auth/refresh';

  static String contentDetail(String id) => '$_prefix/contents/$id';

  static String favoriteDetail(String contentId) =>
      '$_prefix/favorites/$contentId';
}
