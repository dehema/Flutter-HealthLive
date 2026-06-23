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

## 第 2 步：contents（60 条）

```sql
BEGIN;

INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1001, 1, '规律早睡的五个好处', '固定入睡时间有助于调节生物钟，提升第二天的精神状态', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&h=450&q=80', '## 为什么建议早睡?

保持 **22:30 前入睡** 有助于身体进入修复状态。

- 减少熬夜带来的内分泌紊乱
- 降低焦虑与情绪波动', TRUE, 1, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1002, 1, '固定起床时间的力量', '即使周末也尽量保持相近的起床时刻，生物钟会更稳定。', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=800&h=450&q=80', '## 固定起床

尝试将起床时间波动控制在 **30 分钟以内**，减少「社交时差」。', TRUE, 2, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1003, 1, '减少睡前屏幕时间', '蓝光会抑制褪黑素分泌，影响入睡速度与睡眠质量。', 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=800&h=450&q=80', '## 睡前习惯

睡前 **1 小时** 远离手机与电脑。', TRUE, 3, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1004, 1, '午休 20 分钟的小恢复', '短暂午睡能提升下午专注力，但过长反而影响夜间睡眠。', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&h=450&q=80', '## 午休建议

控制在 **20 分钟** 以内。', TRUE, 4, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1005, 1, '数字断舍离与睡眠', '减少睡前信息过载，有助于大脑切换到休息模式。', 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&h=450&q=80', '## 实践方法

设置手机「睡眠模式」，充电位置在卧室外。', TRUE, 5, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1006, 1, '周末也不报复性熬夜', '周末作息大幅偏移会加重周一疲劳，尽量与平日接近。', 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&w=800&h=450&q=80', '## 周末作息

起床时间比平日延迟不超过 **1 小时**。', TRUE, 6, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1007, 1, '睡前阅读代替刷手机', '纸质书或电子墨水屏的暖光阅读，有助于放松神经。', 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&h=450&q=80', '## 阅读建议

选择轻松内容，**15～20 分钟** 即可。', TRUE, 7, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1008, 1, '卧室温度与睡眠品质', '略偏凉的睡眠环境通常更利于深度睡眠。', 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&h=450&q=80', '## 温度参考

夏季 **24～26℃**，冬季 **18～22℃** 因人而异。', TRUE, 8, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1009, 1, '建立睡前仪式', '固定顺序的小习惯会向大脑发送「该休息了」的信号。', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800&h=450&q=80', '## 仪式示例

洗漱 → 拉伸 → 调暗灯光 → 阅读。', TRUE, 9, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1010, 1, '闹钟只响一次就起床', '反复赖床会打乱节律，把闹钟放远是简单有效的一招。', 'https://images.unsplash.com/photo-1706542762554-d9abc1334f4b?auto=format&fit=crop&w=800&h=450&q=80', '## 小技巧

起床后立即接触 **自然光** 或开灯。', TRUE, 10, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1011, 1, '白天多接触自然光', '充足日照有助于调节褪黑素节律，改善夜间入睡。', 'https://images.unsplash.com/photo-1716324836235-23ebe115ae1c?auto=format&fit=crop&w=800&h=450&q=80', '## 行动建议

上午户外 **10～15 分钟**，阴天也有效。', TRUE, 11, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1012, 1, '咖啡因截止时间的讲究', '下午过晚摄入咖啡因可能拖晚入睡时间。', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&h=450&q=80', '## 参考

尽量在 **14:00 前** 完成最后一次咖啡或浓茶。', TRUE, 12, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1013, 1, '情绪日记与减压', '写下当日烦恼可减少睡前反刍，降低入睡难度。', 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=800&h=450&q=80', '## 写法

3 分钟列出 **1 件感恩 + 1 件可改进**。', TRUE, 13, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1014, 1, '保持卧室昏暗安静', '遮光窗帘与降低噪音能显著提升睡眠连续性。', 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=800&h=450&q=80', '## 环境优化

必要时使用耳塞或白噪音。', TRUE, 14, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1015, 1, '午睡不影响夜间睡眠', '午睡过长或太晚可能挤占夜间困意。', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=800&h=450&q=80', '## 建议

**13:00～15:00** 之间，不超过 20 分钟。', TRUE, 15, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1016, 1, '出差时的作息调整', '跨时区或旅途疲劳时，仍尽量固定入睡窗口。', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&h=450&q=80', '## 策略

抵达后先适应 **当地光照**，再调整用餐时间。', TRUE, 16, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1017, 1, '轮班族的睡眠策略', '不规则排班更需保护连续睡眠块与黑暗环境。', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=800&h=450&q=80', '## 要点

下班途中戴墨镜，回家先 **1 小时无屏**。', TRUE, 17, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1018, 1, '渐进式提前入睡', '一次性大幅提前容易失败，每天提前 15 分钟更可持续。', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=800&h=450&q=80', '## 计划

连续 **4～7 天** 微调，直到目标就寝点。', TRUE, 18, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1019, 1, '睡前轻柔拉伸', '颈肩与背部的温和拉伸可缓解日间紧张。', 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=800&h=450&q=80', '## 动作

每侧拉伸 **20 秒**，避免大幅弹跳。', TRUE, 19, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (1020, 1, '感恩日记与入睡', '积极回顾一天能缓解焦虑，让大脑更容易进入休息。', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&h=450&q=80', '## 练习

写下 **3 件** 今日小确幸即可。', TRUE, 20, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2001, 2, '每天步行 30 分钟的变化', '适度运动能显著改善心肺功能，降低慢性病风险。', 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&h=450&q=80', '## 步行的好处

每天步行 **30 分钟** 可以显著改善心血管健康。', TRUE, 1, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2002, 2, '晨间散步如何开启活力一天', '清晨适度活动可以促进血液循环，让身体更快苏醒。', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800&h=450&q=80', '## 晨间散步建议

每天 **15～30 分钟** 即可，不必追求强度。', TRUE, 2, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2003, 2, '午后拉伸缓解久坐疲劳', '简短拉伸能放松颈肩腰背，改善久坐带来的僵硬感。', 'https://images.unsplash.com/photo-1706542762554-d9abc1334f4b?auto=format&fit=crop&w=800&h=450&q=80', '## 办公拉伸

每工作 **45 分钟** 起身活动 3 分钟。', TRUE, 3, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2004, 2, '力量训练入门益处', '适度抗阻训练有助于增加肌肉量、改善代谢与骨密度。', 'https://images.unsplash.com/photo-1716324836235-23ebe115ae1c?auto=format&fit=crop&w=800&h=450&q=80', '## 入门提示

从自重训练开始，每周 **2-3 次**。', TRUE, 4, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2005, 2, '瑜伽与柔韧性的关系', '规律拉伸与瑜伽练习可改善关节活动度，缓解肌肉紧张。', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&h=450&q=80', '## 练习建议

每周 **2 次** 15 分钟基础拉伸。', TRUE, 5, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2006, 2, '骑自行车通勤', '骑行是低冲击有氧方式，适合作为日常通勤或休闲运动。', 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=800&h=450&q=80', '## 安全提示

佩戴头盔，检查车况，注意交通规则。', TRUE, 6, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2007, 2, '办公室微运动', '利用碎片时间做深蹲、提踵等，累积活动量。', 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=800&h=450&q=80', '## 微运动示例

每小时 **1 分钟**：深蹲 10 次 + 提踵 15 次。', TRUE, 7, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2008, 2, '爬楼梯代替电梯', '把日常移动变成训练，提升心肺与下肢力量。', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=800&h=450&q=80', '## 起步

先 **2～3 层** 开始，逐步增加。', TRUE, 8, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2009, 2, '跳绳燃脂入门', '跳绳对场地要求小，适合作为短时高效有氧。', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&h=450&q=80', '## 入门

每次 **3～5 分钟** 分组完成，注意落地缓冲。', TRUE, 9, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2010, 2, '游泳低冲击有氧', '水的浮力减轻关节负担，适合多数人群。', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=800&h=450&q=80', '## 频率

每周 **2 次**，每次 **30 分钟** 左右。', TRUE, 10, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2011, 2, '核心稳定训练', '强化腹背深层肌肉，改善体态并支撑日常动作。', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=800&h=450&q=80', '## 基础动作

死虫、鸟狗、侧桥，各 **30 秒 × 3 组**。', TRUE, 11, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2012, 2, '跑步呼吸节奏', '稳定呼吸能减少侧 stitch，提升跑步舒适度。', 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=800&h=450&q=80', '## 节奏

尝试 **3 步吸气、3 步呼气** 起步。', TRUE, 12, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2013, 2, '运动后拉伸恢复', '训练后静态拉伸有助于缓解延迟性酸痛。', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&h=450&q=80', '## 时机

训练结束后 **5～10 分钟**，每个部位 30 秒。', TRUE, 13, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2014, 2, '周末徒步计划', '户外徒步结合有氧与放松，适合家庭或朋友同行。', 'https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=800&h=450&q=80', '## 准备

穿防滑鞋，带水与简餐，从 **5 km 内** 路线开始。', TRUE, 14, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2015, 2, '平板支撑进阶', '从膝盖着地版本开始，逐步延长核心耐力。', 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=800&h=450&q=80', '## 目标

保持 **20～40 秒** 标准姿势，优先质量。', TRUE, 15, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2016, 2, '弹力带居家训练', '阻力带占用空间小，适合在家做上肢与臀部训练。', 'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=800&h=450&q=80', '## 组合

深蹲、划船、侧走，各 **12～15 次 × 2 组**。', TRUE, 16, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2017, 2, '散步会议新习惯', '边走边聊可打破久坐，同时完成轻度活动。', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=800&h=450&q=80', '## 场景

电话会议或一对一沟通，选 **平坦路线**。', TRUE, 17, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2018, 2, '平衡训练防跌倒', '单脚站立等练习可提升本体感觉与稳定性。', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&h=450&q=80', '## 练习

扶墙单脚站 **20 秒**，左右各 3 组。', TRUE, 18, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2019, 2, '热身 5 分钟法则', '充分热身可提升表现并降低运动损伤风险。', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=800&h=450&q=80', '## 内容

关节环绕 + 慢跑原地 + 动态拉伸。', TRUE, 19, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (2020, 2, '运动前后补水', '及时补水维持体温调节与运动表现。', 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=800&h=450&q=80', '## 提示

运动前 **200 ml**，过程中少量多次。', TRUE, 20, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3001, 3, '均衡饮食如何改变身体状态', '合理搭配蛋白质、碳水与蔬果，让身体获得稳定能量。', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=800&h=450&q=80', '## 均衡饮食

每餐包含优质蛋白，多吃蔬菜水果，控制精加工食品。', TRUE, 1, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3002, 3, '每天喝够水的小技巧', '充足饮水有助于代谢、皮肤状态与精力维持。', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&h=450&q=80', '## 饮水建议

建议每天 **1500-2000 ml**，分次饮用。', TRUE, 2, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3003, 3, '均衡早餐的重要性', '合理搭配蛋白质、碳水与膳食纤维，为上午提供持续能量。', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=800&h=450&q=80', '## 早餐搭配

- 优质蛋白：鸡蛋、牛奶
- 复合碳水：燕麦、全麦面食', TRUE, 3, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3004, 3, '控制添加糖摄入', '过多添加糖与代谢风险相关，减少含糖饮料是有效第一步。', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=800&h=450&q=80', '## 减糖技巧

优先选择原味食物，阅读营养标签。', TRUE, 4, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3005, 3, '地中海饮食要点', '以橄榄油、全谷物、鱼类和大量蔬菜为特色的饮食模式。', 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=800&h=450&q=80', '## 核心原则

多吃蔬果、全谷物、优质脂肪，适量鱼类。', TRUE, 5, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3006, 3, '蛋白质摄入指南', '足量蛋白质支持肌肉修复、免疫与饱腹感。', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&h=450&q=80', '## 参考量

可按 **体重 kg × 1.0～1.2 g** 估算每日需求。', TRUE, 6, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3007, 3, '发酵食品与肠道健康', '酸奶、泡菜等发酵食品含益生菌，有助于维持肠道菌群平衡。', 'https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=800&h=450&q=80', '## 选择建议

优先低糖发酵乳，注意冷藏条件。', TRUE, 7, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3008, 3, '深色蔬菜摄入目标', '深绿与橙黄蔬菜富含叶酸、β-胡萝卜素与钾。', 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=800&h=450&q=80', '## 目标

每餐至少 **1/2 盘** 蔬菜，深浅色搭配。', TRUE, 8, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3009, 3, '全谷物替换精白主食', '全谷物提供更多纤维与 B 族维生素，血糖反应更平稳。', 'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=800&h=450&q=80', '## 替换

白米饭 → 糙米饭；白面包 → 全麦面包。', TRUE, 9, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3010, 3, '健康零食选择', '两餐之间可选坚果、酸奶或水果，避免空热量。', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=800&h=450&q=80', '## 份量

坚果 **一小把（约 20 g）** 即可。', TRUE, 10, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3011, 3, '外食少油少盐', '餐厅菜品往往油盐偏高，主动要求调整更容易坚持。', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&h=450&q=80', '## 技巧

选蒸、煮、烤，酱汁 **另放**。', TRUE, 11, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-11T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3012, 3, '膳食纤维每日目标', '足量纤维支持肠道蠕动与饱腹感。', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=800&h=450&q=80', '## 参考

成人每天 **25～30 g**，逐步增加并多喝水。', TRUE, 12, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-12T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3013, 3, 'omega-3 来源', '深海鱼、亚麻籽等是常见 omega-3 来源。', 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=800&h=450&q=80', '## 建议

每周 **2 次** 鱼类，其中一次为富含脂肪的鱼。', TRUE, 13, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-13T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3014, 3, '烹饪方式影响热量', '同样食材，蒸煮比油炸显著减少额外脂肪。', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&h=450&q=80', '## 优先

蒸、煮、炖、快炒少油。', TRUE, 14, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-14T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3015, 3, '正念饮食练习', '放慢速度、专注味觉，有助于识别饱腹信号。', 'https://images.unsplash.com/photo-1556656793-08538906a9f8?auto=format&fit=crop&w=800&h=450&q=80', '## 练习

每口咀嚼 **15～20 次**，放下餐具再下口。', TRUE, 15, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-15T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3016, 3, '分餐盘法控制份量', '用盘子分区估算比例，比严格称重更易坚持。', 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&h=450&q=80', '## 比例

蔬菜 **1/2**，蛋白 **1/4**，主食 **1/4**。', TRUE, 16, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-16T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3017, 3, '限盐与血压', '减少钠摄入有助于控制血压与水肿。', 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?auto=format&fit=crop&w=800&h=450&q=80', '## 行动

少用酱油与加工食品，用香辛料提味。', TRUE, 17, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-17T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3018, 3, '钙质与骨骼', '奶类、豆制品与深绿蔬菜是常见钙来源。', 'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?auto=format&fit=crop&w=800&h=450&q=80', '## 提示

配合 **维生素 D** 与适度负重运动。', TRUE, 18, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-18T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3019, 3, '铁元素补充', '红肉、动物肝与豆类有助于预防缺铁性疲劳。', 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&h=450&q=80', '## 搭配

与 **维生素 C** 同食可提高植物铁吸收。', TRUE, 19, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-19T08:00:00.000Z'::timestamptz);
INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES (3020, 3, '季节性本地食材', '当季蔬果营养与风味更佳，也减少运输成本。', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&h=450&q=80', '## 建议

每周逛一次本地市场，尝试 **1 种新食材**。', TRUE, 20, '2026-06-22T02:42:11.169Z'::timestamptz, '2026-06-10T08:00:00.000Z'::timestamptz);

COMMIT;
```

