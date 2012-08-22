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
[ "building300" , ["水晶矿", ""]],

[ "crystal0" , "10 水晶" ],
[ "crystal1" , "50 水晶" ],
[ "crystal2" , "100 水晶" ],



[ "drug0" , ["初级生命药水", ""]],
[ "drug1" , ["初级攻击药水", ""]],
[ "drug2" , ["初级复活药水", ""]],
[ "drug3" , ["初级回血药水", ""]],
[ "drug4" , ["初级防御药水", ""]],
[ "drug10" , ["中级生命药水", ""]],
[ "drug11" , ["中级攻击药水", ""]],
[ "drug12" , ["中级复活药水", ""]],
[ "drug13" , ["中级回血药水", ""]],
[ "drug14" , ["中级防御药水", ""]],
[ "drug20" , ["高级生命药水", ""]],
[ "drug21" , ["高级攻击药水", ""]],
[ "drug22" , ["高级复活药水", ""]],
[ "drug23" , ["高级回血药水", ""]],
[ "drug24" , ["高级防御药水", ""]],
[ "drug30" , ["神级生命药水", ""]],
[ "drug31" , ["神级攻击药水", ""]],
[ "drug32" , ["神级复活药水", ""]],
[ "drug33" , ["神级回血药水", ""]],
[ "drug34" , ["神级防御药水", ""]],

