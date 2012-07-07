class CloseAttackEffect extends MyNode
{
    var sol;
    //var cus;

    var ani;
    //var lastTime;
    var accTime;
    var duration;
    function CloseAttackEffect(s)
    {
        sol = s;
        ani = soldierAnimate.get(sol.data.get("attSpe"));//根据特效id 得到相应的特效
        trace("closeAttack", ani);
        var sPos = sol.getPos();
        var offset = ani[1];

        var difx = sol.tar.getPos()[0]-sol.getPos()[0];
        if(difx > 0)
            offset[0] = -offset[0];

        bg = sprite().pos(sPos[0]+offset[0], sPos[1]+offset[1]).anchor(50, 50);
        init();
        //time pics
        //cus = new MyAnimate(ani[2], ani[0], bg);

        accTime = 0;
        duration = ani[2];
        ani = ani[0]; 
    }
    var passTime = 0;
    function update(diff)
    {
        
        accTime += diff;
        if(accTime > duration)
        {
            removeSelf();
            return;
        }
        accTime %= duration;
        var curFrame = accTime*len(ani)/duration;
        bg.texture(ani[curFrame], ARGB_8888, UPDATE_SIZE);
    }
    override function enterScene()
    {
        super.enterScene();
        //cus.enterScene();
        global.myAction.addAct(this);
    }
    override function exitScene()
    {
        global.myAction.removeAct(this);
        //cus.exitScene();
        super.exitScene();
    }
}
