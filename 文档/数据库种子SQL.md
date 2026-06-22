# HealthLive 数据库种子 SQL

> 与 `assets/data/*.json` **一一对应**。在 pgAdmin Query Tool 中复制执行即可写入 PostgreSQL。
> 执行前请确认表结构已创建；若已有旧数据，可先执行「第 0 步」清空。

---

## 第 0 步：清空旧数据（可选，开发环境）

```sql
BEGIN;

TRUNCATE TABLE user_favorites, home_recommendations, daily_tips,
               content_tags, content_benefit_points, contents, users
RESTART IDENTITY CASCADE;

COMMIT;
```

---

## 第 1 步：contents（20 条）

```sql
BEGIN;

INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1, 'lifestyle', '规律早睡的五个好处', '固定入睡时间有助于调节生物钟，提升第二天的精神状态', '', '## 为什么建议早睡?

保持 **22:30 前入睡** 有助于身体进入修复状态。

- 减少熬夜带来的内分泌紊乱
- 降低焦虑与情绪波动', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2, 'exercise', '每天步行 30 分钟的变化', '适度运动能显著改善心肺功能，降低慢性病风险。', '', '## 步行的好处

每天步行 **30 分钟** 可以显著改善心血管健康。

1. 选择舒适的鞋子
2. 保持能交谈的速度', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3, 'diet', '均衡饮食如何改变身体状态', '合理搭配蛋白质、碳水与蔬果，让身体获得稳定能量。', '', '## 均衡饮食

每餐包含优质蛋白，多吃蔬菜水果，控制精加工食品。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (4, 'lifestyle', '固定起床时间的力量', '即使周末也尽量保持相近的起床时刻，生物钟会更稳定。', '', '## 固定起床

尝试将起床时间波动控制在 **30 分钟以内**，减少「社交时差」。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (5, 'exercise', '晨间散步如何开启活力一天', '清晨适度活动可以促进血液循环，让身体更快苏醒。', '', '## 晨间散步建议

每天 **15～30 分钟** 即可，不必追求强度。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (6, 'exercise', '午后拉伸缓解久坐疲劳', '简短拉伸能放松颈肩腰背，改善久坐带来的僵硬感。', '', '## 办公拉伸

每工作 **45 分钟** 起身活动 3 分钟。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (7, 'diet', '每天喝够水的小技巧', '充足饮水有助于代谢、皮肤状态与精力维持。', '', '## 饮水建议

建议每天 **1500-2000 ml**，分次饮用。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (8, 'diet', '均衡早餐的重要性', '合理搭配蛋白质、碳水与膳食纤维，为上午提供持续能量。', '', '## 早餐搭配

- 优质蛋白：鸡蛋、牛奶
- 复合碳水：燕麦、全麦面食', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (9, 'lifestyle', '减少睡前屏幕时间', '蓝光会抑制褪黑素分泌，影响入睡速度与睡眠质量。', '', '## 睡前习惯

睡前 **1 小时** 远离手机与电脑。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (10, 'lifestyle', '午休 20 分钟的小恢复', '短暂午睡能提升下午专注力，但过长反而影响夜间睡眠。', '', '## 午休建议

控制在 **20 分钟** 以内。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (11, 'exercise', '力量训练入门益处', '适度抗阻训练有助于增加肌肉量、改善代谢与骨密度。', '', '## 入门提示

从自重训练开始，每周 **2-3 次**。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (12, 'exercise', '瑜伽与柔韧性的关系', '规律拉伸与瑜伽练习可改善关节活动度，缓解肌肉紧张。', '', '## 练习建议

每周 **2 次** 15 分钟基础拉伸。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (13, 'diet', '控制添加糖摄入', '过多添加糖与代谢风险相关，减少含糖饮料是有效第一步。', '', '## 减糖技巧

优先选择原味食物，阅读营养标签。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (14, 'diet', '地中海饮食要点', '以橄榄油、全谷物、鱼类和大量蔬菜为特色的饮食模式。', '', '## 核心原则

多吃蔬果、全谷物、优质脂肪，适量鱼类。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (15, 'diet', '蛋白质摄入指南', '足量蛋白质支持肌肉修复、免疫与饱腹感。', '', '## 参考量

可按 **体重 kg × 1.0～1.2 g** 估算每日需求。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (16, 'lifestyle', '数字断舍离与睡眠', '减少睡前信息过载，有助于大脑切换到休息模式。', '', '## 实践方法

设置手机「睡眠模式」，充电位置在卧室外。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (17, 'exercise', '骑自行车通勤', '骑行是低冲击有氧方式，适合作为日常通勤或休闲运动。', '', '## 安全提示

佩戴头盔，检查车况，注意交通规则。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (18, 'diet', '发酵食品与肠道健康', '酸奶、泡菜等发酵食品含益生菌，有助于维持肠道菌群平衡。', '', '## 选择建议

优先低糖发酵乳，注意冷藏条件。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (19, 'lifestyle', '周末也不报复性熬夜', '周末作息大幅偏移会加重周一疲劳，尽量与平日接近。', '', '## 周末作息

起床时间比平日延迟不超过 **1 小时**。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (20, 'exercise', '办公室微运动', '利用碎片时间做深蹲、提踵等，累积活动量。', '', '## 微运动示例

每小时 **1 分钟**：深蹲 10 次 + 提踵 15 次。', TRUE, 0, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);

COMMIT;
```

