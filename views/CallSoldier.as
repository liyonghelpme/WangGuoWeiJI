//综合store goods soldier store的元素
class CallSoldier extends MyNode
{
    var stores;

    var allSoldier;

    var silverText;
    var goldText;
    var cryText;
    var scene;

    var monAni;

    var data;
    var goods;
    var info;
    var infoLabel;

    var blueButton;
    function initData()
    {
        data = copy(storeSoldier); 
    }
    function CallSoldier(s)//兵营
    {
        scene = s;
        bg = sprite("back.png");
        init();
        initData();


        bg.addsprite("titleBack.png").anchor(0, 0).pos(38, 10).size(705, 64);
        bg.addsprite("rightBack.png").anchor(0, 0).pos(246, 75).size(523, 393);
        bg.addsprite("leftBack.png").anchor(0, 0).pos(33, 75).size(205, 392);

        bg.addsprite("resBack.png").anchor(0, 0).pos(270, 24).size(454, 37);
        monAni = bg.addnode();
        bg.addsprite("conTitSol.png").anchor(0, 0).pos(386, 90).size(185, 44);
        bg.addsprite("titCamp.png").anchor(0, 0).pos(0, 0);

        
        var close = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        close.bg.pos(772, 27);
        addChild(close);

        info = bg.addnode();
        infoLabel = bg.addnode();

        goods = new SoldierGoods(this);
        
        blueButton = new NewButton("blueButton.png", [150, 44], getStr("callSol", null), null, 18, FONT_NORMAL, [100, 100, 100], onCall, null);
        blueButton.bg.pos(130, 432).anchor(50, 50);
        addChild(blueButton);

        addChild(goods);
        initText();

        if(scene.state == PARAMS["buildWork"])//当前正在工作 显示正在加速的士兵
            setSoldier([scene.getObjectId(), 1]);
        else//显示 默认士兵
            setSoldier([0, 1]);//soldier Id 0 canBuy 1
    }
    //id can
    var curSelSol = null;
    //招募 加速
    function onCall()
    {
        if(curSelSol != null)
        {
            var id = curSelSol[0]; 
            var cost = getCost(SOLDIER, id);
            var buyable = global.user.checkCost(cost);
            trace("curSelSol", curSelSol, cost, buyable, id, scene.bid);

            if(buyable["ok"] == 0)
            {
                buyable.pop("ok");
                var it = buyable.items();
                global.director.curScene.addChild(new UpgradeBanner(getStr("resLack", ["[NAME]", getStr(it[0][0], null), "[NUM]", str(it[0][1])]) , [100, 100, 100], null));
                return;
            }
            global.user.doCost(cost);
            //建筑进入工作状态
            global.httpController.addRequest("buildingC/beginWork", dict([["uid", global.user.uid], ["bid", scene.bid], ["objectKind", SOLDIER], ["objectId", id]]));
            scene.funcBuild.beginWork(id);//进入工作状态
            setSoldier(curSelSol);//更新显示信息
        }
    }
    function setSoldier(idCan)
    {
        accTime = 0;
        curSelSol = idCan;
        monAni.removefromparent();
        info.removefromparent();
        infoLabel.removefromparent();
        blueButton.removeSelf();

        if(curSelSol != null)
        {
            var id = idCan[0];
            var can = idCan[1];

            var soldier = getData(SOLDIER, id);
            
            load_sprite_sheet("soldierm"+str(id)+".plist");
            var act;
            if(can == 1)
                act = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
            else
                act = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png", BLACK));

            monAni = bg.addsprite().anchor(50, 50).pos(135, 177);
            monAni.addaction(act);
            

            info = bg.addsprite("infoBack.png").anchor(0, 0).pos(35, 263).size(201, 134);
            var s;
            var solPure = getSolPureData(id, 0);
            var att = max(solPure["physicAttack"], solPure["magicAttack"]);
            var def = max(solPure["physicDefense"], solPure["magicDefense"]);
                
            //兵营没有工作
            if(scene.state != PARAMS["buildWork"] || id != scene.getObjectId())
            {
                //怪兽
                if(soldier["solOrMon"] == 1)
                {
                    s = stringLines(getStr("monDes", ["[NAME]", soldier["name"], "[ATTKIND]", getStr(SOL_CATEGORY[soldier["kind"]], null), "[ATT]", str(att), "[DEF]", str(def), "[HEALTH]", str(solPure["healthBoundary"])]), 20, 25, [100, 100, 100], FONT_NORMAL );
                }
                //普通士兵
                else if(soldier["isHero"] == 0)
                {
                    s = stringLines(getStr("solDes", ["[NAME]", soldier["name"], "[ATTKIND]", getStr(SOL_CATEGORY[soldier["kind"]], null), "[ATT]", str(att), "[DEF]", str(def), "[HEALTH]", str(solPure["healthBoundary"])]), 20, 25, [100, 100, 100], FONT_NORMAL );
                }
                else
                {
                    s = stringLines(getStr("heroDes", ["[NAME]", soldier["name"], "[ATTKIND]", getStr(SOL_CATEGORY[soldier["kind"]], null), "[ATT]", str(att), "[DEF]", str(def), "[HEALTH]", str(solPure["healthBoundary"])]), 20, 25, [100, 100, 100], FONT_NORMAL );
                }

                infoLabel = s;
                s.pos(47, 275);
                bg.add(infoLabel);
            }
            //兵营工作 显示招募状态
            else if(scene.state == PARAMS["buildWork"] && id == scene.getObjectId())//正在工作 且点击的是当前对象
            {
                s = stringLines(getStr("calling", ["[NAME]", soldier["name"], "[TIME]", getWorkTime(scene.getLeftTime())] ), 20, 25, [100, 100, 100], FONT_NORMAL );
                infoLabel = s;
                s.pos(59, 306);
                bg.add(infoLabel);
            }
            
            if(scene.state != PARAMS["buildWork"])
            {
                blueButton = new NewButton("blueButton.png", [150, 44], getStr("callSol", null), null, 18, FONT_NORMAL, [100, 100, 100], onCall, null);
                if(!can)
                {
                    blueButton.setGray();
                    blueButton.setCallback(null);
                }
            }
            else
            {
                var gold = scene.funcBuild.getAccCost();
                blueButton = new NewButton("violetBut.png", [150, 44], getStr("accCall", ["[NUM]", str(gold)]), null, 18, FONT_NORMAL, [100, 100, 100], onAcc, null);
                blueButton.bg.addsprite("gold.png").anchor(50, 50).pos(21, 25).size(36, 36);
            }
            blueButton.bg.pos(130, 432).anchor(50, 50);
            addChild(blueButton);
        }
    }
    var accTime = 0;
    function onAcc()
    {
        var gold = scene.funcBuild.getAccCost();
        var cost = dict([["gold", gold]]);
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            global.director.curScene.addChild(new UpgradeBanner(getStr("resLack", ["[NAME]", getStr("gold", null), "[NUM]", str(gold)]) , [100, 100, 100], null));
            return;
        }
        if(accTime == 0)
        {
            accTime += 1;
            global.director.curScene.addChild(new UpgradeBanner(getStr("sureToAcc", ["[NUM]", str(gold)]) , [100, 100, 100], null));
            blueButton.word.setWords(getStr("ok2", null));
        }
        else
        {
            accTime = 0;
            //global.user.doCost(cost);
            scene.funcBuild.doAcc();
            global.director.popView();//加速结束后 应该显示收获图标
        }
    }
    function onFinishCall()
    {
        global.director.popView();
        scene.funcBuild.whenBusy();
    }
    function update(diff)
    {
        if(curSelSol != null && scene.state == PARAMS["buildWork"])
        {
            var id = curSelSol[0];
            if(id == scene.getObjectId())
            {
                infoLabel.removefromparent();
                var leftTime = scene.getLeftTime();
                var soldier = getData(SOLDIER, id);

                infoLabel = stringLines(getStr("calling", ["[NAME]", soldier["name"], "[TIME]", getWorkTime(max(leftTime, 0))]), 20, 25, [100, 100, 100], FONT_NORMAL );
                infoLabel.pos(59, 306);
                bg.add(infoLabel);

                if(leftTime <= 0)//可以收获 
                {
                    blueButton.word.setWords(getStr("finishCall", null));
                    blueButton.setCallback(onFinishCall);
                }
                else
                {
                    var gold = scene.funcBuild.getAccCost();
                    blueButton.word.setWords(getStr("accCall", ["[NUM]", str(gold)]));
                }
            }
        }

    }
    function initText()
    {
        silverText = bg.addlabel(str(global.user.getValue("silver")), "fonts/heiti.ttf", 18).anchor(0, 0).pos(621, 37);
        goldText = bg.addlabel(str(global.user.getValue("gold")), "fonts/heiti.ttf", 18).anchor(0, 0).pos(474, 37);
        cryText = bg.addlabel(str(global.user.getValue("crystal")), "fonts/heiti.ttf", 18).anchor(0, 0).pos(318, 36);

    }
    function updateValue(res)
    {
        silverText.text(str(res.get("silver")));
        goldText.text(str(res.get("gold")));
        cryText.text(str(res.get("crystal")));
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_RESOURCE, this);
        global.timer.addTimer(this);
    }
    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == UPDATE_RESOURCE)
        {
            updateValue(global.user.resource);
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        global.msgCenter.removeCallback(UPDATE_RESOURCE, this);
        super.exitScene();
    }

    function closeDialog(n, e, p, x, y, points)
    {
        global.director.popView(); 
    }
}
