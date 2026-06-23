#!/usr/bin/env python3
"""Generate assets/data/*.json and 文档/数据库种子SQL.md from shared seed definitions."""
from __future__ import annotations

import json
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "assets" / "data"
DOC_PATH = ROOT / "文档" / "数据库种子SQL.md"
BASE = "2026-06-22T02:42:11.169Z"
DEMO_USER = "00000000-0000-0000-0000-000000000001"
ITEMS_PER_CATEGORY = 20

# (id, code, name, description, icon, color, sort_order)
CATEGORIES_DATA = [
    (1, "lifestyle", "作息", "睡眠、早起、规律作息等生活方式科普", "bedtime_outlined", "#5B8DEF", 1),
    (2, "exercise", "运动", "有氧、拉伸、力量训练等运动科普", "directions_run_outlined", "#3D8B7A", 2),
    (3, "diet", "饮食", "早餐、饮水、营养搭配等饮食科普", "restaurant_outlined", "#F2A65A", 3),
]

CATEGORY_CODE_TO_ID = {code: cid for cid, code, *_ in CATEGORIES_DATA}

# 已验证可访问的 Unsplash 图片（HEAD 200）
VERIFIED_PHOTOS = [
    "photo-1631049307264-da0ec9d70304",
    "photo-1506905925346-21bda4d32df4",
    "photo-1618005182384-a83a8bd57fbe",
    "photo-1586023492125-27b2c045efd7",
    "photo-1498050108023-c5249f4df085",
    "photo-1522771739844-6a9f6d5f14af",
    "photo-1505693416388-ac5ce068fe85",
    "photo-1560448204-e02f11c3d0e2",
    "photo-1506126613408-eca07ce68773",
    "photo-1706542762554-d9abc1334f4b",
    "photo-1716324836235-23ebe115ae1c",
    "photo-1441974231531-c6227db76b6e",
    "photo-1416879595882-3373a0480b5b",
    "photo-1518611012118-696072aa579a",
    "photo-1534438327276-14e5300c3a48",
    "photo-1544367567-0f2fcb009e0b",
    "photo-1558618666-fcd25c85cd64",
    "photo-1522071820081-009f0129c71c",
    "photo-1571019614242-c5c5dee9f50b",
    "photo-1512621776951-a57141f2eefd",
    "photo-1523362628745-0c100150b504",
    "photo-1490645935967-10de6ba17061",
    "photo-1551024506-0bccd828d307",
    "photo-1540189549336-e6e99c3679fe",
    "photo-1546069901-ba9599a7e63c",
    "photo-1563805042-7684c019e1cb",
    "photo-1498837167922-ddd27525d352",
    "photo-1504674900247-0877df9cc836",
    "photo-1556656793-08538906a9f8",
    "photo-1517836357463-d25dfeac3438",
    "photo-1556910103-1c02745aae4d",
    "photo-1508804185872-d7badad00f7d",
    "photo-1540575467063-178a50c2df87",
    "photo-1565299624946-b28f40a0ae38",
    "photo-1555939594-58d7cb561ad1",
    "photo-1571019613454-1cb2f99b2d8b",
    "photo-1574680096145-d05b474e2155",
]

