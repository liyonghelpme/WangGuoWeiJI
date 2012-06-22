class QuitBanner extends MyNode
{
    var accTime = 0;
    function QuitBanner()
    {
        bg = sprite("storeBlack.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addlabel(getStr("quitNow", null), null, 25).pos(154, 25).anchor(50, 50).color(100, 100, 100);
        //bg.addaction(sequence(delaytime(5000), callfunc(removeSelf)));
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    function update(diff)
    {
        accTime += diff;
        if(accTime >= 3000)
        {
            global.director.clearQuitState();
            global.director.popView();
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
