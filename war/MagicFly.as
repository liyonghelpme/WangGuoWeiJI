//飞行阶段 动画
//飞行的动画
class MagicFly extends EffectBase
{
    /*
    根据攻击目标设定 魔法的起始和目标位置
    如果目标和人物在同一行 即tar solMap +sy 范围 属于人物范围
    如果目标和人物不在同一行 则魔法攻击敌方
    简化攻击敌方中部
    但是对于防御装置存在问题

    如果在同一行 则攻击同一行



    魔法是飞行的 魔法有阶段  
    */
    function MagicFly(s, t)
    {
        sol = s;
        tar = t;
        var p = sol.getPos();
        var off = getEffectOff(sol, tar);
        var magic = getEffectAni(sol.id);
        trace("magicAni", sol.id, magic);
        var ani = pureMagicData[magic[1]];
        bg = sprite().anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(sol.data["arrSca"]);//起始位置和人物位置和体积 高度相关
        init();
        shiftAni = moveto(0, 0, 0);
        initState();
    }
    override function initState()
    {
        state = FLY_NOW;
        setDir();
        initFlyState();
        updateTime();
    }
    //s60se0
    function initFlyState()
    {
        var magic = getEffectAni(sol.id);
        var ani = pureMagicData[magic[1]];
        cus = new MyAnimate(ani[1], ani[0], bg);

        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        timeAll[FLY_NOW] = dist*1000/speed;        

        shiftAni = moveto(timeAll[FLY_NOW], tPos[0], bg.pos()[1]);
        bg.addaction(shiftAni);
    }
    override function switchState()
    {
        if(state == FLY_NOW)
            removeSelf();
    }
    function doHarm()
    {
        //攻击对象没有死亡
        if(tar != null)
        {
            var hurt = calHurt(sol, tar);
            tar.changeHealth(sol, -hurt);
        }
        removeSelf();
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
