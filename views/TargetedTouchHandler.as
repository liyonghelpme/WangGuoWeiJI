//Only a interface
class TargetedTouchHandler
{
    var bg;
    var lastPos;
    function enterScene()
    {
        //super.enterScene();
        //global.touchManager.addTargeted(this, 0, 1);
        bg.setevent(EVENT_TOUCH, tBegan);
        bg.setevent(EVENT_MOVE, tMove);
        bg.setevent(EVENT_UNTOUCH, tEnd);
    }
    function tBegan(n, e, p, x, y, points)
    {
    }
    function tMove(n, e, p, x, y, points)
    {
    }
    function tEnded(n, e, p, x, y, points)
    {
    }
    /*
    override function exitScene()
    {
        global.touchManager.removeTouch(this);
        super.exitScene();
    }
    */
    function touchBegan(x, y)
    {
        var pos = bg.world2node(x, y);
        lastPos = [x, y];
        return pos[0] < bg.size()[0] && pos[1] < bg.size()[1] && pos[0] > 0 && pos[1] > 0;
    }
    function touchMove(x, y)
    {
    }
    function touchEnded(x, y)
    {
    }
}
