class Loading extends MyNode
{
    /*
    延迟几秒钟 拆除 这个 view
    */
    function Loading()
    {
        bg = sprite("loading.jpg");
        init();
        bg.addsprite("loadingCircle.png").addaction(repeat(rotateby(2000, 360))).pos(759, 37).anchor(50, 50);
        bg.addsprite("loadingWord.png").addaction(repeat(fadeout(1000), fadein(1000))).pos(587, 30);
    }
    /*
    var passTime = 0;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= 3000)
            global.director.popView();
    }
    */
    function receiveMsg(param)
    {
        var msg = param[0];
        if(msg == INITDATA_OVER)
        {
            global.director.popView();
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(INITDATA_OVER, this);
        //global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(INITDATA_OVER, this);
        //global.timer.removeTimer(this);
        super.exitScene();
    }
}
