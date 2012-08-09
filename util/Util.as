
function replaceStr(s, rep)
{
//    trace("replaceStr", s, rep);
    for(var i = 0; i < len(rep); i += 2)
    {
        if(type(rep[i+1]) != type(""))
        {
//            trace("error type", rep[i+1]);
            continue;
        }
        s = s.replace(rep[i], rep[i+1])
    }
    return s;
}
/*
调试方法， 注释掉全局函数 就能找到所有的调用位置
*/
function getStr(key, rep)
{
    var s = strings.get(key);
    if(type(s) == type([]))
    {
        s = s[LANGUAGE];
    }
//    trace("getStr", key, rep, s);
    if(type(rep) == type([]))
    {
        for(var i = 0; i < len(rep); i += 2)
        {
            if(type(rep[i+1]) != type(""))
            {
//                trace("error type", rep[i+1]);
                continue;
            }
            s = s.replace(rep[i], rep[i+1]);
        }
    }
    return s;
}
function getWorldPos(n, points)
{
    //trace("points", points);
    var newPos = dict();
    var item = points.items();
    for(var i = 0; i < len(item); i++)
    {
        if(item[i][0] != -1)
        {
            var pos = item[i][1];
            var np = n.node2world(pos[0], pos[1]);
            newPos.update(item[i][0], np);
        }
    }
    return newPos;
}
function distance2(p1, p2)
{
    var difx = p1[0]-p2[0];
    var dify = p1[1]-p2[1];
    return max(abs(difx), abs(dify));
}
function distance(p1, p2)
{
    var difx = p1[0]-p2[0];
    var dify = p1[1]-p2[1];
    return sqrt(difx*difx+dify*dify);
}
function midMove(oldPos, newPos)
{
    var difx = oldPos[1][0]-oldPos[0][0];
    var dify = oldPos[1][1]-oldPos[0][1];
    var midOld = [oldPos[0][0]+difx/2, oldPos[0][1]+dify/2];

    difx = newPos[1][0]-newPos[0][0];
    dify = newPos[1][1]-newPos[0][1];
    var midNew = [newPos[0][0]+difx/2, newPos[0][1]+dify/2];
    return [midNew[0]-midOld[0], midNew[1]-midOld[1]];
}
function checkIn(bg, pos)
{
    var p = bg.world2node(pos[0], pos[1]);
    var bsize = bg.size();
    return p[0] > 0 && p[0] < bsize[0] && p[1] > 0 && p[1] < bsize[1];
}
function MoveMonster(p1, p2, speed)
{
    var difx = p2[0]-p1[0];
    var dify = p2[1]-p1[1];
    var dist = distance(p1, p2);
    var speX = speed*difx/dist;
    var speY = speed*dify/dist;
    return [speX, speY];
}
function Sign(v)
{
    if(v > 0)
        return 1;
    if(v < 0)
        return -1;
    return 0;
}

function Sum(arr, k)
{
    var s = 0;
    for(var i = 0; i < k; i++)
    {
        s += arr[i];   
    }
    return s;
}
//pos:World coord
function checkInChild(bg, pos)
{
    var sub = bg.subnodes();
    if(sub == null)
        return null;
//    trace("inchild", len(sub));
    for(var i = 0; i < len(sub); i++)
    {
        var inIt = checkIn(sub[i], pos);
        if(inIt)
            return sub[i];
    }
    return null; 
}
/*
直接返回所有的条目， 即便是0 
这里只返回非0条目的目的是为了商店显示价格的时候， 只显示非0条目
*/
//costKey 不包含level的需求，因此在检测需求的时候需要确认level存在
//doCost不包含level
function getCost(kind, id)
{
//    trace("getCost", kind, id);
    var build = getData(kind, id);
    var cost = dict();
    for(var i = 0; i < len(costKey); i++)
    {
        var v = build.get(costKey[i], 0);
        if(v > 0)
            cost.update(costKey[i], v);
    }
    return cost;
}
/*
如果key中包含有gain 则需要替换掉gain
*/
function getGain(kind, id)
{
//    trace("getGain", kind, id);
    var build = getData(kind, id);
    var gain = dict();
    for(var i = 0; i < len(addKey); i++)
    {
        var v = build.get(addKey[i], 0);
        if(v > 0)
        {
            var newKey = addKey[i].replace("gain", "");
            gain.update(newKey, v);
        }
    }
    return gain;
}

