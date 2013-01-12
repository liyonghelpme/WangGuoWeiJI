class CallSoldier extends MyNode
{
    var monAni = node(); 
    var infoLabel = node();
    var blueButton = null;
    var callNum = null;
    var redButton = null;
    var goods;

    var scene;
    function CallSoldier(s)
    {
        scene = s;
        initView();
    }

    var silverText;
    var goldText;
    var cryText;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        temp = bg.addsprite("moneyBack.png").anchor(0, 0).pos(274, 27).size(450, 33).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        temp = bg.addsprite("rightBack.png").anchor(0, 0).pos(252, 77).size(518, 391).color(100, 100, 100, 100);
        temp = bg.addsprite("leftBack.png").anchor(0, 0).pos(32, 77).size(201, 390).color(100, 100, 100, 100);
        temp = bg.addsprite("infoBack.png").anchor(0, 0).pos(31, 246).size(203, 160).color(100, 100, 100, 60);
        temp = bg.addsprite("gold.png").anchor(0, 0).pos(439, 28).size(31, 30).color(100, 100, 100, 100);
        temp = bg.addsprite("crystal.png").anchor(0, 0).pos(586, 30).size(31, 29).color(100, 100, 100, 100);
        temp = bg.addsprite("silver.png").anchor(0, 0).pos(280, 27).size(32, 32).color(100, 100, 100, 100);
        silverText = bg.addlabel(getStr("silver", null), "fonts/heiti.ttf", 23).anchor(0, 50).pos(318, 43).color(100, 100, 100);
        goldText = bg.addlabel(getStr("gold", null), "fonts/heiti.ttf", 23).anchor(0, 50).pos(474, 44).color(100, 100, 100);
        cryText = bg.addlabel(getStr("crystal", null), "fonts/heiti.ttf", 23).anchor(0, 50).pos(621, 44).color(100, 100, 100);
        temp = bg.addsprite("titCamp.png").anchor(0, 0).pos(71, 10).size(174, 62).color(100, 100, 100, 100);
        temp = bg.addsprite("conTitSol.png").anchor(50, 50).pos(514, 112).size(181, 44).color(100, 100, 100, 100);
        goods = new SoldierGoods(this);
        addChild(goods);

        setSoldier([0, 1]);//购买等级是否达标
    }
    function closeDialog()
    {
        global.director.popView();
    }

    function updateValue(res)
    {
        silverText.text(str(res.get("silver")));
        goldText.text(str(res.get("gold")));
        cryText.text(str(res.get("crystal")));
    }
    function update(diff)
    {
        var line;
        var temp;
        var sca;
        var but0;

        infoLabel.removefromparent();
        if(blueButton != null)
            blueButton.removeSelf();
        if(callNum != null)
            callNum.removeSelf();
        if(redButton != null)
            redButton.removeSelf();

        if(curSelSol != null)
        {
            var id = curSelSol[0];
            //var can = curSelSol[1];


            var cost;
            var buyable;
            var soldier = getData(SOLDIER, id);

            var needLevel = soldier.get("level");
            var userLevel = global.user.getValue("level");
            var can = 1;
            if(needLevel > userLevel)
            {
                can = 0;
            }

            var ret = checkInQueue(id);
            //未招募
            if(!ret[0])
            {
                var k = "monDes";
                if(soldier["solOrMon"] == 0)
                    k = "solDes";

                line = stringLines(
                    getStr(k, 
                        ["[NAME]", soldier["name"], 
                        "[ATTKIND]", getStr(SOL_CATEGORY[soldier["kind"]], null), 
                        "[ATT]", str(soldier["attack"]), 
                        "[DEF]", str(soldier["defense"]), 
                        "[HEALTH]", str(soldier["healthBoundary"]), 
                        "[TIME]", str(getDayTime(soldier["time"]))]
                    ), 18, 23, [100, 100, 100], FONT_NORMAL );

                line.pos(47, 261);
                bg.add(line);
                infoLabel = line;

                but0 = new NewButton("blueButton.png", [150, 44], getStr("callSol", null), null, 22, FONT_NORMAL, [100, 100, 100], onCallSol, null);
                but0.bg.pos(130, 435);
                addChild(but0);
                blueButton = but0;

                //cost = getCost(SOLDIER, id);
                //buyable = global.user.checkCost(SOLDIER, cost); 


                if(!can)
                {
                    blueButton.setGray();
                    blueButton.setCallback(null);
                }
            }
            //正在招募
            else
            {
                //var number = scene.objectList[ret[1]][1];
                var num = scene.objectList[ret[1]][1];
                callNum = new ShadowWords("X"+str(num), "fonts/heiti.ttf", 25, FONT_NORMAL, [100, 100, 100]);
                callNum.bg.pos(175, 225).anchor(0, 50);
                addChild(callNum);
                //第一个正在招募的士兵
                if(ret[1] == 0)
                {
                    line = stringLines(
                        getStr("inCalling", ["[NAME]", soldier["name"], "[TIME]", getWorkTime(getLeftTime(ret[1])) ]), 
                            18, 23, [100, 100, 100], FONT_NORMAL );
                    line.pos(130, 326).anchor(50, 50);
                    bg.add(line);
                    infoLabel = line;

                    but0 = new NewButton("violetBut.png", [103, 37], getStr("accCall", ["[KIND]", "gold.png", "[NUM]", str(getAccCost())]), null, 17, FONT_NORMAL, [100, 100, 100], onAccCall, null);
                    but0.bg.pos(177, 435);
                    addChild(but0);
                    redButton = but0;
                    cost = dict([["gold", getAccCost()]]);
                    buyable = global.user.checkCost(cost);
                    if(buyable["ok"] == 0)
                    {
                        redButton.setGray();
                        redButton.setCallback(null);
                    }
                    
                    but0 = new NewButton("blueButton.png", [86, 36], getStr("callOn", null), null, 17, FONT_NORMAL, [100, 100, 100], onCallSol, null);
                    but0.bg.pos(80, 435);
                    addChild(but0);
                    blueButton = but0;

                    if(!can)
                    {
                        blueButton.setGray();
                        blueButton.setCallback(null);
                    }
                }
                //等待招募的士兵
                else
                {
                    line = stringLines(getStr("waitCall", ["[NAME]", soldier["name"], "[TIME]", getWorkTime(getLeftTime(ret[1]))]), 18, 23, [100, 100, 100], FONT_NORMAL );
                    line.pos(131, 326).anchor(50, 50);
                    bg.add(line);
                    infoLabel = line;

                    but0 = new NewButton("blueButton.png", [150, 44], getStr("callOn", null), null, 22, FONT_NORMAL, [100, 100, 100], onCallSol, null);
                    but0.bg.pos(130, 435);
                    addChild(but0);
                    blueButton = but0;

                    //cost = getCost(SOLDIER, id);
                    //buyable = global.user.checkCost(cost);
                    if(!can)
                    {
                        blueButton.setGray();
                        blueButton.setCallback(null);
                    }
                }
            }
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_RESOURCE, this);
        global.msgCenter.registerCallback(CALL_SOL_FINISH, this);
        global.timer.addTimer(this);
        updateValue(global.user.resource);
    }
    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == UPDATE_RESOURCE)
        {
            updateValue(global.user.resource);
        }
        else if(msgId == CALL_SOL_FINISH)
        {
            this.update(0);
            goods.updateTab();
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        global.msgCenter.removeCallback(CALL_SOL_FINISH, this);
        global.msgCenter.removeCallback(UPDATE_RESOURCE, this);
        super.exitScene();
    }
    /*
    士兵在队列里面 显示个数 显示剩余时间
    显示继续招募 显示 加速
    如果在等待队列中 则显示总需要的时间
    
    总人口不足 则不能招募

    不再队列里面 则 普通显示
    正在招募
    等待招募
    */
    function setAnimation()
    {
        var line;
        var temp;
        var but0;
        var sca;
        if(curSelSol != null)
        {
            trace("setAnimation");
            monAni.removefromparent();
            var id = curSelSol[0];
            var can = curSelSol[1];
            var soldier = getData(SOLDIER, id);

            load_sprite_sheet("soldierm"+str(id)+".plist");
            temp = bg.addsprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 50).pos(132, 162).color(100, 100, 100, 100);
            sca = getSca(temp, [184, 154]);
            temp.scale(sca);
            monAni = temp;

            var act;
            if(can == 1)
                act = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
            else
                act = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png", GRAY));
            monAni.addaction(act);
        }
    }
    var curSelSol = null;
    function setSoldier(idCan)
    {
        var line;
        var temp;
        var sca;
        var but0;

        curSelSol = idCan;
        setAnimation();
        this.update(0);
    }
    /*
    加速时间：
        总时间 = needTime * num
        客户端开始时间
        当前时间
        剩余时间 = total - (cur - start)
    */
    function getAccCost()
    {
        var objectList = scene.objectList;
        if(len(objectList) > 0)
        {
            var sData = getData(SOLDIER, objectList[0][0]);
            var total = objectList[0][1]*sData["time"];
            var startTime = scene.funcBuild.objectTime;
            var leftTime =  total - (time()/1000 - startTime);
            return calAccCost(leftTime);
        }
        return 0;
    }

    //等待中总时间
    //已经招募剩余时间
    function getLeftTime(ord)
    {
        var objectList = scene.objectList;
        var id = objectList[ord][0];
        var num = objectList[ord][1];
        var sData = getData(SOLDIER, id);
        if(ord != 0)
            return sData["time"]*num;

        var total = objectList[0][1]*sData["time"];
        var startTime = scene.funcBuild.objectTime;
        var leftTime =  total - (time()/1000 - startTime);
        return leftTime;
    }
    function onAccCall()
    {
        var cost = dict([["gold", getAccCost()]]); 
        var needTime = getLeftTime(0);
        global.httpController.addRequest("buildingC/accCampWork", dict([["uid", global.user.uid], ["bid", scene.bid], ["cost", json_dumps(cost)], ["needTime", needTime]]), null, null);

        global.user.doCost(cost);
        scene.funcBuild.adjustObjectTime(needTime);
        this.update(0);
        goods.updateTab();

        var objectList = scene.objectList;
        if(len(objectList) > 0)
        {
            var solData = getData(SOLDIER, objectList[0][0]);
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("accCampSuc", ["[NAME]", solData["name"]]), [100, 100, 100], null));
        }
    }
    /*
    curSelSol[1] 只是记录 士兵购买等级是否 大于用户等级
    */
    function onCallSol()
    {
        if(curSelSol != null)
        {
            var curSolNum = global.user.getSolNum();
            var campNum = global.user.getCampProductNum();
            curSolNum += campNum;
            trace("curSolNum", curSolNum, campNum);

            var peopleNum = global.user.getPeopleNum();
            
            //士兵人数超出 超出经营最大人数
            //超出人口上限
            if(curSolNum >= getParam("MaxBusiSolNum"))
            {
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("sorrySol", null), [100, 100, 100], null));
                return;
            }
            else if(curSolNum >= peopleNum)
            {
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("buildHouse", null), [100, 100, 100], null));
                return;
            }
  
            var id = curSelSol[0]; 
            var cost = getCost(SOLDIER, id);
            var buyable = global.user.checkCost(cost);
            
            if(buyable["ok"] == 0)
            {
                buyable.pop("ok");
                var it = buyable.items();
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("resLack", ["[NAME]", getStr(it[0][0], null), "[NUM]", str(it[0][1])]), [100, 100, 100], null));
                return;
            }

            global.user.doCost(cost);
            var objectList = scene.objectList;
            if(len(objectList) == 0)
            {
                global.httpController.addRequest("buildingC/campUpdateWorkTime", dict([["uid", global.user.uid], ["bid", scene.bid]]), null, null);
                scene.funcBuild.startWork();
            }
            scene.funcBuild.addSoldier(id);
            this.update(0);
            goods.updateTab();
            global.httpController.addRequest("buildingC/campAddSoldier", dict([["uid", global.user.uid], ["bid", scene.bid], ["solId", id]]), null, null);
        }
    }
    function checkInQueue(id)
    {
        var objectList = scene.objectList;
        for(var i = 0; i < len(objectList); i++)
        {
            var obj = objectList[i];
            if(obj[0] == id)
                return [1, i];
        }
        return [0, -1];
    }
}
