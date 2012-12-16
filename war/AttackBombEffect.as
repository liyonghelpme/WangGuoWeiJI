//血液溅出
class AttackBombEffect extends MyNode
{
    function AttackBombEffect()
    {
        bg = node();
        init();
        genNewParticle(); 
    }
    function genNewParticle()
    {
        var tx = sprite("attackFly2.png");
        var initDeg = rand(360);
        var P_NUM = getParam("bombNum")+rand(getParam("randBombNum"));
        var offD = 360.0/getParam("bombNum");
        for(var i = 0; i < P_NUM; i++)
        {
            var ns = copy(tx);
            var rdDir = rand(getParam("randDir"));
            var dir = initDeg+i*offD+rdDir;
            ns.rotate(dir);
            var dis = rand(getParam("randBombMove"));
            var dx = cos(dir)*dis;
            var dy = sin(dir)*dis;
            var rdsca = getParam("bombScale")+rand(getParam("randBombScale"));
            ns.anchor(0, 50);
            ns.scale(getParam("bombStartScale"));
            ns.color(getParam("bombBloodRed")+rand(10), getParam("bombBloodGreen")+rand(10), getParam("bombBloodBlue")+rand(10));
            ns.addaction(spawn(expout(moveby(getParam("bombTime"), dx, dy)), expout(scaleto(getParam("bombTime"), rdsca, rdsca))));

            bg.add(ns);
        }
    }
    var passTime = 0;
    function update(diff)
    {
        if(passTime > getParam("bombDisappearTime"))
            removeSelf();
        passTime += diff;
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }
    override function exitScene()
    {
        global.myAction.removeAct(this);
        super.exitScene();
    }
}