[ "equip0" , ["红级法袍1", ""]],
[ "equip1" , ["橙级法袍1", ""]],
[ "equip2" , ["黄级法袍1", ""]],
[ "equip3" , ["绿级法袍1", ""]],
[ "equip4" , ["青级法袍1", ""]],
[ "equip5" , ["蓝级法袍1", ""]],
[ "equip6" , ["紫级法袍1", ""]],
[ "equip7" , ["红级法袍2", ""]],
[ "equip8" , ["橙级法袍2", ""]],
[ "equip9" , ["黄级法袍2", ""]],
[ "equip10" , ["绿级法袍2", ""]],
[ "equip11" , ["青级法袍2", ""]],
[ "equip12" , ["蓝级法袍2", ""]],
[ "equip13" , ["紫级法袍2", ""]],
[ "equip14" , ["红级法袍3", ""]],
[ "equip15" , ["橙级法袍3", ""]],
[ "equip16" , ["黄级法袍3", ""]],
[ "equip17" , ["绿级法袍3", ""]],
[ "equip18" , ["青级法袍3", ""]],
[ "equip19" , ["蓝级法袍3", ""]],
[ "equip20" , ["紫级法袍3", ""]],
[ "equip21" , ["红级法袍4", ""]],
[ "equip22" , ["橙级法袍4", ""]],
[ "equip23" , ["黄级法袍4", ""]],
[ "equip24" , ["绿级法袍4", ""]],
[ "equip25" , ["青级法袍4", ""]],
[ "equip26" , ["蓝级法袍4", ""]],
[ "equip27" , ["紫级法袍4", ""]],
[ "equip28" , ["红级戒指1", ""]],
[ "equip29" , ["橙级戒指1", ""]],
[ "equip30" , ["黄级戒指1", ""]],
[ "equip31" , ["绿级戒指1", ""]],
[ "equip32" , ["青级戒指1", ""]],
[ "equip33" , ["蓝级戒指1", ""]],
[ "equip34" , ["紫级戒指1", ""]],
[ "equip35" , ["红级戒指2", ""]],
[ "equip36" , ["橙级戒指2", ""]],
[ "equip37" , ["黄级戒指2", ""]],
[ "equip38" , ["绿级戒指2", ""]],
[ "equip39" , ["青级戒指2", ""]],
[ "equip40" , ["蓝级戒指2", ""]],
[ "equip41" , ["紫级戒指2", ""]],
[ "equip42" , ["红级戒指3", ""]],
[ "equip43" , ["橙级戒指3", ""]],
[ "equip44" , ["黄级戒指3", ""]],
[ "equip45" , ["绿级戒指3", ""]],
[ "equip46" , ["青级戒指3", ""]],
[ "equip47" , ["蓝级戒指3", ""]],
[ "equip48" , ["紫级戒指3", ""]],
[ "equip49" , ["红级项链1", ""]],
[ "equip50" , ["橙级项链1", ""]],
[ "equip51" , ["黄级项链1", ""]],
[ "equip52" , ["绿级项链1", ""]],
[ "equip53" , ["青级项链1", ""]],
[ "equip54" , ["蓝级项链1", ""]],
[ "equip55" , ["紫级项链1", ""]],
[ "equip56" , ["红级项链2", ""]],
[ "equip57" , ["橙级项链2", ""]],
[ "equip58" , ["黄级项链2", ""]],
[ "equip59" , ["绿级项链2", ""]],
[ "equip60" , ["青级项链2", ""]],
[ "equip61" , ["蓝级项链2", ""]],
[ "equip62" , ["紫级项链2", ""]],
[ "equip63" , ["红级魔法书", ""]],
[ "equip64" , ["橙级魔法书", ""]],
[ "equip65" , ["黄级魔法书", ""]],
[ "equip66" , ["绿级魔法书", ""]],
[ "equip67" , ["青级魔法书", ""]],
[ "equip68" , ["蓝级魔法书", ""]],
[ "equip69" , ["紫级魔法书", ""]],
[ "equip70" , ["红级锄头", ""]],
[ "equip71" , ["橙级弓箭", ""]],
[ "equip72" , ["黄级弓箭", ""]],
[ "equip73" , ["绿级剑", ""]],
[ "equip74" , ["青级剑", ""]],
[ "equip75" , ["蓝级铁锤", ""]],
[ "equip76" , ["紫级狼牙棒", ""]],
[ "equip77" , ["红级斧头", ""]],
[ "equip78" , ["橙级弓箭2", ""]],
[ "equip79" , ["黄级刀", ""]],
[ "equip80" , ["绿级枪", ""]],
[ "equip81" , ["青级锚", ""]],
[ "equip82" , ["蓝级弓箭", ""]],
[ "equip83" , ["紫级铁锤", ""]],
[ "equip84" , ["红级拳套", ""]],
[ "equip85" , ["橙级铠甲", ""]],
[ "equip86" , ["黄级手套1", ""]],
[ "equip87" , ["绿级盾牌", ""]],
[ "equip88" , ["青级头盔", ""]],
[ "equip89" , ["蓝级靴子", ""]],
[ "equip90" , ["紫级鞋子", ""]],
[ "equip91" , ["红级盔甲", ""]],
[ "equip92" , ["橙级拳套", ""]],
[ "equip93" , ["黄级手套2", ""]],
[ "equip94" , ["绿级铠甲", ""]],
[ "equip95" , ["青级盾牌", ""]],
[ "equip96" , ["蓝级头盔", ""]],
[ "equip97" , ["紫级头盔", ""]],
[ "equip98" , ["红级铠甲", ""]],
[ "equip99" , ["橙级铠甲", ""]],
[ "equip100" , ["黄级铠甲", ""]],
[ "equip101" , ["绿级铠甲", ""]],
[ "equip102" , ["青级铠甲", ""]],
[ "equip103" , ["蓝级铠甲", ""]],
[ "equip104" , ["紫级铠甲", ""]],
[ "equip105" , ["红级盾牌", ""]],
[ "equip106" , ["橙级靴子", ""]],
[ "equip107" , ["黄级盔甲", ""]],
[ "equip108" , ["红级魔棒1", ""]],
[ "equip109" , ["橙级魔棒1", ""]],
[ "equip110" , ["黄级魔棒1", ""]],
[ "equip111" , ["绿级魔棒1", ""]],
[ "equip112" , ["青级魔棒1", ""]],
[ "equip113" , ["蓝级魔棒1", ""]],
[ "equip114" , ["紫级魔棒1", ""]],
[ "equip115" , ["红级魔棒2", ""]],
[ "equip116" , ["橙级魔棒2", ""]],
[ "equip117" , ["黄级魔棒2", ""]],
[ "equip118" , ["绿级魔棒2", ""]],
[ "equip119" , ["青级魔棒2", ""]],
[ "equip120" , ["蓝级魔棒2", ""]],
[ "equip121" , ["紫级魔棒2", ""]],
[ "equip122" , ["红级魔棒3", ""]],
[ "equip123" , ["橙级魔棒3", ""]],
[ "equip124" , ["黄级魔棒3", ""]],
[ "equip125" , ["绿级魔棒3", ""]],
[ "equip126" , ["青级魔棒3", ""]],
[ "equip127" , ["蓝级魔棒3", ""]],
[ "equip128" , ["紫级魔棒3", ""]],
[ "equip129" , ["圣剑", ""]],
[ "equip130" , ["神圣法袍", ""]],
[ "equip131" , ["神圣盔甲", ""]],
[ "equip132" , ["神圣魔棒", ""]],
[ "equip133" , ["神圣魔法书", ""]],


[ "gold0" , "10 金币" ],
[ "gold1" , "60 金币" ],
[ "gold2" , "125 金币" ],
[ "gold3" , "275 金币" ],
[ "gold4" , "600 金币" ],
[ "gold5" , "1600 金币" ],


