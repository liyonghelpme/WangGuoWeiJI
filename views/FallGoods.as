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
    var ids = [];
    var buildLayer;
    function FallGoods(m, b)
    {
        map = m;
        buildLayer = b;
        bg = node();
        init();
        allFalls = [];
        var i;
        var key = fallThingData.keys();
        for(var k = 0; k < len(key); k++)
        {
            var data = getData(FALL_THING, k);
            if(data.get("possible") > 0)//possible > 0 正常掉落物品   == 0 升级掉落物品
            {
                ids.append(k);
                possible.append(data.get("possible"));
            }
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    //100s
    const FALL_TIME = 50000;
    const FALL_NUM = 5;
    function update(diff)
    {
        //trace("lastTime", lastFallTime);
        lastFallTime += diff;
        if(lastFallTime >= FALL_TIME )
        {
            lastFallTime = 0;
//            trace("getFallObj", lastFallTime, len(allFalls));
            if(len(allFalls) < FALL_NUM)
            {
                getNewFall();       

            }
            else
            {
                var f = allFalls.pop(0);//删除旧的没有拾取的物品
                f.removeSelf();
            }

        }
    }
    //得到当前屏幕中心 生成 若干 掉落物品
    function getLevelUpFallGoods()
    {
        //var level = global.user.getValue("level");
        //kind = 6 7 8 9 10

        var leftUp = buildLayer.bg.world2node(200, 100);
        var rightBottom = buildLayer.bg.world2node(global.director.disSize[0]-200, global.director.disSize[1]-100);
        var width = rightBottom[0]-leftUp[0];
        var height = rightBottom[1]-leftUp[1];

//        trace("levelUpGoods", leftUp, rightBottom, width, height);

        //掉落10-15 编号的物品
        for(var i = 10; i < 15; i++)
        {
            var rx = (rand(width)+leftUp[0])/sizeX;
            var ry = (rand(height)+leftUp[1])/sizeY;

            if(rx%2 != ry%2)
                ry++;

            var curX = rx*sizeX;
            var curY = ry*sizeY;

            var fo = new FallObj(this, i, rx, ry, buildLayer);
            fo.setPos([rx*sizeX, ry*sizeY]);
            allFalls.append(fo);
//            trace("fallObj", rx, ry, ry*sizeY);
            buildLayer.addChildZ(fo, MAX_BUILD_ZORD+1);
        }
    }
    /*
    可以在模块初始化的时候生成所有概率分布值
    
    掉落物品的类型
    掉落物品的区域
    */
    function getNewFall()
    {
        var rv = rand(sum(possible));
        var kind = len(possible)-1;
        for(var i = 1; i <= len(possible); i++)
        {
            var s = Sum(possible, i);
            if(rv <= s)
            {
                kind = i-1;       
                break;
            }
        }
        kind = ids[kind];
        
        var fallData = getData(FALL_THING, kind);
        //掉落物品有次数 限制 
        var times = fallData.get("times");
//        trace("fallData", fallData, kind, rv, ids, times);

        if(times > 0)
        {
            var fallNum = global.user.getFallNum(kind);
//            trace("fallNum", fallNum);
            //超过掉落的最大次数 则停止掉落
            if(fallNum >= times)
            {
                lastFallTime = FALL_TIME;
                return;
            }
            else
            {
                global.user.updateFallNum(kind);
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
            lastFallTime = FALL_TIME;
//            trace("Fall not in zone");
            return;
        }
        var col = global.user.checkFallGoodCol(rx, ry);
//        trace("FallGoods", rx, ry, col);
        if(col == 1)
        {
            lastFallTime = FALL_TIME;
            return;
        }
        var fo = new FallObj(this, kind, rx, ry, buildLayer);
        fo.setPos([rx*sizeX, ry*sizeY]);
        allFalls.append(fo);
//        trace("fallObj", rx, ry, ry*sizeY);
        buildLayer.addChildZ(fo, ry*sizeY);

        //ry*sizeY  普通掉落物品显示在最高的位置 
        //用户升级 掉落物品 供用户拾取
    }

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
