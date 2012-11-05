
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
                    colObjs += it;
            }
        }
        return colObjs;
    }
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
}
