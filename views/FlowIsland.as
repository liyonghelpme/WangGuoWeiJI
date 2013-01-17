class FlowIsland extends MyNode
{
    var scene;
    var kind;//0 1
    var touchDelegate;
    function FlowIsland(s, k)
    {
        scene = s;
        kind = k;
        bg = sprite("island"+str(kind)+".png");
        init();
        bg.prepare();
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;

        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }

    function touchBegan(n, e, p, x, y, points)
    {
        touchDelegate.tBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        touchDelegate.tMoved(n, e, p, x, y, points);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        touchDelegate.tEnded(n, e, p, x, y, points);
    }
}
