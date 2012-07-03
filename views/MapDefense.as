/*
其它士兵攻击他 生命值 状态
计算和他的距离

*/
class MapDefense extends MyNode
{
    var health = 100;
    var healthBound = 100;
    var color;
    var map;
    var state;
    var kind = 3;//0 close 1 far 2 magic 3 defense
    var defense = 0;
    var hurts = dict();
    function MapDefense(m, i, data)
    {
        map = m;
        color = i;
        state = MAP_SOL_DEFENSE;
        bg = sprite("map"+str(m.kind)+"Def"+str(i)+".png").pos(data);
        init();
    }
    function getKind()
    {
        return kind;
    }
    function getVolumn()
    {
        return 40;
    }
    function finishArrage()
    {
    }
    function changeHealth(sol, add)
    {
        var val = hurts.get(sol.sid, [sol, 0]);
        val[1] += add;
        hurts.update(sol.sid, val);

        health += add;
        if(health <= 0)
        {
            health = 0;
            state = MAP_SOL_DEAD;
            map.defenseBreak(this);
        }
        global.msgCenter.sendMsg(CASTLE_DEF, this);
    }
    function stopGame()
    {
    }
    function continueGame()
    {
    }
    function isMySoldier()
    {
        return 0;
    }
    function addToMySol()
    {
        return 1;
    }
}
