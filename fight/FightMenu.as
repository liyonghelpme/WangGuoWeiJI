class FightMenu extends MyNode
{
    var scene;
    var soldier = null;


    //摆擂台
    var black0;
    //var makeArenaWord;
    var makeBut;
    var failWord;

    //点击擂台挑战
    var black1;
    var chaInfo;

    //点击挑战者 应对
    var black2;
    var accInfo;


    var blacks;
    var curBlack = -1;
    
    function onRefresh()
    {
        scene.getOtherArena();
    }
    function onRank()
    {
        global.director.pushView(new RankDialog(FIGHT_RANK), 1, 0);//数据需要从全局中获取
    }
    function onMakeArena()
    {
        if(global.fightModel.myArena == null)
            global.director.pushView(new MakeArenaDialog(scene), 1, 0); 
        else
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("inDefNow", null), [100, 100, 100], null));
    }


    var arenaNum;
    var chaNum;
    function FightMenu(sc)
    {
        scene = sc;
        bg = node();
        init();

        bg.addsprite("map_back0.png", RBINV).size(91, 59).pos(38, 399).anchor(0, 0).setevent(EVENT_TOUCH, returnHome);

        black0 = sprite("storeBlack.png").pos(26, 9).size(463, 82);
        black0.addsprite("fightBlue.jpg").pos(13, 8);
        black0.addsprite("fightRed.jpg").pos(13, 33);

arenaNum = black0.addlabel(getStr("arenaNum", null), "fonts/heiti.ttf", 18, FONT_BOLD).pos(43, 7);
chaNum = black0.addlabel(getStr("chaNum", null), "fonts/heiti.ttf", 18, FONT_BOLD).pos(43, 30);


        var but0 = new NewButton("roleNameBut0.png", [91, 42], getStr("rank", null), null, 20, FONT_BOLD, [100, 100, 100], onRank, null);
        but0.bg.pos([201+45, 22+21]).anchor(50, 50);
        black0.add(but0.bg);


        but0 = new NewButton("blueButton.png", [91, 42], getStr("makeArena", null), null, 20, FONT_BOLD, [100, 100, 100], onMakeArena, null);
        but0.bg.pos([303+45, 22+21]).anchor(50, 50);
        black0.add(but0.bg);
        makeBut = but0;

        var refresh = black0.addsprite("fightRefresh.png").pos(410, 23).setevent(EVENT_TOUCH, onRefresh);
        //如果没有摆擂台则fightGold
failWord = black0.addlabel(getStr("failNum", null), "fonts/heiti.ttf", 16).pos(12, 55).color(55, 94, 49);


        black1 = sprite("storeBlack.png").pos(26, 9).size(463, 82);
chaInfo = black1.addlabel(getStr("chaInfo", null), "fonts/heiti.ttf", 18, FONT_NORMAL, 260, 0, ALIGN_LEFT).pos(13, 24);
        but0 = new NewButton("roleNameBut0.png", [73, 42], getStr("challenge", null), null, 20, FONT_BOLD, [100, 100, 100], onArena, null);
        but0.bg.pos([286+36, 21+21]).anchor(50, 50);
        black1.add(but0.bg);

        but0 = new NewButton("blueButton.png", [73, 42], getStr("cancel", null), null, 20, FONT_BOLD, [100, 100, 100], onCancelArena, null);
        but0.bg.pos([375+36, 21+21]).anchor(50, 50);
        black1.add(but0.bg);


        black2 = sprite("storeBlack.png").pos(26, 9).size(463, 82);
accInfo = black2.addlabel(getStr("accInfo", null), "fonts/heiti.ttf", 18, FONT_NORMAL, 260, 0, ALIGN_LEFT).pos(9, 14);

        but0 = new NewButton("roleNameBut0.png", [91, 42], getStr("accChallenge", null), null, 20, FONT_BOLD, [100, 100, 100], onDefense, null);
        but0.bg.pos([279+45, 20+21]).anchor(50, 50);
        black2.add(but0.bg);

        but0 = new NewButton("blueButton.png", [72, 42], getStr("cancel", null), null, 20, FONT_BOLD, [100, 100, 100], onCancelDefense, null);
        but0.bg.pos([379+36, 20+21]).anchor(50, 50);
        black2.add(but0.bg);

        
        blacks = [black0, black1, black2];
        curBlack = -1;
    }
    function returnHome()
    {
        global.director.popScene(); 
    }
    
    //挑战擂台 资源不足提示黑框
    function onArena()
    {
        var kind = soldier.privateData.get("kind");
        var fData = getData(FIGHT_COST, kind);
        var cost = getCost(FIGHT_COST, kind);

        cost = multiScalar(cost, fData.get("attackCost"));//攻击花费
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            var key = cost.keys()[0];
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("fightNot", ["[NAME]", getStr(key, null)]), [100, 100, 100], null));
        }
        else
        {
            var cs = new ChallengeScene(soldier.privateData.get("uid"), null, 0, 0, CHALLENGE_FIGHT, soldier.privateData);
            global.director.pushScene(cs);
            //global.director.pushView(new LoadChallenge(cs), 1, 0);
            //cs.initData();


            global.user.doCost(cost);
            global.fightModel.addRecord(soldier.privateData.get("uid"));
            setCurChooseSol(null);
            scene.map.updateData();//清理显示的士兵
            //增加挑战记录  删除挑战士兵 全局控制挑战数据 消息传递更新挑战士兵
        }
    }
    function onCancelArena()
    {
        setCurChooseSol(null);
    }

    function onDefense()
    {

        var cs = new ChallengeScene(soldier.privateData.get("uid"), null, 0, 0, CHALLENGE_DEFENSE, soldier.privateData);
        global.director.pushScene(cs);
        //global.director.pushView(new VisitDialog(cs), 1, 0);
        //cs.initData();

        global.fightModel.removeChallenger(soldier.privateData.get("uid")); 
        setCurChooseSol(null);//无论胜负 挑战者都消失
        scene.map.updateData();
    }
    function onCancelDefense()
    {
        setCurChooseSol(null);
    }

    /*
    根新显示菜单
    没有选择士兵
    选择了士兵
    */
    function updateData()
    {
        if(curBlack != -1)
            blacks[curBlack].removefromparent();
        var fData;
        var cost;
        var kind;
        var rk;
        var rv;
        var total;
        var suc;
        if(soldier == null)
        {
            bg.add(black0);
            //没有擂台
            if(global.fightModel.myArena == null)
            {
                makeBut.bg.texture("blueButton.png");
                //makeBut.setevent(EVENT_TOUCH, onMakeArena);
                //makeBut.setCallback(onMakeArena);
                makeBut.word.setWords(getStr("makeArena", null));
                failWord.text(getStr("fightGold", null));
            }
            else 
            {
                makeBut.bg.texture("blueButton.png", GRAY);
                //makeBut.setevent(EVENT_TOUCH, null);
                //makeBut.setCallback(null);
                makeBut.word.setWords(getStr("inDefense", null));
                var leftNum = PARAMS.get("maxFailNum")-global.fightModel.myArena.get("failNum");
                failWord.text(getStr("failNum", ["[NUM]", str(leftNum)]));
            }
            arenaNum.text(getStr("arenaNum", ["[N0]", str(len(global.fightModel.otherArenas))]));
            chaNum.text(getStr("chaNum", ["[N0]", str(len(global.fightModel.challengers))]));
            curBlack = 0;
        }
        //防守
        //["chaInfo", "[NAME]守擂成功率[N0]。挑战费用[N1][KIND]。挑战成功奖励[N2][K2]。"],
        else if(soldier.isArena)
        {
            bg.add(black1);
            kind = soldier.privateData.get("kind");
            cost = getCost(FIGHT_COST, kind);
            fData = getData(FIGHT_COST, kind);

            var attackCost = multiScalar(cost, fData.get("attackCost"));

            var key = attackCost.items()[0][0];
            var value = attackCost.items()[0][1];
                
            var reward = multiScalar(cost, fData.get("attackReward"));
            rk = reward.items()[0][0];
            rv = reward.items()[0][1];
            total = soldier.privateData.get("total");
            suc = soldier.privateData["suc"];
            var r;
            if(total == 0)
                r = 0;
            else 
                r = suc*100/total;
                
            chaInfo.text(getStr("chaInfo", 
                        ["[NAME]", soldier.privateData.get("name"), 
                        "[N0]", str(r),
                         "[N1]", str(value), 
                         "[KIND]", getStr(key, null), 
                         "[N2]", str(rv),
                         "[K2]", getStr(rk, null)]));

            curBlack = 1;
        }
        //进攻
        //["accInfo", "[TIME]内未接受[NAME]挑战将被视为失败，还剩[NUM]次失败次数。守擂成够获得[N1][KIND]奖励"],
        else if(soldier.isArena == 0)
        {
            bg.add(black2);
            var now = time()/1000;
            now = client2Server(now);
            var diff = now - global.fightModel.mostEarlyTime;
            var leftTime = PARAMS.get("failTime")-diff;
            var leftFail = PARAMS.get("maxFailNum")-global.fightModel.myArena.get("failNum");

            kind = global.fightModel.myArena.get("kind");
            fData = getData(FIGHT_COST, kind);
            cost = getCost(FIGHT_COST, kind);
            var defenseReward = multiScalar(cost, fData.get("defenseReward"));
            rk = defenseReward.items()[0][0];
            rv = defenseReward.items()[0][1];

            accInfo.text(getStr("accInfo", 
                ["[TIME]", getWorkTime(leftTime), 
                 "[NAME]", soldier.privateData.get("name"),
                 "[NUM]", str(leftFail),
                 "[N1]", str(rv),
                 "[KIND]", getStr(rk, null)
                ]));
            curBlack = 2;
        }
    }
    function update(diff)
    {
        if(curBlack == 2)//更新 挑战剩余时间
        {
            updateData();
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
        if(scene.initOver == 1)//从挑战场景重新进入 需要更新数据
            updateData();
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    function setCurChooseSol(sol)
    {
        if(soldier != null)
        {
            soldier.clearChoose();
        }
        soldier = sol;
        if(soldier != null)
            soldier.setCurSolFinish();
        updateData();
    }
}
