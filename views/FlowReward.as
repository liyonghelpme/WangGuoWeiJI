class FlowReward extends MyNode
{
    var game;
    var kind;
    function FlowReward(g, k)
    {
        game = g;
        kind = k;
        bg = sprite("drum"+str(kind)+".png").anchor(50, 50).pos(830, 428);
        init();
        bg.addaction(sequence(moveto(game.SPEED, 0, 428), callfunc(setOver)));
    }
    var over = 0;
    function setOver()
    {
        over = 1;
    }

    function calculateReward()
    {
        
    }
    function update(diff)
    {
        if(over)
        {
            //正常死亡出现 miss
            //var miss = game.bg.addsprite("miss.png").anchor(0, 0).pos(16, 364).size(75, 25).color(100, 100, 100, 100).addaction(sequence(moveby(200, 0, -25), callfunc(removeTempNode)));
            removeSelf();
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }
    //exitScene 中不能处理 停止动作等操作 
    override function exitScene()
    {
        global.myAction.removeAct(this);
        game.removeReward(this);
        super.exitScene();
    }
}
