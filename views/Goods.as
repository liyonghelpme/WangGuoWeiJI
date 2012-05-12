class Goods extends MyNode
{
    var goodNum;
    var flowNode;
    var lastPoints;
    var minPos;
    var store;
    var title;
    var cl;

    const offX = 168;
    const offY = 220;

    function Goods(s)
    {
        store = s;
        bg = node().pos(258, 129);
        cl = bg.addnode().size(500, 330).clipping(1);
        title = bg.addlabel("", null, 20).pos(offX/2+offX, 103-129).anchor(50, 50).color(0, 0, 0);
        init();
        goodNum = [];
        flowNode = cl.addnode();
        flowNode.size(0, 0);
        minPos = 0;

    }
    function setTab(g)
    {
        trace(getStr(store.words[g]));
        title.text(getStr(store.words[g]));
        var posX = 0;
        var posY = -offY;

        flowNode.removefromparent();
        flowNode = cl.addnode();

        goodNum = store.allGoods[g];
        for(var i = 0; i < len(goodNum); i++)
        {
            if(i%3 == 0)
            {
                posX = 0;
                posY += offY;
            }
            else
            {
                posX += offX;
            }
            var panel = sprite("goodPanel.png").pos(posX, posY);
            flowNode.add(panel, 0, i);
        }
        var rows = (len(goodNum)+2)/3;
        flowNode.size(3*offX, rows*offY);
        var fSize = flowNode.size();
        var bSize = cl.size();
        minPos = min(-(fSize[1]-bSize[1]), 0);

        flowNode.setevent(EVENT_TOUCH, touchBegan);
        flowNode.setevent(EVENT_MOVE, touchMoved);
        flowNode.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function touchBegan(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        lastPoints = newPos;
    }
    function moveBack(dify)
    {
        var oldPos = flowNode.pos();
        flowNode.pos(oldPos[0], oldPos[1]+dify);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        var oldPoints = lastPoints;
        lastPoints = newPos;
        var dify = lastPoints[1] - oldPoints[1];
        moveBack(dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var oldPos = flowNode.pos();
        oldPos[1] = min(0, max(minPos, oldPos[1]));
        flowNode.pos(oldPos[0], oldPos[1]);
    }
}
