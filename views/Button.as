class Button extends MyNode
{
    var callback;
    var param;
    function Button(b, c, p)
    {
        callback = c;
        param = p;
        bg = b;
        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function touchBegan(n, e, p, x, y, points)
    {
    }
    function touchMoved(n, e, p, x, y, points)
    {
    }
    function touchEnded(n, e, p, x, y, points)
    {
        callback(param);
    }
}
