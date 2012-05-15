const DARK_PRI = -1;
const sizeX = 135/4;
const sizeY = 65/4;
var SX = sizeX-10;
var SY = sizeY-10;
//var XDir = sizeX*10;
//var YDir = sizeY*10;
const AddX = 15;
const AddY = 7;
const MapWidth = 3000;
const MapHeight = 1120;
const NotBigZone = 0;
const InZone = 1;
const NotSmallZone = 2;

const Moving = 0;
const Free = 1;

const ISLAND_LAYER = 1; 
const CLOUD_LAYER = 2; 
const FLY_LAYER = 3;

const GREEN = m_color(
67, 0, 0, 0,
0, 87, 0, 0,
0, 0, 24, 0,
0, 0, 0, 100
);
const YELLOW = m_color(
89, 0, 0, 0,
0, 80, 0, 0,
0, 0, 59, 0,
0, 0, 0, 100
);
const WHITE = m_color(
100, 0, 0, 0,
0, 100, 0, 0,
0, 0, 100, 0,
0, 0, 0, 100
);

const FullZone = [2205, 486, 723, 363];
//then check in which zone
const FarmZone = [
[2193, 432, 735, 393],
[2298, 801, 531, 177],
[2082, 729, 138, 96],
[2118, 450, 87, 69],
];

function getStr(key)
{
    return strings.get(key);
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
    trace("inchild", len(sub));
    for(var i = 0; i < len(sub); i++)
    {
        var inIt = checkIn(sub[i], pos);
        if(inIt)
            return sub[i];
    }
    return null; 
}
function getBuildCost(id)
{
    var build = buildingData.get(id);
    var cost = dict();
    if(build[1] != 0)
        cost.update("silver", build[1]);
    if(build[2] != 0)
        cost.update("crystal", build[2]);
    if(build[3] != 0)
        cost.update("gold", build[3]);
    //var cost = dict([["silver", build[1]], ["crystal", build[2]], ["gold", build[3]]]);
    return cost;
}
function getBuild(id)
{
    trace("getBuild", id);
    var build = buildingData.get(id);
    var ret = dict([
        ["id", build[0]], 
        ["silver", build[1]], 
        ["crystal", build[2]], 
        ["gold", build[3]], 
        ["kind", build[4]], 
        ["sx", build[5]], 
        ["sy", build[6]], 
        ["name", build[7]],
        ["hasAni", build[8]]
        ]);
    return ret;
}
function getAni(id)
{
    return buildAnimate.get(id);
}
function getZone()
{
}
function getPlant(id)
{
   var plant = plantData[id]; 
   var p = dict([
    ["level", plant[0]],
    ["time", plant[1]],
    ["silver", plant[2]],
    ["gain", plant[3]],
    ["exp", plant[4]],
    ["name", plant[5]],
   ]);
   return p;
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

function checkInZone(zone, position)
{
    var difx = position[0] - zone[0];
    var dify = position[1] - zone[1];
    return difx >= 0 && difx < zone[2] && dify > 0 && dify < zone[3]; 
}


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
//[sx sy px py] [sx sy px py]
function checkCol(a, b)
{
    //a = [a[0], a[1], 0, 0];
    /*
    b = [b[0], b[1], b[2]-a[2], b[3]-a[3]]
    a = [a[0], a[1], 0, 0];
    */

    //var aBound = getABound(a);
    //var bBound = getABound(b);
    //trace("checkCollision", a, b, aBound, bBound);
    var difx = a[2]-b[2];
    var dify = a[3]-b[3];
    var cx = difx/sizeX;
    var cy = dify/sizeY;
    /*
    var size0 = [(a[0])/2*sizeX, (a[0])/2*sizeY];
    var size1 = [(b[0])/2*sizeX, (b[0])/2*sizeY];
    */
    var total = a[0]+b[0];

    return (abs(cx)+abs(cy)) < total;
    
    //return abs(difx) < (size0[0]+size1[0]-4) && abs(dify) < (size0[1]+size1[1]-4);
    //return aBound[0] < bBound[2] && aBound[2] > bBound[0] && aBound[1] < bBound[3] && aBound[3] > bBound[1]; 
}
function normalizePos(p)
{
    var x = p[0];
    var y = p[1];
    x -= FullZone[0];
    y -= FullZone[1];
    var q = x/sizeX;
    x = q*sizeX;
    q = y/sizeY;
    y = q*sizeY;
    return [x+FullZone[0], y+FullZone[1]];
}

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
const PassDifficult = 4;
//1-5
/*
function getBigEnable(big)
{
    var star = global.user.getValue("starNum");
    big -= 1;
    if(big == 0)
        return 1;
    big -= 1;
    var starPos = big*6*10+5*10+PassDifficult;
    if(star[starPos] != 0)
        return 1;
    return 0;
}
function getSmallEnable(big, small)
{
    var be = getBigEnable(big);
    if(be == 0)
        return 0;
    var star = global.user.getValue("starNum");
    big -= 1;
    if(small == 0)
        return 1;
    small -= 1
    var starPos = big*6*10+small*10+PassDifficult;
    if(star[starPos] != 0)
        return 1;
    return 0;
}
*/
function getCurEnableDif()
{
    var star = global.user.getValue("starNum");
    var i;
    var j;
    var find = 0;
    for(i = 0; i < len(star); i++)
    {
        for(j = 0; j < len(star[i]); j++)
            if(star[i][PassDifficult] == 0)
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
function getStar(big, small)
{
    var star = global.user.getValue("starNum");
    return star[big-1][small]; 
}
