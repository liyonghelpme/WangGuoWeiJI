
class RoundGridController
{
    var map;
    var mapDict = dict();
    var rows = dict();
    function RoundGridController(m)
    {
        map = m;
    }
    function clearMap(left, top, sx, sy, obj)
    {
        for(var i = 0; i < sx; i++)
        {
            for(var j = 0; j < sy; j++)
            {
                var px = left+i;
                var py = top+j;
                
                var curRow = rows.get(py);
                if(curRow != null)
                {
                    curRow.remove(obj);
                    if(len(curRow) == 0)
                        rows.pop(py);
                }

                var k = getMapKey(px, py);
                var it = mapDict.get(k);
                if(it != null)
                {
                    it.remove(obj);
                    if(len(it) == 0)//简单判定是否是null 就可以断定有无冲突
                        mapDict.pop(k);
                }
            }
        }
        map.updateMapGrid();
    }
    function setMap(left, top, sx, sy, obj)
    {
        for(var i = 0; i < sx; i++)
        {
            for(var j = 0; j < sy; j++)
            {
                var px = left+i;
                var py = top+j;
                var curRow = rows.setdefault(py, []);
                curRow.append(obj);

                var k = getMapKey(px, py);
                var it = mapDict.setdefault(k, []);
                it.append(obj);
            }
        }
        map.updateMapGrid();
    }
    function checkCol(left, top, sx, sy, obj)
    {
        var colObjs = [];
        for(var i = 0; i < sx; i++)
        {
            for(var j = 0; j < sy; j++)
            {
                var px = left+i;
                var py = top+j;
                var k = getMapKey(px, py);
                var it = mapDict.get(k);
                if(it != null)
                {
                    //不和防御建筑判断冲突  布局士兵的时候？
                    //for(var t = 0; t < len(it); t++)
                    //    if(it[t].state != MAP_SOL_DEFENSE)
                    //        colObjs.append(it[t]);
                    colObjs += it;
                }

            }
        }
        return colObjs;
    }

    /*
    得到士兵或者技能所在行的所有士兵
    */
    function getRowObjects(left, top, sx, sy, obj)
    {
        var rowObjects = [];
        for(var j = 0; j < sy; j++)
        {
            var py = top+j;
            var curRow = rows.get(py);
            if(curRow != null)
                rowObjects += curRow;
        }
        return rowObjects;
    }
    
    //唯一标识 地图上士兵的随机性编号 由addSoldier 来分配
    function startAdjustSolPos(sol)
    {
        trace("startAdjustSolPos", sol.curMap);
        var adjustYet = dict();
        var adjustList = [sol];//先入先出队列
        while(1)
        {
            if(len(adjustList) == 0)
                break;
            var s = adjustList.pop(0);
            adjustYet.update(s.mapSolId, 1);
            trace("adjustYet", s.curMap);

            var colList = checkCol(s.curMap[0], s.curMap[1], s.sx, s.sy, s);
            //根据当前士兵 ---》 判断冲突士兵---》调整冲突士兵---》结束条真
            for(var i = 0; i < len(colList); i++)
            {
                //判断冲突方式 不和防御建筑判断冲突
                if(colList[i] != s && adjustYet.get(colList[i].mapSolId) == null)
                {
                    var colSol = colList[i];
                    colSol.clearMap();
                    //MAIN COL 
                    if(colSol.curMap[0] < (s.curMap[0] +s.sx) && (colSol.curMap[0]+colSol.sx) > s.curMap[0])
                    {
                        colSol.curMap[0] = s.curMap[0]+s.sx;
                    }
                    //COL MAIN 
                    else
                    { 
                        colSol.curMap[0] = s.curMap[0]-colSol.sx;
                    }
                    colSol.resetPos(); 
                    colSol.setMap();
                    adjustList.append(colSol);
                }
            }
        }
    }
}