[ "herb0" , ["冬刺草", ""]],
[ "herb1" , ["地根草", ""]],
[ "herb2" , ["墓地苔", ""]],
[ "herb3" , ["太阳草", ""]],
[ "herb4" , ["宁神花", ""]],
[ "herb5" , ["幽灵菇", ""]],
[ "herb6" , ["枯叶草", ""]],
[ "herb7" , ["梦叶草", ""]],
[ "herb8" , ["活根草", ""]],
[ "herb9" , ["火焰花", ""]],
[ "herb10" , ["血皇草", ""]],
[ "herb11" , ["盲目草", ""]],
[ "herb12" , ["石南草", ""]],
[ "herb13" , ["紫莲花", ""]],
[ "herb14" , ["荆棘藻", ""]],
[ "herb15" , ["跌打草", ""]],
[ "herb16" , ["野钢花", ""]],
[ "herb17" , ["金棘草", ""]],
[ "herb18" , ["银叶草", ""]],
[ "herb112" , ["", ""]],
[ "herb111" , ["", ""]],
[ "herb110" , ["", ""]],
[ "herb100" , ["奥利哈康", ""]],
[ "herb101" , ["秘银矿", ""]],
[ "herb102" , ["金矿", ""]],
[ "herb103" , ["钴蓝矿", ""]],
[ "herb104" , ["铁矿", ""]],
[ "herb105" , ["铜矿", ""]],
[ "herb106" , ["银矿", ""]],
[ "herb107" , ["魔晃结晶", ""]],
[ "herb108" , ["魔晶石", ""]],
[ "herb109" , ["黑铁矿", ""]],
[ "herb113" , ["", ""]],
[ "herb114" , ["", ""]],
[ "herb115" , ["", ""]],
[ "herb116" , ["", ""]],
[ "herb117" , ["", ""]],
[ "herb118" , ["", ""]],
[ "herb119" , ["", ""]],
[ "herb120" , ["", ""]],
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
[ "herbDes112" , "herb desc" ],
[ "herbDes111" , "herb desc" ],
[ "herbDes110" , "herb desc" ],
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
[ "herbDes113" , "herb desc" ],
[ "herbDes114" , "herb desc" ],
[ "herbDes115" , "herb desc" ],
[ "herbDes116" , "herb desc" ],
[ "herbDes117" , "herb desc" ],
[ "herbDes118" , "herb desc" ],
[ "herbDes119" , "herb desc" ],
[ "herbDes120" , "herb desc" ],


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
[ "breakReward" , ["奖励：[GOOD]", ""]],
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
["oneEquipCon", "已经拥有一件增加相同属性的装备了！"],
["rewardCry", "奖励水晶[NUM]"],
["newRecord", "新的最高得分[NUM]"],
["challengeScore", "积分增加[NUM]"],
["lostScore", "损失基本[NUM]"],
["nameSame", "士兵名字重复"],
["nameTooLong", "名字太长超过4个字符"],




["solDes0", "solDes0"],

[ "title0" , "title0" ],
[ "des0" , "description0" ],


