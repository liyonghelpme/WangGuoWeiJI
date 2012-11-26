class WarStateModel
{
    var toMove;
    var leftSoldier; //sid
    var rightSoldier;//sid
    var freeList;//x y 空闲位置列表
    var leftSolNum;//已经放置多少士兵
    var rightSolNum;//已经放置多少士兵
    var mapDict;//x y -->士兵id 
    var leftDefense;//sid 0 
    var rightDefense;//sid 1
    var solAttribute; // sid ---》类型 位置 士兵生命值 
    var maxSolId; //当前生成士兵的最大 id 取代 map中的id生成方法
    var rows = null;//没有用
    function WarStateModel()
    {

    }
    /*
    function initData()
    {
        toMove = "B";
        leftSoldier = set();
        rightSoldier = set();
        leftSolNum = 0;
        rightSolNum = 0;
        mapDict = dict();
        //solAttribute = dict();
        maxSolId = 0;
        freeList = set();
        for(var i = 0; i < getParam("WAR_MAP_WIDTH"); i++)
        {
            for(var j = 0; j < getParam("WAR_MAP_HEIGHT"); j++)
            {
                freeList.add(i*WAR_MAP_COFF+j);
            }
        }
    }
    */
    //复制一份新的状态
    function deepCopy()
    {
        var temp = new WarStateModel();
        temp.toMove = toMove;
        temp.leftSoldier = copy(leftSoldier);
        temp.rightSoldier = copy(rightSoldier);
        temp.freeList = copy(freeList);
        temp.leftSolNum = leftSolNum;
        temp.rightSolNum = rightSolNum;
        temp.mapDict = copy(mapDict);//key --->sid
        temp.leftDefense = leftDefense;//sid
        temp.rightDefense = rightDefense;//sid
        temp.solAttribute = dict();//sid ---> miniSoldier
        temp.maxSolId = maxSolId;
        var kv = solAttribute.items();
        for(var i = 0; i < len(kv); i++)
        {
            var key = kv[i][0];
            var value = kv[i][1];
            var sol = new MiniSoldier(value);
            temp.solAttribute.update(key, sol);
        }
        return temp;
    }
    function printState()
    {
        trace("toMove", toMove, "leftSoldier", leftSoldier, "rightSoldier", rightSoldier);
        trace("leftSolNum", leftSolNum, "rightSolNum", rightSolNum);
        trace("leftDefense", leftDefense, "rightDefense", rightDefense);
        trace("freeList", freeList);
        trace("mapDict", mapDict);
        trace("soldier Attribute");
        var it = solAttribute.items();
        for(var i = 0; i < len(it); i++)
        {
            trace(it[i][0]);
            it[i][1].printSoldier();
        }
    }

}
