class Magic extends MyNode
{
    var sol;
    var tar;
    var cus;
    var shiftAni;
    var speed = 20;
    var offY;
    var rowY;
    /*
    根据攻击目标设定 魔法的起始和目标位置
    如果目标和人物在同一行 即tar solMap +sy 范围 属于人物范围
    如果目标和人物不在同一行 则魔法攻击敌方
    简化攻击敌方中部
    但是对于防御装置存在问题

    如果在同一行 则攻击同一行
    */
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

        bg = sprite().anchor(100, 50).pos(p[0]+offX, p[1]+offY);//起始位置和人物位置和体积 高度相关
        init();
        cus = new MyAnimate(ani[1], ani[0], bg);
        shiftAni = moveto(0, 0, 0);

        initMagic();
    }
    var attackTime;
    var passTime = 0;
    function initMagic()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        attackTime = dist*100/speed;        
        setDir();
       
        var eneSize = tar.bg.size();
        //攻击敌方中部 如果是防御装置则攻击本行
        var tY = tPos[1]-eneSize[1]/2;
        if(tar.state == MAP_SOL_DEFENSE)
            tY = rowY+offY;

        shiftAni = moveto(attackTime, tPos[0], tY);
        bg.addaction(shiftAni);
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
        /*
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
        */
    }
    function doHarm()
    {
        //攻击对象没有死亡
        if(sol.tar != null)
        {
            var coff = getSoldierKindCoff(sol.kind, sol.tar.getKind());
            var hurt = coff*(sol.attack-sol.tar.defense)/100;
            hurt = max(hurt, sol.attack/10);//伤害最小是攻击力的1/10
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