[ "name0" , ["艾伯特", "Albert"]],
[ "name1" , ["奥德里奇", "Aldrich"]],
[ "name2" , ["亚历山大", "Alexander"]],
[ "name3" , ["艾伦", "Allen"]],
[ "name4" , ["亚摩斯", "Amos"]],
[ "name5" , [" 安德鲁", "Andrew"]],
[ "name6" , ["安迪", "Andy"]],
[ "name7" , ["安其罗 ", "Angelo"]],
[ "name8" , ["安斯艾尔", "Ansel"]],
[ "name9" , ["安东尼奥", "Antonio "]],
[ "name10" , ["安东尼", "Antony"]],
[ "name11" , [" 阿奇尔 ", "Archer"]],
[ "name12" , ["阿诺", "Arno"]],
[ "name13" , ["亚瑟", "Arthur "]],
[ "name14" , ["艾文", "Arvin"]],
[ "name15" , ["亚撒", "Asa"]],
[ "name16" , ["安格斯", "Augus"]],
[ "name17" , ["拜尔德", "Baird"]],
[ "name18" , ["柏得温", "Baldwin "]],
[ "name19" , ["班克罗福特", "Bancroft"]],
[ "name20" , ["巴德", "Bard"]],
[ "name21" , ["巴罗", "Barlow"]],
[ "name22" , ["巴奈特", "Barnett"]],
[ "name23" , ["巴伦", "Baron"]],
[ "name24" , ["巴里特", "Barret"]],
[ "name25" , ["巴里", "Barry"]],
[ "name26" , ["巴特", "Bart"]],
[ "name27" , ["巴萨罗穆", "Bartholomew"]],
[ "name28" , ["巴顿", "Barton"]],
[ "name29" , ["比恩", "Bean"]],
[ "name30" , ["贝克", "Beck"]],
[ "name31" , ["班尼迪克", "Benedict"]],
[ "name32" , ["班杰明", "Benjamin"]],
[ "name33" , ["班森", "Benson"]],
[ "name34" , ["柏格", "Berg"]],
[ "name35" , ["格吉尔", "Berger"]],
[ "name36" , ["伯尼", "Bernie"]],
[ "name37" , ["伯特", "Bert"]],
[ "name38" , ["伯顿", "Berton"]],
[ "name39" , ["柏特莱姆", "Bertram"]],
[ "name40" , ["毕维斯", "Bevis"]],
[ "name41" , ["比尔", "Bill"]],
[ "name42" , ["比利", "Billy"]],
[ "name43" , ["鲍伯", "Bob"]],
[ "name44" , ["布兹", "Booth"]],
[ "name45" , ["柏格", "Borg"]],
[ "name46" , ["鲍里斯", "Boris"]],
[ "name47" , ["波文", "Bowen"]],
[ "name48" , ["布德", "Boyd"]],
[ "name49" , ["布莱迪", "Brady"]],
[ "name50" , ["布莱恩", "Brian"]],
[ "name51" , ["布拉得里克", "Broderick"]],
[ "name52" , ["布鲁克", "Brook"]],
[ "name53" , ["布鲁斯", "Bruce"]],
[ "name54" , ["布鲁诺", "Bruno"]],
[ "name55" , ["巴克", "Buck"]],
[ "name56" , ["巴尔克", "Burke"]],
[ "name57" , ["伯特", "Burt"]],
[ "name58" , ["波顿", "Burton"]],
[ "name59" , ["拜伦", "Byron"]],
[ "name60" , ["凯撒", "Caesar"]],
[ "name61" , ["卡尔文", "Calvin"]],
[ "name62" , ["凯里", "Carey"]],
[ "name63" , ["卡尔", "Carl"]],
[ "name64" , ["凯尔", "Carr"]],
[ "name65" , ["卡特", "Carter"]],
[ "name66" , ["查德", "Chad"]],
[ "name67" , ["强尼", "Channing"]],
[ "name68" , ["查尔斯", "Charles"]],
[ "name69" , ["查理", "Charlie"]],
[ "name70" , ["夏佐", "Chasel"]],
[ "name71" , ["贾斯特", "Chester"]],
[ "name72" , ["恰克", "Chunk"]],
[ "name73" , ["克雷尔", "Clare"]],
[ "name74" , ["克拉伦斯", "Clarence"]],
[ "name75" , ["克拉克", "Clark"]],
[ "name76" , ["克劳德", "Claude"]],
[ "name77" , ["克利夫兰", "Cleveland"]],
[ "name78" , ["柯利福", "Cliff"]],
[ "name79" , ["柯利弗德", "Clifford"]],
[ "name80" , ["克莱得 ", "Clyde"]],
[ "name81" , ["考尔比", "Colby"]],
[ "name82" , ["科林", "Colin"]],
[ "name83" , ["丹", "Dan"]],
[ "name84" , ["戴纳", "Dana"]],
[ "name85" , ["丹尼尔", "Daniel"]],
[ "name86" , ["达尔西", "Darcy"]],
[ "name87" , ["达蕊", "Daria"]],
[ "name88" , ["达伦", "Darren"]],
[ "name89" , ["迪夫", "Dave"]],
[ "name90" , ["大卫", "David"]],
[ "name91" , ["迪恩", "Dean"]],
[ "name92" , ["邓普斯", "Dempsey"]],
[ "name93" , ["邓尼斯", "Dennis"]],
[ "name94" , ["戴里克", "Derrick"]],
[ "name95" , ["得文", "Devin"]],
[ "name96" , ["狄克", "Dick"]],
[ "name97" , ["唐纳德", "Donald"]],
[ "name98" , ["道格拉斯", "Douglas"]],
[ "name99" , ["杜鲁", "Drew"]],
[ "name100" , ["杜克", "Duke"]],
[ "name101" , ["邓肯", "Duncan"]],
[ "name102" , ["唐恩", "Dunn"]],
[ "name103" , ["德维特", "Dwight"]],
[ "name104" , ["狄伦", "Dylan"]],
[ "name105" , ["埃迪", "Eddy"]],
[ "name106" , ["埃利奥特", "Elliot"]],
[ "name107" , ["艾瑞克", "Eric"]],
[ "name108" , ["菲力克斯", "Felix"]],
[ "name109" , ["斐迪南", "Ferdinand"]],
[ "name110" , ["费奇", "Fitch"]],
[ "name111" , ["费兹捷勒", "Fitzgerald"]],
[ "name112" , ["福特", "Ford"]],
[ "name113" , ["法兰西斯", "Francis"]],
[ "name114" , ["法兰克", "Frank"]],
[ "name115" , ["法兰克林", "Franklin"]],
[ "name116" , ["弗瑞德", "Fred"]],
[ "name117" , ["弗雷得力克", "Frederic"]],
[ "name118" , ["加里", "Gary"]],
[ "name119" , ["亨利", "Henry"]],
[ "name120" , ["霍华德", "Howard"]],
[ "name121" , ["艾梵", "Ivan"]],
[ "name122" , ["艾维斯", "Ives"]],
[ "name123" , ["杰克", "Jack"]],
[ "name124" , ["杰克逊", "Jackson"]],
[ "name125" , ["雅各布", "Jacob"]],
[ "name126" , ["詹姆士", "James"]],
[ "name127" , ["杰瑞德", "Jared"]],
[ "name128" , ["杰森", "Jason"]],
[ "name129" , ["杰", "Jay"]],
[ "name130" , ["杰夫", "Jeff"]],
[ "name131" , ["杰佛瑞", "Jeffrey"]],
[ "name132" , ["杰勒米", "Jeremy"]],
[ "name133" , ["哲罗姆", "Jerome"]],
[ "name134" , ["杰理", "Jerry"]],
[ "name135" , ["吉姆", "Jim"]],
[ "name136" , ["杰米", "Jimmy"]],
[ "name137" , ["约翰", "John"]],
[ "name138" , ["乔尼", "Johnny"]],
[ "name139" , ["约翰逊", "Johnson"]],
[ "name140" , ["琼纳斯", "Jonas"]],
[ "name141" , ["约瑟夫", "Joseph"]],
[ "name142" , ["乔休尔", "Joshua"]],
[ "name143" , ["卡尔", "Karl"]],
[ "name144" , ["肯恩", "Ken"]],
[ "name145" , ["肯特", "Kent"]],
[ "name146" , ["科尔", "Kerr"]],
[ "name147" , ["科尔温", "Kerwin"]],
[ "name148" , ["凯文", "Kevin"]],
[ "name149" , ["金姆", "Kim"]],
[ "name150" , ["金", "King"]],
[ "name151" , ["科克", "Kirk"]],
[ "name152" , ["克里思", "Kris"]],
[ "name153" , ["凯尔", "Kyle"]],
[ "name154" , ["莱纳德", "Leoard"]],
[ "name155" , ["刘易斯", "Lewis"]],
[ "name156" , ["路易斯", "Louis"]],
[ "name157" , ["林顿", "Lyndon"]],
[ "name158" , ["马克", "Mark"]],
[ "name159" , ["马丁", "Martin"]],
[ "name160" , ["马文", "Marvin"]],
[ "name161" , ["马特", "Matt"]],
[ "name162" , ["马克斯", "Max"]],
[ "name163" , ["马克西米兰", "Maximilian"]],
[ "name164" , ["麦斯威尔", "Maxwell"]],
[ "name165" , ["马勒第兹", "Meredith"]],
[ "name166" , ["莫尔", "Merle"]],
[ "name167" , ["米歇尔", "Michael"]],
[ "name168" , ["摩菲", "Murphy"]],
[ "name169" , ["内特", "Nate"]],
[ "name170" , ["尼尔", "Neil"]],
[ "name171" , ["尼克", "Nick"]],
[ "name172" , ["保罗", "Paul"]],
[ "name173" , ["彼特", "Peter"]],
[ "name174" , ["雷蒙德", "Raymond"]],
[ "name175" , ["雷哲", "Reg"]],
[ "name176" , ["雷根", "Regan"]],
[ "name177" , ["雷吉诺德", "Reginald"]],
[ "name178" , ["鲁宾", "Reuben"]],
[ "name179" , ["雷克斯", "Rex"]],
[ "name180" , ["理查德", "Richard"]],
[ "name181" , ["罗伯特", "Robert"]],
[ "name182" , ["罗宾", "Robin"]],
[ "name183" , ["洛克", "Rock"]],
[ "name184" , ["罗德", "Rod"]],
[ "name185" , ["罗得里克", "Roderick"]],
[ "name186" , ["罗德尼", "Rodney"]],
[ "name187" , ["罗恩", "Ron"]],
[ "name188" , ["罗纳尔多", "Ronald"]],
[ "name189" , ["罗里", "Rory"]],
[ "name190" , ["罗伊", "Roy"]],
[ "name191" , ["鲁道夫", "Rudolf"]],
[ "name192" , ["鲁伯特", "Rupert"]],
[ "name193" , ["山姆", "Sam"]],
[ "name194" , ["辛普森", "Sampson"]],
[ "name195" , ["撒姆尔", "Samuel"]],
[ "name196" , ["山迪", "Sandy"]],
[ "name197" , ["撒克逊", "Saxon"]],
[ "name198" , ["史考特", "Scott"]],
[ "name199" , ["肖恩", "Sean"]],
[ "name200" , ["夕巴斯汀", "Sebastian"]],
[ "name201" , ["谢尔顿", "Sheldon"]],
[ "name202" , ["锡德", "Sid"]],
[ "name203" , ["锡得尼", "Sidney"]],
[ "name204" , ["席尔维斯特", "Silvester"]],
[ "name205" , ["赛门", "Simon"]],
[ "name206" , ["史丹", "Stan"]],
[ "name207" , ["史丹佛", "Stanford"]],
[ "name208" , ["史丹尼", "Stanley "]],
[ "name209" , ["史蒂芬", "Stephen"]],
[ "name210" , ["史帝文", "Steven"]],
[ "name211" , ["泰勒", "Taylor"]],
[ "name212" , ["托马斯", "Thomas"]],
[ "name213" , ["汤姆", "Tom"]],
[ "name214" , ["文森", "Vincent"]],
[ "name215" , ["维吉尔", "Virgil"]],
[ "name216" , ["维托", "Vito"]],
[ "name217" , ["维德", "Wade"]],
[ "name218" , ["瓦尔克", "Walker"]],
[ "name219" , ["沃尔特", "Walt"]],
[ "name220" , ["瓦尔特", "Walter"]],
[ "name221" , ["华德", "Ward"]],
[ "name222" , ["华纳", "Warner"]],
[ "name223" , ["韦恩", "Wayne"]],
[ "name224" , ["韦勃", "Webb"]],
[ "name225" , ["韦伯斯特", "Webster"]],
[ "name226" , ["威尔", "Will"]],
[ "name227" , ["威廉", "William"]],
[ "name228" , ["莱特", "Wright"]],
[ "name229" , ["伟兹", "Wythe"]],
[ "name230" , ["扎克", "Zark"]],
[ "name231" , ["爱丽丝", "Alice"]],
[ "name232" , ["阿曼达", "Amanda"]],
[ "name233" , ["艾米", "Amy"]],
[ "name234" , ["安妮", "Ann"]],
[ "name235" , ["埃娃", "Ava"]],
[ "name236" , ["芭芭拉", "Barbara"]],
[ "name237" , ["贝蒂", "Betty"]],
[ "name238" , ["卡罗尔", "Carol"]],
[ "name239" , ["卡洛琳", "Caroline"]],
[ "name240" , ["塞西利亚", "Cecilia"]],
[ "name241" , ["克里斯汀娜", "Christina"]],
[ "name242" , ["黛比", "Debbie"]],
[ "name243" , ["黛米", "Demi"]],
[ "name244" , ["戴安娜", "Diana"]],
[ "name245" , ["多利", "Dolly"]],
[ "name246" , ["多里斯", "Doris"]],
[ "name247" , ["伊莉莎白", "Elizabeth"]],
[ "name248" , ["艾米丽", "Emily"]],
[ "name249" , ["艾玛", "Emma"]],
[ "name250" , ["菲怡", "Fay"]],
[ "name251" , ["菲安娜", "Fiona"]],
[ "name252" , ["姬儿", "Gill"]],
[ "name253" , ["格罗里娅", "Gloria"]],
[ "name254" , ["格雷斯", "Grace"]],
[ "name255" , ["海伦", "Helen"]],
[ "name256" , ["艾琳", "Irene"]],
[ "name257" , ["伊萨贝尔", "Isabel"]],
[ "name258" , ["艾薇", "Ivy"]],
[ "name259" , ["简", "Jane"]],
[ "name260" , ["珍妮", "Jenny"]],
[ "name261" , ["杰西卡", "Jessica"]],
[ "name262" , ["杰西", "Jessie"]],
[ "name263" , ["琼", "Joan"]],
[ "name264" , ["乔安娜", "Joanna"]],
[ "name265" , ["乔伊", "Joy"]],
[ "name266" , ["乔伊斯", "Joyce"]],
[ "name267" , ["朱蒂", "Judy"]],
[ "name268" , ["朱利安", "Julian"]],
[ "name269" , ["朱莉", "Julie"]],
[ "name270" , ["朱丽叶", "Juliet"]],
[ "name271" , ["凯特", "Kate"]],
[ "name272" , ["凯瑟琳", "Katharine"]],
[ "name273" , ["凯利", "Kelly"]],
[ "name274" , ["李", "Lee"]],
[ "name275" , ["莉娜", "Lena"]],
[ "name276" , ["莉莉安", "Lillian"]],
[ "name277" , ["莉莉", "Lily"]],
[ "name278" , ["琳达", "Linda"]],
[ "name279" , ["丽莎", "Lisa"]],
[ "name280" , ["林恩", "Lynn"]],
[ "name281" , ["马尔科姆", "Malcolm"]],
[ "name282" , ["曼迪", "Mandy"]],
[ "name283" , ["玛格丽特", "Margaret"]],
[ "name284" , ["玛利亚", "Maria"]],
[ "name285" , ["玛丽", "Mary"]],
[ "name286" , ["梅", "May"]],
[ "name287" , ["麦露迪", "Melody"]],
[ "name288" , ["茉莉", "Molly"]],
[ "name289" , ["南希", "Nancy"]],
[ "name290" , ["奥利维亚", "Olivia"]],
[ "name291" , ["潘妮", "Penny"]],
[ "name292" , ["瑞秋", "Rachel"]],
[ "name293" , ["瑞贝卡", "Rebecca"]],
[ "name294" , ["丽塔", "Rita"]],
[ "name295" , ["罗斯", "Ross"]],
[ "name296" , ["鲁迪", "Rudy"]],
[ "name297" , ["萨利", "Sally"]],
[ "name298" , ["萨曼塔", "Samantha"]],
[ "name299" , ["瑟琳娜", "Serena"]],
[ "name300" , ["雪莉", "Shirley"]],
[ "name301" , ["索菲亚", "Sophia"]],
[ "name302" , ["苏尼", "Sunny"]],
[ "name303" , ["苏珊", "Susan"]],
[ "name304" , ["特瑞莎", "Teresa"]],
[ "name305" , ["特瑞西", "Tracy"]],
[ "name306" , ["薇薇安", "Vivian"]],
[ "name307" , ["文迪", "Wendy"]],
[ "name308" , ["惠特尼", "Whitney"]],
[ "name309" , ["伊冯", "Yvonne"]],

