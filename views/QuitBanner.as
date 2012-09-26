class QuitBanner extends MyNode
{
    /*
    var accTime = 0;
    function QuitBanner()
    {
        bg = sprite("storeBlack.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
var word = bg.addlabel(getStr("quitNow", null), "fonts/heiti.ttf", 25).pos(154, 25).anchor(50, 50).color(100, 100, 100);

        var wSize = word.prepare().size();
        var bSize = bg.prepare().size();
        bg.size(max(wSize[0]+10, bSize[0]), bSize[1]);
        var nBsize = bg.size();
        word.pos(nBsize[0]/2, nBsize[1]/2);
        
        bg.addaction(sequence(delaytime(2000), fadeout(1000)));
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
    */
}