---

## 第 3 步：content_benefit_points（120 条）

```sql
BEGIN;

INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (1, 1001, '改善睡眠质量', '规律作息帮助大脑建立稳定的睡眠节律', 'sleep', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (2, 1001, '提升专注力', '充足睡眠后注意力与记忆力明显增强', 'focus', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (3, 1002, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (4, 1002, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (5, 1003, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (6, 1003, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (7, 1004, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (8, 1004, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (9, 1005, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (10, 1005, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (11, 1006, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (12, 1006, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (13, 1007, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (14, 1007, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (15, 1008, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (16, 1008, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (17, 1009, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (18, 1009, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (19, 1010, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (20, 1010, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (21, 1011, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (22, 1011, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (23, 1012, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (24, 1012, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (25, 1013, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (26, 1013, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (27, 1014, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (28, 1014, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (29, 1015, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (30, 1015, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (31, 1016, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (32, 1016, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (33, 1017, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (34, 1017, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (35, 1018, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (36, 1018, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (37, 1019, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (38, 1019, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (39, 1020, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (40, 1020, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (41, 2001, '改善心肺功能', '持续步行有助于增强心血管系统效率', 'walk', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (42, 2001, '控制体重', '每日适度活动有助于维持健康体重', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (43, 2002, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (44, 2002, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (45, 2003, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (46, 2003, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (47, 2004, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (48, 2004, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (49, 2005, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (50, 2005, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (51, 2006, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (52, 2006, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (53, 2007, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (54, 2007, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (55, 2008, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (56, 2008, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (57, 2009, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (58, 2009, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (59, 2010, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (60, 2010, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (61, 2011, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (62, 2011, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (63, 2012, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (64, 2012, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (65, 2013, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (66, 2013, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (67, 2014, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (68, 2014, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (69, 2015, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (70, 2015, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (71, 2016, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (72, 2016, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (73, 2017, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (74, 2017, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (75, 2018, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (76, 2018, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (77, 2019, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (78, 2019, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (79, 2020, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (80, 2020, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (81, 3001, '稳定能量供应', '均衡营养避免血糖大幅波动', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (82, 3001, '支持长期健康', '多样化饮食提供全面营养素', 'nutrition', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (83, 3002, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (84, 3002, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (85, 3003, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (86, 3003, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (87, 3004, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (88, 3004, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (89, 3005, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (90, 3005, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (91, 3006, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (92, 3006, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (93, 3007, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (94, 3007, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (95, 3008, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (96, 3008, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (97, 3009, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (98, 3009, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (99, 3010, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (100, 3010, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (101, 3011, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (102, 3011, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (103, 3012, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (104, 3012, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (105, 3013, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (106, 3013, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (107, 3014, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (108, 3014, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (109, 3015, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (110, 3015, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (111, 3016, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (112, 3016, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (113, 3017, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (114, 3017, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (115, 3018, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (116, 3018, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (117, 3019, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (118, 3019, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (119, 3020, '改善状态', '坚持习惯后整体精力与情绪更稳定', 'energy', 1);
INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES (120, 3020, '易于坚持', '从低门槛开始，更容易形成长期习惯', 'balance', 2);

COMMIT;
```

