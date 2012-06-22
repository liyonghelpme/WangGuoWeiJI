class Arrow extends MyNode
{
    var sol;
    var tar;
    var movAct;
    var speed = 10;
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
        movAct.stop();
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        var t = dist*100/speed;
        if(t <= 50)
        {
            doHarm();
            return;
        }
        setDir();
        movAct = moveto(t, tPos[0], rowY+offY);
        bg.addaction(movAct);
    }
    function doHarm()
    {
        tar.changeHealth(-1);
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