# (local_id, title, summary, body)
LIFESTYLE_CONTENTS = [
    (1, "规律早睡的五个好处", "固定入睡时间有助于调节生物钟，提升第二天的精神状态",
     "## 为什么建议早睡?\n\n保持 **22:30 前入睡** 有助于身体进入修复状态。\n\n- 减少熬夜带来的内分泌紊乱\n- 降低焦虑与情绪波动"),
    (2, "固定起床时间的力量", "即使周末也尽量保持相近的起床时刻，生物钟会更稳定。",
     "## 固定起床\n\n尝试将起床时间波动控制在 **30 分钟以内**，减少「社交时差」。"),
    (3, "减少睡前屏幕时间", "蓝光会抑制褪黑素分泌，影响入睡速度与睡眠质量。",
     "## 睡前习惯\n\n睡前 **1 小时** 远离手机与电脑。"),
    (4, "午休 20 分钟的小恢复", "短暂午睡能提升下午专注力，但过长反而影响夜间睡眠。",
     "## 午休建议\n\n控制在 **20 分钟** 以内。"),
    (5, "数字断舍离与睡眠", "减少睡前信息过载，有助于大脑切换到休息模式。",
     "## 实践方法\n\n设置手机「睡眠模式」，充电位置在卧室外。"),
    (6, "周末也不报复性熬夜", "周末作息大幅偏移会加重周一疲劳，尽量与平日接近。",
     "## 周末作息\n\n起床时间比平日延迟不超过 **1 小时**。"),
    (7, "睡前阅读代替刷手机", "纸质书或电子墨水屏的暖光阅读，有助于放松神经。",
     "## 阅读建议\n\n选择轻松内容，**15～20 分钟** 即可。"),
    (8, "卧室温度与睡眠品质", "略偏凉的睡眠环境通常更利于深度睡眠。",
     "## 温度参考\n\n夏季 **24～26℃**，冬季 **18～22℃** 因人而异。"),
    (9, "建立睡前仪式", "固定顺序的小习惯会向大脑发送「该休息了」的信号。",
     "## 仪式示例\n\n洗漱 → 拉伸 → 调暗灯光 → 阅读。"),
    (10, "闹钟只响一次就起床", "反复赖床会打乱节律，把闹钟放远是简单有效的一招。",
     "## 小技巧\n\n起床后立即接触 **自然光** 或开灯。"),
    (11, "白天多接触自然光", "充足日照有助于调节褪黑素节律，改善夜间入睡。",
     "## 行动建议\n\n上午户外 **10～15 分钟**，阴天也有效。"),
    (12, "咖啡因截止时间的讲究", "下午过晚摄入咖啡因可能拖晚入睡时间。",
     "## 参考\n\n尽量在 **14:00 前** 完成最后一次咖啡或浓茶。"),
    (13, "情绪日记与减压", "写下当日烦恼可减少睡前反刍，降低入睡难度。",
     "## 写法\n\n3 分钟列出 **1 件感恩 + 1 件可改进**。"),
    (14, "保持卧室昏暗安静", "遮光窗帘与降低噪音能显著提升睡眠连续性。",
     "## 环境优化\n\n必要时使用耳塞或白噪音。"),
    (15, "午睡不影响夜间睡眠", "午睡过长或太晚可能挤占夜间困意。",
     "## 建议\n\n**13:00～15:00** 之间，不超过 20 分钟。"),
    (16, "出差时的作息调整", "跨时区或旅途疲劳时，仍尽量固定入睡窗口。",
     "## 策略\n\n抵达后先适应 **当地光照**，再调整用餐时间。"),
    (17, "轮班族的睡眠策略", "不规则排班更需保护连续睡眠块与黑暗环境。",
     "## 要点\n\n下班途中戴墨镜，回家先 **1 小时无屏**。"),
    (18, "渐进式提前入睡", "一次性大幅提前容易失败，每天提前 15 分钟更可持续。",
     "## 计划\n\n连续 **4～7 天** 微调，直到目标就寝点。"),
    (19, "睡前轻柔拉伸", "颈肩与背部的温和拉伸可缓解日间紧张。",
     "## 动作\n\n每侧拉伸 **20 秒**，避免大幅弹跳。"),
    (20, "感恩日记与入睡", "积极回顾一天能缓解焦虑，让大脑更容易进入休息。",
     "## 练习\n\n写下 **3 件** 今日小确幸即可。"),
]