function getBuildGain(id)
{
    var build = buildingData.get(id);
    var gain = dict([["people", build[12]]]);
    return gain;
}
/*
两种思路：
每个建筑持有这样一个dict对象 并向里面添加新的属性 可以统一管理静态和动态属性
建筑需要的时候，根据自身的id 来构建这样一个对象 节约空间
    
所有物品的名字都通过字符串函数得到

物品的ID 不能 超过100000 5次
*/
//KIND*100000+id = key --->data
var dataPool = dict();
function getData(kind, id)
{
//    trace("getData", kind, id);
    var key = kind*100000+id;
    var ret = dataPool.get(key, null);
    if(ret == null)
    {
        var k = Keys[kind];
        var datas = CostData[kind].get(id);
        ret = dict();

        for(var i = 0; i < len(k); i++)
        {
            if(k[i] == "name")
                ret.update(k[i], getStr(datas[i], null));
            else if(k[i] == "title" || k[i] == "des")//任务的描述字符串 配方的描述字符串 药材矿石的描述字符串
            {
                ret.update(k[i], getStr(datas[i], null));
            }
            else
                ret.update(k[i], datas[i]);
        }
        dataPool.update(key, ret);
    }
//    trace("getData", kind, id, key, ret);
    return ret;
}


function storeScalePic(pic)
{
    pic.prepare();
    var buildSize = pic.size();
    var bl = min(127*100/buildSize[0], 101*100/buildSize[1]);
    bl = min(120, max(40, bl));
    pic.scale(bl);
}
function getAni(id)
{
    return buildAnimate.get(id);
}
function getZone()
{
}

function getWorkTime(t)
{
//    trace("workTime", t);
    var sec = t % 60;
    t = t / 60;
    var min = t % 60;
    var hour = t / 60;
    var res = str(hour)+":"+str(min)+":"+str(sec);
    return res;
}
function getTimeStr(t)
{
    var sec = t % 60;
    t = t / 60;
    var min = t % 60;
    var hour = t / 60;
    var res = "";
    if(hour != 0)
        res += str(hour)+"h";
    if(min != 0)
        res += str(min)+"m";
    if(sec != 0)
        res += str(sec)+"s";
    return res;
}

function checkInZone(position)
{
    for(var i = 0; i < len(FullZone); i++)
    {
        var zone = FullZone[i];
        var difx = position[0] - zone[0];
        var dify = position[1] - zone[1];
        if(difx >= 0 && difx < zone[2] && dify > 0 && dify < zone[3])
            return 1;
    }
    return 0;
}

function checkInTrain(p)
{   
    var difx = p[0] - TrainZone[0];
    var dify = p[1] - TrainZone[1];
    return difx > 0 && difx < TrainZone[2] && dify > 0 && dify < TrainZone[3]; 
}

