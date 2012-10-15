
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
    var s;
    s = WORDS.get(key);
    if(s == null)
        s = strings.get(key);
    if(s == null)
        s = SolNames.get(key);
    if(s == null)
        return "";

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

/*
function getObjKey(kind, id)
{
    return kind*10000+id;
}
function getObjKindId(v)
{
    return [v/10000, v%10000];
}
*/
function getData(kind, id)
{
    //var key = getObjKey(kind, id);
    var key = getGoodsKey(kind, id);
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
                ret.update(k[i], getStr(datas[i], null));
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
        res += str(hour)+"h ";
    if(min != 0)
        res += str(min)+"m ";
    //没有小时或者分钟则显示秒
    if((hour == 0 || min == 0) && sec != 0)
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
    //trace("checkInTrain", p, TrainZone);
    var difx = p[0] - TrainZone[0];
    var dify = p[1] - TrainZone[1];
    return difx > 0 && difx < TrainZone[2] && dify > 0 && dify < TrainZone[3]; 
}

/*
function getBoundary(dia)
{
    var x0 = dia[2]-(dia[0]+dia[1])/2*SIZEX;
    var y0 = dia[3]-(dia[0]+dia[1])/2*SIZEY;
    var x1 = x0+dia[1]*SIZEX;
    var y1 = y0;
    var x2 = x0+dia[0]*SIZEX;
    var y2 = y0+(dia[0]+dia[1])*SIZEY;
    //trace("x1, y1, x2, y2", x1, y1, x2, y2);
    return [x1, y1, x2, y2];
}
function getT1(x, y)
{
    if(x == 0 && y == 0)
        return 0;
    var t1 = (x*SIZEX+y*-SIZEY)/sqrt(x*x+y*y);
    return t1;
}
function getT2(x, y)
{
    if(x == 0 && y == 0)
        return 0;
    var t2 = (x*-SIZEX+y*-SIZEY)/sqrt(x*x+y*y);
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
    var cx = difx/SIZEX;
    var cy = dify/SIZEY;
    //var size0 = [(a[0])/2*SIZEX, (a[0])/2*SIZEY];
    //var size1 = [(b[0])/2*SIZEX, (b[0])/2*SIZEY];
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

建筑物的位置是 anchor 50 100 
建筑物菱形 所在的矩形的 左上角的位置--> + sx +1 得到最上子菱形位置编号
*/
function getPosMap(sx, sy, px, py)
{
    px -= (sx+sy)*SIZEX/2;
    py -= (sx+sy)*SIZEY;

    px /= SIZEX;
    py /= SIZEY;
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
    px *= SIZEX;
    py *= SIZEY;
    px += (sx+sy)*SIZEX/2;
    py += (sx+sy)*SIZEY;
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
    x -= (sx+sy)*SIZEX/2;
    y -= (sx+sy)*SIZEY;

    //x -= FullZone[0];
    //y -= FullZone[1];
    var q1 = x/SIZEX;
    var q2 = y/SIZEY;
    if(((q1+sx)%2) != ((q2+1)%2))//q1+sx q2+1 要求建筑物最上方的菱形对齐 
    {
        q2++;
    }
    x = q1*SIZEX;
    y = q2*SIZEY;

    x += (sx+sy)*SIZEX/2;
    y += (sx+sy)*SIZEY;
    return [x, y];
    //return [x+FullZone[0], y+FullZone[1]];
}
//0 1 2 3 4 5
//0村庄 所以初始化用户数据大关=1 0 0
//1 2 3 4 5
//const PassDifficult = 0;
//1-5
/*
计算大地图当前开启的大关 小关
返回big+1 small
1 2 3 4 5
*/

/*
得到某个小关卡 难度的得分
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

/*
function checkPlaning()
{
    //trace("curScene", type(global.director.curScene), type(CastleScene));
    if(global.staticScene == null)
        return 0;
    if(global.director.curScene == global.staticScene)
        return global.director.curScene.Planing;
    return 0;
}
*/

/*
访问是否存在临时的动画数组，如果不存在则拼接一个并存储在全局范围中，下次调用可以重用
*/
/*
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
*/

