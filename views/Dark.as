class Dark extends MyNode
{
    var autoPop;
    function Dark(auto)
    {
        autoPop = auto;
        bg = sprite("dark.png").color(0, 0, 0, 65).size(global.director.disSize[0], global.director.disSize[1]);
        init();
    }
    override function enterScene()
    {
        super.enterScene();
        global.touchManager.addHead(this, DARK_PRI, 1);
    }
    override function exitScene()
    {
        global.touchManager.removeTouch(this);
        super.exitScene();
    }
    function touchBegan(x, y)
    {
        return checkIn(bg, [x, y])
    }
    function touchMove(x, y)
    {
        
    }
    function touchEnded(x, y)
    {
        if(autoPop == 1)
            global.director.popView();
        trace("dark pop");
    }
}
