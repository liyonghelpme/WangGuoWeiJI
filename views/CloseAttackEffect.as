class CloseAttackEffect extends MyNode
{
    var sol;
    var cus;
    function CloseAttackEffect(s)
    {
        sol = s;
        var ani = soldierAnimate.get(sol.data.get("attSpe"));//根据特效id 得到相应的特效
        trace("closeAttack", ani);
        var sPos = sol.getPos();
        var offset = ani[1];
        bg = sprite().pos(sPos[0]+offset[0], sPos[1]+offset[1]).anchor(50, 50);
        init();
        //time pics
        cus = new MyAnimate(ani[2], ani[0], bg);
    }
    override function enterScene()
    {
        super.enterScene();
        cus.enterScene();
    }
    override function exitScene()
    {
        cus.exitScene();
        super.exitScene();
    }
}
