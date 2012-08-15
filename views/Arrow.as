class Arrow extends MyNode
{
    var sol;
    var tar;
    var movAct;
    var speed = 20;
    var offY;
    var rowY;
    function Arrow(s, t)
    {
        sol = s;
        tar = t;
        var id = sol.id;
        var p = sol.getPos();
        rowY = p[1];

        
        var difx = tar.getPos()[0]-p[0];
        offY = sol.data.get("arrpx");
        var offX = sol.data.get("arrpy");
        if(difx > 0)
        {
            offX = -offX;
        }
        //soldier anchor 50 100 
        //-50 -50
        bg = sprite("arrow"+str(id)+".png").anchor(100, 50).pos(p[0]+offX, p[1]+offY);
        init();
        movAct = moveto(0, 0, 0);
        initArrow();
    }
    var attackTime;
    var passTime = 0;
    function initArrow()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        attackTime = dist*100/speed;
        setDir();
        


        var eneSize = tar.bg.size();

        var tY = tPos[1]-eneSize[1]/2;
        if(tar.state == MAP_SOL_DEFENSE)
            tY = rowY+offY;

        movAct = moveto(attackTime, tPos[0], tY);
        bg.addaction(movAct);
    }
    function setDir()
    {
        var difx = tar.getPos()[0]-bg.pos()[0];
        if(difx > 0)
            bg.scale(-100, 100);
        else
            bg.scale(100, 100);
    }
    function update(diff)
    {
        passTime += diff;
        if(passTime >= attackTime)
            doHarm();
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
