class FallGoods extends MyNode
{
    var allFalls;
    var map;
    var lastFallTime = 0;
    var Zone = [[60, 492, 774, 468], [831, 483, 294, 537], [1920, 510, 357, 480], [2292, 483, 576, 429]];
    function FallGoods(m)
    {
        bg = node();
        init();
        allFalls = [];
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
    */
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
    function pickObj(obj)
    {
        allFalls.remove(obj);
        /*
        global.user.changeValue("silver", fallThings[obj.kind][1]);
        global.user.changeValue("crystal", fallThings[obj.kind][2]);
        global.user.changeValue("gold", fallThings[obj.kind][3]);
        */
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
    }

}
