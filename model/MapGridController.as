class MapGridController 
{
    var allBuildings = [];
    var allSoldiers = dict();
    var mapDict;
    var scene;
    function MapGridController(s)
    {
        scene = s;
        mapDict = dict();
    }

    //掉落物品根据掉落目标位置设定map
    function updateRxRyMap(rx, ry, obj)
    {
        //var key = rx*10000+ry;
        var key = getMapKey(rx, ry);
        var v = mapDict.get(key, []);
        v.append([obj, 1, 1]);
        mapDict.update(key, v);

        scene.updateMapGrid();
    }
    function clearRxRyMap(rx, ry, obj)
    {
        var key = getMapKey(rx, ry);
        var v = mapDict.get(key, null);
        if(v != null)
        {
            removeMapEle(v, obj);
            if(len(v) == 0)
                mapDict.pop(key);
        }
    }

    
    function addSoldier(sol)
    {
        allSoldiers.update(sol.sid, sol);
    }
    function removeSoldier(sol)
    {
        allSoldiers.pop(sol.sid);
        clearSolMap(sol);
    }

    function removeAllSoldiers()
    {
        var solArr = allSoldiers.values();
        for(var i = 0; i < len(solArr); i++)
        {
            var sol = solArr[i];
            clearSolMap(sol);
            sol.removeSelf();
        }
        allSoldiers = dict();
    }
    //清除士兵的一个格子的map
    //士兵的map根据士兵的目标位置设定
    function clearSolMap(sol)
    {
        if(sol.curMap != null)
        {
            var key = getMapKey(sol.curMap[0], sol.curMap[1]);
            var v = mapDict.get(key, null);
            if(v != null)
            {
                removeMapEle(v, sol);
                if(len(v) == 0)
                    mapDict.pop(key);
            }
        }
    }

    //根据当前位置设定建筑物的Map
    function clearMap(build)
    {
        var map = getBuildMap(build);
        var sx = map[0];
        var sy = map[1];
        var initX = map[2];
        var initY = map[3];
        for(var i = 0; i < sx; i++)
        {
            var curX = initX+i;
            var curY = initY+i;
            for(var j = 0; j < sy; j++)
            {
                var key = getMapKey(curX, curY);
                var v = mapDict.get(key, []);
                if(len(v) == 0)
                    continue;
                removeMapEle(v, build);
                if(len(v) == 0)
                    mapDict.pop(key);
                curX -= 1;
                curY += 1;
            }
        }
    }
    
    function updateMap(build)
    {
        var p = build.getPos();
        return updatePosMap([build.sx, build.sy, p[0], p[1], build]);
    }
    
    //根据目标位置设定map
    //obj 建造冲突 移动冲突
    function updatePosMap(sizePos)
    {
        var map = getPosMap(sizePos[0], sizePos[1], sizePos[2], sizePos[3]);
        var kind = sizePos[4].funcs;

        var sx = map[0];
        var sy = map[1];
        var initX = map[2];
        var initY = map[3];

        for(var i = 0; i < sx; i++)
        {
            var curX = initX+i;
            var curY = initY+i;
            for(var j = 0; j < sy; j++)
            {
                //var key = curX*10000+curY;
                var key = getMapKey(curX, curY);
                var v = mapDict.get(key, []);
                v.append([sizePos[4], 1, 1]);
                mapDict.update(key, v);

                curX -= 1;
                curY += 1;
            }
        }

        scene.updateMapGrid();
        return [initX, initY];
    }

}