EXERCISE_CONTENTS = [
    (1, "每天步行 30 分钟的变化", "适度运动能显著改善心肺功能，降低慢性病风险。",
     "## 步行的好处\n\n每天步行 **30 分钟** 可以显著改善心血管健康。"),
    (2, "晨间散步如何开启活力一天", "清晨适度活动可以促进血液循环，让身体更快苏醒。",
     "## 晨间散步建议\n\n每天 **15～30 分钟** 即可，不必追求强度。"),
    (3, "午后拉伸缓解久坐疲劳", "简短拉伸能放松颈肩腰背，改善久坐带来的僵硬感。",
     "## 办公拉伸\n\n每工作 **45 分钟** 起身活动 3 分钟。"),
    (4, "力量训练入门益处", "适度抗阻训练有助于增加肌肉量、改善代谢与骨密度。",
     "## 入门提示\n\n从自重训练开始，每周 **2-3 次**。"),
    (5, "瑜伽与柔韧性的关系", "规律拉伸与瑜伽练习可改善关节活动度，缓解肌肉紧张。",
     "## 练习建议\n\n每周 **2 次** 15 分钟基础拉伸。"),
    (6, "骑自行车通勤", "骑行是低冲击有氧方式，适合作为日常通勤或休闲运动。",
     "## 安全提示\n\n佩戴头盔，检查车况，注意交通规则。"),
    (7, "办公室微运动", "利用碎片时间做深蹲、提踵等，累积活动量。",
     "## 微运动示例\n\n每小时 **1 分钟**：深蹲 10 次 + 提踵 15 次。"),
    (8, "爬楼梯代替电梯", "把日常移动变成训练，提升心肺与下肢力量。",
     "## 起步\n\n先 **2～3 层** 开始，逐步增加。"),
    (9, "跳绳燃脂入门", "跳绳对场地要求小，适合作为短时高效有氧。",
     "## 入门\n\n每次 **3～5 分钟** 分组完成，注意落地缓冲。"),
    (10, "游泳低冲击有氧", "水的浮力减轻关节负担，适合多数人群。",
     "## 频率\n\n每周 **2 次**，每次 **30 分钟** 左右。"),
    (11, "核心稳定训练", "强化腹背深层肌肉，改善体态并支撑日常动作。",
     "## 基础动作\n\n死虫、鸟狗、侧桥，各 **30 秒 × 3 组**。"),
    (12, "跑步呼吸节奏", "稳定呼吸能减少侧 stitch，提升跑步舒适度。",
     "## 节奏\n\n尝试 **3 步吸气、3 步呼气** 起步。"),
    (13, "运动后拉伸恢复", "训练后静态拉伸有助于缓解延迟性酸痛。",
     "## 时机\n\n训练结束后 **5～10 分钟**，每个部位 30 秒。"),
    (14, "周末徒步计划", "户外徒步结合有氧与放松，适合家庭或朋友同行。",
     "## 准备\n\n穿防滑鞋，带水与简餐，从 **5 km 内** 路线开始。"),
    (15, "平板支撑进阶", "从膝盖着地版本开始，逐步延长核心耐力。",
     "## 目标\n\n保持 **20～40 秒** 标准姿势，优先质量。"),
    (16, "弹力带居家训练", "阻力带占用空间小，适合在家做上肢与臀部训练。",
     "## 组合\n\n深蹲、划船、侧走，各 **12～15 次 × 2 组**。"),
    (17, "散步会议新习惯", "边走边聊可打破久坐，同时完成轻度活动。",
     "## 场景\n\n电话会议或一对一沟通，选 **平坦路线**。"),
    (18, "平衡训练防跌倒", "单脚站立等练习可提升本体感觉与稳定性。",
     "## 练习\n\n扶墙单脚站 **20 秒**，左右各 3 组。"),
    (19, "热身 5 分钟法则", "充分热身可提升表现并降低运动损伤风险。",
     "## 内容\n\n关节环绕 + 慢跑原地 + 动态拉伸。"),
    (20, "运动前后补水", "及时补水维持体温调节与运动表现。",
     "## 提示\n\n运动前 **200 ml**，过程中少量多次。"),
]

