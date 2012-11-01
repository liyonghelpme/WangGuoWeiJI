class EffectBase extends MyNode
{
    var sol;
    var tar;
    var shiftAni;
    var rotateAni;
    var speed;
    var state;
    var passTime;
    var timeAll;
    var totalTime;
    var cus;
    override function init()
    {
        super.init();
        speed = 200;
        state = MAKE_NOW;
        passTime = 0;
        timeAll = [0, 0, 0];
        totalTime = 0;
    }

    //make fly roll的 飞行时间有些段 等待的时间过长了
    function updateTime()
    {
        for(var i = 0; i < (state+1); i++)
        {
            totalTime += timeAll[i]; 
        }
        //totalTime *= 0.9;
    }
    function initState()
    {
        state = MAKE_NOW;
        setDir();
    }

    function setDir()
    {
        var difx = tar.getPos()[0]-bg.pos()[0];

        var oldSca =  bg.scale();
        if(difx > 0)
            bg.scale(-oldSca[1], oldSca[1]);
        else
            bg.scale(oldSca[1]);
    }

    function update(diff)
    {
        passTime += diff;

        if(passTime >= totalTime)
        {
            switchState();
        }
    }

    function doHarm()
    {
        if(tar != null)//攻击对象没有死亡
        {
            var hurt = calHurt(sol, tar);
            tar.changeHealth(sol, -hurt);
        }
        removeSelf();
    }

    function switchState()
    {
    }
    override function enterScene()
    {
        super.enterScene();
    }
    override function exitScene()
    {
        super.exitScene();
    }
}
