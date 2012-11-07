
class MakeFly extends EffectBase
{
    function MakeFly(s, t)
    {
        sol = s;
        tar = t;
        var p = sol.getPos();
        var off = getEffectOff(sol, tar);
        var makeFly = getEffectAni(sol.id);
        var ani = pureMagicData[makeFly[0]];

        bg = sprite().anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(ani[3]);//起始位置和人物位置和体积 高度相关
        init();
        shiftAni = moveto(0, 0, 0);
        initState();
    }
    override function initState()
    {
        state = MAKE_NOW;
        setDir();
        initMakeState();
        updateTime();
    }
    function initMakeState()
    {
        var makeFly = getEffectAni(sol.id);
        var ani = pureMagicData[makeFly[0]];
        cus = new MyAnimate(ani[1], ani[0], bg);
        timeAll[MAKE_NOW] = ani[1];
    }
    override function switchState()
    {
        if(state == MAKE_NOW)
        {
            state = FLY_NOW;
            cus.exitScene();
            initFlyState();
        }
        else if(state == FLY_NOW)
        {
            doHarm();
        }
        updateTime();
    }
    function initFlyState()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        timeAll[FLY_NOW] = dist*1000/speed;        

        shiftAni = moveto(timeAll[FLY_NOW], tPos[0], bg.pos()[1]);
        bg.addaction(shiftAni);

        var makeFly = getEffectAni(sol.id);
        var ani = pureMagicData[makeFly[1]];
        cus = new MyAnimate(ani[1], ani[0], bg);
        cus.enterScene();
    }
    override function enterScene()
    {
        super.enterScene();
        sol.map.myTimer.addTimer(this);
        cus.enterScene();
    }
    override function exitScene()
    {
        cus.exitScene();
        sol.map.myTimer.removeTimer(this);
        super.exitScene();
    }
}
