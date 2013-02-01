/*
Banner 需要实现接口 setMoveAni 用于dialogController 管理
*/
class UpgradeBanner extends MyNode
{
    var movAni = moveto(0, 0, 0);
    var callback;
    function UpgradeBanner(w, col, cb)
    {
        callback = cb;
        if(col == null)
            col = [100, 100, 100];
        bg = sprite("storeBlack.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        var word = colorWordsNode(w, getParam("bannerWordSize"), col, [89, 72, 18]);
        word.anchor(50, 50);
        bg.add(word);
        /*
        根据文字长度 设定 背景长度
        根据背景长度 设定 文字位置
        */
        var wSize = word.size();
        var bSize = bg.prepare().size();
        bg.size(max(wSize[0]+getParam("bannerWidth"), bSize[0]), bSize[1]);
        var nBsize = bg.size();
        word.pos(nBsize[0]/2, nBsize[1]/2);

        bg.addaction(sequence(delaytime(2000), fadeout(1000)));
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    var passTime = 0;
    var inFade = 0;
    var moveX;
    var moveY;
    function update(diff)
    {
        /*
        if(passTime >= getParam("bannerDelayTime"))
        {
            var pt = passTime-getParam("bannerDelayTime");
            pt = min(100, pt*100/getParam("bannerFadeTime"));
            bg.color(100, 100, 100, 100-pt);
            //bg.addaction(fadeout(getParam("bannerFadeTime")));
        }
        */
        if(passTime >= getParam("bannerRemoveTime"))
            removeNow();
        passTime += diff;
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    function removeNow()
    {
        removeSelf();
        if(callback != null)
            callback();
    }
    function setMoveAni(X, Y)
    {
        trace("setMoveAni", X, Y);
        movAni.stop();
        trace("addaction", movAni);
        movAni = expout(moveto(getParam("bannerMoveTime"), X, Y));
        bg.addaction(movAni);
    }
}