["percentHealth", "生命值百分比"],
["percentHealthBoundary", "生命值上限百分比"],
["percentAttack", "攻击力百分比"],
["percentDefense", "防御力百分比"],
["useLevelNot", "士兵等级不足不能使用装备"],
["useLevelCon", "装备使用等级[LEV0], 当前士兵等级[LEV1]"],
["solLevelGtRelive", "士兵等级大于药品限制"],
["solLevelGtReliveCon", "士兵等级[LEV0], 药品等级限制[LEV1]"],
["oreNot", "矿石不足"],
["makeEquip", "打造装备"],
["allOres", "所有矿石"],

["finishBuyTitle", "完成购买任务"],
["finishBuyCon", "恭喜你完成购买[NAME]任务, 得到奖励[REWARD]"],
["recFriend", "推荐好友"],
["addNeibor", "邻居请求"],
["removeNeibor", "解除邻居"],
["friendReq", "好友互动"],
["neiborRequest", "[NAME]请求添加您为邻居."],
["refuse", "拒绝"],
["showNeibor", "邻居"],
["showPapaya", "木瓜好友"],
["emptySeat", "空位"],
["addNeiborMax", "增加邻居上限"],
["accRequestError", "接受请求失败"],
["noUser", "没有这个用户"],
["yourNeiborMax", "你的邻居数超过上限"],
["friNeiborMax", "对方的邻居数超过上限"],
["neiborYet", "你们已经是邻居了"],
["noNeibor", "没有邻居可以访问"],
["noNeiborCon", "没有邻居可以访问"],
["help", "帮助"],
["addNeiMaxTit", "增加邻居名额"],
["addNeiMaxCon", "你当前邻居名额[NUM], 确定花费[CAE]个金币再增加1个名额?"],
["neiborFullTit", "邻居名额已满"],
["neiborFullCon", "是否增加邻居名额?"],
["friNeiFullTit", "好友邻居已满"],
["friNeiFullCon", "好友邻居已满"],
["addNeiTit", "增加更多邻居"],
["addNeiCon", "邻居越多，每天能获得更多的访问水晶"],