/*
function getBoundary(dia)
{
    var x0 = dia[2]-(dia[0]+dia[1])/2*sizeX;
    var y0 = dia[3]-(dia[0]+dia[1])/2*sizeY;
    var x1 = x0+dia[1]*sizeX;
    var y1 = y0;
    var x2 = x0+dia[0]*sizeX;
    var y2 = y0+(dia[0]+dia[1])*sizeY;
    //trace("x1, y1, x2, y2", x1, y1, x2, y2);
    return [x1, y1, x2, y2];
}
function getT1(x, y)
{
    if(x == 0 && y == 0)
        return 0;
    var t1 = (x*sizeX+y*-sizeY)/sqrt(x*x+y*y);
    return t1;
}
function getT2(x, y)
{
    if(x == 0 && y == 0)
        return 0;
    var t2 = (x*-sizeX+y*-sizeY)/sqrt(x*x+y*y);
    return t2;
}
function getABound(a)
{
    var aBound = getBoundary(a);
    var t1 = getT1(aBound[0], aBound[1]);
    var t2 = getT2(aBound[0], aBound[1]);
    var t11 = getT1(aBound[2], aBound[3]);
    var t22 = getT2(aBound[2], aBound[3]);
    aBound = [t1, t2, t11, t22];
    return aBound;
}
*/
//[sx sy px py] [sx sy px py]
/*
冲突检测的精度问题， 
除非采用离散化方法， 否则冲突检测存在精度问题
根据建筑物结构， 当前位置是标准化的（50， 100）
所以可以直接计算相应格子
*/
/*
function checkCol(a, b)
{
    //a = [a[0], a[1], 0, 0];
    //b = [b[0], b[1], b[2]-a[2], b[3]-a[3]]
    //a = [a[0], a[1], 0, 0];

    //var aBound = getABound(a);
    //var bBound = getABound(b);
    //trace("checkCollision", a, b, aBound, bBound);
    var difx = a[2]-b[2];
    var dify = a[3]-b[3];
    var cx = difx/sizeX;
    var cy = dify/sizeY;
    //var size0 = [(a[0])/2*sizeX, (a[0])/2*sizeY];
    //var size1 = [(b[0])/2*sizeX, (b[0])/2*sizeY];
    var total = a[0]+b[0];

    return (abs(cx)+abs(cy)) < total;
    
    //return abs(difx) < (size0[0]+size1[0]-4) && abs(dify) < (size0[1]+size1[1]-4);
    //return aBound[0] < bBound[2] && aBound[2] > bBound[0] && aBound[1] < bBound[3] && aBound[3] > bBound[1]; 
}
*/
/*
返回菱形拼图的左上角第一块的中心的编号
自动调整x y值 使其奇偶性相同
*/
function getBuildMap(build)
{
    var sx = build.sx;
    var sy = build.sy;
    var p = build.getPos();
    var px = p[0];
    var py = p[1];

    return getPosMap(sx, sy, px, py);

}
/*
根据位置 大小 计算map图 
*/
function getPosMap(sx, sy, px, py)
{
    px -= (sx+sy)*sizeX/2;
    py -= (sx+sy)*sizeY;

    px /= sizeX;
    py /= sizeY;
    //trace("getBuildMap", px+sx, py+1);
    return [sx, sy, px+sx, py+1];
}
/*
根据map计算建筑物的位置
*/
function setBuildMap(map)
{
    var sx = map[0];
    var sy = map[1];
    var px = map[2];
    var py = map[3];

    px -= sx;
    py -= 1;
    px *= sizeX;
    py *= sizeY;
    px += (sx+sy)*sizeX/2;
    py += (sx+sy)*sizeY;
    return [px, py];
}
/*
使用绝对坐标进行规整化
标准化使用的单位大于冲突计算的单位，可以避免精度损失的问题
*/
function normalizePos(p, sx, sy)
{
    var x = p[0];
    var y = p[1];
    x -= (sx+sy)*sizeX/2;
    y -= (sx+sy)*sizeY;

    //x -= FullZone[0];
    //y -= FullZone[1];
    var q1 = x/sizeX;
    var q2 = y/sizeY;
    if(((q1+sx)%2) != ((q2+1)%2))//q1+sx q2+1 要求建筑物最上方的菱形对齐 
    {
        q2++;
    }
    x = q1*sizeX;
    y = q2*sizeY;

    x += (sx+sy)*sizeX/2;
    y += (sx+sy)*sizeY;
    return [x, y];
    //return [x+FullZone[0], y+FullZone[1]];
}
/*
function checkCollision(build, buildings)
{
    var sx1 = build.data.get("sx");
    var sy1 = build.data.get("sy");
    var bSize = build.getPos();
    var px1 = bSize[0];
    var py1 = bSize[1];



    for(var i = 0; i < len(buildings); i++)
    {
        if(build != buildings[i])
        {
            var sx2 = buildings[i].data.get("sx");
            var sy2 = buildings[i].data.get("sy");
            var oSize = buildings[i].getPos();

            var ret = checkCol([sx1, sy1, px1, py1], [sx2, sy2, oSize[0], oSize[1]]); 
            if(ret == 1)
                return buildings[i];
        }
    }
    return null;
}
*/
//0 1 2 3 4 5
//0村庄 所以初始化用户数据大关=1 0 0
//1 2 3 4 5
/*
function getMaxLevel(big, small, difficult)
{
    return (big-1)*6*10+small*10+difficult;
}
function getBSD(level)
{
    var difficult = level%10;
    var small = level/10;
    var big = small/6;
    small %= 6;
    return [big+1, small, difficult];
}
*/
const PassDifficult = 0;
//1-5
/*
计算大地图当前开启的大关 小关
*/
function getCurEnableDif()
{
    var star = global.user.starNum;
    var i;
    var j;
    var find = 0;
//    trace("curEnable ", star);
    for(i = 0; i < len(star); i++)
    {
        for(j = 0; j < len(star[i]); j++)
            if(star[i][j][PassDifficult] == 0)
            {
                find = 1;
                break;
            }
        if(find == 1)
            break;
    }
    //enable big=i
    //enable small = j
    return [i+1, j];
}
/*
得到某个小关卡 难度的得分
*/
function getStar(big, small, dif)
{
    var star = global.user.starNum;
    return star[big-1][small][dif]; 
}
/*
function checkPosSame(p1, p2)
{
    return p1[0]==p2[0] && p1[1]==p2[1];
}
*/

