class DeadSoldier extends MyNode
{
    var dialog;
    var infoNode = null;
    var cl;
    var flowNode;
    const OFFX = 165;
    const OFFY = 210;
    const ITEM_NUM = 3;
    const ROW_NUM = 2;
    const WIDTH = OFFX*ITEM_NUM;
    const HEIGHT = 321;
    const PANEL_WIDTH = 156;
    const PANEL_HEIGHT = 189;
    const INITX = 267;
    const INITY = 145;

    var data;//[sid, {kind name]}] 
    function initData()
    {
        var allSoldiers = global.user.soldiers;
        var its = allSoldiers.items();
        data = [];
        for(var i = 0; i < len(its); i++)
        {
            if(its[i][1]["dead"] == 1)//只有没有阵亡的士兵
                data.append(its[i]);
        }
    }
    var selled = 0;
    function onSell()
    {
        if(soldier != null)
        {
            var id = soldier[1]["id"];
            var cost = getCost(SOLDIER, id);
            cost = changeToSilver(cost);
            if(selled == 0)
            {
                selled = 1;
                global.director.curScene.addChild(new UpgradeBanner(getStr("sureToSell", ["[NUM]", str(cost.get("silver", 0))]) , [100, 100, 100], null));
            }
            else
            {
                selled = 0;
                var busiSol = new BusiSoldier(null, getData(SOLDIER, id), soldier[1], soldier[0]);//privateData sid
                busiSol.sureToSell();

                global.director.curScene.addChild(new PopBanner(cost));//自己控制
            }
        }
    }
    function onRelive()
    {
        if(soldier != null)
        {
            var cost = getReliveCost(soldier[0]);
            var buyable = global.user.checkCost(cost);
            if(buyable["ok"] == 0)
            {
                buyable.pop("ok");
                var it = buyable.items();
                global.director.curScene.addChild(new ResLackBanner(getStr("resLack", ["[NAME]", getStr(it[0][0], null), "[NUM]", str(it[0][1])]) , [100, 100, 100], BUY_RES[it[0][0]], ObjKind_Page_Map[it[0][0]], null));
                return;
            }
            global.user.doCost(cost);
            
            global.httpController.addRequest("soldierC/doRelive", dict([["uid", global.user.uid], ["sid", soldier[0]], ["crystal", cost["crystal"]]]), null, null);
            var id = soldier[1]["id"]; 
            var busiSol = new BusiSoldier(null, getData(SOLDIER, id), soldier[1], soldier[0]);//privateData sid
            busiSol.doRelive();
            global.director.curScene.addChild(new PopBanner(cost2Minus(cost)));//自己控制
        }
    }

    function onDetail()
    {
        if(soldier != null)
        {
            var id = soldier[1]["id"];
            var busiSol = new BusiSoldier(null, getData(SOLDIER, id), soldier[1], soldier[0]);//privateData sid
            global.director.pushView(new DetailDialog(busiSol), 1, 0);
        }
    }
    var reliveLabel;
    var sellBut;
    function DeadSoldier(d)
    {
        dialog = d;
        bg = node();
        init();
        initData();

        var but0 = new NewButton("violetBut.png", [148, 42], getStr("", null), null, 20, FONT_NORMAL, [100, 100, 100], onRelive, null);
        but0.bg.pos(113, 432);
        addChild(but0);
        but0.bg.addsprite("crystal.png").anchor(0, 0).pos(20, 7).size(27, 27).color(100, 100, 100, 100);
        reliveLabel = but0.bg.addlabel(getStr("reliveBut", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(51, 20).color(100, 100, 100);

        sellBut = new NewButton("solSell.png", [34, 43], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], onSell, null);
        sellBut.bg.pos(213, 431);
        //addChild(sellBut);

        but0 = new NewButton("dialogSolDetail0.png", [41, 30], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], onDetail, null);
        but0.bg.pos(209, 378);
        addChild(but0);

        cl = bg.addnode().pos(INITX, INITY).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();
        updateTab();

        if(len(data) > 0)
            setSoldier(0);
        else 
            setSoldier(null);
        
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }

