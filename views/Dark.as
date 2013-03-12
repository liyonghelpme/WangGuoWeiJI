class Dark extends MyNode
{
    var autoPop;
    function Dark(auto)
    {
        autoPop = auto;
bg = sprite("black.png", ARGB_8888).color(0, 0, 0, 65).size(global.director.disSize[0], global.director.disSize[1]);
        init();
    }
    override function enterScene()
    {
        //super.enterScene();
        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
        //global.touchManager.addHead(this, DARK_PRI, 1);
    }
    override function exitScene()
    {
        //global.touchManager.removeTouch(this);
        //super.exitScene();
    }
    function touchBegan(n, e, p, x, y, points)
    {
        return 1;
    }
    function touchMoved(n, e, p, x, y, points)
    {
        
    }
    function touchEnded(n, e, p, x, y, points)
    {
        if(autoPop == 1)
            global.director.popView();
//        trace("dark pop");
    }
}
