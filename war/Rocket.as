//飞行 调整 曲线 头方向  
class Rocket extends EffectBase
{
    function Rocket(s, t)
    {
        sol = s;
        tar = t;
        var p = sol.getPos();
        var off = getEffectOff(sol, tar);

        var attackAni = getAttackAnimte(sol.id);
        var ani = pureMagicData[attackAni[0]];
        bg = sprite().anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(ani[3]);
        init();

        cus = new MyAnimate(ani[1], ani[0], bg);
        shiftAni = moveto(0, 0, 0);
        initState();
    }
    override function initState()
    {
        state = FLY_NOW;
        initFlyState();
        updateTime();
    }
    function initFlyState()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        timeAll[FLY_NOW] = dist*1000/speed;        

        var startPos = bg.pos();
        var endPos = tPos;
        var difx = (endPos[0]-startPos[0])/3;

        trace("dist", tPos[0] - bg.pos()[0]);
        var oldScale = bg.scale();
        if((tPos[0]-bg.pos()[0]) < 0)
        {
            bg.scale(-abs(oldScale[0]), -abs(oldScale[1]));
        }
        else
        {
            bg.scale(-abs(oldScale[0]), abs(oldScale[1]));
        }

        shiftAni = bezierby(
                timeAll[FLY_NOW], 
                0, 0, 
                difx, -60, 
                difx*2, -60, 
                endPos[0]-startPos[0], endPos[1]-startPos[1],
                1);
        bg.addaction(shiftAni);
    }
    
    override function switchState()
    {
        if(state == FLY_NOW)
        {
            state = BOMB_NOW;
            clearAnimate();
            cus.exitScene();
            bg.rotate(0);
            var oldScale = bg.scale();
            bg.scale(abs(oldScale[0]));
            initBombState();
        }
        else if(state == BOMB_NOW)
        {
            doHarm();
        }
        updateTime();
    }
    function initBombState()
    {
        var attackAni = getAttackAnimte(sol.id);
        var ani = pureMagicData[attackAni[1]];
        timeAll[BOMB_NOW] = ani[1];
        cus = new MyAnimate(ani[1], ani[0], bg);
        cus.enterScene();
    }

    function clearAnimate()
    {
        shiftAni.stop();
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