function colorWords(str)
{
//    trace("colorWords", str);
    var end = str.split("]");
    var begin = end[0].split("[");
    var lenBegin = len(begin[0])/3;
//    trace("color", begin, lenBegin);
    return [begin[0], begin[1], lenBegin];
}
//多行文字
//每行有多个颜色组成
//每个区间前6个字符表示颜色
//rrggbbxxxxx\nrrggbbxxxxxx\nrrggbbxxxxxxx]rrggbbxxxxx]
//rrggbbxxxxx]rrggbbxxxx]rrggbbxxxxxx]
/*
function stringLines(s, sz, lineHeight, color, ft)
{
    var n = node();
    s = s.split("\n");
    var nSize = [0, 0];
    for(var i = 0; i < len(s); i++)
    {
        var lab = n.addlabel(s[i], "fonts/heiti.ttf", sz, ft).pos(0, lineHeight * i).color(color);
        var lSize = lab.prepare().size();
        nSize[0] = max(lSize[0], nSize[0]);
        nSize[1] += lineHeight;
    }
    n.size(nSize);
    return n;
}
*/
//hex xx--->0-255
function hex2int(s)
{
    var temp = 0;
    var zero = ord("0");
    var aord = ord("a");
    var v = ord(s[0]);
    if((v-zero) < 10)
        temp += v-zero;
    else
        temp += v-aord+10;
    temp *= 16;
    v = ord(s[1]);
    if((v-zero) < 10)
        temp += (v-zero);
    else
        temp += v-aord+10;
    return temp;
}
function byte2Hundred(v)
{
    return v*100/255;
}

