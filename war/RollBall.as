class RollBall extends EffectBase
{
    function RollBall(s, t)
    {
        sol = s;
        tar = t;
        var p = sol.getPos();
        var off = getEffectOff(sol, tar);

        bg = sprite("s"+str(sol.id)+"e0.png").anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(sol.data["arrSca"]);
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
        timeAll[FLY_NOW] = dist*1000/speed;        

        var n = timeAll[FLY_NOW]/300*360;
        n += timeAll[FLY_NOW]%300*360/300;
        var dir = bg.scale()[0];
        if(dir >= 0)//正方向
            n = -n;
            
        rotateAni = rotateby(timeAll[FLY_NOW], n);
        shiftAni = moveto(timeAll[FLY_NOW], tPos[0], bg.pos()[1]);
        bg.addaction(spawn(rotateAni, shiftAni));
    }
    override function switchState()
    {
        if(state == FLY_NOW)
            doHarm();
    }
    
    override function enterScene()
    {
        super.enterScene();
        sol.map.myTimer.addTimer(this);
    }
    override function exitScene()
    {
        sol.map.myTimer.removeTimer(this);
        super.exitScene();
    }
}
