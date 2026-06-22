/// 内容数据来源：本地 JSON 资产 或 远程 Server API
enum ContentDataSource {
  /// 读取 `assets/data/*.json`（与 PostgreSQL 表同名），与数据库 seed 保持同源
  json,

  /// 请求 Go 服务端 REST API（PostgreSQL）
  server;

  String get displayName => switch (this) {
        ContentDataSource.json => 'JSON 本地数据',
        ContentDataSource.server => 'Server API',
      };

  /// 解析 `--dart-define=DATA_SOURCE=json|server`
  ///
  /// 兼容旧参数 `USE_MOCK`：`true` → json，`false` → server（仅当未显式设置 DATA_SOURCE 时）
  static ContentDataSource fromEnvironment() {
    const raw = String.fromEnvironment('DATA_SOURCE');
    if (raw == 'json') return ContentDataSource.json;
    if (raw == 'server') return ContentDataSource.server;

    const useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);
    return useMock ? ContentDataSource.json : ContentDataSource.server;
  }
}
