/*
用于暂时 控制屏幕 防止其他点击
*/
class Mask extends MyNode
{
    var passTime = 0;
    var totalTime;
    function Mask(t)
    {
        totalTime = t;
        bg = node().size(global.director.disSize);
        init();
        bg.setevent(EVENT_TOUCH|EVENT_MOVE|EVENT_UNTOUCH, doNothing);
    }
    function update(diff)
    {
        passTime += diff;
        if(passTime >= totalTime)
            global.director.popView();
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
