const DARK_PRI = -1;
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
/*
<<<<<<< HEAD
            newPos.update([[item[0], np]]);
=======
*/
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
    return p[0] > 0 && p[0] < bg.size()[0] && p[1] > 0 && p[1] < bg.size()[1];
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
