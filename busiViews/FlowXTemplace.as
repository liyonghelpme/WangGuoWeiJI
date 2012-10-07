class Name extends MyNode
{
    var data;
    var cl;
    var flowNode;

    const OFFX = [OFFX];
    const OFFY = [OFFY];
    const ITEM_NUM = [ITEM_NUM];
    const ROW_NUM = [ROW_NUM];
    const WIDTH = [WIDTH];
    const HEIGHT = [HEIGHT];
    const PANEL_HEIGHT = [PANEL_HEIGHT];
    const PANEL_WIDTH = [PANEL_WIDTH];
    const INITX = [INITX];
    const INITY = [INITY];

    function Name()
    {
        bg = node();
        init();
        initData();
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();
        updateTab();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

    }
    function initData()
    {
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
        var difx = lastPoints[0]-oldPos[0];

        var curPos = flowNode.pos();
        curPos[0] += difx;
        flowNode.pos(curPos);
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
            }
        }
        var curPos = flowNode.pos();
        var cols = (len(data)+ROW_NUM-1)/ROW_NUM;
        curPos[0] = min(0, max(-cols*OFFX+WIDTH, curPos[0]));
        flowNode.pos(curPos);
        updateTab();
    }
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowCol = -curPos[0]/OFFX;
        var upCol = (-curPos[0]+WIDTH+OFFY-1)/OFFX;
        var colNum = (len(data)+ROW_NUM-1)/ROW_NUM;
        return [max(0, lowCol-ITEM_NUM), min(colNum, upCol+ITEM_NUM)];
    }
    function updateTab()
    {
        var oldPos = flowNode.pos();    
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            for(var j = 0; j < ROW_NUM; j++)
            {
                var curNum = i*ROW_NUM+j;
                if(curNum >= len(data))
                    break;

                var panel = flowNode.addsprite("soldierPanel.png").pos(i*OFFX, j*OFFY).size(PANEL_WIDTH, PANEL_HEIGHT); 

                panel.put(curNum);
            }
        }
    }

}
