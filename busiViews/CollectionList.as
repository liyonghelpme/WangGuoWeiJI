class CollectionList extends MyNode
{
    var data;
    var cl;
    var flowNode;

    const OFFX = 170;//offx
    const OFFY = 183;//offy
    const ITEM_NUM = 4;//in
    const ROW_NUM = 2;//rn
    const WIDTH = 658;
    const HEIGHT = 337;
    const PANEL_HEIGHT = 171;//默认图片大小
    const PANEL_WIDTH = 144;
    const INIT_X = 73;//第一个面板的x y 值
    const INIT_Y = 104;
    const PWID2 = 144;
    const PHEI2 = 156;

    function CollectionList()
    {
        bg = node();
        init();

        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

        initData();
        updateTab();
    }
    //kind Id ---> collectionYet
    function initData()
    {
        data = [[70000, 1], [1, 0], [10002, 0], [20003, 0], [70010, 0], [70011, 0], [70012, 0], [70013, 0], [70020, 0], [70021, 0], [70022, 0], [70023, 0], [70030, 0], [70031, 0], [70032, 0], [70033, 0], [70040, 0], [70041, 0], [70042, 0], [70043, 0], [70050, 0], [70051, 0], [70052, 0], [70053, 0], [70060, 0], [70061, 0], [70062, 0], [70063, 0], [70070, 0], [70071, 0], [70072, 0], [70073, 0], [70080, 0], [70081, 0], [70082, 0], [70083, 0], [70090, 0], [70091, 0], [70092, 0], [70093, 0]];
        
    } 
    var lastPoints;
    var accMove = 0;
    function touchBegan(n, e, p, x, y, points)
    {
        selectNum = -1;
        accMove = 0;
        lastPoints = n.node2world(x, y);
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


    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                selectNum = child.get();
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
    var selectNum = -1;
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

                var kindId = getGoodsKindAndId(data[curNum][0]);
                var kind = kindId[0];
                var id = kindId[1];
                var colYet = data[curNum][1];


                var panel;
                //if(kindId[0] == SOLDIER)
                //    load_sprite_sheet("soldierm"+str(id)+".plist");

                var sca;
                var pic;
                var filter = WHITE;
                if(!colYet)
                    filter = BLACK;
                pic = sprite(replaceStr(KindsPre[kind], ["[ID]", str(id)]), filter).anchor(50, 50).pos(75, 95).color(100, 100, 100, 100);
                sca = getSca(pic, [95, 82]);
                pic.scale(sca);
                var objData = getData(kind, id);

                if(colYet && kindId[0] == SOLDIER && objData["solOrMon"] == 0)
                {
                    panel = flowNode.addsprite("soldierPanel.png").pos(j*OFFX, i*OFFY).size(PANEL_WIDTH, PANEL_HEIGHT); 
                    var initX = 21;
                    var initY = 144;
                    var level = getCareerLev(kindId[1]);
                    for(var k = 0; k < 4; k++)
                    {
                        filter = WHITE;
                        if(k > level)
                            filter = GRAY;
                        if(k < 3)
                            panel.addsprite("soldierLev0.png", filter).pos(initX, initY);
                        else
                            panel.addsprite("soldierLev1.png", filter).pos(initX, initY);
                        initX += 24;
                    }
                }
                else
                {
                    panel = flowNode.addsprite("dialogFriendPanel.png").pos(j*OFFX, i*OFFY).size(PWID2, PHEI2); 
                }
                panel.add(pic);
                panel.addlabel(objData["name"], "fonts/heiti.ttf", 20).anchor(50, 50).pos(74, 23).color(28, 15, 4);


                panel.put(curNum);
                if(curNum == selectNum)
                {
                    showShadow(panel);
                }
            }
        }
    }

    function clearShadow()
    {
        selectNum = -1;
        updateTab();
    }
    function onBuyIt(curNum)
    {
        var kindId = getGoodsKindAndId(data[curNum][0]);
        var kind = kindId[0];
        var id = kindId[1];
        var colYet = data[curNum][1];
        var objData = getData(kind, id);

        if(kind != SOLDIER)
        {
            var st = new Store(global.director.curScene);
            if(objData["kind"] != 2)
                st.changeTab(GOODS_PAGE[kind]);
            else
                st.changeTab(DECOR_PAGE);
                
            global.director.pushView(st, 1, 0);
        }
        else
        {
            var ret = global.msgCenter.checkCallback(CALL_SOL); 
            if(!ret)
            {
                global.director.curScene.addChild(new UpgradeBanner(getStr("noCamp", null) , [100, 100, 100], null));
            }
            else
            {
                global.director.popView();
                global.msgCenter.sendOneMsg(CALL_SOL, id);//招募特定类型士兵
            }
        }
    }
    function showShadow(child)
    {
        var curNum = child.get();
        var kindId = getGoodsKindAndId(data[curNum][0]);
        var kind = kindId[0];
        var id = kindId[1];
        var colYet = data[curNum][1];
        var objdata = getData(kind, id);
        if(colYet)
            return;
        var but0;
        if(kind == SOLDIER)
            but0 = new NewButton("violetBut.png", [92, 35], getStr("callSoldier", null), null, 19, FONT_NORMAL, [100, 100, 100], onBuyIt, curNum);
        else
            but0 = new NewButton("violetBut.png", [92, 35], getStr("buyIt", null), null, 19, FONT_NORMAL, [100, 100, 100], onBuyIt, curNum);
        but0.bg.pos(77, 155);
        child.add(but0.bg); 
    }

}
