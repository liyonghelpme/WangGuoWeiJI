class Name extends MyNode
{
    var data;
    var cl;
    var flowNode;

    const OFFX = [OFFX];//offx
    const OFFY = [OFFY];//offy
    const ITEM_NUM = [ITEM_NUM];//in
    const ROW_NUM = [ROW_NUM];//rn
    const WIDTH = [WIDTH];
    const HEIGHT = [HEIGHT];
    const PANEL_HEIGHT = [PANEL_HEIGHT];//默认图片大小
    const PANEL_WIDTH = [PANEL_WIDTH];
    const INITX = [INITX];//第一个面板的x y 值
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

                var panel = flowNode.addsprite("soldierPanel.png").pos(j*OFFX, i*OFFY).size(PANEL_WIDTH, PANEL_HEIGHT); 

                panel.put(curNum);
            }
        }
    }

}
