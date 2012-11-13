class SoldierGoods extends MyNode
{
    //var goodNum;
    var flowNode;
    var lastPoints;
    var store;
    var cl;

    var data;

    const INIT_X = 271;
    const INIT_Y = 147;
    const offX = 166;
    const offY = 206;
    const WIDTH = 479;
    const HEIGHT = 319;
    const PAN_PER_ROW = 3;
    const ROW_NUM = 2;

    const PAN_WID = 149;
    const PAN_HEI = 189;

    function SoldierGoods(s)
    {
        store = s;
        bg = node();
        init();
        cl = bg.addnode().size(WIDTH, HEIGHT).pos(INIT_X, INIT_Y).clipping(1);
        data = store.data;
        flowNode = cl.addnode();

        updateTab();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }

    //进入场景的时候再updateTab 保证看到黑色框 不被对话框遮挡
    //完全克隆一个虚假的 view 或者 控制所有view 的touch
    override function enterScene()
    {
        super.enterScene();
        //global.msgCenter.registerCallback(CALL_SOLDIER, this);
        //updateTab();
    }
    override function exitScene()
    {
        //global.msgCenter.removeCallback(CALL_SOLDIER, this);
        super.exitScene();
    }
    /*
    根据移动的位置 计算需要显示的范围 预先显示额外的上下两行
    0-325
    */
    function getShowRange()
    {
        var p = flowNode.pos();
        var upRow = -p[1]/offY;
        var lowRow = (-p[1]+HEIGHT+offY-1)/offY;
        var rows = (len(data)+PAN_PER_ROW-1)/PAN_PER_ROW;
        return [max(0, upRow-ROW_NUM), min(lowRow+ROW_NUM, rows)];
    }
    /*
    两种思路， 每次移动结束更新状态
    移动过程中， 每次检测，对于溢出的进行删除，没有显示的进行补偿显示
    */
    var firstSolPanel = null;
    function updateTab()
    {
        firstSolPanel = null;
        var rg = getShowRange();
        
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);
        var userLevel = global.user.getValue("level");
        var panel = sprite("goodPanel.png");
        var pSize = panel.prepare().size();

        for(var i = rg[0];  i < rg[1]; i++)
        {
            var curY = i*offY;
            for(var j = 0; j < PAN_PER_ROW; j++)
            {
                var curNum = i*PAN_PER_ROW+j;
                if(curNum >= len(data))
                {
                    break;
                }

                panel = sprite("goodPanel.png").pos(j*offX+PAN_WID/2, curY+PAN_HEI/2).anchor(50, 50);
                var zOrd = 0;
                if(curNum == 0)
                {
                    zOrd = 3;
                    firstSolPanel = panel;
                }
                flowNode.add(panel, zOrd);

                var sca = getSca(panel, [PAN_WID, PAN_HEI]);
                panel.scale(sca);

                var id = data[curNum];
                var sData = getData(SOLDIER, id);
                var cost = getCost(SOLDIER, id);

                var needLevel = sData.get("level");
                var canBuy = 1;
                if(needLevel > userLevel)
                {
                    canBuy = 0;
                }
                //123 92
                var sol;
                if(canBuy == 0)
                {
                    sol = panel.addsprite("soldier"+str(id)+".png", BLACK).pos(83, 110).anchor(50, 50);
                    //panel.addsprite("roleLevel.png").pos(18, 39).anchor(50, 50);
                    //panel.addsprite("roleLock.png", 1).pos(14, 127).anchor(50, 50);

                    panel.addsprite("storeShadow.png").anchor(0, 0).pos(0, 0).size(151, 191).color(100, 100, 100, 47);
                    //panel.addlabel(str(needLevel+1), "fonts/heiti.ttf", 18).pos(18, 39).anchor(50, 50).color(0, 0, 0);

                    var cw = colorWordsNode(getStr("levelNot", ["[LEVEL]", str(needLevel)]), 20, [100, 100, 100], [0, 100, 0]);
                    cw.anchor(50, 50).pos(75, 97);
                    panel.add(cw); 
                }
                else
                    sol = panel.addsprite("soldier"+str(id)+".png").pos(83, 110).anchor(50, 50);

                var sSca = getSca(sol, [120, 100]);
                sol.scale(sSca);
                
                var picCost = cost.items();
                if(len(picCost) > 0)
                {
                    var picName = picCost[0][0]+".png";
                    var valNum = picCost[0][1];
                    var buyable = global.user.checkCost(cost);
                    var c = [100, 100, 100];
                    if(buyable.get("ok") == 0)
                    {
                        c = [100, 0, 0];
                    }
                    /*
                    消耗图片采用 消耗资源的名字
                    消耗数值 
                    */
                    var cPic = panel.addsprite(picName).pos(35, 189).anchor(50, 50).size(30, 30);  
                    var cNum = panel.addlabel(str(valNum), "fonts/heiti.ttf", 18).pos(95, 188).anchor(50, 50).color(c[0], c[1], c[2]);
                }
                panel.addlabel(sData.get("name"), "fonts/heiti.ttf", 20).pos(pSize[0] / 2, 25).anchor(50, 50).color(0, 0, 0);
                panel.put([id, canBuy]);
            }
        }

        if(firstSolPanel != null)
        {
            global.taskModel.showHintArrow(firstSolPanel, firstSolPanel.prepare().size(), CALL_SOLDIER);
        }

    }
    /*
    切换tab 更新面板 更新物品信息
    */
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
    function moveBack(dify)
    {
        var oldPos = flowNode.pos();
        flowNode.pos(oldPos[0], oldPos[1]+dify);
    }
    var accMove = 0;
    function touchMoved(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        var oldPoints = lastPoints;
        lastPoints = newPos;
        var dify = lastPoints[1] - oldPoints[1];
        accMove += abs(dify);
        moveBack(dify);
    }
    /*
    物品选择面板包含物品选择框类型和选择编号 以及物品需要的等级条件是否满足的信息
    移动结束更新面板数据
    */

    function solNotEnough()
    {
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
        var child = null;
        if(accMove < 10)
        {
            child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                var idCan = child.get(); 
                store.setSoldier(idCan);

            }
        }

        var curPos = flowNode.pos();
        var rows = (len(data)+PAN_PER_ROW-1)/PAN_PER_ROW;
        rows = -rows*offY+HEIGHT;
        curPos[1] = max(rows, min(0, curPos[1]));
        flowNode.pos(curPos);
        updateTab();
        
        //if(child != null)
        store.showHintArrow();
    }
}