["resourceNotTit", "资源不足"],
["resourceNotCon", "你缺少以下资源"],
["resList", "[NAME]:[VAL]"],
["upgradeMineTit", "升级水晶矿"],
["upgradeMineCon", "该水晶矿每次生产[NUM0], 当前你拥有[NUM1]七彩水晶，确定使用[NUM2]个七彩水晶来升级水晶矿？升级后水晶矿生产[NUM3]个水晶。提示：参加活动可以获取七彩水晶。"],
["colorCrystal", "七彩水晶"],
["mineNotBegin", "等级不足[LEVEL],不能开启水晶矿"],
["solDead", "士兵已经死亡"],
["solDeadCon", "死亡士兵不能转职"],
["equipIt", "佩戴"],
["upgrade", "升级"],
["allDrug", "所有药品"],
["sell", "卖出"],
["viewAll", "查看"],
["closeAll", "关闭"],
["netError", "网络异常"],
["netErrorCon", "网络异常，请退出游戏重试，或者忽略该问题，并向我们报告。"],
["finishTask", "完成！"],
["buyObj", "购买[NAME]"],
["exp", "经验"],

/*
[ "drugDes0" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes1" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes2" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes3" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes4" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes10" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes11" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes12" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes13" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes14" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes20" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes21" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes22" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes23" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes24" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes30" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes31" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes32" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes33" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "drugDes34" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],

[ "equipDes0" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes1" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes2" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes3" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes4" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes5" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes6" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes7" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes8" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes9" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes10" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes11" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes12" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes13" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes14" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes15" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes16" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes17" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes18" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes19" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes20" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes21" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes22" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes23" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes24" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes25" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes26" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes27" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes28" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes29" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes30" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes31" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes32" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes33" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes34" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes35" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes36" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes37" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes38" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes39" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes40" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes41" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes42" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes43" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes44" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes45" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes46" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes47" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes48" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes49" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes50" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes51" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes52" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes53" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes54" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes55" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes56" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes57" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes58" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes59" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes60" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes61" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes62" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes63" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes64" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes65" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes66" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes67" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes68" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes69" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes70" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes71" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes72" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes73" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes74" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes75" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes76" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes77" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes78" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes79" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes80" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes81" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes82" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes83" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes84" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes85" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes86" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes87" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes88" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes89" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes90" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes91" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes92" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes93" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes94" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes95" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes96" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes97" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes98" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes99" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes100" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes101" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes102" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes103" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes104" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes105" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes106" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes107" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes108" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes109" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes110" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes111" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes112" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes113" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes114" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes115" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes116" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes117" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes118" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes119" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes120" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes121" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes122" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes123" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes124" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes125" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes126" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes127" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes128" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes129" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes130" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes131" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes132" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
[ "equipDes133" , "暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验暂时试验" ],
*/

