const LANGUAGE = 0;
var strings = dict([
["building0", ["普通农田", ""]],
["building1", ["魔法农田", ""]],
["building10", ["普通民居", ""]],
["building12", ["高级民居", ""]],
["building100", ["树A", ""]],
["building140", ["风车屋", ""]],
["building142", ["马车", ""]],
["building144", ["魔法水晶", ""]],
["building200", ["城堡", ""]],
["building202", ["神像", ""]],
["building204", ["药店", ""]],
["building206", ["铁匠铺", ""]],
["building102", ["树B", ""]],
["building104", ["树C", ""]],
["building106", ["军帐篷", ""]],
["building108", ["凯旋旗", ""]],
["building110", ["喷泉", ""]],
["building112", ["围栏", ""]],
["building114", ["门柱", ""]],
["building116", ["店铺", ""]],
["building118", ["椅子", ""]],
["building120", ["剑靶", ""]],
["building122", ["木桌", ""]],
["building124", ["木桶", ""]],
["building128", ["水井", ""]],
["building130", ["伐木场", ""]],
["building132", ["箭靶", ""]],
["building134", ["稻草车", ""]],
["building136", ["灯柱", ""]],
["building138", ["运木马车", ""]],
["building146", ["牛", ""]],
["building148", ["石头", ""]],
["building162", ["蜗牛", ""]],
["building164", ["路牌", ""]],
["building300", ["水晶矿", ""]],
["building208", ["爱心树", ""]],
["building209", ["爱心树", ""]],
["building210", ["爱心树", ""]],
["building211", ["爱心树", ""]],
["building212", ["爱心树", ""]],
["building213", ["爱心树", ""]],
["building214", ["爱心树", ""]],
["building215", ["爱心树", ""]],
["building216", ["爱心树", ""]],
["building217", ["爱心树", ""]],
["building218", ["爱心树", ""]],
["building219", ["爱心树", ""]],
["building220", ["爱心树", ""]],
["building221", ["爱心树", ""]],
["building222", ["爱心树", ""]],
["building166", ["格斗场", "Ring Fighting"]],
["building224", ["兵营", ""]],
["building170", ["南瓜灯", ""]],
["building172", ["树桩", ""]],
["building174", ["草墩", ""]],
["building176", ["稻草人", ""]],
["building178", ["奶牛", ""]],
["building168", ["指示牌", ""]],
["crystal0", ["10000 水晶", ""]],
["crystal1", ["100000 水晶", ""]],
["crystal2", ["1000000 水晶", ""]],
["drug1", ["单个火焰", ""]],
["drug4", ["单个流星", ""]],
["drug10", ["眩晕(玄武)", ""]],
["drug13", ["刀气(白虎)", ""]],
["drug21", ["治疗(爱心)", ""]],
["drug24", ["蓝色闪电(神圣)", ""]],
["drug31", ["火焰雨", ""]],
["drug34", ["流星雨", ""]],
["drugDes1", ""],
["drugDes4", ""],
["drugDes10", ""],
["drugDes13", ""],
["drugDes21", ""],
["drugDes24", ""],
["drugDes31", ""],
["drugDes34", ""],
["equip1", ["项链A", ""]],
["equip2", ["项链B", ""]],
["equip3", ["项链C", ""]],
["equip4", ["项链D", ""]],
["equip5", ["靴子A", ""]],
["equip6", ["靴子B", ""]],
["equip7", ["靴子C", ""]],
["equip8", ["镰刀", ""]],
["equip9", ["铠甲C", ""]],
["equip10", ["铠甲A", ""]],
["equip11", ["铠甲B", ""]],
["equip12", ["盾牌A", ""]],
["equip13", ["盾牌B", ""]],
["equip14", ["盾牌C", ""]],
["equip15", ["狼牙棒", ""]],
["equip16", ["火把", ""]],
["equip17", ["流星锤", ""]],
["equip18", ["法杖B", ""]],
["equip19", ["法杖A", ""]],
["equip20", ["枪", ""]],
["equip21", ["木棒", ""]],
["equip22", ["斧头", ""]],
["equip23", ["手套B", ""]],
["equip24", ["手套A", ""]],
["equip25", ["弓箭", ""]],
["equip26", ["头盔A", ""]],
["equip27", ["头盔B", ""]],
["equip28", ["头盔C", ""]],
["equip29", ["大锤", ""]],
["equip30", ["剑", ""]],
["equip31", ["刀", ""]],
["equip32", ["戒指A", ""]],
["equip33", ["戒指B", ""]],
["equip34", ["宝剑A", ""]],
["equip35", ["宝剑B", ""]],
["equip36", ["弓箭A", ""]],
["equip37", ["弓箭B", ""]],
["equip38", ["法袍A", ""]],
["equip39", ["法袍B", ""]],
["equip40", ["法袍C", ""]],
["equip41", ["凤凰戒指", ""]],
["equip42", ["凤凰盾牌", ""]],
["equip43", ["凤凰铠甲", ""]],
["equip44", ["凤凰靴子", ""]],
["equip45", ["凤凰法杖", ""]],
["equip46", ["青龙宝刀", ""]],
["equip47", ["青龙戒指", ""]],
["equip48", ["青龙盔甲", ""]],
["equip49", ["青龙盾牌", ""]],
["equip50", ["青龙靴子", ""]],
["equip51", ["白虎戒指", ""]],
["equip52", ["白虎拳套", ""]],
["equip53", ["白虎铠甲", ""]],
["equip54", ["白虎盾牌", ""]],
["equip55", ["白虎靴子", ""]],
["equip56", ["玄武戒指", ""]],
["equip57", ["玄武盔甲", ""]],
["equip58", ["玄武盾牌", ""]],
["equip59", ["玄武靴子", ""]],
["equip60", ["玄武宝剑", ""]],
["equip61", ["神圣头盔", ""]],
["equip62", ["神圣弓箭", ""]],
["equip63", ["神圣靴子", ""]],
["equip64", ["神圣护甲", ""]],
["equip65", ["神圣戒指", ""]],
["equip66", ["爱心法袍", ""]],
["equip67", ["爱心戒指", ""]],
["equip68", ["爱心魔杖", ""]],
["equip69", ["爱心靴子", ""]],
["equip70", ["爱心盾牌", ""]],
["equipDes1", ""],
["equipDes2", ""],
["equipDes3", ""],
["equipDes4", ""],
["equipDes5", ""],
["equipDes6", ""],
["equipDes7", ""],
["equipDes8", ""],
["equipDes9", ""],
["equipDes10", ""],
["equipDes11", ""],
["equipDes12", ""],
["equipDes13", ""],
["equipDes14", ""],
["equipDes15", ""],
["equipDes16", ""],
["equipDes17", ""],
["equipDes18", ""],
["equipDes19", ""],
["equipDes20", ""],
["equipDes21", ""],
["equipDes22", ""],
["equipDes23", ""],
["equipDes24", ""],
["equipDes25", ""],
["equipDes26", ""],
["equipDes27", ""],
["equipDes28", ""],
["equipDes29", ""],
["equipDes30", ""],
["equipDes31", ""],
["equipDes32", ""],
["equipDes33", ""],
["equipDes34", ""],
["equipDes35", ""],
["equipDes36", ""],
["equipDes37", ""],
["equipDes38", ""],
["equipDes39", ""],
["equipDes40", ""],
["equipDes41", ""],
["equipDes42", ""],
["equipDes43", ""],
["equipDes44", ""],
["equipDes45", ""],
["equipDes46", ""],
["equipDes47", ""],
["equipDes48", ""],
["equipDes49", ""],
["equipDes50", ""],
["equipDes51", ""],
["equipDes52", ""],
["equipDes53", ""],
["equipDes54", ""],
["equipDes55", ""],
["equipDes56", ""],
["equipDes57", ""],
["equipDes58", ""],
["equipDes59", ""],
["equipDes60", ""],
["equipDes61", ""],
["equipDes62", ""],
["equipDes63", ""],
["equipDes64", ""],
["equipDes65", ""],
["equipDes66", ""],
["equipDes67", ""],
["equipDes68", ""],
["equipDes69", ""],
["equipDes70", ""],
["fallThing0", "草莓"],
["fallThing1", "苹果"],
["fallThing2", "西瓜"],
["fallThing3", "樱桃"],
["fallThing4", "香蕉"],
["fallThing5", "三明治"],
["fallThing6", "披萨"],
["fallThing7", "棒棒糖"],
["fallThing8", "甜筒"],
["fallThing9", "糖果"],
["fallThing10", ""],
["fallThing11", ""],
["fallThing12", ""],
["fallThing13", ""],
["fallThing14", ""],
["gold0", ["500 金币", ""]],
["gold1", ["1200 金币", ""]],
["gold2", ["2500 金币", ""]],
["gold3", ["6500 金币", ""]],
["gold4", ["14000 金币", ""]],
["herb0", ["冬刺草", ""]],
["herb1", ["地根草", ""]],
["herb2", ["墓地苔", ""]],
["herb3", ["太阳草", ""]],
["herb4", ["宁神花", ""]],
["herb5", ["幽灵菇", ""]],
["herb6", ["枯叶草", ""]],
["herb7", ["梦叶草", ""]],
["herb8", ["活根草", ""]],
["herb9", ["火焰花", ""]],
["herb10", ["血皇草", ""]],
["herb11", ["盲目草", ""]],
["herb12", ["石南草", ""]],
["herb13", ["紫莲花", ""]],
["herb14", ["荆棘藻", ""]],
["herb15", ["跌打草", ""]],
["herb16", ["野钢花", ""]],
["herb17", ["金棘草", ""]],
["herb18", ["银叶草", ""]],
["herb112", ["", ""]],
["herb111", ["", ""]],
["herb110", ["", ""]],
["herb100", ["奥利哈康", ""]],
["herb101", ["秘银矿", ""]],
["herb102", ["金矿", ""]],
["herb103", ["钴蓝矿", ""]],
["herb104", ["铁矿", ""]],
["herb105", ["铜矿", ""]],
["herb106", ["银矿", ""]],
["herb107", ["魔晃结晶", ""]],
["herb108", ["魔晶石", ""]],
["herb109", ["黑铁矿", ""]],
["herb113", ["", ""]],
["herb114", ["", ""]],
["herb115", ["", ""]],
["herb116", ["", ""]],
["herb117", ["", ""]],
["herb118", ["", ""]],
["herb119", ["", ""]],
["herb120", ["", ""]],
["herbDes0", "herb desc"],
["herbDes1", "herb desc"],
["herbDes2", "herb desc"],
["herbDes3", "herb desc"],
["herbDes4", "herb desc"],
["herbDes5", "herb desc"],
["herbDes6", "herb desc"],
["herbDes7", "herb desc"],
["herbDes8", "herb desc"],
["herbDes9", "herb desc"],
["herbDes10", "herb desc"],
["herbDes11", "herb desc"],
["herbDes12", "herb desc"],
["herbDes13", "herb desc"],
["herbDes14", "herb desc"],
["herbDes15", "herb desc"],
["herbDes16", "herb desc"],
["herbDes17", "herb desc"],
["herbDes18", "herb desc"],
["herbDes112", "herb desc"],
["herbDes111", "herb desc"],
["herbDes110", "herb desc"],
["herbDes100", "herb desc"],
["herbDes101", "herb desc"],
["herbDes102", "herb desc"],
["herbDes103", "herb desc"],
["herbDes104", "herb desc"],
["herbDes105", "herb desc"],
["herbDes106", "herb desc"],
["herbDes107", "herb desc"],
["herbDes108", "herb desc"],
["herbDes109", "herb desc"],
["herbDes113", "herb desc"],
["herbDes114", "herb desc"],
["herbDes115", "herb desc"],
["herbDes116", "herb desc"],
["herbDes117", "herb desc"],
["herbDes118", "herb desc"],
["herbDes119", "herb desc"],
["herbDes120", "herb desc"],
["plant0", ["小麦", "Wheat"]],
["plant1", ["胡萝卜", "Carrot"]],
["plant2", ["西红柿", "Tomato"]],
["plant3", ["土豆", "Potato"]],
["plant4", ["南瓜", "Pumpkin"]],
["plant5", ["玉米", "Corn"]],
["plant6", ["青椒", "Green Pepper"]],
["plant7", ["洋葱", "Onion"]],
["plant8", ["白萝卜", "White Turnip"]],
["plant9", ["咖啡豆", "Coffee"]],
["plant10", ["桃子", "Peach"]],
["plant11", ["樱桃", "Cherry"]],
["plant12", ["火龙果", "Pitaya"]],
["plant13", ["红辣椒", "Red Pepper"]],
["plant14", ["草莓", "Strawberry"]],
["plant15", ["菠萝", "Pineapple"]],
["plant16", ["葡萄", "Grape"]],
["plant17", ["蓝莓", "Blueberry"]],
["plant18", ["西瓜", "Watermelon"]],
["plant19", ["香蕉", "Banana"]],
["silver0", ["10000 银币", ""]],
["silver1", ["100000 银币", ""]],
["silver2", ["1000000 银币", ""]],
["soldier0", ["单手剑士", ""]],
["soldier1", ["单手剑士", ""]],
["soldier2", ["单手剑士", ""]],
["soldier3", ["单手剑士", ""]],
["soldier10", ["吸血鬼", ""]],
["soldier11", ["吸血鬼", ""]],
["soldier12", ["吸血鬼", ""]],
["soldier13", ["吸血鬼", ""]],
["soldier20", ["弓箭手", ""]],
["soldier21", ["弓箭手", ""]],
["soldier22", ["弓箭手", ""]],
["soldier23", ["弓箭手", ""]],
["soldier30", ["大地骑士", ""]],
["soldier31", ["大地骑士", ""]],
["soldier32", ["大地骑士", ""]],
["soldier33", ["大地骑士", ""]],
["soldier40", ["森林精灵", ""]],
["soldier41", ["森林精灵", ""]],
["soldier42", ["森林精灵", ""]],
["soldier43", ["森林精灵", ""]],
["soldier50", ["飓风泰坦", ""]],
["soldier51", ["飓风泰坦", ""]],
["soldier52", ["飓风泰坦", ""]],
["soldier53", ["飓风泰坦", ""]],
["soldier60", ["火系魔法师", ""]],
["soldier61", ["火系魔法师", ""]],
["soldier62", ["火系魔法师", ""]],
["soldier63", ["火系魔法师", ""]],
["soldier70", ["猎龙人", ""]],
["soldier71", ["猎龙人", ""]],
["soldier110", ["人鱼", ""]],
["soldier100", ["森林狼人", ""]],
["soldier80", ["矮人", ""]],
["soldier81", ["矮人", ""]],
["soldier82", ["矮人", ""]],
["soldier83", ["矮人", ""]],
["soldier90", ["智天使", ""]],
["soldier91", ["智天使", ""]],
["soldier92", ["智天使", ""]],
["soldier93", ["智天使", ""]],
["soldier72", ["猎龙人", ""]],
["soldier73", ["猎龙人", ""]],
["soldier120", ["食人魔", ""]],
["soldier130", ["小恶魔", ""]],
["soldier140", ["木乃伊", ""]],
["soldier150", ["树人", ""]],
["soldier160", ["石头人", ""]],
["soldier170", ["邪灵法师", ""]],
["soldier180", ["雪人", ""]],
["soldier190", ["骷髅兵", ""]],
["soldier400", ["斧战士", ""]],
["soldier401", ["斧战士", ""]],
["soldier402", ["斧战士", ""]],
["soldier403", ["斧战士", ""]],
["soldier410", ["暗精灵", ""]],
["soldier411", ["暗精灵", ""]],
["soldier412", ["暗精灵", ""]],
["soldier413", ["暗精灵", ""]],
["soldier420", ["堕落天使", ""]],
["soldier421", ["堕落天使", ""]],
["soldier422", ["堕落天使", ""]],
["soldier423", ["堕落天使", ""]],
["soldier430", ["魔剑士", ""]],
["soldier431", ["魔剑士", ""]],
["soldier432", ["魔剑士", ""]],
["soldier433", ["魔剑士", ""]],
["soldier440", ["龙骑士", ""]],
["soldier441", ["龙骑士", ""]],
["soldier442", ["龙骑士", ""]],
["soldier443", ["龙骑士", ""]],
["soldier450", ["熔岩泰坦", ""]],
["soldier451", ["熔岩泰坦", ""]],
["soldier452", ["熔岩泰坦", ""]],
["soldier453", ["熔岩泰坦", ""]],
["soldier460", ["绿巨人", ""]],
["soldier461", ["绿巨人", ""]],
["soldier462", ["绿巨人", ""]],
["soldier463", ["绿巨人", ""]],
["soldier470", ["神圣骑士", ""]],
["soldier471", ["神圣骑士", ""]],
["soldier472", ["神圣骑士", ""]],
["soldier473", ["神圣骑士", ""]],
["soldier480", ["德鲁伊", ""]],
["soldier481", ["德鲁伊", ""]],
["soldier482", ["德鲁伊", ""]],
["soldier483", ["德鲁伊", ""]],
["soldier490", ["水系魔法师", ""]],
["soldier491", ["水系魔法师", ""]],
["soldier492", ["水系魔法师", ""]],
["soldier493", ["水系魔法师", ""]],
["soldier500", ["土系魔法师", ""]],
["soldier501", ["土系魔法师", ""]],
["soldier502", ["土系魔法师", ""]],
["soldier503", ["土系魔法师", ""]],
["soldier510", ["风系魔法师", ""]],
["soldier511", ["风系魔法师", ""]],
["soldier512", ["风系魔法师", ""]],
["soldier513", ["风系魔法师", ""]],
["soldier520", ["雷系魔法师", ""]],
["soldier521", ["雷系魔法师", ""]],
["soldier522", ["雷系魔法师", ""]],
["soldier523", ["雷系魔法师", ""]],
["soldier530", ["巫师", ""]],
["soldier531", ["巫师", ""]],
["soldier532", ["巫师", ""]],
["soldier533", ["巫师", ""]],
["soldier540", ["赛亚人", ""]],
["soldier541", ["赛亚人", ""]],
["soldier542", ["赛亚人", ""]],
["soldier543", ["赛亚人", ""]],
["soldier550", ["火精灵", ""]],
["soldier551", ["火精灵", ""]],
["soldier552", ["火精灵", ""]],
["soldier553", ["火精灵", ""]],
["soldier560", ["火枪地精", ""]],
["soldier561", ["火枪地精", ""]],
["soldier562", ["火枪地精", ""]],
["soldier563", ["火枪地精", ""]],
["soldier570", ["幻影射手", ""]],
["soldier571", ["幻影射手", ""]],
["soldier572", ["幻影射手", ""]],
["soldier573", ["幻影射手", ""]],
["soldier580", ["火箭地精", ""]],
["soldier581", ["火箭地精", ""]],
["soldier582", ["火箭地精", ""]],
["soldier583", ["火箭地精", ""]],
["soldier590", ["凤凰骑士", ""]],
["soldier591", ["凤凰骑士", ""]],
["soldier592", ["凤凰骑士", ""]],
["soldier593", ["凤凰骑士", ""]],
["soldier1010", ["强盗", ""]],
["soldier1020", ["兽人", ""]],
["soldier1030", ["森林魅影", ""]],
["soldier1040", ["森林蜘蛛", ""]],
["soldier1050", ["森林巨兽", ""]],
["soldier1060", ["半人马", ""]],
["soldier1070", ["金刚", ""]],
["soldier1080", ["哥布林", ""]],
["soldier1090", ["土匪", ""]],
["soldier1100", ["猫女", ""]],
["soldier1110", ["土匪头子", ""]],
["soldier1120", ["牛头人", ""]],
["soldier1130", ["翼人", ""]],
["soldier1140", ["平原霸王龙", ""]],
["soldier1150", ["水系钢铁人", ""]],
["soldier1160", ["水系巨兽", ""]],
["soldier1170", ["黑袍射手", ""]],
["soldier1180", ["水系霸王龙", ""]],
["soldier1190", ["水系钢铁王", ""]],
["soldier1200", ["恶魔", ""]],
["soldier1210", ["西斯", ""]],
["soldier1220", ["水系魅影", ""]],
["soldier1230", ["西方邪恶龙", ""]],
["soldier1240", ["洞穴霸王龙", ""]],
["soldier1250", ["洞穴蜘蛛", ""]],
["soldier1260", ["洞穴狼人", ""]],
["soldier1270", ["洞穴巨兽", ""]],
["soldier1280", ["洞穴钢铁人", ""]],
["soldier1290", ["洞穴钢铁王", ""]],
["soldier1300", ["骷髅将军", ""]],
["soldier1310", ["暗夜魔王", ""]],
["soldier1320", ["地狱三头犬", ""]],
["soldier1330", ["雪山蜘蛛", ""]],
["soldier1340", ["雪山狼人", ""]],
["soldier1350", ["雪山猿人", ""]],
["soldier1360", ["钢铁侠", ""]],
["soldier1370", ["雪山魅影", ""]],
["soldier1380", ["黑暗魔君", ""]],
["soldier444", ["龙骑士", ""]],
["soldier484", ["大地之熊", ""]],
["soldier594", ["凤凰", ""]],
["soldier554", ["火精灵", ""]],
["soldier-2", ["城墙", ""]],
["title0", "购买[NAME]"],
["title1", "登录天数"],
["title2", "捡掉落物品"],
["title4", "消除士兵状态"],
["title7", "打开宝箱"],
["title8", "种植农作物"],
["title9", "闯关"],
["title10", "练级"],
["title11", "邻居挑战"],
["title12", "排行榜挑战"],
["title13", "擂台挑战"],
["title14", "守擂"],
["title15", "锻造装备"],
["title16", "炼制药水"],
["title17", "捡掉落物品"],
["title18", "清除士兵状态"],
["title19", "赠送邻居爱心"],
["title20", "消除好友士兵状态"],
["title21", "赠送邻居礼物"],
["title22", "帮助好友开宝箱"],
["title24", "招募士兵"],
["title25", "闯关拯救公主"],
["title27", "新手任务第一阶段"],
["title28", "种植收获农作物"],
["title74", "收获水晶矿"],
["title29", "捡起掉落物品"],
["title30", "清除士兵状态"],
["title31", "完成第二阶段任务"],
["title34", "查看任务对话框"],
["title35", "访问邻居"],
["title36", "清除邻居士兵状态"],
["title37", "开启邻居宝箱"],
["title38", "赠送邻居爱心"],
["title39", "发起邻居请求"],
["title40", "邀请好友"],
["title41", "查看消息"],
["title42", "请求好友打开宝箱"],
["title43", "获取宝箱奖励"],
["title44", "完成第三阶段任务"],
["title45", "购买农田"],
["title46", "购买兵营"],
["title47", "购买民居"],
["title48", "购买经验装饰"],
["title49", "完成第四阶段任务"],
["title50", "购买药加血药水"],
["title51", "士兵练级"],
["title52", "购买装备"],
["title53", "升级装备"],
["title54", "挑战"],
["title55", "购买防御装饰"],
["title56", "购买技能"],
["title57", "升级技能"],
["title58", "完成第五阶段任务"],
["title59", "新手任务第一阶段开始"],
["title60", "新手任务第二阶段开始"],
["title61", "招募士兵"],
["title62", "水晶矿收获"],
["title63", "农作物收获"],
["title64", "等级提升"],
["title65", "士兵数量"],
["title66", "好友士兵状态"],
["title67", "士兵转职"],
["title68", "赠送礼物"],
["title69", "杀死敌人数量"],
["title70", "挑战胜利次数"],
["title71", "掠夺银币"],
["title72", "掠夺水晶"],
["title73", "闯关星星数"],
["des0", "购买 魔法求 宝石 建筑物 装备 药水 招募 各种初级士兵  种植 各种农作物"],
["des1", "总共登录[NUM]天"],
["des2", "捡起[NUM]个掉落物品"],
["des4", "消除[NUM]个士兵状态"],
["des7", "打开[NUM]个宝箱"],
["des8", "农作物是银币和经验的重要来源!"],
["des9", "召集勇士，赶快救出公主吧！"],
["des10", "练级可以帮助士兵快速升级，让他们变得更强大！"],
["des11", "挑战邻居成功可以获得他们水晶矿中的水晶哦！"],
["des12", "挑战比自己排名高的玩家可以获得大量水晶奖励哦！"],
["des13", "挑战擂主是获得金币和水晶的重要来源哦！"],
["des14", "摆擂台守擂是获得金币和水晶的重要来源哦！"],
["des15", "杀怪获得的材料能锻造成各种武器装备"],
["des16", "杀怪获得的材料能炼制成各种药水！"],
["des17", "天上会经常掉一些物品下来，点击它们将会有奖励哦！"],
["des18", "点击士兵状态会有各种有意思的小游戏哦！"],
["des19", "你可以赠送邻居免费爱心，这样Ta也会赠送给你哦！"],
["des20", "帮助邻居消除士兵状态，互帮互助！"],
["des21", "点击某个邻居，你可以赠送礼物给Ta，互帮互助哦！"],
["des22", "进入好友页面，你可以帮助Ta打开宝箱，互帮互助哦！"],
["des24", "快去兵营招募一个士兵吧!"],
["des25", "点击地图，去拯救公主吧！公主还在索伦手中！"],
["des27", "任务描述"],
["des28", "点击农田种植农作物。种植农作物可以获得大量银币和经验哦！"],
["des74", "收获水晶矿"],
["des29", "天上会掉下特殊物品！捡起这些物品能够获得额外奖励！"],
["des30", "点击士兵可以玩各种小游戏哦！还能获得额外奖励！"],
["des31", "任务描述"],
["des34", "任务描述"],
["des35", "任务描述"],
["des36", "任务描述"],
["des37", "任务描述"],
["des38", "任务描述"],
["des39", "任务描述"],
["des40", "任务描述"],
["des41", "任务描述"],
["des42", "任务描述"],
["des43", "任务描述"],
["des44", "任务描述"],
["des45", "任务描述"],
["des46", "任务描述"],
["des47", "任务描述"],
["des48", "任务描述"],
["des49", "任务描述"],
["des50", "任务描述"],
["des51", "任务描述"],
["des52", "任务描述"],
["des53", "任务描述"],
["des54", "任务描述"],
["des55", "任务描述"],
["des56", "任务描述"],
["des57", "任务描述"],
["des58", "任务描述"],
["des59", "任务描述"],
["des60", "任务描述"],
["des61", "从兵营中招募士兵[NAME]"],
["des62", "从水晶矿收获[NUM]水晶"],
["des63", "收获[NUM]个银币"],
["des64", "升到第[NUM]级"],
["des65", "招募[NUM]个士兵"],
["des66", "消除好友[NUM]个士兵状态"],
["des67", "转职[NUM]个士兵"],
["des68", "赠送好友[NUM]个礼物"],
["des69", "杀死[NUM]个敌人"],
["des70", "挑战胜利[NUM]次"],
["des71", "掠夺[NUM]个银币"],
["des72", "掠夺[NUM]个水晶"],
["des73", "获取[NUM]颗闯关星星"],
["goodsList0", ["红宝石", "redTreasureStone"]],
["goodsList1", ["绿宝石", ""]],
["goodsList2", ["蓝宝石", ""]],
["goodsList3", ["紫宝石", ""]],
["goodsListDes0", ""],
["goodsListDes1", ""],
["goodsListDes2", ""],
["goodsListDes3", ""],
["magicStone0", ["橙色魔法球", ""]],
["magicStone1", ["黄色魔法球", ""]],
["magicStone2", ["绿色魔法球", ""]],
["magicStone3", ["蓝色魔法球", ""]],
["magicStoneDes0", ""],
["magicStoneDes1", ""],
["magicStoneDes2", ""],
["magicStoneDes3", ""],
["skills0", ["红色冲击波", "0"]],
["skills1", ["蓝色冲击波", "0"]],
["skills2", ["刀气", "0"]],
["skills3", ["火焰球", "0"]],
["skills4", ["火焰雨", "0"]],
["skills5", ["闪电", "0"]],
["skills6", ["流星", "0"]],
["skills7", ["流星雨", "0"]],
["skills8", ["眩晕", "0"]],
["skills9", ["拯救", "0"]],
["skills10", ["单体治疗", "0"]],
["skills11", ["群体治疗", "0"]],
["skills12", ["龙变身", "0"]],
["skills13", ["火人变身", "0"]],
["skills14", ["熊变身", "0"]],
["skills15", ["凤凰变身", "0"]],
["skills16", ["使用药品", ""]],
["skillsDes0", ""],
["skillsDes1", ""],
["skillsDes2", ""],
["skillsDes3", ""],
["skillsDes4", ""],
["skillsDes5", ""],
["skillsDes6", ""],
["skillsDes7", ""],
["skillsDes8", ""],
["skillsDes9", ""],
["skillsDes10", ""],
["skillsDes11", ""],
["skillsDes12", ""],
["skillsDes13", ""],
["skillsDes14", ""],
["skillsDes15", ""],
["skillsDes16", ""],
["StoreAttWordspeople", "人口上限+[NUM]"],
["StoreAttWordscityDefense", "村庄防御力+[NUM]"],
["StoreAttWordsattack", "攻击力+[NUM]"],
["StoreAttWordsdefense", "防御力+[NUM]"],
["StoreAttWordsexp", "经验+[NUM]"],
["StoreAttWordsphysicAttack", "物理攻击+[NUM]"],
["StoreAttWordsphysicDefense", "物理防御+[NUM]"],
["StoreAttWordsmagicAttack", "魔法攻击+[NUM]"],
["StoreAttWordsmagicDefense", "魔法防御+[NUM]"],
["StoreAttWordspercentAttack", "攻击+[NUM]%"],
["StoreAttWordspercentDefense", "防御+[NUM]%"],
["StoreAttWordshealthBoundary", "生命值上限 +[NUM]"],
["StoreAttWordspercentHealthBoundary", "生命值上限 +[NUM]%"],
["StoreAttWordspercentHealth", "生命值+[NUM]"],
]);