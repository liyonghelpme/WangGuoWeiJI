class SoldierStore extends MyNode
{
    var scene;
    var flowNode;
    var cl;
    const OFFX = 215;
    const ITEM_NUM = 3;
    const WIDTH = OFFX*ITEM_NUM;
    //const HEIGHT = 300;
    const INIT_X = 96;
    const INIT_Y = 148;

    //kind id

    var data = [0, 1, 2, 3, 10, 11, 12, 13, 20, 21, 22, 23, 30, 31, 32, 33, 40, 41, 42, 43, 50, 51, 52, 53, 60, 61, 62, 63, 70, 71, 72, 73, 80, 81, 82, 83, 90, 91, 92, 93, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190];


    var silverText;
    var goldText;
    var cryText;
    var roleLeft;
    var roleRight;
    /*
    scene 是用于处理相关请求的commander
    负责在不同的view 之间进行协调

    flowNode 移动的距离 条目数量需要变动
    */
    function SoldierStore(s)
    {
        scene = s;
        bg = sprite("soldierBack.png");
        init();
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, PAN_HEIGHT+10).clipping(1);

        flowNode = cl.addnode();
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        roleRight = bg.addsprite("roleArr.png").anchor(50, 50).pos(760, 254).size(40, 60);
        new Button(roleRight, moveFlow, -1);
        roleLeft = bg.addsprite("roleArr.png").anchor(50, 50).pos(40, 254).scale(-100, 100).size(40, 60);
        new Button(roleLeft, moveFlow, 1);
        updateTab();
        initData();

        cl.setevent(EVENT_TOUCH, touchBegan);
        //cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

    }
    function moveFlow(param)
    {

        var cols;
        var curPos = flowNode.pos();
        if(param == 1)
        {
            curPos[0] += OFFX*ITEM_NUM;
        }
        else
        {
            curPos[0] -= OFFX*ITEM_NUM;
        }

        cols = -len(data)*OFFX+WIDTH;
        curPos[0] = max(cols, min(0, curPos[0]));
        trace("moveFlow", param, curPos[0], cols);
        flowNode.pos(curPos);
        updateTab();
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function initData()
    {
        silverText = bg.addlabel(str(global.user.getValue("silver")), null, 18).anchor(0, 50).pos(324, 40).color(100, 100, 100);
        goldText = bg.addlabel(str(global.user.getValue("gold")), null, 18).anchor(0, 50).pos(481, 40).color(100, 100, 100);
        cryText = bg.addlabel(str(global.user.getValue("crystal")), null, 18).anchor(0, 50).pos(625, 40).color(100, 100, 100);
        updateValue(global.user.resource);
    }
    override function enterScene()
    {
        super.enterScene();
        global.user.addListener(this);
    }
    override function exitScene()
    {
        global.user.removeListener(this);
        super.exitScene();
    }
    //MAX 0 MIN 
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowCol = -curPos[0]/OFFX;
        var upCol = (-curPos[0]+WIDTH+OFFX-1)/OFFX;
        var colNum = len(data);
        return [max(0, lowCol-1), min(colNum, upCol+1)];
    }
    function updateValue(res)
    {
        silverText.text(str(res.get("silver")));
        goldText.text(str(res.get("gold")));
        cryText.text(str(res.get("crystal")));
    }
    function updateArr()
    {
        var oldPos = flowNode.pos();
        var cols = -len(data)*OFFX+WIDTH;
        trace("updateArr", oldPos, cols);
        if(oldPos[0] >= 0)
        {
            roleLeft.texture("roleArr.png", GRAY);
        }
        else
        {
            roleLeft.texture("roleArr.png");
        }
        if(oldPos[0] <= cols)
        {
            roleRight.texture("roleArr.png", GRAY); 
        }
        else
        {
            roleRight.texture("roleArr.png"); 
        }
    }
    const PAN_WIDTH = 181;
    const PAN_HEIGHT = 235;
    function updateTab()
    {
        updateArr();

        var colNum = len(data);
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos).size(WIDTH*colNum, PAN_HEIGHT);

        var rg = getRange();
        var userLevel = global.user.getValue("level");
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var sca = PAN_WIDTH*100/153;
            var panel = flowNode.addsprite("goodPanel.png").size(153, 182).pos(i*OFFX, 0).scale(sca);
            var id = data[i];
            var data = getData(SOLDIER, id);
            var cost = getCost(SOLDIER, id);
            trace("updateTab", data, cost);
            var needLevel = data.get("level");
            var canBuy = 1;
            if(needLevel > userLevel)
            {
                canBuy = 0;
            }
            //123 92
            var sol;
            if(canBuy == 0)
            {
                sol = panel.addsprite(replaceStr(KindsPre[SOLDIER], ["[ID]", str(id)]), BLACK).pos(76, 90).anchor(50, 50);
                panel.addsprite("roleLevel.png").pos(18, 39).anchor(50, 50);
                panel.addlabel(str(needLevel), null, 18).pos(18, 39).anchor(50, 50).color(0, 0, 0);
                panel.addsprite("roleLock.png", 1).pos(14, 127).anchor(50, 50);
            }
            else
                sol = panel.addsprite(replaceStr(KindsPre[SOLDIER], ["[ID]", str(id)])).pos(76, 90).anchor(50, 50);

            sol.prepare();
            var bSize = sol.size();
            var bl = min(120*100/bSize[0], 90*100/bSize[1]);
            bl = min(120, max(40, bl));
            sol.scale(bl);

            var picCost = cost.items();
            //trace("buildCost", cost);
            if(len(picCost) > 0)
            {
                var picName = picCost[0][0]+".png";
                var valNum = picCost[0][1];
                var buyable = global.user.checkCost(cost);
                var c = [100, 100, 100];
                if(buyable.get("ok") == 0)
                {
                    c = [100, 0, 0];
                    //canBuy = 0;
                }
                /*
                消耗图片采用 消耗资源的名字
                消耗数值 
                */
                var cPic = panel.addsprite(picName).pos(35, 165).anchor(50, 50);  
                var cNum = panel.addlabel(str(valNum), null, 18).pos(88, 162).anchor(50, 50).color(c[0], c[1], c[2]);

            }
                
            /*
            canBuy 只表示等级是否足够
            */
            panel.addlabel(data.get("name"), null, 20).pos(71, 25).anchor(50, 50).color(0, 0, 0);
            panel.put([id, canBuy]);
        }

        trace("finish update Tab");
    }
    var lastPoints;
    function touchBegan(n, e, p, x, y, points)
    {
        accMove = 0;
        lastPoints = n.node2world(x, y);
    }
    function moveBack(difx)
    {
        var curPos = flowNode.pos();
        curPos[0] += difx;
        flowNode.pos(curPos);
    }
    var accMove;
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0]-oldPos[0];
        moveBack(difx);
        accMove += abs(difx);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                var idCan = child.get(); 
                if(idCan[1] == 1)//等级足够显示职业介绍
                {
                    global.director.pushView(new ProfessionIntroDialog(this, idCan[0]), 1, 0);
                }
                //等级不足不做响应

                //var cost = getCost(SOLDIER, idCan[0]);
                //var buyable = global.user.checkCost(cost);
                /*
                资源和等级 满足条件
                soldierId  canBuy
                */
                /*
                if(buyable.get("ok") == 0)
                {
                    var resB = new ResourceBanner(buyable, 412, 255);
                    addChildZ(resB, 1);
                }
                else if(idCan[1] == 1)
                {
                    scene.buySoldier(idCan[0]);
                    var sucB = new SucBanner();
                    sucB.setPos([412, 255]);
                    addChildZ(sucB, 1);
                }
                */
            }
        }
        var curPos = flowNode.pos();
        var cols = -len(data)*OFFX+WIDTH;
        curPos[0] = max(cols, min(0, curPos[0]));
        flowNode.pos(curPos);
        updateTab();
    }
    function buySoldier(id)
    {
        var cost = getCost(SOLDIER, id);
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            var resB = new ResourceBanner(buyable, 412, 255);
            addChildZ(resB, 1);
            return;
        }

        scene.buySoldier(id);
        var sucB = new SucBanner();
        sucB.setPos([412, 255]);
        addChildZ(sucB, 1);

        var curPos = flowNode.pos();
        var cols = -len(data)*OFFX+WIDTH;
        curPos[0] = max(cols, min(0, curPos[0]));
        flowNode.pos(curPos);
        updateTab();
    }
}