//{27\crystal.png} 10 购买
//{crystal.png} 10 购买
function picNumWord(w, sz, col)
{
    var n = node();
    var curX = 0;
    var curY = 0;
    var height = 0;
    var end = w.split("}");
    for(var i = 0; i < len(end); i++)
    {
        var begin = end[i].split("{");

        if(len(begin[0]) > 0)
        {
            var l = label(begin[0], "fonts/heiti.ttf", sz).anchor(0, 50).color(col).pos(curX, curY);
            n.add(l);
            var lSize = l.prepare().size();
            curX += lSize[0];
            height = max(height, lSize[1]);
            var shadow = label(begin[0], "fonts/heiti.ttf", sz).anchor(0, 0).color(0, 0, 0).pos(1, 1);
            l.add(shadow, -1);
        }
        if(len(begin) > 1)
        {
            var s = sprite(begin[1]).size(27, 27).anchor(0, 50).pos(curX, curY);
            n.add(s);
            var sSize = s.prepare().size();
            curX += sSize[0];
            height = max(sSize[1], height);
        }
    }
    n.size(curX, height);
    return n;
}
function colorLines(w, sz, lineHeight)
{
    var n = node();
    w = w.split("\n");
    var nSize = [0, 0];

    var curY = 0;
    var curX = 0;
    for(var i = 0; i < len(w); i++)
    {
        var line = w[i];
        var end = line.split("]");
        for(var j = 0; j < len(end); j++)
        {
            var part = end[j];
            if(len(part) > 0)
            {
                var r = byte2Hundred(hex2int(part.substr(0, 2)));
                var g = byte2Hundred(hex2int(part.substr(2, 4)));
                var b = byte2Hundred(hex2int(part.substr(4, 6)));
                part = part.substr(6);
                
                var l = label(part, "fonts/heiti.ttf", sz).color(r, g, b).pos(curX, curY);
                n.add(l);
                var lSize = l.prepare().size();
                curX += lSize[0];
                if(curX > nSize[0])
                    nSize[0] = curX;
            }
        }
        curX = 0;
        curY += lineHeight;
    }
    nSize[1] = curY;
    n.size(nSize);
    return n;
}
/*
根据文字中格式标号决定颜色
字符串 大小 正常颜色 加重颜色
*/
function colorWordsNode(s, si, nc, sc)
{
    var n = node();
    var end = s.split("]");

    var curX = 0;
    var height = 0;
    for(var i = 0; i < len(end); i++)
    {
        if(end[i].find("[") != -1)//包含有特殊文字
        {
            var p = end[i].split("[");
            if(len(p[0]) > 0)
            {
                var l = label(p[0], "fonts/heiti.ttf", si).color(nc).pos(curX, 0);
                n.add(l);
                var lSize = l.prepare().size();
                curX += lSize[0];
                height = lSize[1];
            }

            if(len(p[1]) > 0)
            {
                l = label(p[1], "fonts/heiti.ttf", si).color(sc).pos(curX, 0);
                n.add(l);
                lSize = l.prepare().size();
                curX += lSize[0];
                height = lSize[1];
            }
        }
        else
        {
            if(len(end[i]) > 0)
            {
                l = label(end[i], "fonts/heiti.ttf", si).color(nc).pos(curX, 0);
                n.add(l);
                lSize = l.prepare().size();
                curX += lSize[0];
                height = lSize[1];
            }
        }
    }
    n.size(curX, height);
    return n;
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
根据某个坐标计算网格对齐坐标
返回士兵需要的对齐坐标
限制坐标的范围
*/



/*
计算到某个等级需要的所有经验
任务模块临时使用
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

function getNodeSca(n, box)
{
    var nSize = n.size();
    var sca = min(box[0]*100/nSize[0], box[1]*100/nSize[1]);
    sca = max(min(150, sca), 50);
    return sca;
}
function getSca(n, box)
{
    var nSize = n.prepare().size();
    if(nSize[0] > box[0] || nSize[1] > box[1])//只有超过最大尺寸的才缩放
    {
        var sca = min(box[0]*100/nSize[0], box[1]*100/nSize[1]);
        //sca = max(min(150, sca), 50);
    }
    else
        sca = 100;
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
        var k = key[i];
        var val = data.get(k);
        if(k == "gold")
        {
            addSilver += val*PARAMS["gold2Silver"]/PARAMS["sellRate"];
        }
        else if(k == "crystal")
        {
            addSilver += val*PARAMS["crystal2Silver"]/PARAMS["sellRate"];
        }
        else if(k == "silver")
            addSilver += val/SELL_RATE;
    }
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
/*
levelUpdate 数据中已经有了每级更新的数据
没有必要再使用getAllData  getLevelupThing 来为某个等级生成数据

levelUpdate 只有新种类士兵 没有 士兵转职
*/
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
//得到特定某个等级所有的士兵
function getLevelSoldier(lev)
{
    var curObj = levelUpdate.get(lev, []);
    for(var i = 0; i < len(curObj); i++)
    {
        if(curObj[i][0] == SOLDIER)
        {
            return curObj[i][1];
        }
    }
    return null;
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

function bubbleSort(obj, cmp)
{
    for(var i = len(obj)-1; i > 0; i--)
    {
        var flag = 0;
        for(var j = 0; j < i; j++)
        {
            if(cmp(obj[j], obj[j+1]) > 0)
            {
                flag = 1;
                var temp = obj[j+1];
                obj[j+1] = obj[j];
                obj[j] = temp;
            }
        }
        if(flag == 0)
            break;
    }
}
//等级 从 大到小排列
function insertArr(arr, obj, cmp)
{
    for(var i = 0; i < len(arr); i++)
    {
        if(cmp(arr[i], obj) > 0)
        {
            break;
        }
    }
    arr.insert(i, obj);
}

//返回node
//font sz
//lineHeight
//size = 20 height 25
function stringLines(s, sz, lineHeight, color, ft)
{
    var n = node();
    s = s.split("\n");
    var nSize = [0, 0];
    for(var i = 0; i < len(s); i++)
    {
        var lab = n.addlabel(s[i], "fonts/heiti.ttf", sz, ft).pos(0, lineHeight * i).color(color);
        var lSize = lab.prepare().size();
        nSize[0] = max(lSize[0], nSize[0]);
        nSize[1] += lineHeight;
    }
    n.size(nSize);
    return n;
}

//"-"+str(num)
//"+"+str(num)+"xp"
//"+"+str(num)+""
var fetchPlist = 0;
//const YELLOW = 0;
//const BLUE = 1;
function altasWord(c, s)
{
    var n = node();
    var plist = c+".plist";
    if(fetchPlist == 0)
    {
        fetchPlist = 1;
        load_sprite_sheet("yellow.plist"); 
        load_sprite_sheet("blue.plist");
        load_sprite_sheet("white.plist");
        load_sprite_sheet("bold.plist");
    }

    var offX = 0;
    var hei = 0;
    for(var i = 0; i < len(s); i++)
    {
        var w = s[i];
        if(s[i] == "+")
            w = "plus";
        else if(s[i] == "-")
            w = "minus";

        var png = sprite(plist+"/"+w+".png").pos(offX, 0);
        n.add(png);
        var si = png.prepare().size();
        offX += si[0]
        hei = si[1];
    }
    n.size(offX, hei);
    return n;
}
//忽略换行符
//只计算实际字符个数 或者换行符 作为两个字符记录 
//totalWord 是实际的单词 包含换行
//而 curWordPos 是 每行单词
//curPos 每行位置
function getWordLen(w)
{
    var l = 0;
    for(var i = 0; i < len(w);)
    {
        var o = ord(w[i]);
        if(o < 128)
            i++;
        else 
            i += 3;
        l++;
    }
    return l;
}
//得到某行 字符的长度
function getLineWordNum(w)
{
    var l = 0;
    for(var i = 0; i < len(w);)
    {
        var o = ord(w[i]);
        if(o < 128)
        {
            i++;
        }
        else
            i += 3;
        l++;
    }
    return l;
}
function multiScalar(d, s)
{
    var res = dict();
    var its = d.items();
    for(var i = 0; i < len(its); i++)
    {
        trace(its[i], s);
        if(its[i][1] > 0)
        {
            res.update(its[i][0], its[i][1]*s/100);
        }
    }
    return res;
}
function getColor(deg)
{
    deg = (deg+360)%360;
    if(deg < 120)
        return [(120-deg)*100/120,  0, deg*100/120];
    if(deg < 240)
    {
        deg -= 120;
        return [0, deg*100/120, (120-deg)*100/120];
    }
    deg -= 240;
    return [deg*100/120, (120-deg)*100/120, 0];
}

//-180 180  120-- 对应100 偏移量
//+30 R-G 
function getHue(v)
{
    var r = getColor(-v);
    var b = getColor(-v+120);
    var g = getColor(-v+240);
    
    return m_color(
        r[0], r[1], r[2], 0, 0,
        g[0], g[1], g[2], 0, 0, 
        b[0], b[1], b[2], 0, 0, 
        0, 0, 0, 100, 0
    );
}

function getClientNow()
{
    return time()/1000;
}
function getServerNow()
{
    var now = time()/1000;
    return client2Server(now);
}

function doNothing()
{
}

function cost2Minus(cost)
{
    var it = cost.items();
    var data = dict();
    for(var i = 0; i < len(it); i++)
    {
        var k = it[i][0];
        var v = it[i][1];
        data.update(k, -v);
    }
    return data;
}

//从服务器获取serverTime时间 根据时间
function showTimeColor()
{
    var hour = global.user.hour;
    trace("curHour", hour);
    if(hour >= 5 && hour < 11)
        return getHue(-180);
    if(hour <= 15 && hour >= 11)
        return getHue(-100);
    return getHue(0);
}

function checkTip(k)
{
    var readYet = global.user.db.get("readYet", dict());
    if(type(readYet) != type(dict()))
    {
        readYet = dict();
    }
    return readYet.get(k, null);
}

function getLoveTreeLeftNum(treeLevel)
{
    var leftNum = 0;
    if(treeLevel < len(loveTreeHeart))
        leftNum = loveTreeHeart[treeLevel] - global.user.getValue("accNum");
    return leftNum;
}

function showFullBack()
{
    var tc = showTimeColor();
    trace("full", tc);
    var temp = sprite("dialogLoginBack0.jpg", tc, ARGB_8888).size(global.director.disSize[0], global.director.disSize[1]).color(100, 100, 100, 80);
    temp.addsprite("dialogLoginStar.png", ARGB_8888);
    return temp;
}

function checkFirstLogin()
{
    var loginTime = global.user.getValue("loginTime");
    var serverTime = global.user.serverTime;
    var lastDay = loginTime/(3600*24);
    var today = serverTime/(3600*24);
    var diff = today - lastDay;
    
    //连续两次登录相差:1天 多天
    return diff;
}
//检测字符串是否整数
function checkNum(s)
{
    var o0 = ord("0");
    for(var i = 0; i < len(s); i++)
    {
        var o = ord(s[i]);
        if((o-o0) > 9 || (o-o0)<0 )
            return 0;
    }
    return 1;
}

/*
客户端存在bug:
http post方法中的dict 中嵌套的dict 的键如果是 字符串会被转换成纯字符
因此加上\"\" 来处理
*/
function dict2Http(d)
{
    var its = d.items();
    var res = [];
    for(var i = 0; i < len(its); i++)
        res.append(["\""+its[i][0]+"\"", its[i][1]]);
    return dict(res);
}
