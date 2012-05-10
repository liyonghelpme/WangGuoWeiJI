class Goods extends MyNode
{
    var goodNum;
    var flowNode;
    function Goods()
    {
        bg = node().pos(261, 129).size(500, 325);
        flowNode = bg.addnode();
        init();
        goodNum = [];
        flowNode.setevent(EVENT_TOUCH, touchBegan);
        flowNode.setevent(EVENT_MOVE, touchMoved);
        flowNode.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function touchBegan(n, e, p, x, y, points)
    {
    }
    function touchMoved(n, e, p, x, y, points)
    {
        
    }
    function touchEnded(n, e, p, x, y, points)
    {
    }
}
