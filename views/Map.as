
class Map extends MyNode
{
    var kind;
    var touchDelegate;
    var walkZone = [102, 186, 938, 356];

    var soldiers = dict();

    var myTimer;
    //color kind
    function Map(k, s)
    {
        kind = k;
        bg = sprite("map"+str(k)+".jpg");
        bg.prepare();
        init();
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;


        initSoldier(s);
        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    /*
    color kind
    */
    function initSoldier(s)
    {
        for(var i = 0; i < len(s); i++)
        {
            var so = new Soldier(this, s[i]);  
            trace("soldier", s[i]);
            var myColor = soldiers.get(s[i][0], []);
            soldiers.update(s[i][0], myColor);
            myColor.append(so);
            addChild(so);
        }
        trace("soldiers", soldiers);
    }
    function update(diff)
    {
    }
    override function enterScene()
    {
        trace("enterScene map");
        myTimer = new Timer(100);
        global.map = this;
        super.enterScene();
    }
    override function exitScene()
    {
        trace("exitScene map");
        global.map = null;
        super.exitScene();
        myTimer.stop();
        myTimer = null;
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
