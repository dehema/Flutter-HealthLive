# HealthLive Client

生活向健康科普 Flutter 客户端，展示作息、运动、饮食相关益处与建议。

## 文档

- [前端开发指南](文档/前端开发指南.md)
- [美术资源列表](文档/美术资源列表.md)
- [打包与环境配置](文档/打包&环境.md)

## 技术栈

| 类别 | 选型 |
|------|------|
| 框架 | Flutter 3.16+ / Dart 3.5+ |
| 状态管理 | Riverpod |
| 路由 | go_router |
| 网络 | Dio |
| 本地存储 | Hive、SharedPreferences、flutter_secure_storage |

## 环境要求

- Flutter SDK >= 3.16（路径不能含空格）
- Dart SDK >= 3.5
- Android 打包详见 [打包与环境配置](文档/打包&环境.md)
- Windows 开发需开启**开发人员模式**（plugin 依赖 symlink）

## 快速开始

```bash
git clone <仓库地址>
cd Flutter-HealthLive

flutter pub get
flutter run --dart-define=USE_MOCK=true --dart-define=ENV=dev
```

对接本地 Go 后端：

```bash
flutter run ^
  --dart-define=USE_MOCK=false ^
  --dart-define=API_BASE_URL=http://10.0.2.2:8080 ^
  --dart-define=ENV=dev
```

> Linux / macOS 将 `^` 换为 `\` 续行。真机调试时将 `10.0.2.2` 改为电脑局域网 IP。

### 运行时配置（`--dart-define`）

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `USE_MOCK` | `true` | `true` 使用内置 Mock；对接后端时设为 `false` |
| `API_BASE_URL` | `http://10.0.2.2:8080` | Go 服务地址 |
| `ENV` | `dev` | 环境标识：`dev` / `staging` / `prod` |

## 项目结构

```
lib/
├── app/              # 应用壳、主题、路由
├── core/             # 配置、网络、存储、依赖注入
├── features/         # 业务模块
│   ├── home/         # 首页
│   ├── category/     # 分类浏览
│   ├── content/      # 内容详情
│   ├── search/       # 搜索
│   ├── favorites/    # 收藏
│   ├── profile/      # 个人中心
│   └── auth/         # 鉴权
└── shared/           # 通用组件与工具
assets/               # 图片、图标、Mock 数据
android/ ios/ ...     # 各平台工程（已纳入版本库）
文档/                  # 开发、打包、美术文档
```

## 测试

```bash
flutter test
```

## 打包

```bash
flutter build apk --dart-define=ENV=prod --dart-define=USE_MOCK=false --dart-define=API_BASE_URL=https://your-api.example.com
```

APK 输出路径：`build/app/outputs/flutter-apk/app-release.apk`。完整环境说明见 [打包与环境配置](文档/打包&环境.md)。

## Git 与版本控制

仓库已接入 Git。根目录 `.gitignore` 与各平台子目录（如 `android/.gitignore`）共同生效。

### 不应提交的内容

| 类别 | 路径 / 模式 | 原因 |
|------|-------------|------|
| 构建产物 | `build/`、`*.apk`、`*.aab` | 本地编译生成，体积大且可复现 |
| Dart 工具缓存 | `.dart_tool/`、`.pub/` | `flutter pub get` 自动恢复 |
| 插件注册 | `.flutter-plugins`、`.flutter-plugins-dependencies` | 依赖解析后自动生成 |
| IDE 配置 | `.idea/`、`*.iml`、`.vscode/` | 个人编辑器偏好 |
| 本地 SDK 路径 | `android/local.properties` | 含本机 Android SDK 绝对路径 |
| Gradle 缓存 | `android/.gradle/` | 构建缓存 |
| 签名密钥 | `*.jks`、`*.keystore`、`key.properties` | 敏感信息，泄露风险 |
| 环境变量文件 | `.env`、`.env.*` | 可能含 API Key 等密钥 |
| 测试覆盖率 | `coverage/` | 本地测试报告 |
| 代码生成 | `*.g.dart`、`*.freezed.dart` | `build_runner` 生成，可重新构建 |
| FVM 缓存 | `.fvm/` | 本地 Flutter 版本缓存 |

### 应提交的内容

- 源代码：`lib/`、`test/`
- 资源：`assets/`
- 依赖锁定：`pubspec.yaml`、`pubspec.lock`
- 平台工程：`android/`、`ios/`、`web/` 等（不含上述忽略项）
- 项目元数据：`.metadata`、`analysis_options.yaml`
- 文档：`文档/`、`README.md`

首次克隆后执行 `flutter pub get` 即可；无需再运行 `flutter create`。