---

## 第 4 步：content_tags（120 条）

```sql
BEGIN;

INSERT INTO content_tags (id, content_id, tag) VALUES (1, 1001, '睡眠');
INSERT INTO content_tags (id, content_id, tag) VALUES (2, 1001, '作息');
INSERT INTO content_tags (id, content_id, tag) VALUES (3, 1002, '早起');
INSERT INTO content_tags (id, content_id, tag) VALUES (4, 1002, '生物钟');
INSERT INTO content_tags (id, content_id, tag) VALUES (5, 1003, '屏幕');
INSERT INTO content_tags (id, content_id, tag) VALUES (6, 1003, '恢复');
INSERT INTO content_tags (id, content_id, tag) VALUES (7, 1004, '数字');
INSERT INTO content_tags (id, content_id, tag) VALUES (8, 1004, '周末');
INSERT INTO content_tags (id, content_id, tag) VALUES (9, 1005, '阅读');
INSERT INTO content_tags (id, content_id, tag) VALUES (10, 1005, '温度');
INSERT INTO content_tags (id, content_id, tag) VALUES (11, 1006, '仪式');
INSERT INTO content_tags (id, content_id, tag) VALUES (12, 1006, '闹钟');
INSERT INTO content_tags (id, content_id, tag) VALUES (13, 1007, '日光');
INSERT INTO content_tags (id, content_id, tag) VALUES (14, 1007, '咖啡因');
INSERT INTO content_tags (id, content_id, tag) VALUES (15, 1008, '情绪');
INSERT INTO content_tags (id, content_id, tag) VALUES (16, 1008, '环境');
INSERT INTO content_tags (id, content_id, tag) VALUES (17, 1009, '午睡');
INSERT INTO content_tags (id, content_id, tag) VALUES (18, 1009, '出差');
INSERT INTO content_tags (id, content_id, tag) VALUES (19, 1010, '轮班');
INSERT INTO content_tags (id, content_id, tag) VALUES (20, 1010, '拉伸');
INSERT INTO content_tags (id, content_id, tag) VALUES (21, 1011, '睡眠');
INSERT INTO content_tags (id, content_id, tag) VALUES (22, 1011, '作息');
INSERT INTO content_tags (id, content_id, tag) VALUES (23, 1012, '早起');
INSERT INTO content_tags (id, content_id, tag) VALUES (24, 1012, '生物钟');
INSERT INTO content_tags (id, content_id, tag) VALUES (25, 1013, '屏幕');
INSERT INTO content_tags (id, content_id, tag) VALUES (26, 1013, '恢复');
INSERT INTO content_tags (id, content_id, tag) VALUES (27, 1014, '数字');
INSERT INTO content_tags (id, content_id, tag) VALUES (28, 1014, '周末');
INSERT INTO content_tags (id, content_id, tag) VALUES (29, 1015, '阅读');
INSERT INTO content_tags (id, content_id, tag) VALUES (30, 1015, '温度');
INSERT INTO content_tags (id, content_id, tag) VALUES (31, 1016, '仪式');
INSERT INTO content_tags (id, content_id, tag) VALUES (32, 1016, '闹钟');
INSERT INTO content_tags (id, content_id, tag) VALUES (33, 1017, '日光');
INSERT INTO content_tags (id, content_id, tag) VALUES (34, 1017, '咖啡因');
INSERT INTO content_tags (id, content_id, tag) VALUES (35, 1018, '情绪');
INSERT INTO content_tags (id, content_id, tag) VALUES (36, 1018, '环境');
INSERT INTO content_tags (id, content_id, tag) VALUES (37, 1019, '午睡');
INSERT INTO content_tags (id, content_id, tag) VALUES (38, 1019, '出差');
INSERT INTO content_tags (id, content_id, tag) VALUES (39, 1020, '轮班');
INSERT INTO content_tags (id, content_id, tag) VALUES (40, 1020, '拉伸');
INSERT INTO content_tags (id, content_id, tag) VALUES (41, 2001, '运动');
INSERT INTO content_tags (id, content_id, tag) VALUES (42, 2001, '步行');
INSERT INTO content_tags (id, content_id, tag) VALUES (43, 2002, '有氧');
INSERT INTO content_tags (id, content_id, tag) VALUES (44, 2002, '晨练');
INSERT INTO content_tags (id, content_id, tag) VALUES (45, 2003, '拉伸');
INSERT INTO content_tags (id, content_id, tag) VALUES (46, 2003, '办公');
INSERT INTO content_tags (id, content_id, tag) VALUES (47, 2004, '力量');
INSERT INTO content_tags (id, content_id, tag) VALUES (48, 2004, '训练');
INSERT INTO content_tags (id, content_id, tag) VALUES (49, 2005, '瑜伽');
INSERT INTO content_tags (id, content_id, tag) VALUES (50, 2005, '柔韧');
INSERT INTO content_tags (id, content_id, tag) VALUES (51, 2006, '骑行');
INSERT INTO content_tags (id, content_id, tag) VALUES (52, 2006, '微运动');
INSERT INTO content_tags (id, content_id, tag) VALUES (53, 2007, '楼梯');
INSERT INTO content_tags (id, content_id, tag) VALUES (54, 2007, '跳绳');
INSERT INTO content_tags (id, content_id, tag) VALUES (55, 2008, '游泳');
INSERT INTO content_tags (id, content_id, tag) VALUES (56, 2008, '核心');
INSERT INTO content_tags (id, content_id, tag) VALUES (57, 2009, '跑步');
INSERT INTO content_tags (id, content_id, tag) VALUES (58, 2009, '徒步');
INSERT INTO content_tags (id, content_id, tag) VALUES (59, 2010, '居家');
INSERT INTO content_tags (id, content_id, tag) VALUES (60, 2010, '补水');
INSERT INTO content_tags (id, content_id, tag) VALUES (61, 2011, '运动');
INSERT INTO content_tags (id, content_id, tag) VALUES (62, 2011, '步行');
INSERT INTO content_tags (id, content_id, tag) VALUES (63, 2012, '有氧');
INSERT INTO content_tags (id, content_id, tag) VALUES (64, 2012, '晨练');
INSERT INTO content_tags (id, content_id, tag) VALUES (65, 2013, '拉伸');
INSERT INTO content_tags (id, content_id, tag) VALUES (66, 2013, '办公');
INSERT INTO content_tags (id, content_id, tag) VALUES (67, 2014, '力量');
INSERT INTO content_tags (id, content_id, tag) VALUES (68, 2014, '训练');
INSERT INTO content_tags (id, content_id, tag) VALUES (69, 2015, '瑜伽');
INSERT INTO content_tags (id, content_id, tag) VALUES (70, 2015, '柔韧');
INSERT INTO content_tags (id, content_id, tag) VALUES (71, 2016, '骑行');
INSERT INTO content_tags (id, content_id, tag) VALUES (72, 2016, '微运动');
INSERT INTO content_tags (id, content_id, tag) VALUES (73, 2017, '楼梯');
INSERT INTO content_tags (id, content_id, tag) VALUES (74, 2017, '跳绳');
INSERT INTO content_tags (id, content_id, tag) VALUES (75, 2018, '游泳');
INSERT INTO content_tags (id, content_id, tag) VALUES (76, 2018, '核心');
INSERT INTO content_tags (id, content_id, tag) VALUES (77, 2019, '跑步');
INSERT INTO content_tags (id, content_id, tag) VALUES (78, 2019, '徒步');
INSERT INTO content_tags (id, content_id, tag) VALUES (79, 2020, '居家');
INSERT INTO content_tags (id, content_id, tag) VALUES (80, 2020, '补水');
INSERT INTO content_tags (id, content_id, tag) VALUES (81, 3001, '饮食');
INSERT INTO content_tags (id, content_id, tag) VALUES (82, 3001, '营养');
INSERT INTO content_tags (id, content_id, tag) VALUES (83, 3002, '饮水');
INSERT INTO content_tags (id, content_id, tag) VALUES (84, 3002, '早餐');
INSERT INTO content_tags (id, content_id, tag) VALUES (85, 3003, '减糖');
INSERT INTO content_tags (id, content_id, tag) VALUES (86, 3003, '地中海');
INSERT INTO content_tags (id, content_id, tag) VALUES (87, 3004, '蛋白质');
INSERT INTO content_tags (id, content_id, tag) VALUES (88, 3004, '发酵');
INSERT INTO content_tags (id, content_id, tag) VALUES (89, 3005, '肠道');
INSERT INTO content_tags (id, content_id, tag) VALUES (90, 3005, '蔬菜');
INSERT INTO content_tags (id, content_id, tag) VALUES (91, 3006, '全谷物');
INSERT INTO content_tags (id, content_id, tag) VALUES (92, 3006, '零食');
INSERT INTO content_tags (id, content_id, tag) VALUES (93, 3007, '外食');
INSERT INTO content_tags (id, content_id, tag) VALUES (94, 3007, '纤维');
INSERT INTO content_tags (id, content_id, tag) VALUES (95, 3008, 'omega-3');
INSERT INTO content_tags (id, content_id, tag) VALUES (96, 3008, '烹饪');
INSERT INTO content_tags (id, content_id, tag) VALUES (97, 3009, '正念');
INSERT INTO content_tags (id, content_id, tag) VALUES (98, 3009, '分餐');
INSERT INTO content_tags (id, content_id, tag) VALUES (99, 3010, '限盐');
INSERT INTO content_tags (id, content_id, tag) VALUES (100, 3010, '当季');
INSERT INTO content_tags (id, content_id, tag) VALUES (101, 3011, '饮食');
INSERT INTO content_tags (id, content_id, tag) VALUES (102, 3011, '营养');
INSERT INTO content_tags (id, content_id, tag) VALUES (103, 3012, '饮水');
INSERT INTO content_tags (id, content_id, tag) VALUES (104, 3012, '早餐');
INSERT INTO content_tags (id, content_id, tag) VALUES (105, 3013, '减糖');
INSERT INTO content_tags (id, content_id, tag) VALUES (106, 3013, '地中海');
INSERT INTO content_tags (id, content_id, tag) VALUES (107, 3014, '蛋白质');
INSERT INTO content_tags (id, content_id, tag) VALUES (108, 3014, '发酵');
INSERT INTO content_tags (id, content_id, tag) VALUES (109, 3015, '肠道');
INSERT INTO content_tags (id, content_id, tag) VALUES (110, 3015, '蔬菜');
INSERT INTO content_tags (id, content_id, tag) VALUES (111, 3016, '全谷物');
INSERT INTO content_tags (id, content_id, tag) VALUES (112, 3016, '零食');
INSERT INTO content_tags (id, content_id, tag) VALUES (113, 3017, '外食');
INSERT INTO content_tags (id, content_id, tag) VALUES (114, 3017, '纤维');
INSERT INTO content_tags (id, content_id, tag) VALUES (115, 3018, 'omega-3');
INSERT INTO content_tags (id, content_id, tag) VALUES (116, 3018, '烹饪');
INSERT INTO content_tags (id, content_id, tag) VALUES (117, 3019, '正念');
INSERT INTO content_tags (id, content_id, tag) VALUES (118, 3019, '分餐');
INSERT INTO content_tags (id, content_id, tag) VALUES (119, 3020, '限盐');
INSERT INTO content_tags (id, content_id, tag) VALUES (120, 3020, '当季');

COMMIT;
```

