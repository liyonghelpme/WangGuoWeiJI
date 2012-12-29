//进入新的场景的对话框 需要关闭自身 因为其他场景可能 会修改状态 
//而退出场景之后没有同步数据 会导致不一致
class AllSoldier extends MyNode
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
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("sureToSell", ["[NUM]", str(cost.get("silver", 0))]), [100, 100, 100], null));
            }
            else
            {
                selled = 0;
                var busiSol = new BusiSoldier(null, getData(SOLDIER, id), soldier[1], soldier[0]);//privateData sid
                busiSol.sureToSell();

                showMultiPopBanner(cost);
            }
        }
    }
    //var skillBut;
    //var sellBut;
    function AllSoldier(d)
    {
        dialog = d;
        bg = node();
        init();
        initData();
        var but0;
        
        but0 = new NewButton("solEquip.png", [48, 46], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], onEquip, null);
        but0.bg.pos(60, 431);
        addChild(but0);

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
                var level = getCareerLev(id);

                var solPic = panel.addsprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 50).pos(80, 98);
                var sca = getSca(solPic, [125, 96]);
                solPic.scale(sca);

                panel.addlabel(name, "fonts/heiti.ttf", 20).anchor(50, 50).pos(80, 25).color(28, 15, 4);


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
        //skillBut.removeSelf();
        //sellBut.removeSelf();


        if(soldier != null)
        {
            var id = soldier[1]["id"];
            load_sprite_sheet("soldierm"+str(id)+".plist");
            var monAni = infoNode.addsprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 50).pos(132, 175);
            var sca = getSca(monAni, [158, 137]);
            monAni.scale(sca);

            var sData = getData(SOLDIER, id);
            /*
            if(sData["isHero"] == 1)
                addChild(skillBut);
            else
                addChild(sellBut);
            */

            var act;
            act = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
            monAni.addaction(act);

            var busiSol = new BusiSoldier(null, sData, soldier[1], soldier[0]);//privateData sid

            var healthBoundary = busiSol.healthBoundary;

            var line = stringLines(getStr("allSolDes", ["[NAME]", busiSol.myName, "[CAREER]", busiSol.data["name"], "[ATTKIND]", getStr(SOL_CATEGORY[busiSol.data["kind"]], null), "[ATT]", str(busiSol.attack), "[DEF]", str(busiSol.defense), "[HEALTH]", str(healthBoundary)] ), 15, 20, [100, 100, 100], FONT_NORMAL );
            line.pos(47, 275);
            infoNode.add(line);
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

    function onDrug()
    {
        if(soldier != null)
        {
            var id = soldier[1]["id"];
            //无法更新非加入场景的对象的数据
            var busiSol = new BusiSoldier(null, getData(SOLDIER, id), soldier[1], soldier[0]);//privateData sid
            global.director.pushView(new DrugDialog(busiSol, DRUG), 1, 0);
        }
    }
    function onEquip()
    {
        if(soldier != null)
        {
            var id = soldier[1]["id"];
            var busiSol = new BusiSoldier(null, getData(SOLDIER, id), soldier[1], soldier[0]);//privateData sid
            global.director.pushView(new DrugDialog(busiSol, EQUIP), 1, 0);
        }
    }
    //更新士兵状态
    function onTrain()
    {
        if(soldier != null)
        {
            global.director.popView();
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
