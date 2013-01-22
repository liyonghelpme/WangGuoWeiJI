const LANGUAGE = 0;
var strings = dict([
["building0", ["普通农田", "Farmland
"]],
["building1", ["魔法农田", "Magic Farmland
"]],
["building10", ["普通民居", "House
"]],
["building12", ["高级民居", "Advanced House
"]],
["building100", ["树A", "Tree A
"]],
["building140", ["风车屋", "Windmill
"]],
["building142", ["马车", "Carriage
"]],
["building144", ["魔法水晶", "Magical Crystal
"]],
["building200", ["城堡", "Castle
"]],
["building202", ["神像", "Statue
"]],
["building204", ["药店", "Medicine Shop
"]],
["building206", ["铁匠铺", "Blacksmith
"]],
["building102", ["树B", "Tree B
"]],
["building104", ["树C", "Tree C
"]],
["building106", ["军帐篷", "Army Tent
"]],
["building108", ["凯旋旗", "Flag
"]],
["building110", ["喷泉", "Fountain
"]],
["building112", ["围栏", "Fence
"]],
["building114", ["门柱", "Gatepost
"]],
["building116", ["店铺", "Shop
"]],
["building118", ["椅子", "Bench
"]],
["building120", ["剑靶", "Sword Target
"]],
["building122", ["木桌", "Table
"]],
["building124", ["木桶", "Bucket
"]],
["building128", ["水井", "Well
"]],
["building130", ["伐木场", "Lumber Mill
"]],
["building132", ["箭靶", "Shooting Target
"]],
["building134", ["稻草车", "Hay cart
"]],
["building136", ["灯柱", "Lamp Post
"]],
["building138", ["运木马车", "Lumber Cart
"]],
["building146", ["牛", "Ox
"]],
["building148", ["石头", "Stone
"]],
["building162", ["蜗牛", "Snail
"]],
["building164", ["路牌", "Road Sign
"]],
["building300", ["水晶矿", "Crystal Mine
"]],
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
["building166", ["格斗场", "Coliseum
"]],
["building224", ["兵营", "Army Base
"]],
["building170", ["南瓜灯", "Pumpkin Lantern
"]],
["building172", ["树桩", "Wood Stump
"]],
["building174", ["草墩", "Hay Stack
"]],
["building176", ["稻草人", "Scarecrow
"]],
["building178", ["奶牛", "Cow
"]],
["building168", ["指示牌", "Sign Post
"]],
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
["equip1", ["项链A", "Necklace A
"]],
["equip2", ["项链B", "Necklace B
"]],
["equip3", ["项链C", "Necklace C
"]],
["equip4", ["项链D", "Necklace D
"]],
["equip5", ["靴子A", "Boots A
"]],
["equip6", ["靴子B", "Boots B
"]],
["equip7", ["靴子C", "Boots C
"]],
["equip8", ["镰刀", "Scythe
"]],
["equip9", ["铠甲C", "Armor C
"]],
["equip10", ["铠甲A", "Armor A
"]],
["equip11", ["铠甲B", "Armor B
"]],
["equip12", ["盾牌A", "Shield A
"]],
["equip13", ["盾牌B", "Shield B
"]],
["equip14", ["盾牌C", "Shield C
"]],
["equip15", ["狼牙棒", "Mace
"]],
["equip16", ["火把", "Torch
"]],
["equip17", ["流星锤", "Hammer
"]],
["equip18", ["法杖B", "Mage Staff B
"]],
["equip19", ["法杖A", "Mage Staff A
"]],
["equip20", ["枪", "Spear
"]],
["equip21", ["木棒", "Cudgel
"]],
["equip22", ["斧头", "Axe
"]],
["equip23", ["手套B", "Gloves B
"]],
["equip24", ["手套A", "Gloves A
"]],
["equip25", ["弓箭", "Bow and Arrows
"]],
["equip26", ["头盔A", "Helmet A
"]],
["equip27", ["头盔B", "Helmet B
"]],
["equip28", ["头盔C", "Helmet C
"]],
["equip29", ["大锤", "Sledge Hammer
"]],
["equip30", ["剑", "Sword
"]],
["equip31", ["刀", "Blade
"]],
["equip32", ["戒指A", "Ring A
"]],
["equip33", ["戒指B", "Ring B
"]],
["equip34", ["宝剑A", "Prized Sword A
"]],
["equip35", ["宝剑B", "Prized Sword B
"]],
["equip36", ["弓箭A", "Bow & Arrow A
"]],
["equip37", ["弓箭B", "Bow & Arrow B
"]],
["equip38", ["法袍A", "Robe A
"]],
["equip39", ["法袍B", "Robe B
"]],
["equip40", ["法袍C", "Robe C
"]],
["equip41", ["凤凰戒指", "Phoenix Ring
"]],
["equip42", ["凤凰盾牌", "Phoenix Shield
"]],
["equip43", ["凤凰铠甲", "Phoenix Amor
"]],
["equip44", ["凤凰靴子", "Phoenix Boots
"]],
["equip45", ["凤凰法杖", "Phoenix Staff
"]],
["equip46", ["青龙宝刀", "Dragon Blade
"]],
["equip47", ["青龙戒指", "Dragon Ring
"]],
["equip48", ["青龙盔甲", "Dragon Armor
"]],
["equip49", ["青龙盾牌", "Dragon Shield
"]],
["equip50", ["青龙靴子", "Dragon Boots
"]],
["equip51", ["白虎戒指", "Tiger Ring
"]],
["equip52", ["白虎拳套", "Tiger Knuckles 
"]],
["equip53", ["白虎铠甲", "Tiger Armor
"]],
["equip54", ["白虎盾牌", "Tiger Shield
"]],
["equip55", ["白虎靴子", "Tiger Boots
"]],
["equip56", ["玄武戒指", "Basaltic Ring
"]],
["equip57", ["玄武盔甲", "Basaltic Armor
"]],
["equip58", ["玄武盾牌", "Basaltic Shield
"]],
["equip59", ["玄武靴子", "Basaltic Boots
"]],
["equip60", ["玄武宝剑", "Basaltic Sword
"]],
["equip61", ["神圣头盔", "Sacred Helmet
"]],
["equip62", ["神圣弓箭", "Sacred Bow 
"]],
["equip63", ["神圣靴子", "Sacred Boots
"]],
["equip64", ["神圣护甲", "Sacred Armor
"]],
["equip65", ["神圣戒指", "Sacred Ring
"]],
["equip66", ["爱心法袍", "Robe of Heart
"]],
["equip67", ["爱心戒指", "Ring of Heart
"]],
["equip68", ["爱心魔杖", "Staff of Heart
"]],
["equip69", ["爱心靴子", "Boots of Heart
"]],
["equip70", ["爱心盾牌", "Shield of Heart
"]],
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
["soldier0", ["单手剑士", "Swordsman
"]],
["soldier1", ["单手剑士", "Swordsman
"]],
["soldier2", ["单手剑士", "Swordsman
"]],
["soldier3", ["单手剑士", "Swordsman
"]],
["soldier10", ["吸血鬼", "Vampire
"]],
["soldier11", ["吸血鬼", "Vampire
"]],
["soldier12", ["吸血鬼", "Vampire
"]],
["soldier13", ["吸血鬼", "Vampire
"]],
["soldier20", ["弓箭手", "Archer
"]],
["soldier21", ["弓箭手", "Archer
"]],
["soldier22", ["弓箭手", "Archer
"]],
["soldier23", ["弓箭手", "Archer
"]],
["soldier30", ["大地骑士", "Earth Rider
"]],
["soldier31", ["大地骑士", "Earth Rider
"]],
["soldier32", ["大地骑士", "Earth Rider
"]],
["soldier33", ["大地骑士", "Earth Rider
"]],
["soldier40", ["森林精灵", "Forest Elf
"]],
["soldier41", ["森林精灵", "Forest Elf
"]],
["soldier42", ["森林精灵", "Forest Elf
"]],
["soldier43", ["森林精灵", "Forest Elf
"]],
["soldier50", ["飓风泰坦", "Hurricane Titan
"]],
["soldier51", ["飓风泰坦", "Hurricane Titan
"]],
["soldier52", ["飓风泰坦", "Hurricane Titan
"]],
["soldier53", ["飓风泰坦", "Hurricane Titan
"]],
["soldier60", ["火系魔法师", "Fire Mage
"]],
["soldier61", ["火系魔法师", "Fire Mage
"]],
["soldier62", ["火系魔法师", "Fire Mage
"]],
["soldier63", ["火系魔法师", "Fire Mage
"]],
["soldier70", ["猎龙人", "Dragon Hunter
"]],
["soldier71", ["猎龙人", "Dragon Hunter
"]],
["soldier110", ["人鱼", "Mermaid
"]],
["soldier100", ["森林狼人", "Werewolf
"]],
["soldier80", ["矮人", "Dwarf
"]],
["soldier81", ["矮人", "Dwarf
"]],
["soldier82", ["矮人", "Dwarf
"]],
["soldier83", ["矮人", "Dwarf
"]],
["soldier90", ["智天使", "Cherubim
"]],
["soldier91", ["智天使", "Cherubim
"]],
["soldier92", ["智天使", "Cherubim
"]],
["soldier93", ["智天使", "Cherubim
"]],
["soldier72", ["猎龙人", "Dragon Hunter
"]],
["soldier73", ["猎龙人", "Dragon Hunter
"]],
["soldier120", ["食人魔", "Ogre
"]],
["soldier130", ["小恶魔", "Little Devil
"]],
["soldier140", ["木乃伊", "Mummy
"]],
["soldier150", ["树人", "Treant
"]],
["soldier160", ["石头人", "Stone Giant
"]],
["soldier170", ["邪灵法师", "Necromancer
"]],
["soldier180", ["雪人", "Snow Man
"]],
["soldier190", ["骷髅兵", "Skelesoldier
"]],
["soldier400", ["斧战士", "Axe Soldier
"]],
["soldier401", ["斧战士", "Axe Soldier
"]],
["soldier402", ["斧战士", "Axe Soldier
"]],
["soldier403", ["斧战士", "Axe Soldier
"]],
["soldier410", ["暗精灵", "Dark Elf
"]],
["soldier411", ["暗精灵", "Dark Elf
"]],
["soldier412", ["暗精灵", "Dark Elf
"]],
["soldier413", ["暗精灵", "Dark Elf
"]],
["soldier420", ["堕落天使", "Fallen Angel
"]],
["soldier421", ["堕落天使", "Fallen Angel
"]],
["soldier422", ["堕落天使", "Fallen Angel
"]],
["soldier423", ["堕落天使", "Fallen Angel
"]],
["soldier430", ["魔剑士", "Sword Mage
"]],
["soldier431", ["魔剑士", "Sword Mage
"]],
["soldier432", ["魔剑士", "Sword Mage
"]],
["soldier433", ["魔剑士", "Sword Mage
"]],
["soldier440", ["龙战士", "Dragon Warrior
"]],
["soldier441", ["龙战士", "Dragon Warrior
"]],
["soldier442", ["龙战士", "Dragon Warrior
"]],
["soldier443", ["龙战士", "Dragon Warrior
"]],
["soldier450", ["熔岩泰坦", "Lava Titan
"]],
["soldier451", ["熔岩泰坦", "Lava Titan
"]],
["soldier452", ["熔岩泰坦", "Lava Titan
"]],
["soldier453", ["熔岩泰坦", "Lava Titan
"]],
["soldier460", ["绿巨人", "Green Giant
"]],
["soldier461", ["绿巨人", "Green Giant
"]],
["soldier462", ["绿巨人", "Green Giant
"]],
["soldier463", ["绿巨人", "Green Giant
"]],
["soldier470", ["神圣骑士", "Sacred Knight
"]],
["soldier471", ["神圣骑士", "Sacred Knight
"]],
["soldier472", ["神圣骑士", "Sacred Knight
"]],
["soldier473", ["神圣骑士", "Sacred Knight
"]],
["soldier480", ["德鲁伊", "Druid
"]],
["soldier481", ["德鲁伊", "Druid
"]],
["soldier482", ["德鲁伊", "Druid
"]],
["soldier483", ["德鲁伊", "Druid
"]],
["soldier490", ["水系魔法师", "Water Mage
"]],
["soldier491", ["水系魔法师", "Water Mage
"]],
["soldier492", ["水系魔法师", "Water Mage
"]],
["soldier493", ["水系魔法师", "Water Mage
"]],
["soldier500", ["土系魔法师", "Earth Mage
"]],
["soldier501", ["土系魔法师", "Earth Mage
"]],
["soldier502", ["土系魔法师", "Earth Mage
"]],
["soldier503", ["土系魔法师", "Earth Mage
"]],
["soldier510", ["风系魔法师", "Wind Mage
"]],
["soldier511", ["风系魔法师", "Wind Mage
"]],
["soldier512", ["风系魔法师", "Wind Mage
"]],
["soldier513", ["风系魔法师", "Wind Mage
"]],
["soldier520", ["雷系魔法师", "Thunder Mage
"]],
["soldier521", ["雷系魔法师", "Thunder Mage
"]],
["soldier522", ["雷系魔法师", "Thunder Mage
"]],
["soldier523", ["雷系魔法师", "Thunder Mage
"]],
["soldier530", ["巫师", "Sorcerer
"]],
["soldier531", ["巫师", "Sorcerer
"]],
["soldier532", ["巫师", "Sorcerer
"]],
["soldier533", ["巫师", "Sorcerer
"]],
["soldier540", ["赛亚人", "Saiyan
"]],
["soldier541", ["赛亚人", "Saiyan
"]],
["soldier542", ["赛亚人", "Saiyan
"]],
["soldier543", ["赛亚人", "Saiyan
"]],
["soldier550", ["火精灵", "Fire Fairy
"]],
["soldier551", ["火精灵", "Fire Fairy
"]],
["soldier552", ["火精灵", "Fire Fairy
"]],
["soldier553", ["火精灵", "Fire Fairy
"]],
["soldier560", ["火枪地精", "Musket Goblin
"]],
["soldier561", ["火枪地精", "Musket Goblin
"]],
["soldier562", ["火枪地精", "Musket Goblin
"]],
["soldier563", ["火枪地精", "Musket Goblin
"]],
["soldier570", ["幻影射手", "Phantom Archer
"]],
["soldier571", ["幻影射手", "Phantom Archer
"]],
["soldier572", ["幻影射手", "Phantom Archer
"]],
["soldier573", ["幻影射手", "Phantom Archer
"]],
["soldier580", ["火箭地精", "Rocket Goblin
"]],
["soldier581", ["火箭地精", "Rocket Goblin
"]],
["soldier582", ["火箭地精", "Rocket Goblin
"]],
["soldier583", ["火箭地精", "Rocket Goblin
"]],
["soldier590", ["凤凰战士", "Phoenix Warrior
"]],
["soldier591", ["凤凰战士", "Phoenix Warrior
"]],
["soldier592", ["凤凰战士", "Phoenix Warrior
"]],
["soldier593", ["凤凰战士", "Phoenix Warrior
"]],
["soldier1010", ["强盗", "Robber
"]],
["soldier1020", ["兽人", "Beast Man
"]],
["soldier1030", ["森林魅影", "Forest Phantom
"]],
["soldier1040", ["森林蜘蛛", "Forest Spider
"]],
["soldier1050", ["森林巨兽", "Forest Beast
"]],
["soldier1060", ["半人马", "Centaur
"]],
["soldier1070", ["金刚", "King Kong
"]],
["soldier1080", ["哥布林", "Goblin
"]],
["soldier1090", ["土匪", "Bandit
"]],
["soldier1100", ["猫女", "Cat Girl
"]],
["soldier1110", ["土匪头子", "Bandit Leader
"]],
["soldier1120", ["牛头人", "Tauren
"]],
["soldier1130", ["翼人", "Harpy
"]],
["soldier1140", ["平原霸王龙", "Plain T-Rex
"]],
["soldier1150", ["水系钢铁人", "Aquatic Ironman
"]],
["soldier1160", ["水系巨兽", "Aquatic Beast
"]],
["soldier1170", ["黑袍射手", "Robe Archer
"]],
["soldier1180", ["水系霸王龙", "Aquatic T-Rex
"]],
["soldier1190", ["水系钢铁王", "Aquatic Iron King
"]],
["soldier1200", ["恶魔", "Demon
"]],
["soldier1210", ["西斯", "Sith
"]],
["soldier1220", ["水系魅影", "Aquatic Phantom
"]],
["soldier1230", ["西方邪恶龙", "Evil Dragon
"]],
["soldier1240", ["洞穴霸王龙", "Cave T-Rex
"]],
["soldier1250", ["洞穴蜘蛛", "Cave Spider
"]],
["soldier1260", ["洞穴狼人", "Cave Werewolf
"]],
["soldier1270", ["洞穴巨兽", "Cave Monster
"]],
["soldier1280", ["洞穴钢铁人", "Cave Ironman
"]],
["soldier1290", ["洞穴钢铁王", "Cave Iron King
"]],
["soldier1300", ["骷髅将军", "Skelegeneral 
"]],
["soldier1310", ["暗夜魔王", "Night Stalker
"]],
["soldier1320", ["地狱三头犬", "Cerberus 
"]],
["soldier1330", ["雪山蜘蛛", "Snow Spider
"]],
["soldier1340", ["雪山狼人", "Snow Werewolf
"]],
["soldier1350", ["雪山猿人", "Snow Ape
"]],
["soldier1360", ["钢铁侠", "Iron Man
"]],
["soldier1370", ["雪山魅影", "Snow Phantom
"]],
["soldier1380", ["黑暗魔君", "Dark Lord
"]],
["soldier444", ["龙", "Dragon
"]],
["soldier484", ["大地之熊", "Earth Bear
"]],
["soldier594", ["凤凰", "Phoenix
"]],
["soldier554", ["火之灵", "Fire Spirit
"]],
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
["title25", "前往拯救公主"],
["title27", "新手任务完成"],
["title28", "收获农作物"],
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
["title75", "挑战排行榜其它用户"],
["title76", "任务标题"],
["title77", "任务标题"],
["title78", "任务标题"],
["title79", "任务标题"],
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
["des27", "恭喜你完成了新手任务"],
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
["des75", "挑战排行榜玩家"],
["des76", "任务描述"],
["des77", "任务描述"],
["des78", "任务描述"],
["des79", "任务描述"],
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
["skills2", ["刀气", "Bladekee
"]],
["skills3", ["单个火焰", "Single Flame
"]],
["skills4", ["火焰雨", "Flame Shower
"]],
["skills5", ["蓝色闪电", "Blue Lightening
"]],
["skills6", ["单个流星", "Single Meteor
"]],
["skills7", ["流星雨", "Meteor Shower
"]],
["skills8", ["眩晕", "Dizzy
"]],
["skills9", ["拯救", "0"]],
["skills10", ["补血", "Healing
"]],
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