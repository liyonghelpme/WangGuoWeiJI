/*
行为树节点: sel  seq not action
实现参考:
http://www.moddb.com/groups/indievault/tutorials/game-ai-behavior-tree
https://gist.github.com/3249905#file-bhtree_example-py

*/
const X_GRID_COFF = 100;
//获取某关怪兽
class WorldStatus
{
    var board;//x*100+y ---> solId 棋盘状态
    var mons;//[[id, num], [id, num], [id, num]]
    var solId;//当前最大的怪兽id
    var solIdMons; //solId ---> dict(sid, id, monX, monY)
    //怪兽的 位置 x, y 拷贝怪兽数据 修改怪兽数据
    function WorldStatus(m)
    {
        board = dict();
        mons = m;
        solId = 0;
        solIdMons = dict();
        trace("WorldStatus", board, mons, solId, solIdMons);
    }
    //返回: 怪兽数据列表[dict(), dict(), dict()]
    //地方坐标偏移7的位置
    function getAllMons()
    {
        var val = solIdMons.values();
        for(var i = 0; i < len(val); i++)
        {
            val[i]["monX"] += 7;
        }
        return val;
    }
    //放置一个怪兽
    //m: monster Kind Id
    //修改棋盘状态
    //修改怪兽数量
    //修改solIdMons 怪兽编号
    function putSol(m)
    {
        trace("putSol", m, mons);
        var mon = getData(SOLDIER, m);
        var sx = mon["sx"];
        var sy = mon["sy"];
        var find = 0;
        for(var x = 0; x < 5; x++)
        {
            for(var y = 0; y < 5; y++)
            {
                var col = 0;
                //所有网格都不冲突
                for(var mx = 0; mx < sx; mx++)
                {
                    for(var my = 0; my < sy; my++)
                    {
                        if(board.get((x+mx)*X_GRID_COFF+(y+my)) != null || (x+mx) >= 5 || (y+my) >= 5)
                        {
                            col = 1;
                            break;
                        }
                    }
                    if(col)
                        break;
                }
                //减少怪兽数量 mons
                //添加分配怪兽 solIdMons
                //放置棋盘 board
                if(!col)
                {
                    solIdMons[solId] = dict([["id", m], ["monX", x], ["monY", y], ["sid", solId]]);//id 位置
                    for(mx = 0; mx < sx; mx++)
                    {
                        for(my = 0; my < sy; my++)
                        {
                            board[(x+mx)*X_GRID_COFF+(y+my)] = solId;
                        }
                    }
                    solId++;
                    for(var i = 0; i < len(mons); i++)
                        if(mons[i][0] == m)
                        {
                            mons[i][1]--;
                            break;
                        }
                    find = 1;
                    break;
                }
            }
            if(find)
                break;
        }
    }

    //打印棋盘状态
    function printBoard()
    {
        trace("printBoard", solIdMons, board);
        for(var y = 0; y < 5; y++)
        {
            var rn = "";
            for(var x = 0; x < 5; x++)
            {
                if(board.get(x*X_GRID_COFF+y) != null)
                {
                    var sol = getData(SOLDIER, solIdMons.get(board.get(x*X_GRID_COFF+y))["id"]);
                    rn += sol["name"]+", "
                }
                else
                    rn += "x, ";
            }
            trace(rn);
        }
    }
    //monster Id
    //检测该怪兽可否放置到棋盘上
    function checkPutable(m)
    {
        trace("checkPutable", m, mons);
        var mon = getData(SOLDIER, m);
        var sx = mon["sx"];
        var sy = mon["sy"];
        for(var x = 0; x < 5; x++)
        {
            for(var y = 0; y < 5; y++)
            {
                var col = 0;
                //所有网格不冲突 可以放置
                for(var mx = 0; mx < sx; mx++)
                {
                    for(var my = 0; my < sy; my++)
                    {
                        if(board.get((x+mx)*X_GRID_COFF+(y+my)) != null || (x+mx) >= 5 || (y+my) >= 5 )
                        {
                            col = 1;
                            break;
                        }
                    }
                    if(col)
                        break;
                }
                if(!col)
                    return 1;
            }
        }
        return 0;
    }
}