---

## 第 5 步：daily_tips（10 条）

```sql
BEGIN;

INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (1, 1001, '今日一知：规律早睡的五个好处', '固定入睡时间有助于调节生物钟，提升第二天的精神状态', '2026-06-13'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (2, 2002, '今日一知：晨间散步如何开启活力一天', '清晨适度活动可以促进血液循环，让身体更快苏醒。', '2026-06-14'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (3, 3003, '今日一知：均衡早餐的重要性', '合理搭配蛋白质、碳水与膳食纤维，为上午提供持续能量。', '2026-06-15'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (4, 1004, '今日一知：午休 20 分钟的小恢复', '短暂午睡能提升下午专注力，但过长反而影响夜间睡眠。', '2026-06-16'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (5, 2005, '今日一知：瑜伽与柔韧性的关系', '规律拉伸与瑜伽练习可改善关节活动度，缓解肌肉紧张。', '2026-06-17'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (6, 3006, '今日一知：蛋白质摄入指南', '足量蛋白质支持肌肉修复、免疫与饱腹感。', '2026-06-18'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (7, 1007, '今日一知：睡前阅读代替刷手机', '纸质书或电子墨水屏的暖光阅读，有助于放松神经。', '2026-06-19'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (8, 2008, '今日一知：爬楼梯代替电梯', '把日常移动变成训练，提升心肺与下肢力量。', '2026-06-20'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (9, 3009, '今日一知：全谷物替换精白主食', '全谷物提供更多纤维与 B 族维生素，血糖反应更平稳。', '2026-06-21'::date, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES (10, 1010, '今日一知：闹钟只响一次就起床', '反复赖床会打乱节律，把闹钟放远是简单有效的一招。', '2026-06-22'::date, '2026-06-22T02:42:11.169Z'::timestamptz);

COMMIT;
```

