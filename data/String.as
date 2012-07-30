const LANGUAGE = 0; //0 chinese 1 english
var strings = dict([
[ "building0" , "普通农田" ],
[ "building1" , "魔法农田" ],
[ "building10" , "普通民居" ],
[ "building12" , "高级民居" ],
[ "building100" , "树" ],
[ "building140" , "风车" ],
[ "building142" , "马车" ],
[ "building144" , "魔法水晶" ],
[ "building200" , "城堡" ],
[ "building202" , "神像" ],
[ "building204" , "药店" ],
[ "building206" , "铁匠铺" ],
[ "building102" , "树2" ],
[ "building104" , "树3" ],
[ "building106" , "军帐篷" ],
[ "building108" , "军旗" ],
[ "building110" , "喷泉" ],
[ "building112" , "围栏" ],
[ "building114" , "围栏门口" ],
[ "building116" , "店铺" ],
[ "building118" , "木凳" ],
[ "building120" , "剑靶" ],
[ "building122" , "木桌" ],
[ "building124" , "木水桶" ],
[ "building126" , "木牌" ],
[ "building128" , "水井" ],
[ "building130" , "伐木场" ],
[ "building132" , "箭靶" ],
[ "building134" , "草堆车" ],
[ "building136" , "路灯" ],
[ "building138" , "运木马车" ],
[ "building146" , "牛" ],
[ "building148" , "石块" ],
[ "building150" , "花丛1" ],
[ "building152" , "花丛2" ],
[ "building154" , "花丛3" ],
[ "building156" , "草丛1" ],
[ "building158" , "草丛2" ],
[ "building160" , "草丛3" ],
[ "building162" , "蜗牛" ],
[ "building164" , "路牌" ],
[ "crystal0" , "10 水晶" ],
[ "crystal1" , "50 水晶" ],
[ "crystal2" , "100 水晶" ],
[ "drug0" , "生命药水" ],
[ "drug1" , "攻击药水" ],
[ "drug2" , "复活药水" ],
[ "drug3" , "经验药水" ],
[ "drug4" , "防御药水" ],
[ "drug10" , "普通生命药水" ],
[ "drug11" , "普通攻击药水" ],
[ "drug12" , "普通复活药水" ],
[ "drug13" , "普通经验药水" ],
[ "drug14" , "普通防御药水" ],
[ "drug20" , "特效生命药水" ],
[ "drug21" , "特效攻击药水" ],
[ "drug22" , "特效复活药水" ],
[ "drug23" , "特效经验药水" ],
[ "drug24" , "特效防御药水" ],
[ "drug30" , "神效生命药水" ],
[ "drug31" , "神效攻击药水" ],
[ "drug32" , "神效复活药水" ],
[ "drug33" , "神效经验药水" ],
[ "drug34" , "神效防御药水" ],
[ "equip0" , "刀" ],
[ "equip1" , "剑" ],
[ "equip2" , "铁钩" ],
[ "equip3" , "铁锤" ],
[ "equip4" , "头盔" ],
[ "equip5" , "弓箭" ],
[ "equip6" , "戒指" ],
[ "equip7" , "护腕" ],
[ "equip8" , "护膝" ],
[ "equip9" , "斧头" ],
[ "equip10" , "木棒" ],
[ "equip11" , "长枪" ],
[ "equip12" , "流星锤" ],
[ "equip13" , "火把" ],
[ "equip14" , "狼牙棒" ],
[ "equip15" , "盾牌" ],
[ "equip16" , "铠甲" ],
[ "equip17" , "镰刀" ],
[ "equip18" , "鞋" ],
[ "equip19" , "项链" ],
[ "equip20" , "弩" ],
[ "equip21" , "魔法棒" ],
[ "equip22" , "神圣头盔" ],
[ "equip23" , "圣剑" ],
[ "equip24" , "神圣弓箭" ],
[ "equip25" , "神圣戒指" ],
[ "equip26" , "神圣护甲" ],
[ "equip27" , "神圣法袍" ],
[ "equip28" , "神圣盔甲" ],
[ "equip29" , "神圣靴子" ],
[ "equip30" , "神圣魔杖" ],
[ "equip31" , "神圣魔法书" ],
[ "equip33" , "剑普通" ],
[ "equip34" , "剑精致" ],
[ "equip35" , "头盔普通" ],
[ "equip36" , "头盔精致" ],
[ "equip37" , "弓箭普通" ],
[ "equip38" , "弓箭精致" ],
[ "equip39" , "戒指普通" ],
[ "equip40" , "戒指精致" ],
[ "equip42" , "普通手套" ],
[ "equip43" , "精致手套" ],
[ "equip44" , "水晶球1" ],
[ "equip45" , "水晶球2" ],
[ "equip46" , "水晶球3" ],
[ "equip47" , "水晶球4" ],
[ "equip48" , "水晶球5" ],
[ "equip49" , "普通法杖" ],
[ "equip50" , "精致法杖" ],
[ "equip51" , "法袍" ],
[ "equip52" , "普通法袍" ],
[ "equip53" , "精致法袍" ],
[ "equip54" , "普通盾牌" ],
[ "equip55" , "精致盾牌" ],
[ "equip56" , "普通铠甲" ],
[ "equip57" , "精致铠甲" ],
[ "equip58" , "普通靴子" ],
[ "equip59" , "精致靴子" ],
[ "equip60" , "普通项链" ],
[ "equip61" , "精致项链" ],
[ "equip62" , "黄金项链" ],
[ "equip32" , "神圣头盔" ],
[ "equip41" , "手套" ],
[ "gold0" , "10 金币" ],
[ "gold1" , "60 金币" ],
[ "gold2" , "125 金币" ],
[ "gold3" , "275 金币" ],
[ "gold4" , "600 金币" ],
[ "gold5" , "1600 金币" ],
[ "herb0" , "冬刺草" ],
[ "herb1" , "地根草" ],
[ "herb2" , "墓地苔" ],
[ "herb3" , "太阳草" ],
[ "herb4" , "宁神花" ],
[ "herb5" , "幽灵菇" ],
[ "herb6" , "枯叶草" ],
[ "herb7" , "梦叶草" ],
[ "herb8" , "活根草" ],
[ "herb9" , "火焰花" ],
[ "herb10" , "血皇草" ],
[ "herb11" , "盲目草" ],
[ "herb12" , "石南草" ],
[ "herb13" , "紫莲花" ],
[ "herb14" , "荆棘藻" ],
[ "herb15" , "跌打草" ],
[ "herb16" , "野钢花" ],
[ "herb17" , "金棘草" ],
[ "herb18" , "银叶草" ],
[ "herb19" , "雨燕草" ],
[ "herb20" , "魔皇草" ],
[ "herb21" , "黄金参" ],
[ "herb100" , "奥利哈康" ],
[ "herb101" , "秘银矿" ],
[ "herb102" , "金矿" ],
[ "herb103" , "钴蓝矿" ],
[ "herb104" , "铁矿" ],
[ "herb105" , "铜矿" ],
[ "herb106" , "银矿" ],
[ "herb107" , "魔晃结晶" ],
[ "herb108" , "魔晶石" ],
[ "herb109" , "黑铁矿" ],
[ "herbDes0" , "herb desc" ],
[ "herbDes1" , "herb desc" ],
[ "herbDes2" , "herb desc" ],
[ "herbDes3" , "herb desc" ],
[ "herbDes4" , "herb desc" ],
[ "herbDes5" , "herb desc" ],
[ "herbDes6" , "herb desc" ],
[ "herbDes7" , "herb desc" ],
[ "herbDes8" , "herb desc" ],
[ "herbDes9" , "herb desc" ],
[ "herbDes10" , "herb desc" ],
[ "herbDes11" , "herb desc" ],
[ "herbDes12" , "herb desc" ],
[ "herbDes13" , "herb desc" ],
[ "herbDes14" , "herb desc" ],
[ "herbDes15" , "herb desc" ],
[ "herbDes16" , "herb desc" ],
[ "herbDes17" , "herb desc" ],
[ "herbDes18" , "herb desc" ],
[ "herbDes19" , "herb desc" ],
[ "herbDes20" , "herb desc" ],
[ "herbDes21" , "herb desc" ],
[ "herbDes100" , "herb desc" ],
[ "herbDes101" , "herb desc" ],
[ "herbDes102" , "herb desc" ],
[ "herbDes103" , "herb desc" ],
[ "herbDes104" , "herb desc" ],
[ "herbDes105" , "herb desc" ],
[ "herbDes106" , "herb desc" ],
[ "herbDes107" , "herb desc" ],
[ "herbDes108" , "herb desc" ],
[ "herbDes109" , "herb desc" ],


[ "plant0" , ["小麦", "Wheat"]],
[ "plant1" , ["胡萝卜", "Carrot"]],
[ "plant2" , ["西红柿", "Tomato"]],
[ "plant3" , ["土豆", "Potato"]],
[ "plant4" , ["南瓜", "Pumpkin"]],
[ "plant5" , ["玉米", "Corn"]],
[ "plant6" , ["青椒", "Green Pepper"]],
[ "plant7" , ["洋葱", "Onion"]],
[ "plant8" , ["白萝卜", "White Turnip"]],
[ "plant9" , ["咖啡豆", "Coffee"]],
[ "plant10" , ["桃子", "Peach"]],
[ "plant11" , ["樱桃", "Cherry"]],
[ "plant12" , ["火龙果", "Pitaya"]],
[ "plant13" , ["红辣椒", "Red Pepper"]],
[ "plant14" , ["草莓", "Strawberry"]],
[ "plant15" , ["菠萝", "Pineapple"]],
[ "plant16" , ["葡萄", "Grape"]],
[ "plant17" , ["蓝莓", "Blueberry"]],
[ "plant18" , ["西瓜", "Watermelon"]],
[ "plant19" , ["香蕉", "Banana"]],

[ "silver0" , "10000 银币" ],
[ "silver1" , "100000 银币" ],
[ "silver2" , "500000 银币" ],
[ "soldier0" , "剑士" ],
[ "soldier1" , "剑士" ],
[ "soldier2" , "剑士" ],
[ "soldier3" , "剑士" ],
[ "soldier10" , "吸血鬼" ],
[ "soldier11" , "吸血鬼" ],
[ "soldier12" , "吸血鬼" ],
[ "soldier13" , "吸血鬼" ],
[ "soldier20" , "弓箭手" ],
[ "soldier21" , "弓箭手" ],
[ "soldier22" , "弓箭手" ],
[ "soldier23" , "弓箭手" ],
[ "soldier30" , "骑士" ],
[ "soldier31" , "骑士" ],
[ "soldier32" , "骑士" ],
[ "soldier33" , "骑士" ],
[ "soldier40" , "精灵" ],
[ "soldier41" , "精灵" ],
[ "soldier42" , "精灵" ],
[ "soldier43" , "精灵" ],
[ "soldier50" , "泰坦" ],
[ "soldier51" , "泰坦" ],
[ "soldier52" , "泰坦" ],
[ "soldier53" , "泰坦" ],
[ "soldier60" , "火系魔法师" ],
[ "soldier61" , "火系魔法师" ],
[ "soldier62" , "火系魔法师" ],
[ "soldier63" , "火系魔法师" ],
[ "soldier70" , "龙战士" ],
[ "soldier71" , "龙战士" ],
[ "soldier110" , "人鱼" ],
[ "soldier100" , "人狼" ],
[ "soldier80" , "矮人" ],
[ "soldier81" , "矮人" ],
[ "soldier82" , "矮人" ],
[ "soldier83" , "矮人" ],
[ "soldier90" , "天使" ],
[ "soldier91" , "天使" ],
[ "soldier92" , "天使" ],
[ "soldier93" , "天使" ],
[ "soldier72" , "龙战士" ],
[ "soldier73" , "龙战士" ],
[ "soldier120" , "哥布林" ],
[ "soldier130" , "恶魔" ],
[ "soldier140" , "木乃伊" ],
[ "soldier150" , "树人" ],
[ "soldier160" , "石头人" ],
[ "soldier170" , "邪灵法师" ],
[ "soldier180" , "雪人" ],
[ "soldier190" , "骷髅战士" ],
[ "finishTask" , ["完成", ""]],
[ "makeDrugPage" , ["炼金页面", ""]],
[ "finTask" , ["[DO]/[NEED]", ""]],
[ "needExp" , ["[EXP]xp", ""]],
[ "level" , ["Level", ""]],
[ "free0" , ["免费金币", ""]],
[ "share" , ["分享", ""]],
[ "pageNO" , ["-[NUM]-", ""]],
[ "free" , ["免费", ""]],
[ "haha" , ["hah", ""]],
[ "shareGift" , ["分享礼物", ""]],
[ "nextTime" , ["下一次", ""]],
[ "challengeGroup" , ["挑战团体", ""]],
[ "challengeHero" , ["挑战英雄", ""]],
[ "newRank" , ["新手榜", ""]],
[ "visit" , ["访问", ""]],
[ "heroRank" , ["英雄榜", ""]],
[ "groupRank" , ["团体榜", ""]],
[ "collectRole" , ["再收集[NUM]个人物就可以升级到[LEVEL]", ""]],
[ "working" , ["生产中", ""]],
[ "peopleCapacity" , ["人口上限+[NUM]", ""]],
[ "viliDefense" , ["村庄防御力[NUM]", ""]],
[ "quitNow" , ["再次点击退出游戏", ""]],
[ "resLack" , ["缺少[NAME][NUM]", ""]],
[ "glory" , ["荣誉等级", ""]],
[ "ok" , ["确定", ""]],
[ "cancel" , ["取消", ""]],
[ "rand" , ["随机", ""]],
[ "papaya" , ["木瓜币", ""]],
[ "crystal" , ["水晶", ""]],
[ "buySuc" , ["购买成功", ""]],
[ "silver" , ["银币", ""]],
[ "gold" , ["金币", ""]],
[ "attack" , ["攻击力", ""]],
[ "defense" , ["防御力", ""]],
[ "health" , ["生命值", ""]],

["healthAndBoundary", "生命值：[HEALTH]/[BOUND]"],

[ "levelNot" , ["需要等级[[LEVEL]]", ""]],
[ "people" , ["人口", ""]],
[ "cityDefense" , ["城堡防御力", ""]],
[ "accContent" , ["加速[NAME]需要消耗[NUM]个金币，确定加速?", ""]],
[ "accTitle" , ["加速", ""]],
[ "sellContent" , ["确认卖出[NAME]?", ""]],
[ "sellTitle" , ["确定卖出?", ""]],
[ "get" , ["得到", ""]],
[ "sendGift" , ["赠送礼物", ""]],
[ "addFriend" , ["添加好友", ""]],
[ "chooseBuild" , ["点击建筑物进行拖拽", ""]],
[ "dragBuild" , ["拖拽建筑物进行移动", ""]],
[ "mapIsland5" , ["奇迹雪山", ""]],
[ "mapIsland4" , ["奇迹洞穴", ""]],
[ "mapIsland3" , ["奇迹之湖", ""]],
[ "mapIsland2" , ["奇迹平原", ""]],
[ "mapIsland1" , ["奇迹森林", ""]],
[ "mapIsland0" , ["奇迹村", ""]],
[ "mapAll" , ["奇迹大陆", ""]],
[ "drugs" , ["所有药材", ""]],
[ "herbNot" , ["药材不足", ""]],
[ "makeDrug" , ["炼药", ""]],
[ "needLev" , ["需要等级[[LEV]]", ""]],
[ "allSoldier" , ["所有", ""]],
[ "dead" , ["阵亡", ""]],
[ "transfer" , ["转职", ""]],
[ "useIt" , ["使用", ""]],
[ "buyIt" , ["购买", ""]],
[ "unloadIt" , ["卸下", ""]],
[ "nameSol" , ["士兵命名", ""]],
[ "transferLev" , ["下次转职需要的等级：[LEVEL]", ""]],
[ "attVal" , ["攻击力：[NUM]", ""]],
[ "defVal" , ["防御力：[NUM]", ""]],
[ "attSpeed" , ["攻击速度：[LEV]", ""]],
[ "attRange" , ["攻击范围：[LEV]", ""]],
[ "recLife" , ["回血速度：[LEV]", ""]],
[ "levVal" , ["[LEV1]级，还需要[EXP]exp升到[LEV2]级", ""]],
[ "nextTrans" , ["下次转职需要等级[LEV]", ""]],
[ "friGift" , ["好友礼物", ""]],
[ "moreGame" , ["更多游戏", ""]],
[ "howManyGift" , ["你有[NUM]份来自好友的礼物", ""]],
[ "recAll" , ["接受所有", ""]],
[ "friSendGift" , ["[NAME]赠送给你[NUM]个[KIND]", ""]],
[ "receive" , ["接受", ""]],
[ "download" , ["下载", ""]],
[ "restart" , ["重新开始", ""]],
[ "continue" , ["继续", ""]],
[ "tryAgain" , ["重试", ""]],
[ "quit" , ["退出", ""]],
[ "breakReward" , ["奖励：[GOOD1], [GOOD2]", ""]],
["levelupSol", "升级士兵："],
["noLevelUp", "没有升级士兵"],
["nameNotNull", "士兵姓名不能为空"],
["solIntro", "[NAME]介绍"],
["sureToBuy", "确定购买"],
["slow", "慢"],
["mid", "中"],
["fast", "快"],
["near", "近"],
["far", "远"],
["noTransfer", "已经达到最高级职业"],
["trainZone", "训练场"],
["curSolSolBound", "当前士兵数量/士兵数量上限：[NUM1]/[NUM2]"],
["solTip", "提示：训练场不能摆放建筑，开启浮岛可以容纳更多士兵，点击经营页面上方浮岛查看详细信息。"],
["houseNot", "民居不足"],
["buildHouse", "你需要建造更多的民居来容纳士兵"],
["solTooMany", "士兵超出"],
["sorrySol", "抱歉，奇迹村最多只能容纳50个人口，开启浮岛来容纳更多人口！"],
["notOpen", "尚未开启"],
["comeSoon", "敬请期待"],
["resNot", "资源不足"],
["myNameIs", "我是[NAME]"],
["letFight", "让我们战斗吧!"],
["farmTooTitle", "等级不足"],
["farmTooCon", "抱歉，你需要升到第[LEV]级才可以继续购买农田"],
["plantLevel", "种植农作物[NAME]需要等级[LEVEL]"],
["levelNotTitle", "等级不足"],
["phyAtt", "物理攻击[NUM]"],
["magAtt", "魔法攻击[NUM]"],
["phyDef", "物理防御[NUM]"],
["magDef", "魔法防御[NUM]"],
["physicAttack", "物理攻击"],
["magicAttack", "魔法攻击"],
["physicDefense", "物理防御"],
["magicDefense", "魔法防御"],
["healthBoundary", "生命值上限"],
["eqLevel", "强化等级[LEV]"],
["oneEquipTitle", "装备类型重复"],
["oneEquipCon", "已经拥有一件同类型的装备了！"],
["rewardCry", "奖励水晶[NUM]"],
["newRecord", "新的最高得分[NUM]"],
["challengeScore", "积分增加[NUM]"],
["lostScore", "损失基本[NUM]"],



["solDes0", "solDes0"],

[ "title0" , "title0" ],
[ "des0" , "description0" ],

]);


