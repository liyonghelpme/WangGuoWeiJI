var WORDS = dict([
["noTip", "1.士兵佩戴高等级装备闯关更轻松\n2.闯关时英雄可以使用技能\n3.能使用加攻，加生命和加防药水(回血，复活药水除外)"],
["solAtt", "[NAME]\n生命值:[HEAL]/[BOUNDARY]\n物理攻击力:[PATTACK]\n物理防御力:[PDEFENSE]\n魔法攻击力:[MAGATT]\n魔法防御:[MAGDEF]\n攻击范围:[RANGE]\n攻击速度:[SPEED]\n经验:[EXP]/[NEEDEXP]\n等级:[LEV]"],
["welcomeWord", "    黑暗魔法师索伦降临奇迹大陆，企图带领邪恶大军\n占领整个大陆并抢走觊觎已久的王国公主！"],
["selectHero", "1.点击选择英雄\n2.为英雄取名\n3.[NAME]，召集勇士，救出公主！"],
["trainTipLine", "1.每行只能放置一个士兵\n2.练级可以使用技能和所有药水(包括回血药水)\n3.士兵练级建议佩戴高级装备\n4.右边数字表示该行剩余怪兽数量"],
["heartNum", "本周获得好友爱心：[WEEKNUM]\n历史累计爱心数量：[ACCNUM]\n[LEV]级爱心树还需要爱心：[LEFTNUM]"],
["topHeartNum", "本周获得好友爱心：[WEEKNUM]\n历史累计爱心数量：[ACCNUM]\n顶级爱心树"],
["heroDes440", "-进程攻击型英雄\n-天赋技能：变身成龙"],
["heroDes480", "-防御型英雄\n-天赋技能：变身成天熊"],
["heroDes590", "-远程攻击型英雄\n-天赋技能：变身成凤凰"],
["heroDes550", "-魔法型英雄\n-天赋技能：变身成火精灵"],
["fightTip", "1.点击左上摆擂台按钮\n2.点击蓝色名字用户攻击其它擂台\n3.点击红色名字用户防守自己擂台"],
["starLevel", "-             [STAR]\n-需要等级[LEV]"],
["solDes", "士兵(能三次转职)\n[ATTKIND]\n攻击力:[ATT]\n防御力:[DEF]\n生命值:[HEALTH]"],
["heroDes", "英雄(能转职、变身)\n[ATTKIND]\n攻击力:[ATT]\n防御力:[DEF]\n生命值:[HEALTH]"],
["monDes", "雇佣兵(不能转职)\n[ATTKIND]\n攻击力:[ATT]\n防御力:[DEF]\n生命值:[HEALTH]"],
["calling", "正在招募[NAME]\n剩余时间 [TIME]"],
["heartCon", "1.每周一零点刷新爱心榜，排在前列的有大奖哦！\n2.爱心可以促使爱心树成长\n3.邻居可以免费赠送爱心给你\n4.赠送礼物给邻居能获得爱心奖励\n5.帮助好友开宝箱也能获得爱心奖励"],
["loveAcc", "48280b本周累计爱心数量：[N0]\n48280b历史累计爱心数量：[N1]\n48280b爱心树升级还需爱心数量：[N2]\n48280b"],
["liveCon", "48280b爱心榜排名：[N0]\n48280b奖励：[NAME]\na4274c邀请好友赠送你免费爱心吧！"],
["liveTip", "807f7d提示：邻居之间可以免费赠送爱心给对方；\n807f7d赠送礼物开宝箱也能获得爱心"],
["allSolDes", "[NAME]([CAREER])\n[ATTKIND]\n等级:[LEV]\n攻击力:[ATT]\n防御力:[DEF]\n生命值:[HEALTH]"],
["finishTask", "完 成"],
["makeDrugPage", "炼金页面"],
["finTask", "[DO]/[NEED]"],
["needExp", "[EXP]xp"],
["free0", "免费金币"],
["share", "分 享"],
["pageNO", "-[NUM]-"],
["free", "免费"],
["haha", "hah"],
["shareGift", "分享礼物"],
["nextTime", "下一次"],
["challengeGroup", "挑战团体"],
["challengeHero", "挑战英雄"],
["newRank", "新手榜"],
["visit", "访 问"],
["heroRank", "英雄榜"],
["groupRank", "团体榜"],
["collectRole", "再收集[NUM]个人物就可以升级到[LEVEL]"],
["working", "生产中"],
["peopleCapacity", "人口上限+[NUM]"],
["viliDefense", "村庄防御力[NUM]"],
["quitNow", "再次点击退出游戏"],
["resLack", "缺少[NAME][NUM]"],
["glory", "收藏等级"],
["ok", "确 定"],
["cancel", "取 消"],
["rand", "随 机"],
["papaya", "木瓜币"],
["crystal", "水晶"],
["buySuc", "购买成功"],
["silver", "银币"],
["gold", "金币"],
["attack", "攻击力"],
["defense", "防御力"],
["health", "血量"],
["healthAndBoundary", "生命值:[HEALTH]/[BOUND]"],
["levelNot", "需要等级[[LEVEL]]"],
["people", "人口上限"],
["cityDefense", "村庄防御力"],
["accContent", "加速[NAME]需要消耗[NUM]个金币，确定加速?"],
["accTitle", "加速"],
["sellContent", "确认卖出[NAME]?"],
["sellTitle", "确定卖出?"],
["get", "得到"],
["addFriend", "添加好友"],
["chooseBuild", "点击建筑物或士兵进行拖拽"],
["dragBuild", "拖拽建筑物或士兵移动到你想要的位置"],
["mapIsland5", "奇迹雪山"],
["mapIsland4", "奇迹洞穴"],
["mapIsland3", "奇迹之湖"],
["mapIsland2", "奇迹平原"],
["mapIsland1", "奇迹森林"],
["mapIsland0", "奇迹村"],
["mapAll", "奇迹大陆"],
["drugs", "所有药材"],
["herbNot", "药材不足"],
["makeDrug", "炼 药"],
["needLev", "需要等级[[LEV]]"],
["dead", "阵 亡"],
["transfer", "转 职"],
["useIt", "使 用"],
["buyIt", "购 买"],
["unloadIt", "卸 下"],
["nameSol", "士兵命名"],
["transferLev", "下次转职需要的等级：[LEVEL]"],
["attVal", "攻击力：[NUM]"],
["defVal", "防御力：[NUM]"],
["attSpeed", "攻击速度：[LEV]"],
["attRange", "攻击范围：[LEV]"],
["recLife", "回血速度：[LEV]"],
["levVal", "等级：[LEV1]级，还需要[EXP]经验升到[LEV2]级"],
["nextTrans", "转职等级：[CAREER]，下次转职需要等级[LEV]"],
["friGift", "好友礼物"],
["moreGame", "更多游戏"],
["howManyGift", "你有[NUM]份来自好友的礼物"],
["recAll", "接受所有"],
["friSendGift", "[NAME]赠送给你[NUM]个[KIND]"],
["receive", "接 受"],
["download", "下 载"],
["restart", "重新开始"],
["continue", "继 续"],
["tryAgain", "重 试"],
["quit", "退 出"],
["breakReward", "奖励：[GOOD]"],
["levelupSol", "升级士兵："],
["noLevelUp", "没有升级士兵"],
["nameNotNull", "士兵姓名不能为空"],
["solIntro", "[NAME]介绍"],
["sureToBuy", "确定购买"],
["slow", "慢"],
["mid", "中等"],
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
["comeSoon", "即将开启..."],
["resNot", "资源不足"],
["myNameIs", "我是[NAME]"],
["letFight", "让我们战斗吧!"],
["farmTooTitle", "等级不足"],
["farmTooCon", "抱歉，你需要升到第[LEV]级才可以购买更多农田"],
["plantLevel", "种植农作物[NAME]需要等级[LEVEL]"],
["levelNotTitle", "等级不足"],
["phyAtt", "物理攻击：[NUM]"],
["magAtt", "魔法攻击：[NUM]"],
["phyDef", "物理防御：[NUM]"],
["magDef", "魔法防御：[NUM]"],
["physicAttack", "物理攻击"],
["magicAttack", "魔法攻击"],
["physicDefense", "物理防御"],
["magicDefense", "魔法防御"],
["healthBoundary", "生命值上限"],
["eqLevel", "Lv. [LEV]"],
["oneEquipTitle", "装备类型重复"],
["oneEquipCon", "已经拥有一件增加相同属性的装备了！"],
["rewardCry", "奖励水晶[NUM]"],
["rewardGold", "奖励金币[NUM]"],
["newRecord", "新的最高得分[NUM]"],
["challengeScore", "积分增加[NUM]"],
["lostScore", "损失积分[NUM]"],
["nameSame", "士兵名字重复"],
["nameTooLong", "名字太长超过4个汉字或12个字母"],
["solDes0", "solDes0"],
["title0", "title0"],
["des0", "description0"],
["percentHealth", "血量"],
["percentHealthBoundary", "生命值上限"],
["percentAttack", "攻击力"],
["percentDefense", "防御力"],
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
["neiborRequest", "[NAME]请求添加您为邻居. [YEAR]/[MON]/[DAY] [HOUR]:[MIN]"],
["refuse", "拒 绝"],
["showNeibor", "邻 居"],
["showPapaya", "木瓜好友"],
["emptySeat", "空 位"],
["addNeiborMax", "增加邻居上限"],
["accRequestError", "接受请求失败"],
["noUser", "没有这个用户"],
["yourNeiborMax", "你的邻居数超过上限"],
["friNeiborMax", "对方的邻居数超过上限"],
["neiborYet", "你们已经是邻居了"],
["noNeibor", "没有邻居可以访问"],
["noNeiborCon", "没有邻居可以访问"],
["help", "帮 助"],
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
["upgradeMineCon", "该水晶矿每次生产[NUM0], 当前你拥有[NUM1]七彩水晶，确定使用[NUM2]个七彩水晶来升级"],
["colorCrystal", "七彩水晶"],
["mineNotBegin", "等级不足[LEVEL],不能开启水晶矿"],
["solDead", "士兵已经死亡"],
["solDeadCon", "死亡士兵不能转职"],
["equipIt", "佩 戴"],
["upgrade", "升 级"],
["allDrug", "所有药品"],
["sell", "卖 出"],
["viewAll", "查 看"],
["closeAll", "关 闭"],
["netError", "网络异常"],
["netErrorCon", "网络异常，请退出游戏重试，或者忽略该问题，并向我们报告。"],
["buyObj", "购买[NAME]"],
["exp", "经验"],
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
["sendIt", "赠 送"],
["friSendEquip", "[NAME]赠送你一件装备[ENAME]等级[LEVEL]。 [YEAR]/[MON]/[DAY] [HOUR]:[MIN]"],
["friSendOthers", "[NAME]赠送你[ONAME]。[YEAR]/[MON]/[DAY] [HOUR]:[MIN]"],
["skillLevel", "Lv. [LEV]"],
["giveup", "放 弃"],
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
["skills0", "红色冲击波"],
["skills1", "蓝色冲击波"],
["skills2", "刀气"],
["skills3", "火球"],
["skills4", "火焰雨"],
["skills5", "闪电"],
["skills6", "流星"],
["skills7", "流星雨"],
["skills8", "眩晕"],
["skills9", "拯救"],
["skills10", "单体治疗"],
["skills11", "群体治疗"],
["skills12", "龙变身"],
["skills13", "火人变身"],
["skills14", "熊变身"],
["skills15", "凤凰变身"],
["heroSkillNum", "该英雄目前最多只能学习[MAXNUM]个技能，剩余[LEFTNUM]个技能点。"],
["heroSkillCountNot", "抱歉，该英雄目前只能学习[NUM]个技能"],
["heroLevelNot", "需要英雄等级[LEV]才能学习该技能"],
["roundTip", "闯关诀窍"],
["trainTip", "练级诀窍"],
["tips", "提示"],
["selectSol", "点击选择士兵"],
["dragSol", "([NAME])拖动士兵到指定位置"],
["effectLevel", "复活等级小于"],
["unlimit", "无限"],
["dearKing", "  哼哼！尊敬的国王陛下,快把公主交出来吧！"],
["dearSuo", "  索伦！我是不会把公主交给你的！"],
["fightNow", "  勇士们！拿起你们的剑！为了家园，为了尊严！杀死索伦！"],
["battleEnd0", "    王国战败，索伦劫走了公主。故事就此结束了？？？"],
["battleEnd1", "    王国战败，索伦劫走了公主。不，它才刚刚开始..."],
["kingWeBack", "陛下，我们回来了！"],
["rebuildHome", "英雄们！救出公主..."],
["nameLen", "(最多输入4个汉字或12个字母)"],
["nameRepeat", "该姓名已经存在"],
["solNameCareer", "[NAME]([CAREER])"],
["trainSol", "士兵练级"],
["trainSolFast", "练级能快速提升士兵等级"],
["equipDrugFast", "提示：佩戴装备练级速度更快；练级过程中可以使用药水"],
["easy", "简单"],
["difficult", "困难"],
["abnormal", "变态"],
["doubleExp", "双倍经验练级需要话费10金币"],
["doubleExpNow", "双倍经验"],
["generalExp", "普通练级"],
["lack", "缺少[NUM][NAME]"],
["need10Gold", "确定双倍经验升级？"],
["solTrainOver0", "[NAME]经验增加[EXP], 等级提升[LEV]"],
["solTrainOver1", "[NAME]经验增加[EXP], 等级提升[LEV](可以转职)"],
["selTarPos", "点击选择士兵移动位置"],
["buySol", "购买[NAME]来丰富你的军队!"],
["buyEquip", "购买[NAME]来丰富你的装备!"],
["buyBuild", "购买[NAME]来丰富你的装饰！"],
["richThing", "丰富的物品能够吸引更多的好友来你的页面赠送爱心。爱心越多，奖励越丰盛！"],
["loveTree", "[LEV]级[NAME]"],
["moreHeart", "好友赠送的爱心越多，爱心树成长的越快"],
["heartTip", "爱心榜须知"],
["inviteFri", "邀请好友"],
["rank", "排行榜"],
["liveHeart", "第[NUM]周，恭喜你获得了[NUM1]爱心"],
["heartReward0", "你在上周获得了[N0]个爱心，奖励[N1]个水晶。赶快邀请你的好友进入王国危机，给你赠送爱心吧！"],
["heartReward1", "你在上周获得了[N0]个爱心，奖励[N1]个水晶。爱心树还差[N2]个爱心进入下一个阶段。赶快邀请你"],
["heroName", "英雄取名"],
["onFlag", "点击绿色旗子"],
["onVillage", "点击奇迹村"],
["onNotOpen", "该关卡未解锁"],
["career0", "初级"],
["career1", "中级"],
["career2", "高级"],
["career3", "圣级"],
["expToLev", "[EXP]xp to level [LEV]"],
["nameLev", "[NAME]([LEV])"],
["accChallenge", "接受挑战"],
["accInfo", "[TIME]小时内未接受[NAME]挑战将被视为失败，还剩[NUM]次失败次数。守擂成够获得[N1]"],
["chaInfo", "[NAME]守擂成功率[N0]%。挑战费用[N1][KIND]。挑战成功奖励[N2][K2]。"],
["challenge", "挑 战"],
["arenaNum", "[N0]个擂主"],
["chaNum", "[N0]个挑战者"],
["makeArena", "摆擂台"],
["inDefense", "守擂中"],
["failNum", "守擂失败次数还剩：[NUM]次"],
["fightGold", "格斗能够快速获得水晶金币"],
["arenaHigh", "擂台等级越高，守擂成功奖励越高！"],
["arenaReward", "[NAME]每次守擂成功将会获得[NUM][KIND]奖励，有[N1]次守擂失败机会。"],
["inDefNow", "正在守擂中..."],
["arena0", "普通擂台"],
["arena1", "中等擂台"],
["arena2", "高等擂台"],
["arena3", "精英擂台"],
["costNum", "[NUM][KIND]"],
["arenaTip", "摆擂台是快速获得水晶和金币的一种方式哦！"],
["fightNot", "[NAME]不足"],
["attackRank", "挑战榜"],
["defenseRank", "守擂榜"],
["noSol", "没有放置士兵"],
["totalStar", "Total [NUM]"],
["condition", "解锁条件:"],
["unlock", "    [gold] 提前解锁"],
["decorInfo0", "[NAME]｜增加[[NUM]]村庄防御力"],
["decorInfo1", "[NAME]｜增加[[NUM]]经验"],
["magicFarm", "[NAME](收获加倍)｜生产倒计时 [[TIME]]"],
["normalFarm", "[NAME]｜生产倒计时 [[TIME]]"],
["mineInfo", "[[LEV]级]水晶矿｜生产倒计时 [[TIME]]"],
["loveInfo", "[[LEV]]爱心树(还需要[[NUM]]颗爱心升到下一等级)"],
["houseInfo", "[NAME]可以容纳[[PEOP]]人"],
["castleInfo", "奇迹村([[LEV]])｜村庄防御力:[[NUM]]"],
["campInfo", "兵营｜[NAME]招募倒计时 [[TIME]]"],
["level", "等级"],
["upgradeHouseTit", "升级民居"],
["upgradeHouseCon", "增加人口[NUM0], 当前民居等级[NUM1]，升级等级[NUM2]，花费[NUM3][KIND]"],
["buildLevel", "[NAME]等级[LEV]"],
["closePhy", "近战物理攻击"],
["farPhy", "远程物理攻击"],
["farMagic", "远程魔法攻击"],
["callSol", "确定招募"],
["accCall", "   [NUM]  加速"],
["ok2", "    确定"],
["sureToAcc", "再次点击确定加速招募｜加速价格为[[NUM]金币]"],
["sureToSell", "再次点击确定卖出｜卖出价格[[NUM]银币]"],
["sureToGenAcc", "再次点击确定加速｜加速价格为[[NUM]金币]"],
["finishCall", "收获士兵"],
["opSuc", "操作成功｜[[NUM][KIND]]"],
["today", "今天"],
["tomorrow", "明天"],
["loginReward", "每天登录奖励"],
["continLogin", "连续登录天数越多，奖励越丰盛哦！"],
["infoFri", "提醒你的好友们来获取每天登录奖励"],
["dayN", "Day [NUM]"],
["rankInfo", "排行须知"],
["Num", "No.[NUM]"],
["loveNum", "爱心数:[NUM]"],
["numWeek", "第[NUM]周"],
["congHeart", "恭喜你本周获得了[NUM]颗爱心"],
["levTree", "[NUM]级爱心树"],
["loveIrrigate", "爱心树需要灌溉爱心才能生长！"],
["buyLoveEquip", "购买爱心装备"],
["loveAccTip", "a4274c每收集100颗爱心奖励1件爱心装备哦！"],
["conLoveUp", "恭喜！你的爱心树升到了第[NUM]级！"],
["loveUp", "爱心树升级"],
["lessGetEquip", "48280b还差[NUM]颗爱心你就将获得[NAME]哦!"],
["lessTip", "807f7d集齐爱心套装，将有意想不到的效果哦！"],
["equipDes", "装备描述"],
["noCamp", "没有空闲兵营无法招募士兵"],
["StoreWord150000", "升级装备"],
["StoreWord150001", "升级装备"],
["StoreWord150002", "升级装备"],
["StoreWord150003", "升级装备"],
["StoreWord160000", "升级技能"],
["StoreWord160001", "升级技能"],
["StoreWord160002", "升级技能"],
["StoreWord1", "产量加倍"],
["StoreWord160003", "升级技能"],
["StoreWord50002", "复活1-7级"],
["StoreWord50012", "复活1-20级"],
["StoreWord50022", "复活1-50"],
["StoreWord50032", "复活无等级限制"],
["StoreAttWordspeople", "人口上限+[NUM]"],
["StoreAttWordscityDefense", "村庄防御力+[NUM]"],
["StoreAttWordsattack", "攻击力+[NUM]"],
["StoreAttWordsdefense", "防御力+[NUM]"],
["StoreAttWordshealth", "血量+[NUM]"],
["StoreAttWordsexp", "经验+[NUM]"],
["StoreAttWordshealthBoundary", "生命值上限+[NUM]"],
["StoreAttWordsphysicAttack", "物理攻击+[NUM]"],
["StoreAttWordsphysicDefense", "物理防御+[NUM]"],
["StoreAttWordsmagicAttack", "魔法攻击+[NUM]"],
["StoreAttWordsmagicDefense", "魔法防御+[NUM]"],
["StoreAttWordspercentHealth", "血量+[NUM]%"],
["StoreAttWordspercentHealthBoundary", "生命值上限+[NUM]%"],
["StoreAttWordspercentAttack", "攻击+[NUM]%"],
["StoreAttWordspercentDefense", "防御+[NUM]%"],
["buySilver", "购买银币"],
["buyCrystal", "购买水晶"],
["buyGold", "购买金币"],
["allSoldier", "所有士兵"],
["deadSoldier", "已阵亡士兵"],
["waitTransfer", "待转职士兵"],
["reliveBut", "[NUM] 复活"],
["transferBut", "[NUM] 转职"],
["conTrans", "恭喜！[NAME]升级为[LEV][CAREER]！"],
["neiborTip", "邻居须知"],
["neibor", "邻居"],
["otherPlayer", "其他玩家"],
["getCrystal", "Get     [NUM]"],
["addPlayerNeibor", "添加玩家为邻居"],
["addSeat", "增加邻居位"],
["addGoldSeat", "[NUM] 提前增加"],
["searchPlayer", "搜索玩家"],
["inputInvite", "输入指定玩家邀请码"],
["inviteFriend", "邀请好友"],
["neiReqSuc", "邻居请求发送成功^_^"],
["invite", "邀请"],
["inviteBut", "邀 请"],
["inviteReward", "每邀请1个木瓜好友都将奖励10个银币"],
["reward10Sil", "奖励10银币"],
["sendSuc", "请求发送成功"],
["notEmpty", "输入不能为空"],
["errorCode", "邀请码错误"],
["noCode", "没有该用户"],
["reqYet", "已经发送过请求"],
["touchRemoveNeibor", "再次点击解除邻居关系"],
["relationBreak", "和[NAME]的邻居关系解除"],
["inviteGame", "[NAME]邀请你加入王国危机"],
["defenseNum", "守擂成功:[NUM]"],
["score", "积分:[NUM]"],
["collectionTip", "收藏须知"],
["callSoldier", "招 募"],
["gloryText", "D+"],
["buyDrug", "购买药水"],
["freeMake", "免费炼制"],
["drugDes", "防御、生命值、攻击药水可以暂时提升士兵基本属性，回血药水能帮助士兵回血"],
["opSucDrug", "操作成功｜[NAME]+[[NUM]][KIND]"],
["equipDialog", "装备可以提升士兵基本属性，集齐套装之后还有附加属性和附加技能哦！"],
["buyEquipBut", "购买装备"],
["freeForge", "免费锻造"],
["seeDetail", "你拥有[NUM]个[NAME],展开查看详细信息"],
["closeDetail", "你拥有[NUM]个[NAME]，点击关闭"],
["giftTip", "送礼须知"],
["openEquip", "你拥有[NUM]个[KIND]，展开查看详细信息"],
["equip", "装备"],
["drug", "药水"],
["material", "材料"],
["closeGift", "你拥有[NUM]个[KIND]，点击关闭"],
["noSuchThing", "没有[NAME]物品"],
["buyGift", "购买礼物"],
["noGift", "抱歉，你当前没有礼物可以赠送"],
["moreSkill", "该英雄目前最多只能学习[NUM]个技能，每次转职都能再多学习一个技能"],
["costBuy", "{[KIND]} [NUM] 购买"],
["clickToBuy", "再次点击确定购买"],
["sendOver", "操作成功｜成功送出[NAME]"],
["forgeTip", "锻造须知"],
["forgePage", "锻造页面"],
["drugTip", "炼药须知"],
["drugPage", "炼药页面"],
["forge", "锻造"],
["doDrug", "炼药"],
["makeSuc", "锻造成功"],
["equipHighLevel", "装备等级越高，附加属性越高哦！"],
["buyTreasure", "购买宝石"],
["stoneHighLevel", "[NAME]最高可以将装备提升到第[NUM]级，确定使用？"],
["sorryNum", "抱歉，你的[NAME]数量不足！"],
["skillPower", "技能等级越高，威力越大！"],
["buyMagic", "购买魔法球"],
["agree", "同 意"],
["timeStr", "[YEAR]/[MON]/[DAY] [HOUR]:[MIN]"],
["robCrystal", "邻居[NAME]挑战成功，抢走[NUM]水晶 [YEAR]/[MON]/[DAY] [HOUR]:[MIN]"],
["sendHeart", "[NAME]赠送你一颗爱心 [YEAR]/[MON]/[DAY] [HOUR]:[MIN]"],
["helpOpen", "[NAME]帮助你打开了宝箱 [YEAR]/[MON]/[DAY] [HOUR]:[MIN]"],
["handled", "已处理"],
["scoreSecTitle", "欢迎为王国危机打分反馈！"],
["feedbackHandle", "你的反馈我们会第一时间处理！此外我们会陆续上线新功能、新人物、技能、装备等"],
["loveGame", "喜欢王国危机吗？"],
["scoreNow", "打分反馈"],
["levelUpShare", "恭喜你升级啦！快与好友分享吧！"],
["levelUp", "升级啦！"],
["transOk", "转职等级：[NAME]，下次转职需要升级到[LEV]级"],
["noTrans", "转职等级：[NAME]，已经到达顶级"],
["warnText", "(不超过4个汉字或12个字母数字)"],
["solName", "为士兵取名"],
["closeDialog", "关闭按钮"],
["systemSetting", "系统设置"],
["sound", "声音设置"],
["developer", "开发者"],
["soundAndMusic", "音效 & 音乐"],
["caesarGameStudio", "凯撒游戏工作室"],
["emailAddress", "联系方式：caesars321@gmail.com"],
["addFreeSeat", "ffffff升到]67e84d[LEV]级\nffffff免费增加"],
["solDetail", "[ATTKIND]：[ATTACK]\n魔法物理防御力：[MAGIC][PHYSIC]\n生命值：[HEALTH]/[HEALTH_BOUNDARY]\n攻击速度：[ATT_SPEED]\n攻击范围：[ATT_RANGE]\n回血速度：[HEAL_SPEED]\n等级：[LEV0]级，还需要[EXP]经验升到[LEV1]级\n[TRANS]"],
["physicAtt", "物理攻击力"],
["magicAtt", "魔法攻击力"],
["tips0", "帮助好友清除士兵状态将能获得免费水晶"],
["tips1", "访问木瓜社区或邀请好友来添加更多邻居！"],
["tips2", "赠送邻居礼物将能获得免费爱心"],
["tips3", "帮助好友开启宝箱将会获得免费爱心"],
["tips4", "挑战邻居成功可以掠夺邻居水晶矿中部分水晶"],
["flying", "飞行中..."],
["fly", "飞行中"],
["friLevel", "等级 [NUM]"],
["friRank", "排名 [NUM]"],
["cantBuild", "当前不能建造"],
["openBox", "开启宝箱"],
["helpFriOpen", "帮助[NAME]开启宝箱吧！"],
["findFriend", "求助好友"],
["helpOpenBox", "帮助开启"],
["helpSuc", "帮助成功"],
["unknown", "???"],
["mistGiftInBox", "宝箱中有什么礼物在等着你哦！"],
["oneGold", "[NUM]金币"],
["openOnePos", "再次点击确定开启一个位置"],
["openNow", "打开"],
["freeHeart", "操作成功｜你赠送给对方[一颗免费爱心:)]"],
["dayOne", "每天只能赠送1颗爱心给对方哦^_^"],
["sureToChallenge", "再次点击确定挑战｜挑战成功奖励[[NUM]颗水晶]"],
["oneChallenge", "每天只能挑战对方1次哦^_^"],
["shareBox", "[NAME]捡到一个神奇的宝箱，帮助Ta开启宝箱获得神秘礼物吧！"],
["mysteriousGift", "神秘礼物"],
["nextBoxRich", "下个宝箱礼物将更加丰富哦！"],
["conForGift", "恭喜你获得了如下礼物："],
["boxReward0", "-- [NUM][KIND]"],
["boxReward1", "-- [NUM]个[KIND]"],
["shareWithFriend", "赶快与好友分享吧！^_^"],
["shareOpenBox", "[NAME]开启了一个神秘宝箱，得到大量礼物，赶快加入王国危机吧！"],
["back", "返 回"],
["inviteRank", "邀请榜"],
["shareInvite", "分享邀请码"],
["inputeInviteCode", "输入邀请码"],
["inviteContent", "1.分享邀请码给好友\n2.好友在新手阶段输入你的邀请码\n3.每成功邀请1个好友奖励[GOLD]金币\n4.你的邀请码是[CODE]"],
["inviteShare", "[NAME]的邀请码是[CODE]，赶快加入王国危机加Ta为好友吧！"],
["inviteError", "邀请码输入错误"],
["inputYet", "抱歉，你已经输入过邀请码了^_^"],
["level3Input", "抱歉，只有[LEV]级内输入邀请码才有效！"],
["noSuchUser", "没有该用户"],
["selfInvite", "这是你自己的邀请码！"],
["inviteSuc", "操作成功｜对方获得10金币奖励"],
["inviteNum", "邀请数[NUM]"],
["dayTask", "每日任务"],
["taskTip", "任务须知"],
["levelStr", "Level"],
["buySth", "购买[NAME]"],
["buyGoods", "购买物品，经营村庄！"],
["buySoldier", "招募勇士，拯救公主！"],
["buySolTitle", "招募[NAME]"],
]);