DIET_CONTENTS = [
    (1, "均衡饮食如何改变身体状态", "合理搭配蛋白质、碳水与蔬果，让身体获得稳定能量。",
     "## 均衡饮食\n\n每餐包含优质蛋白，多吃蔬菜水果，控制精加工食品。"),
    (2, "每天喝够水的小技巧", "充足饮水有助于代谢、皮肤状态与精力维持。",
     "## 饮水建议\n\n建议每天 **1500-2000 ml**，分次饮用。"),
    (3, "均衡早餐的重要性", "合理搭配蛋白质、碳水与膳食纤维，为上午提供持续能量。",
     "## 早餐搭配\n\n- 优质蛋白：鸡蛋、牛奶\n- 复合碳水：燕麦、全麦面食"),
    (4, "控制添加糖摄入", "过多添加糖与代谢风险相关，减少含糖饮料是有效第一步。",
     "## 减糖技巧\n\n优先选择原味食物，阅读营养标签。"),
    (5, "地中海饮食要点", "以橄榄油、全谷物、鱼类和大量蔬菜为特色的饮食模式。",
     "## 核心原则\n\n多吃蔬果、全谷物、优质脂肪，适量鱼类。"),
    (6, "蛋白质摄入指南", "足量蛋白质支持肌肉修复、免疫与饱腹感。",
     "## 参考量\n\n可按 **体重 kg × 1.0～1.2 g** 估算每日需求。"),
    (7, "发酵食品与肠道健康", "酸奶、泡菜等发酵食品含益生菌，有助于维持肠道菌群平衡。",
     "## 选择建议\n\n优先低糖发酵乳，注意冷藏条件。"),
    (8, "深色蔬菜摄入目标", "深绿与橙黄蔬菜富含叶酸、β-胡萝卜素与钾。",
     "## 目标\n\n每餐至少 **1/2 盘** 蔬菜，深浅色搭配。"),
    (9, "全谷物替换精白主食", "全谷物提供更多纤维与 B 族维生素，血糖反应更平稳。",
     "## 替换\n\n白米饭 → 糙米饭；白面包 → 全麦面包。"),
    (10, "健康零食选择", "两餐之间可选坚果、酸奶或水果，避免空热量。",
     "## 份量\n\n坚果 **一小把（约 20 g）** 即可。"),
    (11, "外食少油少盐", "餐厅菜品往往油盐偏高，主动要求调整更容易坚持。",
     "## 技巧\n\n选蒸、煮、烤，酱汁 **另放**。"),
    (12, "膳食纤维每日目标", "足量纤维支持肠道蠕动与饱腹感。",
     "## 参考\n\n成人每天 **25～30 g**，逐步增加并多喝水。"),
    (13, "omega-3 来源", "深海鱼、亚麻籽等是常见 omega-3 来源。",
     "## 建议\n\n每周 **2 次** 鱼类，其中一次为富含脂肪的鱼。"),
    (14, "烹饪方式影响热量", "同样食材，蒸煮比油炸显著减少额外脂肪。",
     "## 优先\n\n蒸、煮、炖、快炒少油。"),
    (15, "正念饮食练习", "放慢速度、专注味觉，有助于识别饱腹信号。",
     "## 练习\n\n每口咀嚼 **15～20 次**，放下餐具再下口。"),
    (16, "分餐盘法控制份量", "用盘子分区估算比例，比严格称重更易坚持。",
     "## 比例\n\n蔬菜 **1/2**，蛋白 **1/4**，主食 **1/4**。"),
    (17, "限盐与血压", "减少钠摄入有助于控制血压与水肿。",
     "## 行动\n\n少用酱油与加工食品，用香辛料提味。"),
    (18, "钙质与骨骼", "奶类、豆制品与深绿蔬菜是常见钙来源。",
     "## 提示\n\n配合 **维生素 D** 与适度负重运动。"),
    (19, "铁元素补充", "红肉、动物肝与豆类有助于预防缺铁性疲劳。",
     "## 搭配\n\n与 **维生素 C** 同食可提高植物铁吸收。"),
    (20, "季节性本地食材", "当季蔬果营养与风味更佳，也减少运输成本。",
     "## 建议\n\n每周逛一次本地市场，尝试 **1 种新食材**。"),
]

