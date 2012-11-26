/*
其它士兵攻击他 生命值 状态
计算和他的距离

1*5 的装置
*/
class MapDefense extends MyNode
{
    var health = 100;
    var healthBoundary = 100;
    var color;
    var map;
    var state;
    var kind = 3;//0 close 1 far 2 magic 3 defense
    //var defense = 0;
    var physicDefense = 1;
    var magicDefense = 1;

    var hurts = dict();
    var data;
    var sx = 1;
    var sy = 5;
    var curMap = [0, 0];
    var mapSolId = 0;
    var attackType = 3;
    var defenseType = 3;
    var id = MAP_DEFENSE_ID;//防御建筑
    function MapDefense(m, i, d)
    {
        map = m;
        color = i;
        if(color == MYCOLOR)
            curMap = [0, 0];
        else
            curMap = [getParam("WAR_MAP_WIDTH")-1, 0];
        //城墙属性类型100
        data = dict([["category", 100]]);
        state = MAP_SOL_DEFENSE;

        bg = sprite("map"+str(m.kind)+"Def"+str(i)+".png", ARGB_8888).pos(d);
        init();
    }
    function setDefense(val)
    {
        trace("setDefense 暂时用临时值", val);
        //health = val;
        //healthBoundary = val;
    }
    function getKind()
    {
        return kind;
    }
    function getVolumn()
    {
        return 40;
    }
    function finishArrange()
    {
    }
    function acceptHarm(sol, hurt)
    {
        changeHealth(sol, -hurt[0]);
    }
    function changeHealth(sol, add)
    {
        var val = hurts.get(sol.sid, [sol, 0]);
        val[1] += add;
        hurts.update(sol.sid, val);

        health += add;
        if(health <= 0)
        {
            trace("defenseBreak", health);
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
    function addToMySol()
    {
        return 1;
    }
    function showBlood()
    {
    }
    function hideBlood()
    {
    }

    function setMap()
    {
        map.roundGridController.setMap(curMap[0], curMap[1], sx, sy, this);
    }


    function printSoldier()
    {
        trace(id, health, curMap, color, mapSolId);
    }
}
