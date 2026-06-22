#!/usr/bin/env python3
"""Generate assets/data/*.json and 文档/数据库种子SQL.md from shared seed definitions."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "assets" / "data"
DOC_PATH = ROOT / "文档" / "数据库种子SQL.md"
BASE = "2026-06-22T02:42:11.169Z"
DEMO_USER = "00000000-0000-0000-0000-000000000001"

# (id, code, name, description, icon, color, sort_order)
CATEGORIES_DATA = [
    (1, "lifestyle", "作息", "睡眠、早起、规律作息等生活方式科普", "bedtime_outlined", "#5B8DEF", 1),
    (2, "exercise", "运动", "有氧、拉伸、力量训练等运动科普", "directions_run_outlined", "#3D8B7A", 2),
    (3, "diet", "饮食", "早餐、饮水、营养搭配等饮食科普", "restaurant_outlined", "#F2A65A", 3),
]

CATEGORY_CODE_TO_ID = {code: cid for cid, code, *_ in CATEGORIES_DATA}

CONTENTS_DATA = [
    (1, "lifestyle", "规律早睡的五个好处", "固定入睡时间有助于调节生物钟，提升第二天的精神状态",
     "## 为什么建议早睡?\n\n保持 **22:30 前入睡** 有助于身体进入修复状态。\n\n- 减少熬夜带来的内分泌紊乱\n- 降低焦虑与情绪波动"),
    (2, "exercise", "每天步行 30 分钟的变化", "适度运动能显著改善心肺功能，降低慢性病风险。",
     "## 步行的好处\n\n每天步行 **30 分钟** 可以显著改善心血管健康。\n\n1. 选择舒适的鞋子\n2. 保持能交谈的速度"),
    (3, "diet", "均衡饮食如何改变身体状态", "合理搭配蛋白质、碳水与蔬果，让身体获得稳定能量。",
     "## 均衡饮食\n\n每餐包含优质蛋白，多吃蔬菜水果，控制精加工食品。"),
    (4, "lifestyle", "固定起床时间的力量", "即使周末也尽量保持相近的起床时刻，生物钟会更稳定。",
     "## 固定起床\n\n尝试将起床时间波动控制在 **30 分钟以内**，减少「社交时差」。"),
    (5, "exercise", "晨间散步如何开启活力一天", "清晨适度活动可以促进血液循环，让身体更快苏醒。",
     "## 晨间散步建议\n\n每天 **15～30 分钟** 即可，不必追求强度。"),
    (6, "exercise", "午后拉伸缓解久坐疲劳", "简短拉伸能放松颈肩腰背，改善久坐带来的僵硬感。",
     "## 办公拉伸\n\n每工作 **45 分钟** 起身活动 3 分钟。"),
    (7, "diet", "每天喝够水的小技巧", "充足饮水有助于代谢、皮肤状态与精力维持。",
     "## 饮水建议\n\n建议每天 **1500-2000 ml**，分次饮用。"),
    (8, "diet", "均衡早餐的重要性", "合理搭配蛋白质、碳水与膳食纤维，为上午提供持续能量。",
     "## 早餐搭配\n\n- 优质蛋白：鸡蛋、牛奶\n- 复合碳水：燕麦、全麦面食"),
    (9, "lifestyle", "减少睡前屏幕时间", "蓝光会抑制褪黑素分泌，影响入睡速度与睡眠质量。",
     "## 睡前习惯\n\n睡前 **1 小时** 远离手机与电脑。"),
    (10, "lifestyle", "午休 20 分钟的小恢复", "短暂午睡能提升下午专注力，但过长反而影响夜间睡眠。",
     "## 午休建议\n\n控制在 **20 分钟** 以内。"),
    (11, "exercise", "力量训练入门益处", "适度抗阻训练有助于增加肌肉量、改善代谢与骨密度。",
     "## 入门提示\n\n从自重训练开始，每周 **2-3 次**。"),
    (12, "exercise", "瑜伽与柔韧性的关系", "规律拉伸与瑜伽练习可改善关节活动度，缓解肌肉紧张。",
     "## 练习建议\n\n每周 **2 次** 15 分钟基础拉伸。"),
    (13, "diet", "控制添加糖摄入", "过多添加糖与代谢风险相关，减少含糖饮料是有效第一步。",
     "## 减糖技巧\n\n优先选择原味食物，阅读营养标签。"),
    (14, "diet", "地中海饮食要点", "以橄榄油、全谷物、鱼类和大量蔬菜为特色的饮食模式。",
     "## 核心原则\n\n多吃蔬果、全谷物、优质脂肪，适量鱼类。"),
    (15, "diet", "蛋白质摄入指南", "足量蛋白质支持肌肉修复、免疫与饱腹感。",
     "## 参考量\n\n可按 **体重 kg × 1.0～1.2 g** 估算每日需求。"),
    (16, "lifestyle", "数字断舍离与睡眠", "减少睡前信息过载，有助于大脑切换到休息模式。",
     "## 实践方法\n\n设置手机「睡眠模式」，充电位置在卧室外。"),
    (17, "exercise", "骑自行车通勤", "骑行是低冲击有氧方式，适合作为日常通勤或休闲运动。",
     "## 安全提示\n\n佩戴头盔，检查车况，注意交通规则。"),
    (18, "diet", "发酵食品与肠道健康", "酸奶、泡菜等发酵食品含益生菌，有助于维持肠道菌群平衡。",
     "## 选择建议\n\n优先低糖发酵乳，注意冷藏条件。"),
    (19, "lifestyle", "周末也不报复性熬夜", "周末作息大幅偏移会加重周一疲劳，尽量与平日接近。",
     "## 周末作息\n\n起床时间比平日延迟不超过 **1 小时**。"),
    (20, "exercise", "办公室微运动", "利用碎片时间做深蹲、提踵等，累积活动量。",
     "## 微运动示例\n\n每小时 **1 分钟**：深蹲 10 次 + 提踵 15 次。"),
]

CUSTOM_POINTS = {
    1: [("改善睡眠质量", "规律作息帮助大脑建立稳定的睡眠节律", "sleep"),
        ("提升专注力", "充足睡眠后注意力与记忆力明显增强", "focus")],
    2: [("改善心肺功能", "持续步行有助于增强心血管系统效率", "walk"),
        ("控制体重", "每日适度活动有助于维持健康体重", "balance")],
    3: [("稳定能量供应", "均衡营养避免血糖大幅波动", "energy"),
        ("支持长期健康", "多样化饮食提供全面营养素", "nutrition")],
}

DEFAULT_POINTS = [
    ("改善状态", "坚持习惯后整体精力与情绪更稳定", "energy"),
    ("易于坚持", "从低门槛开始，更容易形成长期习惯", "balance"),
]

CUSTOM_TAGS = {
    1: ["睡眠", "作息"], 2: ["运动", "步行"], 3: ["饮食", "营养"],
    4: ["早起", "生物钟"], 5: ["有氧", "晨练"], 6: ["拉伸", "办公"],
    7: ["饮水", "习惯"], 8: ["早餐", "营养"], 9: ["睡眠", "屏幕"],
    10: ["午休", "恢复"], 11: ["力量", "训练"], 12: ["瑜伽", "柔韧"],
    13: ["减糖", "饮食"], 14: ["地中海", "饮食"], 15: ["蛋白质", "营养"],
    16: ["睡眠", "数字"], 17: ["骑行", "有氧"], 18: ["发酵", "肠道"],
    19: ["作息", "周末"], 20: ["办公", "微运动"],
}

TIP_CONTENT_IDS = [1, 5, 8, 11, 14, 17, 20, 3, 6, 9]
REC_CONTENT_IDS = list(range(1, 9))
FAV_CONTENT_IDS = [1, 2, 5, 8, 11]

# Unsplash 免费图库（演示用）；格式统一 800×450
# 许可：https://unsplash.com/license
def _unsplash(photo_id: str) -> str:
    return (
        f"https://images.unsplash.com/{photo_id}"
        "?auto=format&fit=crop&w=800&h=450&q=80"
    )

COVER_URLS = {
    1: _unsplash("photo-1631049307264-da0ec9d70304"),   # 睡眠
    2: _unsplash("photo-1441974231531-c6227db76b6e"),   # 步行
    3: _unsplash("photo-1512621776951-a57141f2eefd"),   # 均衡饮食
    4: _unsplash("photo-1506905925346-21bda4d32df4"),   # 早起/日出
    5: _unsplash("photo-1416879595882-3373a0480b5b"),   # 晨间散步
    6: _unsplash("photo-1518611012118-696072aa579a"),   # 拉伸
    7: _unsplash("photo-1523362628745-0c100150b504"),   # 饮水
    8: _unsplash("photo-1490645935967-10de6ba17061"),   # 早餐
    9: _unsplash("photo-1618005182384-a83a8bd57fbe"),   # 手机/屏幕
    10: _unsplash("photo-1586023492125-27b2c045efd7"),  # 午休
    11: _unsplash("photo-1534438327276-14e5300c3a48"),  # 力量训练
    12: _unsplash("photo-1544367567-0f2fcb009e0b"),     # 瑜伽
    13: _unsplash("photo-1551024506-0bccd828d307"),     # 减糖/健康饮品
    14: _unsplash("photo-1540189549336-e6e99c3679fe"),  # 地中海饮食
    15: _unsplash("photo-1546069901-ba9599a7e63c"),     # 蛋白质
    16: _unsplash("photo-1498050108023-c5249f4df085"),  # 数字断舍离
    17: _unsplash("photo-1558618666-fcd25c85cd64"),     # 骑行
    18: _unsplash("photo-1563805042-7684c019e1cb"),     # 发酵/酸奶
    19: _unsplash("photo-1631049307264-da0ec9d70304"),  # 周末睡眠
    20: _unsplash("photo-1522071820081-009f0129c71c"),  # 办公室运动
}


def sql_str(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def global_content_id(category_id: int, local_id: int) -> int:
    """内容全局 ID：category_id * 1000 + 原序号，如 category_id=1、原 id=11 → 1011。"""
    return category_id * 1000 + local_id


def local_to_global_id(local_id: int) -> int:
    cat_code = next(cat for lid, cat, *_ in CONTENTS_DATA if lid == local_id)
    return global_content_id(CATEGORY_CODE_TO_ID[cat_code], local_id)


def build_seed():
    categories = []
    for cid, code, name, desc, icon, color, sort_order in CATEGORIES_DATA:
        categories.append({
            "id": cid,
            "code": code,
            "name": name,
            "description": desc,
            "icon": icon,
            "color": color,
            "sort_order": sort_order,
            "published": True,
            "created_at": BASE,
            "updated_at": BASE,
        })

    contents = []
    for local_id, cat, title, summary, body in CONTENTS_DATA:
        category_id = CATEGORY_CODE_TO_ID[cat]
        contents.append({
            "id": global_content_id(category_id, local_id),
            "category_id": category_id,
            "title": title,
            "summary": summary,
            "cover_url": COVER_URLS.get(local_id, ""),
            "body": body,
            "published": True,
            "sort_order": 0,
            "created_at": BASE,
            "updated_at": f"2026-06-{(10 + local_id % 10):02d}T08:00:00.000Z",
        })

    points = []
    pid = 1
    for local_id, cat, *_ in CONTENTS_DATA:
        content_id = global_content_id(CATEGORY_CODE_TO_ID[cat], local_id)
        for j, (title, desc, icon) in enumerate(CUSTOM_POINTS.get(local_id, DEFAULT_POINTS), 1):
            points.append({
                "id": pid, "content_id": content_id, "title": title,
                "description": desc, "icon": icon, "sort_order": j,
            })
            pid += 1

    tags = []
    tid = 1
    for local_id, cat, *_ in CONTENTS_DATA:
        content_id = global_content_id(CATEGORY_CODE_TO_ID[cat], local_id)
        for tag in CUSTOM_TAGS[local_id]:
            tags.append({"id": tid, "content_id": content_id, "tag": tag})
            tid += 1

    tips = []
    for i, local_id in enumerate(TIP_CONTENT_IDS, 1):
        content_id = local_to_global_id(local_id)
        c = next(item for item in contents if item["id"] == content_id)
        tips.append({
            "id": i,
            "content_id": content_id,
            "title": f"今日一知：{c['title'][:14]}",
            "summary": c["summary"],
            "tip_date": f"2026-06-{12 + i:02d}",
            "created_at": BASE,
        })

    recs = []
    for i, local_id in enumerate(REC_CONTENT_IDS, 1):
        recs.append({
            "id": i, "content_id": local_to_global_id(local_id), "sort_order": i,
            "published": True, "created_at": BASE,
        })

    users = [{
        "id": DEMO_USER,
        "email": "demo@healthlive.local",
        "password_hash": "$2a$10$REPLACE_WITH_BCRYPT_HASH",
        "nickname": "演示用户",
        "is_active": True,
        "created_at": BASE,
        "updated_at": BASE,
    }]

    favs = [
        {"user_id": DEMO_USER, "content_id": local_to_global_id(local_id), "created_at": BASE}
        for local_id in FAV_CONTENT_IDS
    ]

    return categories, contents, points, tags, tips, recs, users, favs


def write_json(name: str, key: str, rows: list) -> None:
    path = DATA_DIR / name
    path.write_text(json.dumps({key: rows}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def generate_sql(categories, contents, points, tags, tips, recs, users, favs) -> str:
    lines = [
        "# HealthLive 数据库种子 SQL",
        "",
        "> 与 `assets/data/*.json` **一一对应**。在 pgAdmin Query Tool 中复制执行即可写入 PostgreSQL。",
        "> 执行前请确认表结构已创建；若已有旧数据，可先执行「第 0 步」清空。",
        "",
        "---",
        "",
        "## 表结构参考：categories（若尚未建表）",
        "",
        "```sql",
        "CREATE TABLE IF NOT EXISTS categories (",
        "    id          SERIAL PRIMARY KEY,",
        "    code        VARCHAR(32) NOT NULL UNIQUE,",
        "    name        VARCHAR(64) NOT NULL,",
        "    description TEXT,",
        "    icon        VARCHAR(64),",
        "    color       VARCHAR(16),",
        "    sort_order  INT NOT NULL DEFAULT 0,",
        "    published   BOOLEAN NOT NULL DEFAULT TRUE,",
        "    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),",
        "    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()",
        ");",
        "",
        "-- 若 contents 表尚无 category_id，可执行：",
        "-- ALTER TABLE contents ADD COLUMN IF NOT EXISTS category_id INT REFERENCES categories(id);",
        "-- ALTER TABLE contents DROP COLUMN IF EXISTS category;",
        "```",
        "",
        "---",
        "",
        "## 第 0 步：清空旧数据（可选，开发环境）",
        "",
        "```sql",
        "BEGIN;",
        "",
        "TRUNCATE TABLE user_favorites, home_recommendations, daily_tips,",
        "               content_tags, content_benefit_points, contents, categories, users",
        "RESTART IDENTITY CASCADE;",
        "",
        "COMMIT;",
        "```",
        "",
        "---",
        "",
        f"## 第 1 步：categories（{len(categories)} 条）",
        "",
        "```sql",
        "BEGIN;",
        "",
    ]

    for cat in categories:
        lines.append(
            f"INSERT INTO categories (id, code, name, description, icon, color, sort_order, published, created_at, updated_at) VALUES "
            f"({cat['id']}, {sql_str(cat['code'])}, {sql_str(cat['name'])}, {sql_str(cat['description'])}, "
            f"{sql_str(cat['icon'])}, {sql_str(cat['color'])}, {cat['sort_order']}, TRUE, "
            f"{sql_str(cat['created_at'])}::timestamptz, {sql_str(cat['updated_at'])}::timestamptz);"
        )

    lines.extend(["", "COMMIT;", "```", "", "---", "", "## 第 2 步：contents（20 条）", "", "```sql", "BEGIN;", ""])

    for c in contents:
        lines.append(
            f"INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES "
            f"({c['id']}, {c['category_id']}, {sql_str(c['title'])}, {sql_str(c['summary'])}, "
            f"{sql_str(c['cover_url'])}, {sql_str(c['body'])}, TRUE, {c['sort_order']}, "
            f"{sql_str(c['created_at'])}::timestamptz, {sql_str(c['updated_at'])}::timestamptz);"
        )

    lines.extend(["", "COMMIT;", "```", "", "---", "", "## 第 3 步：content_benefit_points（40 条）", "", "```sql", "BEGIN;", ""])

    for p in points:
        icon = sql_str(p["icon"]) if p["icon"] else "NULL"
        lines.append(
            f"INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES "
            f"({p['id']}, {p['content_id']}, {sql_str(p['title'])}, {sql_str(p['description'])}, {icon}, {p['sort_order']});"
        )

    lines.extend(["", "COMMIT;", "```", "", "---", "", "## 第 4 步：content_tags（40 条）", "", "```sql", "BEGIN;", ""])

    for t in tags:
        lines.append(
            f"INSERT INTO content_tags (id, content_id, tag) VALUES "
            f"({t['id']}, {t['content_id']}, {sql_str(t['tag'])});"
        )

    lines.extend(["", "COMMIT;", "```", "", "---", "", "## 第 5 步：daily_tips（10 条）", "", "```sql", "BEGIN;", ""])

    for tip in tips:
        lines.append(
            f"INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES "
            f"({tip['id']}, {tip['content_id']}, {sql_str(tip['title'])}, {sql_str(tip['summary'])}, "
            f"{sql_str(tip['tip_date'])}::date, {sql_str(tip['created_at'])}::timestamptz);"
        )

    lines.extend(["", "COMMIT;", "```", "", "---", "", "## 第 6 步：home_recommendations（8 条）", "", "```sql", "BEGIN;", ""])

    for r in recs:
        lines.append(
            f"INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES "
            f"({r['id']}, {r['content_id']}, {r['sort_order']}, TRUE, {sql_str(r['created_at'])}::timestamptz);"
        )

    lines.extend(["", "COMMIT;", "```", "", "---", "", "## 第 7 步：users（1 条）", "", "```sql", "BEGIN;", ""])

    for u in users:
        lines.append(
            f"INSERT INTO users (id, email, password_hash, nickname, is_active, created_at, updated_at) VALUES "
            f"({sql_str(u['id'])}::uuid, {sql_str(u['email'])}, {sql_str(u['password_hash'])}, "
            f"{sql_str(u['nickname'])}, TRUE, {sql_str(u['created_at'])}::timestamptz, {sql_str(u['updated_at'])}::timestamptz);"
        )

    lines.extend(["", "COMMIT;", "```", "", "---", "", "## 第 8 步：user_favorites（5 条）", "", "```sql", "BEGIN;", ""])

    for f in favs:
        lines.append(
            f"INSERT INTO user_favorites (user_id, content_id, created_at) VALUES "
            f"({sql_str(f['user_id'])}::uuid, {f['content_id']}, {sql_str(f['created_at'])}::timestamptz);"
        )

    lines.extend([
        "",
        "COMMIT;",
        "```",
        "",
        "---",
        "",
        "## 第 9 步：重置自增序列（若 id 使用 SERIAL/BIGSERIAL）",
        "",
        "```sql",
        "SELECT setval(pg_get_serial_sequence('categories', 'id'), (SELECT MAX(id) FROM categories));",
        "SELECT setval(pg_get_serial_sequence('contents', 'id'), (SELECT MAX(id) FROM contents));",
        "SELECT setval(pg_get_serial_sequence('content_benefit_points', 'id'), (SELECT MAX(id) FROM content_benefit_points));",
        "SELECT setval(pg_get_serial_sequence('content_tags', 'id'), (SELECT MAX(id) FROM content_tags));",
        "SELECT setval(pg_get_serial_sequence('daily_tips', 'id'), (SELECT MAX(id) FROM daily_tips));",
        "SELECT setval(pg_get_serial_sequence('home_recommendations', 'id'), (SELECT MAX(id) FROM home_recommendations));",
        "```",
        "",
        "---",
        "",
        "## 数据量一览",
        "",
        "| 表 | 条数 | 对应 JSON |",
        "|----|------|-----------|",
        f"| categories | {len(categories)} | assets/data/categories.json |",
        f"| contents | {len(contents)} | assets/data/contents.json |",
        f"| content_benefit_points | {len(points)} | assets/data/content_benefit_points.json |",
        f"| content_tags | {len(tags)} | assets/data/content_tags.json |",
        f"| daily_tips | {len(tips)} | assets/data/daily_tips.json |",
        f"| home_recommendations | {len(recs)} | assets/data/home_recommendations.json |",
        f"| users | {len(users)} | assets/data/users.json |",
        f"| user_favorites | {len(favs)} | assets/data/user_favorites.json |",
        "",
        "> 若表字段与上述 SQL 不一致（如用 `status` 代替 `published`），请按实际表结构调整列名。",
    ])

    return "\n".join(lines) + "\n"


def main():
    categories, contents, points, tags, tips, recs, users, favs = build_seed()
    write_json("categories.json", "categories", categories)
    write_json("contents.json", "contents", contents)
    write_json("content_benefit_points.json", "content_benefit_points", points)
    write_json("content_tags.json", "content_tags", tags)
    write_json("daily_tips.json", "daily_tips", tips)
    write_json("home_recommendations.json", "home_recommendations", recs)
    write_json("users.json", "users", users)
    write_json("user_favorites.json", "user_favorites", favs)
    DOC_PATH.write_text(
        generate_sql(categories, contents, points, tags, tips, recs, users, favs),
        encoding="utf-8",
    )
    print(f"Generated {len(categories)} categories, 20 contents, {len(points)} points, {len(tags)} tags")
    print(f"SQL doc: {DOC_PATH}")


if __name__ == "__main__":
    main()
