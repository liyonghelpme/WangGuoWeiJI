class Choice extends MyNode
{
    var store; 
    var flowTab;
    var lastPoints;
    var tabArray;
    var choose;

    var TabNum = 0;
    const Height = 77;
    const ROW_NUM = 5; 
    const BackHei = Height*ROW_NUM; 

    const Extra = 5;
    const InitOff = BackHei/2;


    //bg.addsprite("leftBoard.png").anchor(0, 0).pos(29, 74).size(207, 396);
    function Choice(s)
    {
        store = s;
        TabNum = len(store.allGoods);
        bg = node().pos(33, 78).size(198, BackHei).clipping(1);
        init();
        flowTab = node().pos(0, InitOff-Height*2);
        bg.add(flowTab);

        //var shadow = sprite("shadow.png", ARGB_8888);
        //bg.add(shadow, 2, 2);

        initTabs();
        getTabs();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);

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
    function touchMoved(n, e, p, x, y, points)
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
//        trace("sel", sel);
        for(var i = 0; i < len(tabArray); i++)
        {
            if(tabArray[i][1] == sel)
            {
                tabArray[i][0].texture("greenChoice.png");
            }
            else
            {
                if(tabArray[i][1]%2 == 0)
                    tabArray[i][0].texture("whiteChoice.png");
                else
                    tabArray[i][0].texture("yellowChoice.png");
            }
        }
            
    }
    //0 1 2 3
    function changeTab(sel)
    {
//        trace("changeTab", sel);
        var curPos = flowTab.pos();
        flowTab.pos(curPos[0], InitOff+Height*-sel);
        getTabs();
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var curPos = flowTab.pos();
        var k = (curPos[1]-InitOff)/Height;
        k = max(min(0, k), -(TabNum-1));
        flowTab.pos(curPos[0], InitOff+Height*k);
        getTabs();
    }

    /*
    bg.addsprite("yellowChoice.png").anchor(0, 0).pos(33, 388).size(198, 78);
    bg.addsprite("whiteChoice.png").anchor(0, 0).pos(33, 311).size(198, 78);
    bg.addsprite("greenChoice.png").anchor(0, 0).pos(33, 233).size(198, 79);
    bg.addsprite("whiteChoice.png").anchor(0, 0).pos(33, 156).size(198, 78);
    */
    function initTabs()
    {
        tabArray = [];
        var t;
        for(var i = 0; i < TabNum; i++)
        {
            t = sprite("whiteChoice.png").pos(0, i*Height).anchor(0, 50).size(198, 78);
            t.addsprite(store.pics[i]).pos(0, 0).anchor(0, 0);
            tabArray.append([t, i]); 
            flowTab.add(t);
        }
    }
    function checkIn(start, end)
    {
        var i;
        var first;
        var t;
        var curPos = flowTab.pos();
        var selected = -(curPos[1]-InitOff)/Height;
//        trace("choice", start, end, selected);
        setTabs(selected);
        store.setTab(selected);
    }
    function getTabs()
    {
        var curPos = flowTab.pos();
        var start = max(-curPos[1]/Height-Extra, 0);
        var end = min((-curPos[1]+BackHei)/Height+Extra, TabNum);
        checkIn(start, end);
    }
}
