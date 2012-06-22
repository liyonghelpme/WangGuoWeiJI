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
    function MapDefense(m, i, data)
    {
        map = m;
        color = i;
        state = MAP_SOL_DEFENSE;
        bg = sprite("map"+str(m.kind)+"Def"+str(i)+".png").pos(data);
        init();
    }
    function getVolumn()
    {
        return 40;
    }
    function finishArrage()
    {
    }
    function changeHealth(add)
    {
        health += add;
        global.msgCenter.sendMsg(CASTLE_DEF, this);
    }
}