---

## 第 6 步：home_recommendations（8 条）

```sql
BEGIN;

INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (1, 1001, 1, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (2, 1002, 2, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (3, 1003, 3, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (4, 2001, 4, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (5, 2002, 5, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (6, 2003, 6, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (7, 3001, 7, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES (8, 3002, 8, TRUE, '2026-06-22T02:42:11.169Z'::timestamptz);

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

## 第 8 步：user_favorites（8 条）

```sql
BEGIN;

INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 1001, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 2001, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 3001, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 1003, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 2004, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 3005, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 1006, '2026-06-22T02:42:11.169Z'::timestamptz);
INSERT INTO user_favorites (user_id, content_id, created_at) VALUES ('00000000-0000-0000-0000-000000000001'::uuid, 2007, '2026-06-22T02:42:11.169Z'::timestamptz);

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
| contents | 60 | assets/data/contents.json |
| content_benefit_points | 120 | assets/data/content_benefit_points.json |
| content_tags | 120 | assets/data/content_tags.json |
| daily_tips | 10 | assets/data/daily_tips.json |
| home_recommendations | 8 | assets/data/home_recommendations.json |
| users | 1 | assets/data/users.json |
| user_favorites | 8 | assets/data/user_favorites.json |

> 若表字段与上述 SQL 不一致（如用 `status` 代替 `published`），请按实际表结构调整列名。
