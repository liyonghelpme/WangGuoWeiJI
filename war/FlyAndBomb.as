//飞行 爆炸 凤凰骑士
class FlyAndBomb extends EffectBase
{
    var labelText;
    function FlyAndBomb(s, t)
    {
        sol = s;
        tar = t;


        var p = sol.getPos();
        var off = getEffectOff(sol, tar);

        var flyAni = getEffectAni(sol.id);
        var ani = pureMagicData[flyAni[1]];
        bg = sprite().anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(sol.data["arrSca"]);
        init();
        shiftAni = moveto(0, 0, 0);
        if(getParam("debugAttack"))
        {
labelText = bg.addlabel("", getFont(), 20).color(rand(100), 0, 0).scale(-100, 100);
        }

        initState();
    }
    override function initState()
    {
        state = FLY_NOW;
        setDir();
        var flyAni = getEffectAni(sol.id);
        var ani = pureMagicData[flyAni[1]];
        cus = new MyAnimate(ani[1], ani[0], bg);
        initFlyState();
        updateTime();
    }
    function initFlyState()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        timeAll[FLY_NOW] = max(dist*1000/speed, getParam("minFlyTime"));        
        if(getParam("debugAttack"))
        {
            labelText.text("fly"+str(timeAll[FLY_NOW]));
        }

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

        var flyAni = getEffectAni(sol.id);
        var ani = pureMagicData[flyAni[2]];
        if(getParam("debugAttack"))
        {
            labelText.text("bomb"+str(ani[1]));
        }
        timeAll[BOMB_NOW] = ani[1];
        cus = new OneAnimate(ani[1], ani[0], bg, "", 1);
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
        if(getParam("debugAttack"))
            labelText.removefromparent();
        cus.exitScene();
        sol.map.myTimer.removeTimer(this);
        super.exitScene();
    }
}
