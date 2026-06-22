# HealthLive 数据库种子 SQL

> 与 `assets/data/*.json` **一一对应**。在 pgAdmin Query Tool 中复制执行即可写入 PostgreSQL。
> 执行前请确认表结构已创建；若已有旧数据，可先执行「第 0 步」清空。

---

## 表结构参考：categories（若尚未建表）

```sql
CREATE TABLE IF NOT EXISTS categories (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(32) NOT NULL UNIQUE,
    name        VARCHAR(64) NOT NULL,
    description TEXT,
    icon        VARCHAR(64),
    color       VARCHAR(16),
    sort_order  INT NOT NULL DEFAULT 0,
    published   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 若 contents 表尚无 category_id，可执行：
-- ALTER TABLE contents ADD COLUMN IF NOT EXISTS category_id INT REFERENCES categories(id);
-- ALTER TABLE contents DROP COLUMN IF EXISTS category;
```

---

## 第 0 步：清空旧数据（可选，开发环境）

```sql
BEGIN;

TRUNCATE TABLE user_favorites, home_recommendations, daily_tips,
               content_tags, content_benefit_points, contents, categories, users
RESTART IDENTITY CASCADE;

COMMIT;
```

---

## 第 1 步：categories（3 条）

```sql
BEGIN;

INSERT INTO categories (id, code, name, description, icon, color, sort_order, published, created_at, updated_at) VALUES (1, 'lifestyle', '作息', '睡眠、早起、规律作息等生活方式科普', 'bedtime_outlined', '#5B8DEF', 1, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO categories (id, code, name, description, icon, color, sort_order, published, created_at, updated_at) VALUES (2, 'exercise', '运动', '有氧、拉伸、力量训练等运动科普', 'directions_run_outlined', '#3D8B7A', 2, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO categories (id, code, name, description, icon, color, sort_order, published, created_at, updated_at) VALUES (3, 'diet', '饮食', '早餐、饮水、营养搭配等饮食科普', 'restaurant_outlined', '#F2A65A', 3, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 2 步：contents（20 条）

```sql
BEGIN;

INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1001, 1, '规律早睡的五个好处', '固定入睡时间有助于调节生物钟，提升第二天的精神状态', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&h=450&q=80', '## 为什么建议早睡?

保持 **22:30 前入睡** 有助于身体进入修复状态。

- 减少熬夜带来的内分泌紊乱
- 降低焦虑与情绪波动', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2002, 2, '每天步行 30 分钟的变化', '适度运动能显著改善心肺功能，降低慢性病风险。', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&h=450&q=80', '## 步行的好处

每天步行 **30 分钟** 可以显著改善心血管健康。

1. 选择舒适的鞋子
2. 保持能交谈的速度', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3003, 3, '均衡饮食如何改变身体状态', '合理搭配蛋白质、碳水与蔬果，让身体获得稳定能量。', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&h=450&q=80', '## 均衡饮食

每餐包含优质蛋白，多吃蔬菜水果，控制精加工食品。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1004, 1, '固定起床时间的力量', '即使周末也尽量保持相近的起床时刻，生物钟会更稳定。', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=800&h=450&q=80', '## 固定起床

尝试将起床时间波动控制在 **30 分钟以内**，减少「社交时差」。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2005, 2, '晨间散步如何开启活力一天', '清晨适度活动可以促进血液循环，让身体更快苏醒。', 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=800&h=450&q=80', '## 晨间散步建议

每天 **15～30 分钟** 即可，不必追求强度。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2006, 2, '午后拉伸缓解久坐疲劳', '简短拉伸能放松颈肩腰背，改善久坐带来的僵硬感。', 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=800&h=450&q=80', '## 办公拉伸

每工作 **45 分钟** 起身活动 3 分钟。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3007, 3, '每天喝够水的小技巧', '充足饮水有助于代谢、皮肤状态与精力维持。', 'https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=800&h=450&q=80', '## 饮水建议

建议每天 **1500-2000 ml**，分次饮用。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3008, 3, '均衡早餐的重要性', '合理搭配蛋白质、碳水与膳食纤维，为上午提供持续能量。', 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=800&h=450&q=80', '## 早餐搭配

