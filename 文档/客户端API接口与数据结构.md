# HealthLive API 接口与数据结构

> 本文档定义 **Flutter 客户端 ↔ Go 服务端** 的 REST 约定。  
> 服务端从 PostgreSQL（`healthlive` 库）读取数据，客户端通过 HTTP JSON 访问，**不直连数据库**。

**代码对照：**

| 说明 | 路径 |
|------|------|
| 路由常量 | `lib/core/network/api_paths.dart` |
| HTTP 客户端 | `lib/core/network/api_client.dart` |
| 请求拦截 / 鉴权 | `lib/core/network/api_interceptor.dart` |
| 远程数据源 | `lib/features/content/data/datasources/content_remote_datasource.dart` |
| DTO 模型 | `lib/features/content/data/models/`、`lib/features/home/data/models/` |

---

## 1. 基础约定

### 1.1 Base URL

| 环境 | 示例 |
|------|------|
| Android 模拟器 | `http://10.0.2.2:8080` |
| 真机 / 局域网 | `http://<电脑局域网 IP>:8080` |
| 生产 | `https://api.example.com` |

由 Flutter 启动参数注入：

```bash
flutter run --dart-define=DATA_SOURCE=server --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

### 1.2 版本前缀

所有业务接口路径以 **`/api/v1`** 开头（见 `ApiConstants.apiVersionPrefix`）。

### 1.3 请求头

| Header | 值 | 说明 |
|--------|-----|------|
| `Content-Type` | `application/json` | 默认 |
| `Authorization` | `Bearer {access_token}` | 需登录接口；客户端自动从 SecureStorage 注入 |

### 1.4 时间格式

ISO 8601 UTC，例如：`2026-06-10T08:00:00Z`。  
客户端使用 `DateTime.parse` 解析字段 `updated_at`。

### 1.5 JSON 命名

- 请求 / 响应字段：**snake_case**（如 `cover_url`、`page_size`）
- Dart 模型通过 DTO `fromJson` 映射

---

## 2. 统一响应格式

### 2.1 成功响应

HTTP 状态码 `200`，Body：

```json
{
  "code": 0,
  "message": "ok",
  "data": { }
}
```

- `code === 0` 表示业务成功
- 客户端 `ApiInterceptor` 在 `code !== 0` 时视为业务错误
- `ApiClient._unwrapResponse` 自动取出 **`data`** 字段交给 DTO 解析

### 2.2 分页列表的 `data` 结构

```json
{
  "code": 0,
  "message": "ok",
  "data": {
    "items": [],
    "total": 100,
    "page": 1,
    "page_size": 20
  }
}
```

### 2.3 错误响应

| HTTP | 场景 | 客户端处理 |
|------|------|------------|
| 400 | 参数错误 | 展示 `message` |
| 401 | 未登录 / Token 过期 | 清除 Token，引导登录 |
| 404 | 资源不存在 | 内容不存在页 |
| 5xx | 服务端异常 | 通用错误 + 重试 |

Body 示例：

```json
{
  "code": 40401,
  "message": "内容不存在或已下线",
  "data": null
}
```

---

## 3. 数据类型定义

### 3.1 ContentCategory（分类）

| API 值 | 显示名 | 说明 |
|--------|--------|------|
| `lifestyle` | 作息 | 睡眠、早起、规律作息 |
| `exercise` | 运动 | 有氧、拉伸、办公活动 |
| `diet` | 饮食 | 早餐、饮水、营养 |

对应 Dart：`ContentCategory`（`lib/core/constants/content_category.dart`）

### 3.2 BenefitPoint（核心好处）

详情页「核心好处」列表项。

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `title` | string | 是 | 好处标题 |
| `description` | string | 是 | 说明文案 |
| `icon` | string | 否 | 图标标识，如 `sleep`、`walk` |

```json
{
  "title": "改善睡眠质量",
  "description": "规律作息帮助大脑建立稳定的睡眠节律",
  "icon": "sleep"
}
```

对应 Dart：`BenefitPointDto`

### 3.3 Content（内容）

列表与详情共用；**列表接口可不返回 `body`、`points`** 以减小体积，详情接口须返回完整字段。

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `id` | string | 是 | 内容 ID |
| `title` | string | 是 | 标题 |
| `summary` | string | 是 | 摘要 |
| `cover_url` | string | 是 | 封面 URL，无封面传 `""` |
| `category` | string | 是 | `lifestyle` / `exercise` / `diet` |
| `tags` | string[] | 是 | 标签，如 `["睡眠", "作息"]` |
| `points` | BenefitPoint[] | 详情必填 | 核心好处列表 |
| `body` | string | 详情必填 | Markdown 正文 |
| `updated_at` | string | 是 | ISO 8601 更新时间 |

```json
{
  "id": "1",
  "title": "规律早睡的五个好处",
  "summary": "固定入睡时间有助于调节生物钟，提升第二天的精神状态",
  "cover_url": "",
  "category": "lifestyle",
  "tags": ["睡眠", "作息"],
  "points": [
    {
      "title": "改善睡眠质量",
      "description": "规律作息帮助大脑建立稳定的睡眠节律",
      "icon": "sleep"
    }
  ],
  "body": "## 为什么建议早睡?\n\n保持 **22:30 前入睡** …",
  "updated_at": "2026-06-10T08:00:00Z"
}
```

对应 Dart：`ContentDto`

**数据库映射：** `contents` + `content_benefit_points` + `content_tags`

### 3.4 DailyTip（每日一知）

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `content_id` | string | 是 | 关联内容 ID |
| `title` | string | 是 | 展示标题 |
| `summary` | string | 是 | 摘要 |

```json
{
  "content_id": "1",
  "title": "今日一知：规律早睡",
  "summary": "固定入睡时间有助于调节生物钟，提升第二天的精神状态"
}
```

对应 Dart：`DailyTipDto`  
**数据库映射：** `daily_tips`

### 3.5 Home（首页聚合）

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `daily_tip` | DailyTip | 是 | 每日一知 |
| `recommended` | Content[] | 是 | 推荐内容列表（通常为 Content 摘要字段） |

```json
{
  "daily_tip": {
    "content_id": "1",
    "title": "今日一知：规律早睡",
    "summary": "固定入睡时间有助于调节生物钟，提升第二天的精神状态"
  },
  "recommended": [
    {
      "id": "1",
      "title": "规律早睡的五个好处",
      "summary": "…",
      "cover_url": "",
      "category": "lifestyle",
      "tags": ["睡眠", "作息"],
      "points": [],
      "body": "",
      "updated_at": "2026-06-10T08:00:00Z"
    }
  ]
}
```

对应 Dart：`HomeDto`  
**数据库映射：** `daily_tips` + `home_recommendations` JOIN `contents`

### 3.6 PaginatedContents（分页列表）

| 字段 | 类型 | 说明 |
|------|------|------|
| `items` | Content[] | 当前页数据 |
| `total` | int | 总条数 |
| `page` | int | 当前页，从 1 开始 |
| `page_size` | int | 每页条数，默认 20 |

对应 Dart：`PaginatedResponseDto`

---

## 4. 接口清单

### 4.1 首页

#### `GET /api/v1/home`

| 项 | 说明 |
|----|------|
| 鉴权 | 否 |
| 客户端 | `HomePage` → `ContentRemoteDataSource.fetchHome()` |
| 响应 `data` | [Home](#35-home首页聚合) |

**请求示例：**

```http
GET /api/v1/home HTTP/1.1
Host: 10.0.2.2:8080
Content-Type: application/json
```

---

#### `GET /api/v1/daily-tip`

| 项 | 说明 |
|----|------|
| 鉴权 | 否 |
| 状态 | 路径已预留（`ApiPaths.dailyTip`），首页目前走 `/home` 聚合 |
| 响应 `data` | [DailyTip](#34-dailytip每日一知) |

---

### 4.2 内容

#### `GET /api/v1/contents`

分类分页列表。

| 项 | 说明 |
|----|------|
| 鉴权 | 否 |
| 客户端 | `CategoryPage` → `fetchByCategory()` |

**Query 参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `category` | string | 是 | `lifestyle` / `exercise` / `diet` |
| `page` | int | 是 | 页码，从 1 开始 |
| `page_size` | int | 否 | 默认 `20` |

**请求示例：**

```http
GET /api/v1/contents?category=lifestyle&page=1&page_size=20 HTTP/1.1
```

**响应 `data`：** [PaginatedContents](#36-paginatedcontents分页列表)

---

#### `GET /api/v1/contents/{id}`

内容详情。

| 项 | 说明 |
|----|------|
| 鉴权 | 否 |
| 客户端 | `ContentDetailPage` → `fetchById(id)` |

**路径参数：**

| 参数 | 说明 |
|------|------|
| `id` | 内容 ID |

**响应 `data`：** 完整 [Content](#33-content内容)（含 `body`、`points`）

**错误：** 不存在时 HTTP `404` 或 `code !== 0`，客户端展示「内容不存在」

---

#### `GET /api/v1/contents/search`

搜索。

| 项 | 说明 |
|----|------|
| 鉴权 | 否 |
| 客户端 | `SearchPage` → `search()` |

**Query 参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `q` | string | 是 | 关键词（匹配标题、摘要、标签） |
| `page` | int | 是 | 页码 |
| `page_size` | int | 否 | 默认 `20` |

**请求示例：**

```http
GET /api/v1/contents/search?q=睡眠&page=1&page_size=20 HTTP/1.1
```

**响应 `data`：** [PaginatedContents](#36-paginatedcontents分页列表)

---

### 4.3 收藏（预留，需登录）

当前 Flutter **收藏仅存本地 Hive**；以下接口供后端 Auth 就绪后云端同步。

#### `GET /api/v1/favorites`

| 项 | 说明 |
|----|------|
| 鉴权 | 是 |
| 响应 `data` | `Content[]` 或 [PaginatedContents](#36-paginatedcontents分页列表) |

#### `POST /api/v1/favorites`

**Body：**

```json
{
  "content_id": "1"
}
```

#### `DELETE /api/v1/favorites/{content_id}`

取消收藏。

---

### 4.4 鉴权（预留）

#### `POST /api/v1/auth/login`

**Body：**

```json
{
  "email": "user@example.com",
  "password": "******"
}
```

**响应 `data`（建议）：**

```json
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "expires_in": 3600
}
```

客户端存入 `SecureStorage`，后续请求带 `Authorization: Bearer {access_token}`。

#### `POST /api/v1/auth/refresh`

**Body：**

```json
{
  "refresh_token": "eyJ..."
}
```

---

## 5. 接口与模块对照

| 方法 | 路径 | Flutter 模块 | 实现状态 |
|------|------|--------------|----------|
| GET | `/api/v1/home` | Home | 客户端已对接 |
| GET | `/api/v1/daily-tip` | Home | 路径预留 |
| GET | `/api/v1/contents` | Category | 客户端已对接 |
| GET | `/api/v1/contents/{id}` | Content | 客户端已对接 |
| GET | `/api/v1/contents/search` | Search | 客户端已对接 |
| GET | `/api/v1/favorites` | Favorites | 预留（本地 Hive） |
| POST | `/api/v1/favorites` | Favorites | 预留 |
| DELETE | `/api/v1/favorites/{content_id}` | Favorites | 预留 |
| POST | `/api/v1/auth/login` | Auth | 预留 |
| POST | `/api/v1/auth/refresh` | Auth | 预留 |

---

## 6. 数据库表与 API 字段关系

| API 对象 | PostgreSQL 表 |
|----------|----------------|
| Content 主字段 | `contents` |
| Content.points | `content_benefit_points` |
| Content.tags | `content_tags` |
| Home.daily_tip | `daily_tips` |
| Home.recommended | `home_recommendations` → `contents` |
| 收藏 | `user_favorites` + `users` |

服务端查询 `contents` 后组装 JSON，字段名与上表 **snake_case** 保持一致即可被 Flutter DTO 直接解析。

---

## 7. 数据来源切换（`DATA_SOURCE`）

| 模式 | 启动参数 | 数据来源 |
|------|----------|----------|
| JSON（**默认**） | `DATA_SOURCE=json` | `assets/data/*.json`（按表 JOIN） |
| Server | `DATA_SOURCE=server` | 本文档定义的 REST 接口 |

演示 APK 建议使用 `json`；联调 / 生产使用 `server`：

```bash
flutter run --dart-define=DATA_SOURCE=server --dart-define=API_BASE_URL=http://10.0.2.2:8080 --dart-define=ENV=dev
```

详见 [内容数据同步](内容数据同步.md)（含 JSON ↔ PostgreSQL 与 pgAdmin 导出说明）。

---

## 8. 修订记录

| 版本 | 日期 | 说明 |
|------|------|------|
| 1.0.0 | 2026-06-18 | 初版：对齐 ApiPaths、DTO、统一响应与分页格式 |
