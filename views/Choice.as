class Choice extends MyNode
{
    var back; 
    var flowTab;
    var lastPoints;
    var tabArray;
    var choose;

    const TabNum = 50;
    const Height = 80;
    const BackHei = 377; 
    const Extra = 5;
    const InitOff = 190;

    function Choice(b)
    {
        back = b;
        bg = node().pos(26, 77).size(204, 377).clipping(1);
        init();
        flowTab = node().pos(0, InitOff-Height*2);
        bg.add(flowTab);

        var shadow = sprite("shadow.png", ARGB_8888);
        bg.add(shadow, 2, 2);

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMove);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
        tabArray = [];
        getTabs();
    }
    function touchBegan(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);    
        lastPoints = newPos;
    }
    function moveBack(dify)
    {
        var oldPos = flowTab.pos();
        flowTab.pos(oldPos[0], oldPos[1]+dify); 
    }
    function touchMove(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);    
        var oldPos = lastPoints;
        lastPoints = newPos;
        var dify = lastPoints[1] - oldPos[1];
        moveBack(dify);

        var curPos = flowTab.pos();
        var selected = (curPos[1]-InitOff)/Height;
        selected = max(min(0, selected), -(TabNum-1));
        setTabs(-selected);
    }
    function setTabs(sel)
    {
        trace("sel", sel);
        for(var i = 0; i < len(tabArray); i++)
        {
            if(tabArray[i][1] == sel)
            {
                tabArray[i][0].texture("goodGreen.png");
            }
            else
            {
                if(tabArray[i][1]%2 == 0)
                    tabArray[i][0].texture("goodWhite.png");
                else
                    tabArray[i][0].texture("goodYellow.png");
            }
        }
            
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var curPos = flowTab.pos();
        var k = (curPos[1]-InitOff)/Height;
        k = max(min(0, k), -(TabNum-1));
        flowTab.pos(curPos[0], InitOff+Height*k);
        getTabs();
    }

    function checkIn(start, end)
    {
        var i;
        var first;
        var t;
        var curPos = flowTab.pos();
        var selected = -(curPos[1]-InitOff)/Height;
        for(i = 0; i < len(tabArray); i++)
        {
            tabArray[i][0].removefromparent();
        }
        for(i = start; i < end; i++)
        {
            if(i == selected)
                t = sprite("goodGreen.png").pos(0, i*Height).anchor(0, 50);
            else
            {
                if(i%2 == 0)
                    t = sprite("goodWhite.png").pos(0, i*Height).anchor(0, 50);
                else
                    t = sprite("goodYellow.png").pos(0, i*Height).anchor(0, 50);
            }
            tabArray.append([t, i]);
            flowTab.add(t);
        }
    }
    function getTabs()
    {
        var curPos = flowTab.pos();
        var start = max(-curPos[1]/Height-Extra, 0);
        var end = min((-curPos[1]+BackHei)/Height+Extra, TabNum);
        checkIn(start, end);
    }
}