CONTENTS_BY_CATEGORY = {
    "lifestyle": LIFESTYLE_CONTENTS,
    "exercise": EXERCISE_CONTENTS,
    "diet": DIET_CONTENTS,
}

CUSTOM_POINTS = {
    ("lifestyle", 1): [("改善睡眠质量", "规律作息帮助大脑建立稳定的睡眠节律", "sleep"),
                       ("提升专注力", "充足睡眠后注意力与记忆力明显增强", "focus")],
    ("exercise", 1): [("改善心肺功能", "持续步行有助于增强心血管系统效率", "walk"),
                      ("控制体重", "每日适度活动有助于维持健康体重", "balance")],
    ("diet", 1): [("稳定能量供应", "均衡营养避免血糖大幅波动", "energy"),
                  ("支持长期健康", "多样化饮食提供全面营养素", "nutrition")],
}

DEFAULT_POINTS = [
    ("改善状态", "坚持习惯后整体精力与情绪更稳定", "energy"),
    ("易于坚持", "从低门槛开始，更容易形成长期习惯", "balance"),
]

TAGS_BY_CATEGORY = {
    "lifestyle": ["睡眠", "作息", "早起", "生物钟", "屏幕", "恢复", "数字", "周末", "阅读", "温度",
                    "仪式", "闹钟", "日光", "咖啡因", "情绪", "环境", "午睡", "出差", "轮班", "拉伸"],
    "exercise": ["运动", "步行", "有氧", "晨练", "拉伸", "办公", "力量", "训练", "瑜伽", "柔韧",
                 "骑行", "微运动", "楼梯", "跳绳", "游泳", "核心", "跑步", "徒步", "居家", "补水"],
    "diet": ["饮食", "营养", "饮水", "早餐", "减糖", "地中海", "蛋白质", "发酵", "肠道", "蔬菜",
             "全谷物", "零食", "外食", "纤维", "omega-3", "烹饪", "正念", "分餐", "限盐", "当季"],
}

# (category_code, local_id)
TIP_CONTENT_REFS = [
    ("lifestyle", 1), ("exercise", 2), ("diet", 3), ("lifestyle", 4), ("exercise", 5),
    ("diet", 6), ("lifestyle", 7), ("exercise", 8), ("diet", 9), ("lifestyle", 10),
]

REC_CONTENT_REFS = [
    ("lifestyle", i) for i in range(1, 4)
] + [("exercise", i) for i in range(1, 4)
] + [("diet", i) for i in range(1, 3)]

FAV_CONTENT_REFS = [
    ("lifestyle", 1), ("exercise", 1), ("diet", 1),
    ("lifestyle", 3), ("exercise", 4), ("diet", 5),
    ("lifestyle", 6), ("exercise", 7),
]


def _unsplash(photo_id: str) -> str:
    return (
        f"https://images.unsplash.com/{photo_id}"
        "?auto=format&fit=crop&w=800&h=450&q=80"
    )


def cover_url_for(category_code: str, local_id: int) -> str:
    cat_index = {"lifestyle": 0, "exercise": 1, "diet": 2}[category_code]
    offset = cat_index * 7 + local_id - 1
    photo = VERIFIED_PHOTOS[offset % len(VERIFIED_PHOTOS)]
    return _unsplash(photo)