    var lastPoints;
    var accMove = 0;
    var curTouch = null;
    var oldScale;
    var player;
    function touchBegan(n, e, p, x, y, points)
    {
        selled = 0;
        accMove = 0;
        lastPoints = n.node2world(x, y);
        curTouch = checkInChild(flowNode, lastPoints);
        if(curTouch != null)
        {
            oldScale = curTouch.scale();
            curTouch.scale(oldScale[0]*80/100, oldScale[1]*80/100);
            player = global.controller.butMusic.play(0, 80, 80, 0, 100);
        }
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var dify = lastPoints[1]-oldPos[1];

        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);
        accMove += abs(dify);
    }
    /*
    最小位置 当前 最大的行数 * 行偏移 + 总高度
    最大位置 0

    当整体高度小于显示高度的时候 向0 对齐
    */

    function touchEnded(n, e, p, x, y, points)
    {
        if(curTouch != null)
        {
            curTouch.scale(oldScale);
            curTouch = null;
            player.stop();
            player = null;
        }

        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                setSoldier(child.get());
            }
        }
        var curPos = flowNode.pos();
        var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT,curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
    
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    function updateTab()
    {
        var oldPos = flowNode.pos();    
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            for(var j = 0; j < ITEM_NUM; j++)
            {
                var curNum = i*ITEM_NUM+j;
                if(curNum >= len(data))
                    break;

                var panel = flowNode.addsprite("soldierPanel.png").pos(j*OFFX+PANEL_WIDTH/2, i*OFFY+PANEL_HEIGHT/2).size(PANEL_WIDTH, PANEL_HEIGHT).anchor(50, 50); 


                var id = data[curNum][1].get("id");
                var name = data[curNum][1].get("name");
                var level = id%10;

                var solPic = panel.addsprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 50).pos(80, 98).color(60, 60, 60, 100);
                var sca = getSca(solPic, [125, 96]);
                solPic.scale(sca);

                panel.addlabel(name, "fonts/heiti.ttf", 20).anchor(50, 50).pos(80, 25).color(28, 15, 4);

                panel.addsprite("solDead.png").anchor(0, 0).pos(64, 89).size(72, 52).color(100, 100, 100, 100);


                var initX = 23;
                var initY = 159;
                for(var k = 0; k < 4; k++)
                {
                    var filter = WHITE;
                    if(k > level)
                        filter = GRAY;
                    if(k < 3)
                        panel.addsprite("soldierLev0.png", filter).pos(initX, initY);
                    else
                        panel.addsprite("soldierLev1.png", filter).pos(initX, initY);
                    initX += 27;
                }
                panel.put(curNum);
            }
        }
    }
    var soldier = null;
    //bg.addsprite("雪山猿人左.png").anchor(50, 50).pos(132, 175).size(158, 137);
    function setSoldier(sol)
    {
        if(infoNode != null)
            infoNode.removefromparent();
        if(sol != null)
            soldier = data[sol];//[sid [id]] 
        else
            soldier = null;
        infoNode = bg.addnode();
        sellBut.removeSelf();


        if(soldier != null)
        {
            var id = soldier[1]["id"];
            load_sprite_sheet("soldierm"+str(id)+".plist");
            var monAni = infoNode.addsprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 50).pos(132, 175);
            var sca = getSca(monAni, [158, 137]);
            monAni.scale(sca);
            var sData = getData(SOLDIER, id);
            if(sData["isHero"] == 0)
                addChild(sellBut);


            var act;
            act = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
            monAni.addaction(act);

            var busiSol = new BusiSoldier(null, sData, soldier[1], soldier[0]);//privateData sid

            var att = max(busiSol.physicAttack, busiSol.magicAttack);
            var def = max(busiSol.physicDefense, busiSol.magicDefense);
            var healthBoundary = busiSol.healthBoundary;

            var line = stringLines(getStr("allSolDes", ["[NAME]", busiSol.myName, "[CAREER]", busiSol.data["name"], "[LEV]", str(busiSol.level), "[ATTKIND]", getStr(SOL_CATEGORY[busiSol.data["kind"]], null), "[ATT]", str(att), "[DEF]", str(def), "[HEALTH]", str(healthBoundary)] ), 15, 20, [100, 100, 100], FONT_NORMAL );
            line.pos(47, 275);
            infoNode.add(line);
        }
        //reliveLabel = but0.bg.addlabel(getStr("reliveBut", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(51, 20).color(100, 100, 100);

        if(soldier == null)
            reliveLabel.text(getStr("reliveBut", ["[NUM]", str(0)]));
        else
        {
            var cost = getReliveCost(soldier[0]);
            var it = cost.values();
            reliveLabel.text(getStr("reliveBut", ["[NUM]", str(it[0])]));
        }
            
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_SOL, this);
    }

    function receiveMsg(param)
    {
        var mid = param[0];
        if(mid == UPDATE_SOL)
        {
            initData();
            updateTab();
            //有士兵显示第0个 
            //没有士兵 清空显示
            if(len(data) > 0)
                setSoldier(0);
            else 
                setSoldier(null);
        }
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(UPDATE_SOL, this);
        super.exitScene();
    }
}
