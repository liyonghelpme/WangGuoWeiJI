//id = big *100 + small  比较合适 可以扩展
function getRoundMonster(big, small)
{
    return realGenRoundMonster(big*getParam("MapMonsterNumCoff")+small);
}
//1 大关奖励 1个 
//2 大关奖励 2 个
function getMapReward(big, small)
{
    return getGain(ROUND_MAP_REWARD, big*getParam("MapMonsterNumCoff")+small);
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

偏移半个格子
*/
function getSolMap(p, sx, sy, offY)
{
    var ix = p[0]+MAP_OFFX/2-MAP_INITX-MAP_OFFX/2*sx;
    var xk = ix/MAP_OFFX;
    var iy = p[1]+MAP_OFFY/2-MAP_INITY-MAP_OFFY*sy-offY;
    var yk = iy/MAP_OFFY;

    return [xk, yk];
}

//skill Map ---> 50 50 heart 

//根据手指 50 50 计算 技能网格的左上角位置
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

根据网格左上角位置 实际位置
*/
function getGridPos(gridId)
{
    var x = gridId[0]*MAP_OFFX+MAP_INITX;
    var y = gridId[1]*MAP_OFFY+MAP_INITY;
    return [x, y];
}
//计算群体技能的左上角网格得到的 0 0 的位置偏移位置
//群体技能应该有偏移值
function getSkillPos(mx, my, sx, sy, offX, offY)
{
    //+MAP_OFFX/2*sx
    //+MAP_OFFY*sy
    mx = mx*MAP_OFFX+MAP_INITX+offX;
    my = my*MAP_OFFY+MAP_INITY+offY;
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



function getTotalStar(big)
{
    if(big < 0)
        return 0;

    var star = global.user.starNum;
    var total = 0;
    for(var i = 0; i < len(star[big]); i++)
    {
        total += star[big][i];
    }
    return total;
}
//检测应该开启 等级
//0 1 2 3 4
function checkBigEnable(big)
{
    if(big <= 0)
        return 1;

    var star = global.user.starNum;
    var unlockLevel = global.user.unlockLevel;
    //已经解锁
    if(unlockLevel.count(big) > 0)
        return 1;

    //前一关卡所有小关都闯过
    var lastRound = star[big-1];
    if(lastRound[len(lastRound)-1] > 0)
        return 1;

    return 0;
}
function checkBigSmallEnable(big, small)
{
    var star = global.user.starNum;
    //第一小关 检测当前大关是否开启
    if(small == 0)
    {
        return checkBigEnable(big);
    }
    //检测上一小关是否开启
    else
    {
        return star[big][small-1] > 0;
    }
}

function getMaxBigEnable()
{
    for(var i = PARAMS.get("bigNum")-1; i >= 0; i--)
    {
        var ena = checkBigEnable(i);
        if(ena)
            return i;
    }
    return 0;
}


//check enable
//level starNum curStar --->enable
//enable = 0 -----> condition satisfy--->enable 

function getChallengeNeiborCry(nid)
{
    var neibor = global.friendController.getNeiborData(nid);
    var cry;
    cry = getProduction(neibor.get("mineLevel"));
    if(neibor.get("level") < global.user.getValue("level"))
        cry = cry/10;
    else if(neibor.get("level") == global.user.getValue("level"))
        cry = cry/5;
    else
        cry = cry/2;
    return max(cry, 1);
}
//闯关页面 两个矩形的相交测试
function checkInterSect(rect1, rect2)
{
    //trace("checkInterSect", rect1, rect2);
    return rect1[0] < (rect2[0]+rect2[2]) && rect1[1] < (rect2[1]+rect2[3]) &&  rect2[0] < (rect1[0]+rect1[2]) && rect2[1] < (rect1[1]+rect1[3]);
}