def sql_str(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def global_content_id(category_id: int, local_id: int) -> int:
    return category_id * 1000 + local_id


def ref_to_global_id(category_code: str, local_id: int) -> int:
    return global_content_id(CATEGORY_CODE_TO_ID[category_code], local_id)


def iter_contents():
    for cat_code, rows in CONTENTS_BY_CATEGORY.items():
        cat_id = CATEGORY_CODE_TO_ID[cat_code]
        for local_id, title, summary, body in rows:
            yield cat_code, cat_id, local_id, title, summary, body


def tags_for(category_code: str, local_id: int) -> list[str]:
    pool = TAGS_BY_CATEGORY[category_code]
    i = (local_id - 1) * 2
    return [pool[i % len(pool)], pool[(i + 1) % len(pool)]]


def verify_cover_urls(contents: list) -> None:
    failed = []
    for item in contents:
        url = item["cover_url"]
        try:
            req = urllib.request.Request(
                url, method="HEAD", headers={"User-Agent": "Mozilla/5.0"},
            )
            with urllib.request.urlopen(req, timeout=15) as resp:
                if resp.status != 200:
                    failed.append((item["id"], url, resp.status))
        except Exception as exc:
            failed.append((item["id"], url, str(exc)[:60]))
    if failed:
        details = "\n".join(f"  id={cid}: {err}" for cid, _, err in failed)
        raise RuntimeError(f"{len(failed)} cover URL(s) failed verification:\n{details}")


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
    for cat_code, cat_id, local_id, title, summary, body in iter_contents():
        contents.append({
            "id": global_content_id(cat_id, local_id),
            "category_id": cat_id,
            "title": title,
            "summary": summary,
            "cover_url": cover_url_for(cat_code, local_id),
            "body": body,
            "published": True,
            "sort_order": local_id,
            "created_at": BASE,
            "updated_at": f"2026-06-{(10 + local_id % 10):02d}T08:00:00.000Z",
        })

    verify_cover_urls(contents)

    points = []
    pid = 1
    for cat_code, cat_id, local_id, *_ in iter_contents():
        content_id = global_content_id(cat_id, local_id)
        point_rows = CUSTOM_POINTS.get((cat_code, local_id), DEFAULT_POINTS)
        for j, (ptitle, desc, icon) in enumerate(point_rows, 1):
            points.append({
                "id": pid, "content_id": content_id, "title": ptitle,
                "description": desc, "icon": icon, "sort_order": j,
            })
            pid += 1

    tags = []
    tid = 1
    for cat_code, cat_id, local_id, *_ in iter_contents():
        content_id = global_content_id(cat_id, local_id)
        for tag in tags_for(cat_code, local_id):
            tags.append({"id": tid, "content_id": content_id, "tag": tag})
            tid += 1

    content_by_id = {c["id"]: c for c in contents}

    tips = []
    for i, (cat_code, local_id) in enumerate(TIP_CONTENT_REFS, 1):
        content_id = ref_to_global_id(cat_code, local_id)
        c = content_by_id[content_id]
        tips.append({
            "id": i,
            "content_id": content_id,
            "title": f"今日一知：{c['title'][:14]}",
            "summary": c["summary"],
            "tip_date": f"2026-06-{12 + i:02d}",
            "created_at": BASE,
        })

    recs = []
    for i, (cat_code, local_id) in enumerate(REC_CONTENT_REFS, 1):
        recs.append({
            "id": i,
            "content_id": ref_to_global_id(cat_code, local_id),
            "sort_order": i,
            "published": True,
            "created_at": BASE,
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
        {
            "user_id": DEMO_USER,
            "content_id": ref_to_global_id(cat_code, local_id),
            "created_at": BASE,
        }
        for cat_code, local_id in FAV_CONTENT_REFS
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

    lines.extend([
        "", "COMMIT;", "```", "", "---", "",
        f"## 第 2 步：contents（{len(contents)} 条）", "", "```sql", "BEGIN;", "",
    ])

    for c in contents:
        lines.append(
            f"INSERT INTO contents (id, category_id, title, summary, cover_url, body, published, sort_order, created_at, updated_at) VALUES "
            f"({c['id']}, {c['category_id']}, {sql_str(c['title'])}, {sql_str(c['summary'])}, "
            f"{sql_str(c['cover_url'])}, {sql_str(c['body'])}, TRUE, {c['sort_order']}, "
            f"{sql_str(c['created_at'])}::timestamptz, {sql_str(c['updated_at'])}::timestamptz);"
        )

    lines.extend([
        "", "COMMIT;", "```", "", "---", "",
        f"## 第 3 步：content_benefit_points（{len(points)} 条）", "", "```sql", "BEGIN;", "",
    ])

    for p in points:
        icon = sql_str(p["icon"]) if p["icon"] else "NULL"
        lines.append(
            f"INSERT INTO content_benefit_points (id, content_id, title, description, icon, sort_order) VALUES "
            f"({p['id']}, {p['content_id']}, {sql_str(p['title'])}, {sql_str(p['description'])}, {icon}, {p['sort_order']});"
        )

    lines.extend([
        "", "COMMIT;", "```", "", "---", "",
        f"## 第 4 步：content_tags（{len(tags)} 条）", "", "```sql", "BEGIN;", "",
    ])

    for t in tags:
        lines.append(
            f"INSERT INTO content_tags (id, content_id, tag) VALUES "
            f"({t['id']}, {t['content_id']}, {sql_str(t['tag'])});"
        )

    lines.extend([
        "", "COMMIT;", "```", "", "---", "",
        f"## 第 5 步：daily_tips（{len(tips)} 条）", "", "```sql", "BEGIN;", "",
    ])

    for tip in tips:
        lines.append(
            f"INSERT INTO daily_tips (id, content_id, title, summary, tip_date, created_at) VALUES "
            f"({tip['id']}, {tip['content_id']}, {sql_str(tip['title'])}, {sql_str(tip['summary'])}, "
            f"{sql_str(tip['tip_date'])}::date, {sql_str(tip['created_at'])}::timestamptz);"
        )

    lines.extend([
        "", "COMMIT;", "```", "", "---", "",
        f"## 第 6 步：home_recommendations（{len(recs)} 条）", "", "```sql", "BEGIN;", "",
    ])

    for r in recs:
        lines.append(
            f"INSERT INTO home_recommendations (id, content_id, sort_order, published, created_at) VALUES "
            f"({r['id']}, {r['content_id']}, {r['sort_order']}, TRUE, {sql_str(r['created_at'])}::timestamptz);"
        )

    lines.extend([
        "", "COMMIT;", "```", "", "---", "",
        f"## 第 7 步：users（{len(users)} 条）", "", "```sql", "BEGIN;", "",
    ])

    for u in users:
        lines.append(
            f"INSERT INTO users (id, email, password_hash, nickname, is_active, created_at, updated_at) VALUES "
            f"({sql_str(u['id'])}::uuid, {sql_str(u['email'])}, {sql_str(u['password_hash'])}, "
            f"{sql_str(u['nickname'])}, TRUE, {sql_str(u['created_at'])}::timestamptz, {sql_str(u['updated_at'])}::timestamptz);"
        )

    lines.extend([
        "", "COMMIT;", "```", "", "---", "",
        f"## 第 8 步：user_favorites（{len(favs)} 条）", "", "```sql", "BEGIN;", "",
    ])

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
    per_cat = len(contents) // len(categories)
    print(f"Generated {len(categories)} categories, {len(contents)} contents ({per_cat} per category)")
    print(f"  points={len(points)}, tags={len(tags)}, tips={len(tips)}, recs={len(recs)}, favs={len(favs)}")
    print(f"  All {len(contents)} cover URLs verified OK")
    print(f"SQL doc: {DOC_PATH}")


if __name__ == "__main__":
    main()