//行为树 基本节点
class Task
{
    var children;
    function Task()
    {
        children = [];
    }
    function run()
    {
    }
    function addChild(c)
    {
        children.append(c);
    }
}

//或关系 优先选择第一个 true的节点
class Selector extends Task
{
    override function run()
    {
        for(var i = 0; i < len(children); i++)
        {
            if(children[i].run())
                return 1;
        }
        return 0;
    }
}
//与关系 所有子节点顺序执行 False 则中断 
class Sequence extends Task
{
    override function run()
    {
        for(var i = 0; i < len(children); i++)
        {
            if(!children[i].run())
                return 0;
        }
        return 1;
    }
}
//返回子节点的非
class Not extends Task
{
    override function run()
    {
        return !(children[0].run());
    }
}
//action 子节点 寻找近战，如果是后排 首先放置远程再放置近战
//前排首先放置 近战肉盾 
class FindDefenser extends Task
{
    var status;
    function FindDefenser(s)
    {
        status = s;
    }
    //生命值最高的 可放置的
    override function run()
    {
        trace("FindDefenser");
        var heal = 0;
        var allHealId = [];
        for(var i = 0; i < len(status.mons); i++)
        {   
            var mid = status.mons[i][0];
            var mNumber = status.mons[i][1];
            var mon = getData(SOLDIER, mid);
            if(mon["healthBoundary"] >= heal && mon["range"] == 0 && mNumber > 0)
            {
                if(mon["healthBoundary"] > heal)
                {
                    if(status.checkPutable(mid))
                    {
                        heal = mon["healthBoundary"];
                        allHealId = [mid];
                    }
                }
                else
                {
                    if(status.checkPutable(mid))
                    {
                        allHealId.append(mid);
                    }
                }
            }
        }

        trace("FindDefenser", allHealId);
        if(len(allHealId) > 0)
        {
            var rd = rand(len(allHealId));
            status.putSol(allHealId[rd]);
        }
        return 1;
    }
}
//前线有位置可以放置士兵
class FrontHasPos extends Task
{
    var status;
    function FrontHasPos(s)
    {
        status = s;
    }
    override function run()
    {
        trace("FrontHasPos");
        var x = 0;
        for(var y = 0; y < 5; y++)
        {
            if(status.board.get(x*X_GRID_COFF+y) == null)
                return 1;
        }
        return 0;
    }
}
//前线有近战 体积小
class FrontPutMon extends Task
{
    var status;
    function FrontPutMon(s)
    {
        status = s;
    }
    override function run()
    {
        trace("FrontPutMon");
        for(var i = 0; i < len(status.mons); i++)
        {
            var mid = status.mons[i][0];
            var mNumber = status.mons[i][1];
            var mon = getData(SOLDIER, mid);
            if(mon["range"] == 0 && mon["sx"] == 1 && mon["sy"] == 1 && mNumber > 0)//近战怪兽数量 > 0 
                return 1;
        }
        return 0;
    }
}
//寻找远程不在前线
class FindFarAway extends Task
{
    var status;
    function FindFarAway(s)
    {
        status = s;
    }
    override function run()
    {
        trace("FindFarAway");
        var allFarId = [];
        for(var i = 0; i < len(status.mons); i++)
        {
            var mid = status.mons[i][0];
            var mNumber = status.mons[i][1];
            var mon = getData(SOLDIER, mid);
            if(mon["range"] > 0 && mNumber > 0)
            {
                if(status.checkPutable(mid))
                {
                    allFarId.append(mid);
                }
            }
        }
        if(len(allFarId))
        {
            var rd = rand(len(allFarId));
            status.putSol(allFarId[rd]);
        }
        return 1;
    }
}

