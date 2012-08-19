//Map big 已经-1  因为0是村子
function getRoundMonster(big, small)
{
    var k = big*10+small;
    var data = mapMonsterData.get(k);
    var res = [];
    for(var i = 0; i < len(data); i++)
    {
        var r = dict();
        for(var j = 0; j < len(mapMonsterKey); j++)
        {
            r.update(mapMonsterKey[j], data[i][j]);
        }
        res.append(r);
    }
    trace("mapMonster", res);
    return res;
}

function getRandomMapReward(big, small)
{
    var reward = mapReward.get(big*10+small);
    var v1;
    var v2;
    var v3;
    var v4;
    var res;

    var k1;
    var k2;
    var k3;
    var k4;
    //小关最后一关4 种 数量 1-10
    if(small == 6)
    {
        v1 = rand(10)+1; 
        v2 = rand(10)+1; 
        v3 = rand(10)+1; 
        v4 = rand(10)+1;

        k1 = rand(len(reward));
        k2 = (k1+1)%len(reward);
        k3 = (k1+2)%len(reward);
        k4 = (k1+3)%len(reward);
        
        res = [[k1, v1], [k2, v2], [k3, v3], [k4, v4]];
    }
    //2种 1-5
    else
    {
        v1 = rand(5)+1;
        v2 = rand(5)+1;
        res = [[reward[0], v1], [reward[1], v2]];
    }
    return res;
}


/*
战斗地图使用的Map 函数
获得某个士兵地图格子映射 50 100 2*2
x 1 - 11     1-5  7-11
y 0 - 4  
返回左上角的格子编号
士兵的Y值存在 偏移 offY

范围攻击技能的

士兵是50 100
群体技能 是 50 50 位置
*/
function getSolMap(p, sx, sy, offY)
{
    var ix = p[0]-MAP_INITX-MAP_OFFX/2*sx;
    var xk = ix/MAP_OFFX;
    var iy = p[1]-MAP_INITY-MAP_OFFY*sy-offY;
    var yk = iy/MAP_OFFY;

    return [xk, yk];
}
function getSkillMap(p, sx, sy, offY)
{
    var ix = p[0]-MAP_INITX-MAP_OFFX/2*sx;
    var xk = ix/MAP_OFFX;
    var iy = p[1]-MAP_INITY-MAP_OFFY/2*sy-offY;
    var yk = iy/MAP_OFFY;

    return [xk, yk];
}
/*
计算安排士兵时 的 士兵下方网格的位置

士兵和技能的网格 都是 左上角网格
*/
function getGridPos(gridId)
{
    var x = gridId[0]*MAP_OFFX+MAP_INITX;
    var y = gridId[1]*MAP_OFFY+MAP_INITY;
    return [x, y];
}
/*
function getSolPos(mx, my, sx, sy, offY)
{
//    trace("getSolPos", offY);
    mx = mx*MAP_OFFX+MAP_OFFX/2*sx+MAP_INITX;
    my = my*MAP_OFFY+MAP_OFFY*sy+MAP_INITY+offY;
    return [mx, my];
}
*/
//计算群体技能的位置
function getSkillPos(mx, my, sx, sy)
{
    mx = mx*MAP_OFFX+MAP_OFFX/2*sx+MAP_INITX;
    my = my*MAP_OFFY+MAP_OFFY*sy+MAP_INITY;
    return [mx, my];
}

/*
根据手指的位置计算相应的 网格编号
一个大型士兵有2*2个网格 得到的是 左下角的网格
位置是 anchor 50 100 位置

放置士兵的时候
士兵移动的时候
士兵的zord

限制当前网格的位置 左上角 右下角 超出边界则消失

返回左上角网格的编号

手指点击士兵网格的中心

对齐网格
*/
function getPosSolMap(p, sx, sy)
{
    var ix = p[0]-MAP_INITX-MAP_OFFX/2*sx;
    var xk = ix/MAP_OFFX;
    //var xk = min(MAP_WIDTH-sx, max(0, k));

    var iy = p[1]-MAP_INITY-MAP_OFFY/2*sy;
    var yk = iy/MAP_OFFY;
    //var yk = min(MAP_HEIGHT-sy, max(0, k));

    return [xk, yk];
}

/*
由格子计算士兵的坐标

根据左上格子的坐标 计算 50 100 的位置
*/
//0-12 0-4
function getSolPos(mx, my, sx, sy, offY)
{
//    trace("getSolPos", offY);
    mx = mx*MAP_OFFX+MAP_OFFX/2*sx+MAP_INITX;
    my = my*MAP_OFFY+MAP_OFFY*sy+MAP_INITY+offY;
    return [mx, my];
}

//<= bigNum
function getOpenBig()
{
    var level = global.user.getValue("level");
    if(level < 15)
        return 1;
    if(level < 30)
        return 2;
    if(level < 40)
        return 3;
    if(level < 50)
        return 4;
    return 5;
}
