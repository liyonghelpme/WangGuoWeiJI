class Magic extends MyNode
{
    var sol;
    var tar;
    var cus;
    var shiftAni;
    var speed = 10;
    var offY;
    var rowY;
    function Magic(s, t)
    {
        sol = s;
        tar = t;
        var ani = getMagicAnimate(sol.id/10*10);
        trace("animateAni", ani, sol.id);

        var p = sol.getPos();
        rowY = p[1];
        var difx = tar.getPos()[0]-p[0];
        offY = sol.data.get("arrpx");
        var offX = sol.data.get("arrpy");
        if(difx > 0)
        {
            offX = -offX;
        }

        bg = sprite().pos(ani[2]).anchor(100, 50).pos(p[0]+offX, p[1]+offY);
        init();
        cus = new MyAnimate(ani[1], ani[0], bg);
        shiftAni = moveto(0, 0, 0);
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
        shiftAni.stop();
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        //var dist = distance(bg.pos(), [tPos[0], tPos[1]+offY]);
        var t = dist*100/speed;        
        if(t <= 50)
        {
            doHarm();
            return;
        }
        setDir();
        shiftAni = moveto(t, tPos[0], rowY+offY);
        bg.addaction(shiftAni);
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
        cus.enterScene();
    }
    override function exitScene()
    {
        cus.exitScene();
        sol.map.myTimer.removeTimer(this);
        super.exitScene();
    }
}