/*
[ "magicStone0" , ["橙色魔法球", ""]],
[ "magicStone1" , ["黄色魔法球", ""]],
[ "magicStone2" , ["绿色魔法球", ""]],
[ "magicStone3" , ["蓝色魔法球", ""]],
[ "magicStoneDes0" , "" ],
[ "magicStoneDes1" , "" ],
[ "magicStoneDes2" , "" ],
[ "magicStoneDes3" , "" ],


[ "goodsList0" , ["红宝石", "redTreasureStone"]],
[ "goodsList1" , ["绿宝石", ""]],
[ "goodsList2" , ["蓝宝石", ""]],
[ "goodsList3" , ["紫宝石", ""]],
[ "goodsListDes0" , "" ],
[ "goodsListDes1" , "" ],
[ "goodsListDes2" , "" ],
[ "goodsListDes3" , "" ],
*/

["upgradeEquip", "装备升级"],
["stoneLevel", "[NAME]提升装备等级到[LEV0], 成功概率[POS0]%, 装备损坏概率[POS1]%"],
["sucPos", "成功率[POS]%"],
["treaNum", "[NUM]颗"], 
["brokenEquip", "装备损坏会降低等级"],
["sucUpgrade", "恭喜，装备升级成功！"],
["failUpgrade", "抱歉，升级失败，但装备未损坏！"],
["failEquip", "抱歉，升级失败，装备损坏！"],
["sendGift", "赠送礼物"],
["moreThings", "你拥有多个物品，点击展开查看详细信息"],
["noThing", "没有该类物品"],
["sendIt", "赠送"],
["friSendEquip", "[NAME]赠送你一件装备[ENAME]等级[LEVEL]"],
["friSendOthers", "[NAME]赠送你[ONAME]"],
["skillLevel", "Lv. [LEV]"],
["giveup", "放弃"],
["buySkillTit", "购买技能"],
["buySkillCon", "购买技能[NAME]"],
["upgradeSkill", "升级技能"],
["useStoneEquip", "使用宝石升级装备之后，装备的属性将更加强大"],
["useStoneMagic", "使用魔法石升级技能，技能会更强大"],
["magicStoneLevel", "[NAME]提升技能到[LEV0]等级, 成功概率[POS0]%"],
["sucUpgradeSkill", "恭喜，技能升级成功！"],
["failUpgradeSkill", "抱歉，技能升级失败！"],
["selTarget", "选择施法敌方士兵"],
["selOurSol", "选择我方士兵"],
["selMulti", "选择施法区域"],
["selRow", "选择施法所在行"],