---

## 第 2 步：content_benefit_points（40 条）

```sql
BEGIN;

INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (1, 1, '改善睡眠质量', '规律作息帮助大脑建立稳定的睡眠节律', 'sleep', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (2, 1, '提升专注力', '充足睡眠后注意力与记忆力明显增强', 'focus', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (3, 2, '改善心肺功能', '持续步行有助于增强心血管系统效率', 'walk', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (4, 2, '控制体重', '每日适度活动有助于维持健康体重', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (5, 3, '稳定能量供应', '均衡营养避免血糖大幅波动', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (6, 3, '支持长期健康', '多样化饮食提供全面营养素', 'nutrition', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (7, 4, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (8, 4, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (9, 5, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (10, 5, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (11, 6, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (12, 6, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (13, 7, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (14, 7, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (15, 8, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (16, 8, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (17, 9, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (18, 9, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (19, 10, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (20, 10, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (21, 11, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (22, 11, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (23, 12, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (24, 12, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (25, 13, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (26, 13, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (27, 14, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (28, 14, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (29, 15, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (30, 15, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (31, 16, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (32, 16, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (33, 17, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (34, 17, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (35, 18, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (36, 18, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (37, 19, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (38, 19, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (39, 20, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (40, 20, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);

COMMIT;
```

---

## 第 3 步：content_tags（40 条）

```sql
BEGIN;

INSERT INTO content_tags (id, content_id, tag) VALUES (1, 1, '睡眠');
INSERT INTO content_tags (id, content_id, tag) VALUES (2, 1, '作息');
INSERT INTO content_tags (id, content_id, tag) VALUES (3, 2, '运动');
INSERT INTO content_tags (id, content_id, tag) VALUES (4, 2, '步行');
INSERT INTO content_tags (id, content_id, tag) VALUES (5, 3, '饮食');
INSERT INTO content_tags (id, content_id, tag) VALUES (6, 3, '营养');
INSERT INTO content_tags (id, content_id, tag) VALUES (7, 4, '早起');
INSERT INTO content_tags (id, content_id, tag) VALUES (8, 4, '生物钟');
INSERT INTO content_tags (id, content_id, tag) VALUES (9, 5, '有氧');
INSERT INTO content_tags (id, content_id, tag) VALUES (10, 5, '晨练');
INSERT INTO content_tags (id, content_id, tag) VALUES (11, 6, '拉伸');
INSERT INTO content_tags (id, content_id, tag) VALUES (12, 6, '办公');
INSERT INTO content_tags (id, content_id, tag) VALUES (13, 7, '饮水');
INSERT INTO content_tags (id, content_id, tag) VALUES (14, 7, '习惯');
INSERT INTO content_tags (id, content_id, tag) VALUES (15, 8, '早餐');
INSERT INTO content_tags (id, content_id, tag) VALUES (16, 8, '营养');
INSERT INTO content_tags (id, content_id, tag) VALUES (17, 9, '睡眠');
INSERT INTO content_tags (id, content_id, tag) VALUES (18, 9, '屏幕');
INSERT INTO content_tags (id, content_id, tag) VALUES (19, 10, '午休');
INSERT INTO content_tags (id, content_id, tag) VALUES (20, 10, '恢复');
INSERT INTO content_tags (id, content_id, tag) VALUES (21, 11, '力量');
INSERT INTO content_tags (id, content_id, tag) VALUES (22, 11, '训练');
INSERT INTO content_tags (id, content_id, tag) VALUES (23, 12, '瑜伽');
INSERT INTO content_tags (id, content_id, tag) VALUES (24, 12, '柔韧');
INSERT INTO content_tags (id, content_id, tag) VALUES (25, 13, '减糖');
INSERT INTO content_tags (id, content_id, tag) VALUES (26, 13, '饮食');
INSERT INTO content_tags (id, content_id, tag) VALUES (27, 14, '地中海');
INSERT INTO content_tags (id, content_id, tag) VALUES (28, 14, '饮食');
INSERT INTO content_tags (id, content_id, tag) VALUES (29, 15, '蛋白质');
INSERT INTO content_tags (id, content_id, tag) VALUES (30, 15, '营养');
INSERT INTO content_tags (id, content_id, tag) VALUES (31, 16, '睡眠');
INSERT INTO content_tags (id, content_id, tag) VALUES (32, 16, '数字');
INSERT INTO content_tags (id, content_id, tag) VALUES (33, 17, '骑行');
INSERT INTO content_tags (id, content_id, tag) VALUES (34, 17, '有氧');
INSERT INTO content_tags (id, content_id, tag) VALUES (35, 18, '发酵');
INSERT INTO content_tags (id, content_id, tag) VALUES (36, 18, '肠道');
INSERT INTO content_tags (id, content_id, tag) VALUES (37, 19, '作息');
INSERT INTO content_tags (id, content_id, tag) VALUES (38, 19, '周末');
INSERT INTO content_tags (id, content_id, tag) VALUES (39, 20, '办公');
INSERT INTO content_tags (id, content_id, tag) VALUES (40, 20, '微运动');

COMMIT;
```