/*
假定消耗的物品非0 飞向的是经营页面的菜单栏位置
*/
/*
function flyObject(bg, cost, callback)
{
    var TarPos = dict([["silver", [297, 460]], ["crystal", [253, 460]], ["gold", [550, 460]]]);
    var bsize = bg.size();
    var coor2 = bg.node2world(bsize[0]/2, bsize[1]/2);

    var item = cost.items();
    for(var i = 0; i < len(item); i++)
    {
        var k = item[i][0];
        var v = item[i][1];
        var obj = getscene().addsprite(str(k)+".png");
        var tar = TarPos.get(k);
        var dis = sqrt(distance(coor2, tar));
        obj.addaction(sequence(sinein(bezierby(
                    500+dis*25,
                    coor2[0], coor2[1], 
                    coor2[0]+100, coor2[1]-100, 
                    coor2[0]+100, coor2[1]+100, 
                    tar[0], tar[1])),callfunc(callback)));
        
    }
}
*/
/*
function getFallThing(kind)
{
    var v = fallThings[kind];
//    trace("getFallThing", v);
    return dict([["silver", v[1]], ["crystal", v[2]], ["gold", v[3]]]);
}
*/
/*
building id-->function id -> function array
*/
function getBuildFunc(id)
{
    return buildFunc.get(id);   
}
function getZord(curPos)
{
    return curPos[1];
}

function checkPlaning()
{
    //trace("curScene", type(global.director.curScene), type(CastleScene));
    if(global.staticScene == null)
        return 0;
    if(global.director.curScene == global.staticScene)
        return global.director.curScene.Planing;
    return 0;
}
/*
访问是否存在临时的动画数组，如果不存在则拼接一个并存储在全局范围中，下次调用可以重用
*/
function getMoveAnimate(id)
{
    var ani = moveAnimate.get(id, null);
    if(ani != null)
        return ani;
    var data = getData(SOLDIER, id);
    var num = data.get("moveNum");
    var pics = [];
    for(var i = 0; i < num; i++)
    {
        pics.append("ss"+str(id)+"m"+str(i)+".png"); 
    }
    ani = [pics, 2000];
    moveAnimate.update(id, ani);
    return ani;
}
function getAttAnimate(id)
{
    var ani = attAnimate.get(id);
    if(ani != null)
        return ani;
    var data = getData(SOLDIER, id);
    var num = data.get("attNum");
    var pics = [];
    for(var i = 0; i < num; i++)
    {
        pics.append("ss"+str(id)+"a"+str(i)+".png"); 
    }
    ani = [pics, 1000];
    attAnimate.update(id, ani);
    return ani;
}

function colorWords(str)
{
//    trace("colorWords", str);
    var end = str.split("]");
    var begin = end[0].split("[");
    var lenBegin = len(begin[0])/3;
//    trace("color", begin, lenBegin);
    return [begin[0], begin[1], lenBegin];
}

function getMagicAnimate(id)
{
    var ani = magicAnimate.get(id);
    return ani;
}
function getMapAnimate(id)
{
    var ani = mapAllAnimate.get(id);
    if(ani == null)
        return null;
    var res = [];
    for(var i = 0; i < len(ani); i++)
    {
        res.append(mapAnimate.get(ani[i]));
    }
    return res;
}


