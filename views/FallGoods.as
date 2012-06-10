/*
掉落物品在buildLayer 上面
*/
class FallGoods extends MyNode
{
    var allFalls;
    var map;
    var lastFallTime = 0;
    var Zone = [[60, 492, 774, 468], [831, 483, 294, 537], [1920, 510, 357, 480], [2292, 483, 576, 429]];
    var possible = [];
    var buildLayer;
    function FallGoods(m, b)
    {
        map = m;
        buildLayer = b;
        bg = node();
        init();
        allFalls = [];
        var i;
        for(i = 0; i < len(fallThings); i++)
        {
            possible.append(fallThings[i][4]);
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    function update(diff)
    {
        //trace("lastTime", lastFallTime);
        lastFallTime += diff;
        if(lastFallTime >= 3000 )
        {
            if(len(allFalls) < 8)
            {
                getNewFall();       
            }
            /*
            else
            {
                var f = allFalls.pop(0);
                f.removeSelf();
            }
            */
            lastFallTime = 0;
        }
    }
    /*
    可以在模块初始化的时候生成所有概率分布值
    
    掉落物品的类型
    掉落物品的区域
    */
    function getNewFall()
    {
        var rv = rand(Sum(possible, len(possible)));
        var kind = len(fallThings)-1;
        for(var i = 1; i <= len(fallThings); i++)
        {
            var s = Sum(possible, i);
            if(rv <= s)
            {
                kind = i-1;       
                break;
            }
        }

        var rx = rand(MapWidth/sizeX);
        var ry = rand(MapHeight/sizeY);
        if(rx%2 != ry%2)
            ry++;
        var curX = rx*sizeX;
        var curY = ry*sizeY;
        for(i = 0; i < len(Zone); i++)
        {
            var difx = curX - Zone[i][0];
            var dify = curY - Zone[i][1];
            if(difx > 0 && difx < Zone[i][2] && dify > 0 && dify < Zone[i][3])
                break;
        }
        if(i > len(Zone))
        {
            trace("Fall not in zone");
            return;
        }
        var col = global.user.checkFallGoodCol(rx, ry);
        trace("FallGoods", rx, ry, col);
        if(col == 1)
            return;
        var fo = new FallObj(this, kind, rx, ry);
        fo.setPos([rx*sizeX, ry*sizeY]);
        allFalls.append(fo);
        buildLayer.addChildZ(fo, ry*sizeY);
    }

    /*
    function getNewFall()
    {

        var possible = [];
        var i;
        for(i = 0; i < len(fallThings); i++)
        {
            possible.append(fallThings[i][4]);
        }

        var rv = rand(Sum(possible, len(possible)));

        var kind = len(fallThings)-1;
        for(i = 1; i <= len(fallThings); i++)
        {
            var s = Sum(possible, i);
            if(rv <= s)
            {
                kind = i-1;       
                break;
            }
        }
        var area = 0;
        var temp = []
        for(i = 0; i < len(Zone); i++)
        {
            area += Zone[i][2]*Zone[i][3];   
            temp.append(Zone[i][2]*Zone[i][3]);
        }

        rv = rand(area);
        var pos = len(temp)-1;
        for(i = 1; i <= len(temp); i++)
        {
            s = Sum(temp, i);
            if(rv <= s)
            {
                pos = i-1;
                break;
            }
        }

        
        var curZone = Zone[pos];
        var x = rand(curZone[2]);
        var y = rand(curZone[3]);
        trace("goods", kind, x, y, curZone);
        var fo = new FallObj(this, kind);
        fo.setPos([curZone[0]+x, curZone[1]+y]);
        allFalls.append(fo);
        
        addChild(fo);
    }
    */

    function pickObj(obj)
    {
        allFalls.remove(obj);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
