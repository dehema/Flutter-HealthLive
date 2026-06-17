/// 鉴权仓库接口，待 Go 后端 Auth API 就绪后实现�?
abstract class AuthRepository {
  Future<bool> isLoggedIn();

  Future<void> login({
    required String username,
    required String password,
  });

  Future<void> logout();

  Future<void> refreshToken();
}
