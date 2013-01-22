//旋转 飞行 爆炸
class FireBall extends EffectBase
{
    function FireBall(s, t)
    {
        sol = s;
        tar = t;
        var p = sol.getPos();
        var off = getEffectOff(sol, tar);
        
        //旋转
        bg = sprite("s"+str(sol.id)+"e0.png").anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]);
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
    function initFlyState()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        timeAll[FLY_NOW] = max(dist*1000/speed, getParam("minFlyTime"));        

        var n = timeAll[FLY_NOW]/getParam("rotateTime")*360;
        n += timeAll[FLY_NOW]%getParam("rotateTime")*360/getParam("rotateTime");//300ms ---360
        var dir = bg.scale()[0];
        if(dir >= 0)//正方向
            n = -n;
            
        rotateAni = rotateby(timeAll[FLY_NOW], n);
        shiftAni = moveto(timeAll[FLY_NOW], tPos[0], bg.pos()[1]);
        bg.addaction(spawn(rotateAni, shiftAni));

        var p = sol.getPos();
        var off = getEffectOff(sol, tar);

        var startPos = [p[0]+off[0], p[1]+off[1]+sol.data["arrFlyOffY"]];
        var endPos = [tar.getPos()[0], p[1]+off[1]+sol.data["arrFlyOffY"]];
        dir = getDir(); 
        var arrowTrail = new ArrowFlyEffect(timeAll[FLY_NOW], startPos, endPos, dir, sol.data["particleId"]);
        sol.map.addChildZ(arrowTrail, MAX_BUILD_ZORD);
    }
    override function switchState()
    {
        if(state == FLY_NOW)
            removeSelf();
    }
    
    override function enterScene()
    {
        super.enterScene();
        sol.map.myTimer.addTimer(this);
        //cus.enterScene();
    }
    override function exitScene()
    {
        //cus.exitScene();
        sol.map.myTimer.removeTimer(this);
        super.exitScene();
    }
}