//还有可以放置的怪兽 无论近战还是远程
class HasMonPutable extends Task
{
    var status;
    function HasMonPutable(s)
    {
        status = s;
    }
    override function run()
    {
        trace("HasMonPutable");
        var find = 0;
        for(var i = 0; i < len(status.mons); i++)
        {
            var mid = status.mons[i][0];
            var mNumber = status.mons[i][1];
            var mon = getData(SOLDIER, mid);
            if(mNumber > 0)
                if(status.checkPutable(mid))
                    return 1;
        }
        return 0;
    }
}
//随机放置一只怪兽
class RandPutSol extends Task
{
    var status;
    function RandPutSol(s)
    {
        status = s;
    }
    override function run()
    {
        trace("RandPutSol");
        var leftMons = [];
        for(var i = 0; i < len(status.mons); i++)
        {
            var mid = status.mons[i][0];
            var mNumber = status.mons[i][1];
            var mon = getData(SOLDIER, mid);
            if(mNumber > 0)
                leftMons.append(mid);
        }
        if(len(leftMons) > 0)
        {
            var rd = rand(len(leftMons));
            status.putSol(leftMons[rd]);
            return 0;
        }
        return 1;
    }
}
//有远程
class HasFarAway extends Task
{
    var status;
    function HasFarAway(s)
    {
        status = s;
    }
    override function run()
    {
        trace("HasFarAway", status.board);
        for(var i = 0; i < len(status.mons); i++)
        {
            var mid = status.mons[i][0];
            var mNumber = status.mons[i][1];
            var mon = getData(SOLDIER, mid);
            if(mNumber > 0 && mon["range"] > 0)
            {
                return 1;
            }
        }
        return 0;
    }
}

//挑战排行榜
function realGenChallengeSoldier(sols)
{
    var kinds = dict();
    for(var i = 0; i < len(sols); i++)
    {
        var num = kinds.setdefault(sols[i]["id"], 0);
        num++;
        kinds[sols[i]["id"]] = num;
    }
    kinds = kinds.items();
    return realGenRoundMonster(kinds);
}
//检测没有前线
//检测还有远程
/*
WorldStatus 中的solIdMons  每个solId 的怪兽的位置 id 类型 x, y 位置信息 
temp 怪兽数量将会被修改 因此 传入的是可修改的对象
*/
//big*100 + small = rid
//[[kind, num], [kind, num]] 怪兽id 怪兽数量
function realGenRoundMonster(temp)
{
    var status = new WorldStatus(temp);
    
    var root = new Sequence();
    var sel = new Selector();
    var seq = new Sequence();
    var sel1 = new Selector();
    var sel2 = new Selector();
    var sel3 = new Selector();
    var seq1 = new Sequence();
    var notDec = new Not();
    var notDec1 = new Not();
    var notDec2 = new Not();
    var seq2 = new Sequence();

    var hasMonPutable1 = new HasMonPutable(status);
    var findDefenser = new FindDefenser(status);
    var findFarAway = new FindFarAway(status);
    //var randPutSol = new RandPutSol(status);
    //var checkPosAndFarAway = new CheckPosAndFarAway(status);
    
    var hasFarAway = new HasFarAway(status);
    var frontHasPos1 = new FrontHasPos(status);

    var frontHasPos = new FrontHasPos(status);
    var frontPutMon = new FrontPutMon(status);
    var hasMonPutable = new HasMonPutable(status);

    root.addChild(sel);
    sel.addChild(notDec1);
    notDec1.addChild(hasMonPutable1);

    sel.addChild(seq);
    seq.addChild(sel1);
    
    sel1.addChild(seq2);
    seq2.addChild(notDec2);
    notDec2.addChild(frontHasPos1);
    seq2.addChild(hasFarAway);

    sel1.addChild(findDefenser);

    seq.addChild(sel2);
    sel2.addChild(seq1);
    seq1.addChild(frontHasPos);
    seq1.addChild(frontPutMon);
    sel2.addChild(findFarAway);
    seq.addChild(sel3);

    sel3.addChild(notDec);
    notDec.addChild(hasMonPutable);
    
    trace("finish Make Tree");
    var count = 0;
    while(!root.run())
    {
        trace("cycle -----");
        if(count >= 100)
        {
            trace("too many run", count);
            status.printBoard();
            break;
        }
        count++;
    }
    status.printBoard();
    //id  x, y
    return status.getAllMons();
}
