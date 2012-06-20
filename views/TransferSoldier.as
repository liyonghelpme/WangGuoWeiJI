class TransferSoldier extends MyNode
{
    var flowNode;
    const OFFX = 168;
    const OFFY = 165;
    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    const WIDTH = OFFX*ITEM_NUM;
    const HEIGHT = OFFY*ROW_NUM;
    const PANEL_WIDTH = 136;
    const PANEL_HEIGHT = 156;
    const INITX = 72;
    const INITY = 120;
    var data;


    //只是用user的士兵数据 不要和士兵的view 产生关联
    function initTransfer()
    {
        data = [];
        var sol = global.user.soldiers.items();
        //sid kindId name 
        for(var i = 0; i < len(sol); i++)
        {
            var exp = sol[i][1].get("exp");
            var solData = getData(SOLDIER, sol[i][1].get("id"));
            if(exp >= solData.get("needExp"))
                data.append([sol[i][0], sol[i][1].get("id"), sol[i][1].get("name")]);
        }
    }
    function TransferSoldier()
    {
        bg = node().pos(INITX, INITY).size(WIDTH, 321).clipping(1);
        init();
        initTransfer();
        flowNode = bg.addnode();

        updateTab();
        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    var lastPoints;
    var accMove = 0;
    function touchBegan(n, e, p, x, y, points)
    {
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
    /*
    最小位置 当前 最大的行数 * 行偏移 + 总高度
    最大位置 0

    当整体高度小于显示高度的时候 向0 对齐
    */
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                var sid = child.get();
                trace("transfer id", sid);
                global.user.doTransfer(sid);//soldier sid
                initTransfer();
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
        flowNode = bg.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            for(var j = 0; j < ITEM_NUM; j++)
            {
                var curNum = i*ITEM_NUM+j;
                if(curNum >= len(data))
                    break;
                var panel = flowNode.addsprite("soldierPanel.png").pos(j*OFFX, i*OFFY); 
                panel.put(data[curNum][0]);//soldierId

                var oldSize = panel.prepare().size();
                var sca = min(PANEL_WIDTH*100/oldSize[0], PANEL_HEIGHT*100/oldSize[1]);
                panel.scale(sca);

                var id = data[curNum][1];
                var name = data[curNum][2];
                var level = id%10;

                panel.addsprite("soldier"+str(id)+".png").pos(83, 110).anchor(50, 50);
                panel.addlabel(name, null, 30).pos(83, 26).color(0, 0, 0).anchor(50, 50);

                var initX = 33;
                var initY = 186;
                for(var k = 0; k < 4; k++)
                {
                    var filter = WHITE;
                    if(k > level)
                        filter = GRAY;
                    if(k < 3)
                        panel.addsprite("soldierLev0.png", filter).pos(initX, initY).anchor(50, 50);
                    else
                        panel.addsprite("soldierLev1.png", filter).pos(initX, initY).anchor(50, 50);
                    initX += 30;
                }
            }
        }
    }
}
