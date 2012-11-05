//飞行 爆炸 凤凰骑士
class FlyAndBomb extends EffectBase
{

    function FlyAndBomb(s, t)
    {
        sol = s;
        tar = t;


        var p = sol.getPos();
        var off = getEffectOff(sol, tar);

        var flyAni = getFlyAndBombAni(sol.id);
        var ani = pureMagicData[flyAni[0]];
        bg = sprite().anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(ani[3]);
        init();
        shiftAni = moveto(0, 0, 0);
        initState();

    }
    override function initState()
    {
        state = FLY_NOW;
        setDir();
        var flyAni = getFlyAndBombAni(sol.id);
        var ani = pureMagicData[flyAni[0]];
        cus = new MyAnimate(ani[1], ani[0], bg);
        initFlyState();
        updateTime();
    }
    function initFlyState()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        timeAll[FLY_NOW] = dist*1000/speed;        

        shiftAni = moveto(timeAll[FLY_NOW], tPos[0], bg.pos()[1]);
        bg.addaction(shiftAni);
    }


    

    var bombing = 0;
    var bombTime = 0;
    function clearAnimate()
    {
        shiftAni.stop();
    }
    function initBombState()
    {
        state = BOMB_NOW;
        var flyAni = getFlyAndBombAni(sol.id);
        var ani = pureMagicData[flyAni[1]];
        timeAll[BOMB_NOW] = ani[1];
        cus = new MyAnimate(ani[1], ani[0], bg);
        cus.enterScene();
    }
    override function switchState()
    {
        if(state == FLY_NOW)
        {
            cus.exitScene();
            clearAnimate();
            initBombState();
        }
        else if(state == BOMB_NOW)
        {
            doHarm();
        }
        updateTime();
    }
    //两个阶段 不同动画
    //第一阶段 抛物线移动
    //第二阶段 爆炸
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