[ "skills0" , ["红色冲击波", "0"]],
[ "skills1" , ["蓝色冲击波", "0"]],
[ "skills2" , ["刀气", "0"]],
[ "skills3" , ["火球", "0"]],
[ "skills4" , ["火焰雨", "0"]],
[ "skills5" , ["闪电", "0"]],
[ "skills6" , ["流星", "0"]],
[ "skills7" , ["流星雨", "0"]],
[ "skills8" , ["眩晕", "0"]],
[ "skills9" , ["拯救", "0"]],
[ "skills10" , ["单体治疗", "0"]],
[ "skills11" , ["群体治疗", "0"]],
[ "skills12" , ["龙变身", "0"]],
[ "skills13" , ["火人变身", "0"]],
[ "skills14" , ["熊变身", "0"]],
[ "skills15" , ["凤凰变身", "0"]],

["heroSkillNum", "该英雄目前最多只能学习[MAXNUM]个技能，剩余[LEFTNUM]个技能点。"],
["heroSkillCountNot", "英雄剩余技能点不足，转职可以增加技能点"],
["heroLevelNot", "需要英雄等级[LEV]才能学习该技能"],
["noTip", "1.士兵佩戴高等级装备闯关更轻松\n2.闯关时英雄可以使用技能\n3.可以使用加生命值上限，加攻击，加防御力药水(生命值，复活药水除外)"],
["roundTip", "闯关诀窍"],
["selectSol", "选择士兵"],
["dragSol", "([NAME])拖动士兵到指定位置"],
["solAtt", "生命值:[HEAL]/[BOUNDARY]\n物理攻击力:[PATTACK]\n物理防御力:[PDEFENSE]\n魔法攻击力:[MAGATT]\n魔法防御:[MAGDEF]\n攻击范围:[RANGE]\n攻击速度:[SPEED]\n经验:[EXP]/[NEEDEXP]\n等级:[LEV]"],
]);