/*
获得某个士兵地图格子映射 50 100 2*2
x 1 - 11     1-5  7-11
y 0 - 4  
返回左上角的格子编号
士兵的Y值存在 偏移 offY
*/
function getSolMap(p, sx, sy, offY)
{
    var ix = p[0]-MAP_INITX-MAP_OFFX/2*sx;
    var xk = ix/MAP_OFFX;
    var iy = p[1]-MAP_INITY-MAP_OFFY*sy-offY;
    var yk = iy/MAP_OFFY;

    return [xk, yk];
}
function getGridPos(gridId)
{
    var x = gridId[0]*MAP_OFFX+MAP_INITX;
    var y = gridId[1]*MAP_OFFY+MAP_INITY;
    return [x, y];
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
根据某个坐标计算网格对齐坐标
返回士兵需要的对齐坐标
限制坐标的范围
*/

/*
由格子计算士兵的坐标
*/
//0-12 0-4
function getSolPos(mx, my, sx, sy, offY)
{
//    trace("getSolPos", offY);
    mx = mx*MAP_OFFX+MAP_OFFX/2*sx+MAP_INITX;
    my = my*MAP_OFFY+MAP_OFFY*sy+MAP_INITY+offY;
    return [mx, my];
}


/*
计算到某个等级需要的所有经验
*/
function getExp(level)
{
    return 50;
}
/*
返回未完成的任务
返回已经完成但是没有领取奖励的
res [id, curNum]

升级更新任务列表
完成任务更新数据
*/
function getCurLevelAllTask(level)
{
    var res;
    var it = taskData.keys(); 
    var fin = [];
    var notFin = [];
    for(var i = 0; i < len(it); i++)
    {
        var ta = getData(TASK, it[i]);
        if(ta.get("level") <= level)
        {
            var d = global.user.getTaskFinData(it[i]);
            if(d[1] == 0)
            {
                if(d[0] >= ta.get("need"))
                    fin.append([it[i], d[0]]);
                else
                    notFin.append([it[i], d[0]]);
            }
        }
    }
    res = fin + notFin;
//    trace("curLevelAllTask", level, res);
    return res;
}
function getSca(n, box)
{
    var nSize = n.prepare().size();
    var sca = min(box[0]*100/nSize[0], box[1]*100/nSize[1]);
    sca = max(min(150, sca), 50);
    return sca;
}
function removeTempNode(n)
{
    n.removefromparent();
}
//0  近战--->远程
//1 远程---> 魔法师
//2 魔法师--->克制近战
var soldierKindCoff = dict([
[1, 120],
[1002, 120],
[2000, 120],
]);
//attacker defenser
function getSoldierKindCoff(attKind, defKind)
{
    var key = attKind*1000+defKind;
    return soldierKindCoff.get(key, 100);
}


/*
可能存在问题 show 和close 出现的时机不一致 就会导致 经营页面的菜单出现问题
*/
function showCastleDialog()
{
    //global.msgCenter.sendMsg(SHOW_DIALOG, 0);
}

function closeCastleDialog()
{
    global.director.popView();
    //global.msgCenter.sendMsg(SHOW_DIALOG, 1);
}
function removeMapEle(arr, obj)
{
    for(var i = 0; i < len(arr); i++)
    {
        if(arr[i][0] == obj)
        {
            arr.pop(i);
            break;
        }
    }
}

function changeToSilver(data)
{
    var key = data.keys();
    //不能归还金币 和 水晶 1金币 = 2水晶 = 1000银币
    var addSilver = 0;
    for(var i = 0; i < len(key); i++)
    {
        var val = data.get(key[i]);
        if(key == "gold")
        {
            addSilver += val*1000/SELL_RATE;
        }
        else if(key == "crystal")
        {
            addSilver += val*500/SELL_RATE;
        }
        else
            addSilver += val/SELL_RATE;
    }
//    trace("changeToSilver", data, addSilver);
    data = dict([["silver", addSilver]]);

    return data;
}
//秒为单位
function server2Client(t)
{
    return t-global.user.serverTime+global.user.clientTime;
}
function client2Server(t)
{
    return t-global.user.clientTime+global.user.serverTime;
}
//可以初始化时构造level更新数组
function getAllData(kind)
{
    var datas = dict();
    var key = CostData[kind].keys();
    for(var i = 0; i < len(key); i++)
    {
        var d = getData(kind, key[i]);
        var lev = datas.get(d.get("level"), []);
        lev.append([kind, d]);
        datas.update(d.get("level"), lev);
    }
    return datas;
}
//level ---> kind id
function getLevelupThing()
{
    var allSoldiers = getAllData(SOLDIER);
    var allBuildings = getAllData(BUILD);
    var lev = global.user.getValue("level");
    var res1 = allSoldiers.get(lev, []);
    var res2 = allBuildings.get(lev, []);
    return res1+res2;
}
//0 == 1 > -1  <
//mid Element = first
//until begin >= end
//qsort = qsort(A) + midElement + qsort(B)
function qsort(obj, begin, end, cmp)
{
    if(begin >= end)
        return;
    var initX = begin;
    var mid = obj[begin];
    for(var i = begin+1; i < end; i++)
    {
        var ret = cmp(mid, obj[i]);
        if(ret > 0)// small ---> big
        {
            var temp = obj[i];
            obj[i] = obj[initX];
            obj[initX] = temp;
            initX++;
        }
    }
    obj[initX] = mid;
    qsort(obj, begin, initX-1, cmp);
    qsort(obj, initX+1, end, cmp);
}