---

## 第 4 步：daily_tips（10 条）

```sql
BEGIN;

INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (1, 1, '今日一知：规律早睡的五个好处', '固定入睡时间有助于调节生物钟，提升第二天的精神状态', '2026-06-13'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (2, 5, '今日一知：晨间散步如何开启活力一天', '清晨适度活动可以促进血液循环，让身体更快苏醒。', '2026-06-14'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (3, 8, '今日一知：均衡早餐的重要性', '合理搭配蛋白质、碳水与膳食纤维，为上午提供持续能量。', '2026-06-15'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (4, 11, '今日一知：力量训练入门益处', '适度抗阻训练有助于增加肌肉量、改善代谢与骨密度。', '2026-06-16'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (5, 14, '今日一知：地中海饮食要点', '以橄榄油、全谷物、鱼类和大量蔬菜为特色的饮食模式。', '2026-06-17'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (6, 17, '今日一知：骑自行车通勤', '骑行是低冲击有氧方式，适合作为日常通勤或休闲运动。', '2026-06-18'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (7, 20, '今日一知：办公室微运动', '利用碎片时间做深蹲、提踵等，累积活动量。', '2026-06-19'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (8, 3, '今日一知：均衡饮食如何改变身体状态', '合理搭配蛋白质、碳水与蔬果，让身体获得稳定能量。', '2026-06-20'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (9, 6, '今日一知：午后拉伸缓解久坐疲劳', '简短拉伸能放松颈肩腰背，改善久坐带来的僵硬感。', '2026-06-21'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (10, 9, '今日一知：减少睡前屏幕时间', '蓝光会抑制褪黑素分泌，影响入睡速度与睡眠质量。', '2026-06-22'::date, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 5 步：home_recommendations（8 条）

```sql
BEGIN;

INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (1, 1, 1, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (2, 2, 2, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (3, 3, 3, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (4, 4, 4, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (5, 5, 5, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (6, 6, 6, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (7, 7, 7, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (8, 8, 8, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 6 步：users（1 条）

```sql
BEGIN;

INSERT INTO users (id, email, password_hash, nickname, is_active, created_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 'demo@healthlive.local', '$2a$10$REPLACE_WITH_BCRYPT_HASH', '演示用户', TRUE, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 7 步：user_favorites（5 条）

```sql
BEGIN;

INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 1, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 2, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 5, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 8, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 11, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 8 步：重置自增序列（若 id 使用 SERIAL/BIGSERIAL）

```sql
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
| contents | 20 | assets/data/contents.json |
| content_benefit_points | 40 | assets/data/content_benefit_points.json |
| content_tags | 40 | assets/data/content_tags.json |
| daily_tips | 10 | assets/data/daily_tips.json |
| home_recommendations | 8 | assets/data/home_recommendations.json |
| users | 1 | assets/data/users.json |
| user_favorites | 5 | assets/data/user_favorites.json |

> 若表字段与上述 SQL 不一致（如用 `status` 代替 `published`），请按实际表结构调整列名。
