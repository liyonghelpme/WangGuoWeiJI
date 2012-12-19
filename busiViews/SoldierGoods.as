class SoldierGoods extends MyNode
{
    var data;
    var cl;
    var flowNode;

    const OFFX = 159;//offx
    const OFFY = 215;//offy
    const ITEM_NUM = 3;//in
    const ROW_NUM = 2;//rn
    const WIDTH = 474;
    const HEIGHT = 323;
    const PANEL_HEIGHT = 188;//默认图片大小
    const PANEL_WIDTH = 149;
    const INIT_X = 272;//第一个面板的x y 值
    const INIT_Y = 146;

    var store;
    function SoldierGoods(s)
    {
        store = s;
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
    function initData()
    {
        data = copy(storeSoldier); 
    } 
    var lastPoints;
    var accMove = 0;

    var curTouch = null;
    var oldScale;
    var player;
    function touchBegan(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        lastPoints = newPos;
        accMove = 0;

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
                var idCan = child.get(); 
                if(idCan[1])//可以购买才点击
                    store.setSoldier(idCan);
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
        var but0;
        var line;
        var temp;
        var sca;
        var oldPos = flowNode.pos();    
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);
        var userLevel = global.user.getValue("level");

        var rg = getRange();

        for(var i = rg[0]; i < rg[1]; i++)
        {
            for(var j = 0; j < ITEM_NUM; j++)
            {
                var curNum = i*ITEM_NUM+j;
                if(curNum >= len(data))
                    break;

                var panel = flowNode.addsprite("goodPanel.png").pos(j*OFFX+PANEL_WIDTH/2, i*OFFY+PANEL_HEIGHT/2).anchor(50, 50).size(PANEL_WIDTH, PANEL_HEIGHT); 

                var id = data[curNum];
                var sData = getData(SOLDIER, id);
                var cost = getCost(SOLDIER, id);
                var picCost = cost.items();
                
                var needLevel = sData.get("level");
                var canBuy = 1;
                if(needLevel > userLevel)
                {
                    canBuy = 0;
                }

                var solPic;
                if(canBuy == 0)
                {
                    solPic = panel.addsprite("soldier"+str(id)+".png", BLACK).anchor(50, 50).pos(73, 95).color(100, 100, 100, 100);
                    temp = panel.addsprite("storeShadow.png").anchor(50, 50).pos(71, 93).size(PANEL_WIDTH, PANEL_HEIGHT).color(100, 100, 100, 47);
                    var cw = colorWordsNode(getStr("levelNot", ["[LEVEL]", str(needLevel+1)]), 20, [100, 100, 100], [0, 100, 0]);
                    cw.anchor(50, 50).pos(78, 92);
                    panel.add(cw); 
                }
                else
                {
                    solPic = panel.addsprite("soldier"+str(id)+".png").anchor(50, 50).pos(73, 95).color(100, 100, 100, 100);
                }
                
                sca = getSca(solPic, [125, 96]);
                solPic.scale(sca);

                var ret = store.checkInQueue(id);
                if(ret[0])
                {
                    if(ret[1] == 0)
                        panel.addlabel(getStr("callingSol", null), "fonts/heiti.ttf", 17).anchor(0, 50).pos(14, 132).color(95, 29, 14);
                    else
                        panel.addlabel(getStr("callInQueue", ["[NUM]", str(ret[1]+1)]), "fonts/heiti.ttf", 17).anchor(0, 50).pos(14, 132).color(43, 25, 9);
                }

                if(len(picCost) > 0 && canBuy)//可以购买
                {
                    var picName = picCost[0][0]+".png";
                    var valNum = picCost[0][1];
                    var buyable = global.user.checkCost(cost);
                    var c = [100, 100, 100];
                    if(buyable.get("ok") == 0)
                    {
                        c = [100, 0, 0];
                    }

                    temp = panel.addsprite(picName).anchor(50, 50).pos(32, 169).size(30, 30).color(100, 100, 100, 100);
                    panel.addlabel(str(valNum), "fonts/heiti.ttf", 20).anchor(50, 50).pos(89, 168).color(c);
                }

                panel.addlabel(sData["name"], "fonts/heiti.ttf", 21).anchor(50, 50).pos(74, 25).color(29, 16, 4);


            
                panel.put([id, canBuy]);
            }
        }
    }

}