- 优质蛋白：鸡蛋、牛奶
- 复合碳水：燕麦、全麦面食', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1009, 1, '减少睡前屏幕时间', '蓝光会抑制褪黑素分泌，影响入睡速度与睡眠质量。', 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=800&h=450&q=80', '## 睡前习惯

睡前 **1 小时** 远离手机与电脑。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1010, 1, '午休 20 分钟的小恢复', '短暂午睡能提升下午专注力，但过长反而影响夜间睡眠。', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&h=450&q=80', '## 午休建议

控制在 **20 分钟** 以内。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2011, 2, '力量训练入门益处', '适度抗阻训练有助于增加肌肉量、改善代谢与骨密度。', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=800&h=450&q=80', '## 入门提示

从自重训练开始，每周 **2-3 次**。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2012, 2, '瑜伽与柔韧性的关系', '规律拉伸与瑜伽练习可改善关节活动度，缓解肌肉紧张。', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&h=450&q=80', '## 练习建议

每周 **2 次** 15 分钟基础拉伸。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3013, 3, '控制添加糖摄入', '过多添加糖与代谢风险相关，减少含糖饮料是有效第一步。', 'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=800&h=450&q=80', '## 减糖技巧

优先选择原味食物，阅读营养标签。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3014, 3, '地中海饮食要点', '以橄榄油、全谷物、鱼类和大量蔬菜为特色的饮食模式。', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=800&h=450&q=80', '## 核心原则

多吃蔬果、全谷物、优质脂肪，适量鱼类。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3015, 3, '蛋白质摄入指南', '足量蛋白质支持肌肉修复、免疫与饱腹感。', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&h=450&q=80', '## 参考量

可按 **体重 kg × 1.0～1.2 g** 估算每日需求。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1016, 1, '数字断舍离与睡眠', '减少睡前信息过载，有助于大脑切换到休息模式。', 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&h=450&q=80', '## 实践方法

设置手机「睡眠模式」，充电位置在卧室外。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2017, 2, '骑自行车通勤', '骑行是低冲击有氧方式，适合作为日常通勤或休闲运动。', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=800&h=450&q=80', '## 安全提示

佩戴头盔，检查车况，注意交通规则。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3018, 3, '发酵食品与肠道健康', '酸奶、泡菜等发酵食品含益生菌，有助于维持肠道菌群平衡。', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=800&h=450&q=80', '## 选择建议

优先低糖发酵乳，注意冷藏条件。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1019, 1, '周末也不报复性熬夜', '周末作息大幅偏移会加重周一疲劳，尽量与平日接近。', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&h=450&q=80', '## 周末作息

起床时间比平日延迟不超过 **1 小时**。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2020, 2, '办公室微运动', '利用碎片时间做深蹲、提踵等，累积活动量。', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=800&h=450&q=80', '## 微运动示例

每小时 **1 分钟**：深蹲 10 次 + 提踵 15 次。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);

COMMIT;
```

---

## 第 3 步：content_benefit_points（40 条）

```sql
BEGIN;

INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (1, 1001, '改善睡眠质量', '规律作息帮助大脑建立稳定的睡眠节律', 'sleep', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (2, 1001, '提升专注力', '充足睡眠后注意力与记忆力明显增强', 'focus', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (3, 2002, '改善心肺功能', '持续步行有助于增强心血管系统效率', 'walk', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (4, 2002, '控制体重', '每日适度活动有助于维持健康体重', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (5, 3003, '稳定能量供应', '均衡营养避免血糖大幅波动', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (6, 3003, '支持长期健康', '多样化饮食提供全面营养素', 'nutrition', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (7, 1004, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (8, 1004, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (9, 2005, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (10, 2005, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (11, 2006, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (12, 2006, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (13, 3007, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (14, 3007, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (15, 3008, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (16, 3008, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (17, 1009, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (18, 1009, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (19, 1010, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (20, 1010, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (21, 2011, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (22, 2011, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (23, 2012, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (24, 2012, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (25, 3013, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (26, 3013, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (27, 3014, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (28, 3014, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (29, 3015, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (30, 3015, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (31, 1016, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (32, 1016, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (33, 2017, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (34, 2017, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (35, 3018, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (36, 3018, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (37, 1019, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (38, 1019, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (39, 2020, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (40, 2020, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);

COMMIT;
```

---

## 第 4 步：content_tags（40 条）

```sql
BEGIN;

INSERT INTO content_tags (id, content_id, tag) VALUES (1, 1001, '睡眠');
INSERT INTO content_tags (id, content_id, tag) VALUES (2, 1001, '作息');
INSERT INTO content_tags (id, content_id, tag) VALUES (3, 2002, '运动');
INSERT INTO content_tags (id, content_id, tag) VALUES (4, 2002, '步行');
INSERT INTO content_tags (id, content_id, tag) VALUES (5, 3003, '饮食');
INSERT INTO content_tags (id, content_id, tag) VALUES (6, 3003, '营养');
INSERT INTO content_tags (id, content_id, tag) VALUES (7, 1004, '早起');
INSERT INTO content_tags (id, content_id, tag) VALUES (8, 1004, '生物钟');
INSERT INTO content_tags (id, content_id, tag) VALUES (9, 2005, '有氧');
INSERT INTO content_tags (id, content_id, tag) VALUES (10, 2005, '晨练');
INSERT INTO content_tags (id, content_id, tag) VALUES (11, 2006, '拉伸');
INSERT INTO content_tags (id, content_id, tag) VALUES (12, 2006, '办公');
INSERT INTO content_tags (id, content_id, tag) VALUES (13, 3007, '饮水');
INSERT INTO content_tags (id, content_id, tag) VALUES (14, 3007, '习惯');
INSERT INTO content_tags (id, content_id, tag) VALUES (15, 3008, '早餐');
INSERT INTO content_tags (id, content_id, tag) VALUES (16, 3008, '营养');
INSERT INTO content_tags (id, content_id, tag) VALUES (17, 1009, '睡眠');
INSERT INTO content_tags (id, content_id, tag) VALUES (18, 1009, '屏幕');
INSERT INTO content_tags (id, content_id, tag) VALUES (19, 1010, '午休');
INSERT INTO content_tags (id, content_id, tag) VALUES (20, 1010, '恢复');
INSERT INTO content_tags (id, content_id, tag) VALUES (21, 2011, '力量');
INSERT INTO content_tags (id, content_id, tag) VALUES (22, 2011, '训练');
INSERT INTO content_tags (id, content_id, tag) VALUES (23, 2012, '瑜伽');
INSERT INTO content_tags (id, content_id, tag) VALUES (24, 2012, '柔韧');
INSERT INTO content_tags (id, content_id, tag) VALUES (25, 3013, '减糖');
INSERT INTO content_tags (id, content_id, tag) VALUES (26, 3013, '饮食');
INSERT INTO content_tags (id, content_id, tag) VALUES (27, 3014, '地中海');
INSERT INTO content_tags (id, content_id, tag) VALUES (28, 3014, '饮食');
INSERT INTO content_tags (id, content_id, tag) VALUES (29, 3015, '蛋白质');
INSERT INTO content_tags (id, content_id, tag) VALUES (30, 3015, '营养');
INSERT INTO content_tags (id, content_id, tag) VALUES (31, 1016, '睡眠');
INSERT INTO content_tags (id, content_id, tag) VALUES (32, 1016, '数字');
INSERT INTO content_tags (id, content_id, tag) VALUES (33, 2017, '骑行');
INSERT INTO content_tags (id, content_id, tag) VALUES (34, 2017, '有氧');
INSERT INTO content_tags (id, content_id, tag) VALUES (35, 3018, '发酵');
INSERT INTO content_tags (id, content_id, tag) VALUES (36, 3018, '肠道');
INSERT INTO content_tags (id, content_id, tag) VALUES (37, 1019, '作息');
INSERT INTO content_tags (id, content_id, tag) VALUES (38, 1019, '周末');
INSERT INTO content_tags (id, content_id, tag) VALUES (39, 2020, '办公');
INSERT INTO content_tags (id, content_id, tag) VALUES (40, 2020, '微运动');

COMMIT;
```

---

## 第 5 步：daily_tips（10 条）

```sql
BEGIN;

INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (1, 1001, '今日一知：规律早睡的五个好处', '固定入睡时间有助于调节生物钟，提升第二天的精神状态', '2026-06-13'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (2, 2005, '今日一知：晨间散步如何开启活力一天', '清晨适度活动可以促进血液循环，让身体更快苏醒。', '2026-06-14'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (3, 3008, '今日一知：均衡早餐的重要性', '合理搭配蛋白质、碳水与膳食纤维，为上午提供持续能量。', '2026-06-15'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (4, 2011, '今日一知：力量训练入门益处', '适度抗阻训练有助于增加肌肉量、改善代谢与骨密度。', '2026-06-16'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (5, 3014, '今日一知：地中海饮食要点', '以橄榄油、全谷物、鱼类和大量蔬菜为特色的饮食模式。', '2026-06-17'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (6, 2017, '今日一知：骑自行车通勤', '骑行是低冲击有氧方式，适合作为日常通勤或休闲运动。', '2026-06-18'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (7, 2020, '今日一知：办公室微运动', '利用碎片时间做深蹲、提踵等，累积活动量。', '2026-06-19'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (8, 3003, '今日一知：均衡饮食如何改变身体状态', '合理搭配蛋白质、碳水与蔬果，让身体获得稳定能量。', '2026-06-20'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (9, 2006, '今日一知：午后拉伸缓解久坐疲劳', '简短拉伸能放松颈肩腰背，改善久坐带来的僵硬感。', '2026-06-21'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (10, 1009, '今日一知：减少睡前屏幕时间', '蓝光会抑制褪黑素分泌，影响入睡速度与睡眠质量。', '2026-06-22'::date, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 6 步：home_recommendations（8 条）

```sql
BEGIN;

INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (1, 1001, 1, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (2, 2002, 2, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (3, 3003, 3, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (4, 1004, 4, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (5, 2005, 5, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (6, 2006, 6, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (7, 3007, 7, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (8, 3008, 8, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 7 步：users（1 条）

```sql
BEGIN;

INSERT INTO users (id, email, password_hash, nickname, is_active, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 'demo@healthlive.local', '$2a$10$REPLACE_WITH_BCRYPT_HASH', '演示用户', TRUE, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 8 步：user_favorites（5 条）

```sql
BEGIN;

INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 1001, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 2002, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 2005, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 3008, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 2011, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 9 步：重置自增序列（若 id 使用 SERIAL/BIGSERIAL）

```sql
SELECT setval(pg_get_serial_sequence('categories', 'id'), (SELECT MAX(id) FROM categories));
SELECT setval(pg_get_serial_sequence('contents', 'id'), (SELECT MAX(id) FROM contents));
SELECT setval(pg_get_serial_sequence('content_benefit_points', 'id'), (SELECT MAX(id) FROM content_benefit_points));
SELECT setval(pg_get_serial_sequence('content_tags', 'id'), (SELECT MAX(id) FROM content_tags));
SELECT setval(pg_get_serial_sequence('daily_tips', 'id'), (SELECT MAX(id) FROM daily_tips));
SELECT setval(pg_get_serial_sequence('home_recommendations', 'id'), (SELECT MAX(id) FROM home_recommendations));
```

---

## 数据量一览

| 表 | 条数 | 对应 JSON |
|----|------|-----------|
| categories | 3 | assets/data/categories.json |
| contents | 20 | assets/data/contents.json |
| content_benefit_points | 40 | assets/data/content_benefit_points.json |
| content_tags | 40 | assets/data/content_tags.json |
| daily_tips | 10 | assets/data/daily_tips.json |
| home_recommendations | 8 | assets/data/home_recommendations.json |
| users | 1 | assets/data/users.json |
| user_favorites | 5 | assets/data/user_favorites.json |

> 若表字段与上述 SQL 不一致（如用 `status` 代替 `published`），请按实际表结构调整列名。
