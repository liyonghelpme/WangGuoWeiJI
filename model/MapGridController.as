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

    function updateRxRyMap(rx, ry, obj)
    {
        var key = rx*10000+ry;
        var v = mapDict.get(key, []);
        v.append([obj, 1, 1]);
        mapDict.update(key, v);
    }
    function removeRxRyMap(rx, ry, obj)
    {
        var key = rx*10000+ry;
        var v = mapDict.get(key, null);
        if(v != null)
        {
            removeMapEle(v, obj);
            //v.remove(obj);
        }
    }

    
    function addSoldier(sol)
    {
        allSoldiers.update(sol.sid, sol);
    }
    //清除士兵的一个格子的map
    function clearSolMap(sol)
    {
        if(sol.curMap != null)
        {
            var key = sol.curMap[0]*10000+sol.curMap[1];
            var v = mapDict.get(key, null);
            if(v != null)
            {
                removeMapEle(v, sol);
            }
        }
    }
    function removeSoldier(sol)
    {
        //allSoldiers.remove(sol);
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
                var key = curX*10000+curY;
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
                var key = curX*10000+curY;
                var v = mapDict.get(key, []);
                v.append([sizePos[4], 1, 1]);
                mapDict.update(key, v);

                curX -= 1;
                curY += 1;
            }
        }

        return [initX, initY];
    }

}
