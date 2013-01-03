/*
掉落物品在buildLayer 上面
*/
class FallGoods extends MyNode
{
    var allFalls;
    var map;
    var lastFallTime = getParam("FallTime");
    var Zone = [[60, 492, 774, 468], [831, 483, 294, 537], [1920, 510, 357, 480], [2292, 483, 576, 429]];
    var possible = [];
    var ids = [];
    var buildLayer;
    var fallTimes = 0;
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
        global.msgCenter.registerCallback(MOVE_TO_FALL, this);
    }
    //100s
    function update(diff)
    {
        lastFallTime += diff;
        if(lastFallTime >= getParam("FallTime") )
        {
            lastFallTime = 0;
            //最多掉落物品
            if(len(allFalls) < getParam("FallNum"))
            {
                for(var i = 0; i < getParam("EachFallNum") && len(allFalls) < getParam("FallNum"); i++)
                    getNewFall();       
                fallTimes++;
            }
            else
            {
                if(len(allFalls) > 0)
                {
                    var f = allFalls.pop(0);//删除旧的没有拾取的物品
                    f.removeSelf();
                }
            }
        }
    }
    //得到当前屏幕中心 生成 若干 掉落物品
    function getLevelUpFallGoods()
    {
        var leftUp = buildLayer.bg.world2node(200, 100);
        var rightBottom = buildLayer.bg.world2node(global.director.disSize[0]-200, global.director.disSize[1]-100);
        var width = rightBottom[0]-leftUp[0];
        var height = rightBottom[1]-leftUp[1];

//        trace("levelUpGoods", leftUp, rightBottom, width, height);

        //掉落10-15 编号的物品
        for(var i = 10; i < 15; i++)
        {
            var rx = (rand(width)+leftUp[0])/SIZEX;
            var ry = (rand(height)+leftUp[1])/SIZEY;

            if(rx%2 != ry%2)
                ry++;

            var curX = rx*SIZEX;
            var curY = ry*SIZEY;

            var fo = new FallObj(this, i, rx, ry, buildLayer, fallTimes);
            fo.setPos([rx*SIZEX, ry*SIZEY]);
            allFalls.append(fo);
            buildLayer.addChildZ(fo, MAX_BUILD_ZORD+1);
        }
    }
    /*
    可以在模块初始化的时候生成所有概率分布值
    
    掉落物品的类型
    掉落物品的区域
    */

    function getFallObjOnMap()
    {
        var fo = new FallObj(this, ids[0], 0, 0, buildLayer, fallTimes);
        //直接设定 掉落物品位置
        fo.bg.pos(2090, 750);
        allFalls.append(fo);
        buildLayer.addChildZ(fo, MAX_BUILD_ZORD);
        return fo;
    }
    function receiveMsg(param)
    {
        trace("receiveFall", param);
        var msgId = param[0];
        if(msgId == MOVE_TO_FALL)
        {
            var fo = getFallObjOnMap();
            map.moveToBuild(fo);
            global.taskModel.showHintArrow(fo.bg, fo.bg.size(), PICK_FALL);
        }
    }
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

        var rx = rand(MapWidth/SIZEX);
        var ry = rand(MapHeight/SIZEY);
        if(rx%2 != ry%2)
            ry++;
        var curX = rx*SIZEX;
        var curY = ry*SIZEY;
        for(i = 0; i < len(Zone); i++)
        {
            var difx = curX - Zone[i][0];
            var dify = curY - Zone[i][1];
            if(difx > 0 && difx < Zone[i][2] && dify > 0 && dify < Zone[i][3])
                break;
        }
        //超出边界 冲突 不掉落
        if(i > len(Zone))
        {
            //lastFallTime = getParam("FallTime");
            return;
        }
        var col = buildLayer.checkFallGoodCol(rx, ry);
        if(col == 1)
        {
            //lastFallTime = getParam("FallTime");
            return;
        }
        //根据当前掉落次数计算奖励 reward = min(base+add*times max)
        var fo = new FallObj(this, kind, rx, ry, buildLayer, fallTimes);
        fo.setPos([rx*SIZEX, ry*SIZEY]);
        allFalls.append(fo);
        buildLayer.addChildZ(fo, ry*SIZEY);

        //ry*SIZEY  普通掉落物品显示在最高的位置 
        //用户升级 掉落物品 供用户拾取
        return fo;
    }

    function pickObj(obj)
    {
        allFalls.remove(obj);
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(MOVE_TO_FALL, this);
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
