class MovLayer extends MyNode
{
    var scene;
    var solTimer;
    var mapDict = dict();
    function MovLayer(sc)
    {
        scene = sc;
        bg = node();
        init();
    }

    function clearMap(build)
    {
        var map = getBuildMap(build);
        var sx = map[0];
        var sy = map[1];
        var initX = map[2];
        var initY = map[3];
        for(var i = 0; i < sx; i++)
        {
            var curX = initX+i;
            var curY = initY+i;
            for(var j = 0; j < sy; j++)
            {
                var key = curX*10000+curY;
                var v = mapDict.get(key, []);
                if(len(v) == 0)
                    continue;
                removeMapEle(v, build);
                if(len(v) == 0)
                    mapDict.pop(key);
                curX -= 1;
                curY += 1;
            }
        }
    }

    function updatePosMap(sizePos)
    {
        var map = getPosMap(sizePos[0], sizePos[1], sizePos[2], sizePos[3]);
        //var kind = sizePos[4].funcs;
        var sx = map[0];
        var sy = map[1];
        var initX = map[2];
        var initY = map[3];

        for(var i = 0; i < sx; i++)
        {
            var curX = initX+i;
            var curY = initY+i;
            for(var j = 0; j < sy; j++)
            {
                var key = curX*10000+curY;
                var v = mapDict.get(key, []);
                v.append([sizePos[4], 1, 1]);
                mapDict.update(key, v);

                curX -= 1;
                curY += 1;
            }
        }
        return [initX, initY];
    }

    override function enterScene()
    {
        solTimer = new Timer(200);
        super.enterScene();
        initSoldiers();
    }

    override function exitScene()
    {
        removeSoldiers();

        super.exitScene();
        solTimer.stop();
        solTimer = null;
    }
    var allSoldiers = [];
    function initSoldiers()
    {
        var sol = scene.soldiers;
        var val = sol.values();
//        trace("initFriend Soldier", len(sol));
        for(var i = 0; i < len(val); i++)
        {
            var s = new FriendSoldier(val[i], this);
            addChild(s);
            allSoldiers.append(s);
        }
    }
    function removeSoldiers()
    {
        for(var i = 0; i < len(allSoldiers); i++)
            allSoldiers[i].removeSelf();
        allSoldiers = [];
    }
    const FlowZone = [285, 126, 482, 373];

    function checkInFlow(p)
    {   
        var difx = p[0] - FlowZone[0];
        var dify = p[1] - FlowZone[1];
        return difx > 0 && difx < FlowZone[2] && dify > 0 && dify < FlowZone[3]; 
    }

    function checkPosCollision(mx, my, ps)
    {
        var inZ = checkInFlow(ps);
        /*
        限制上下边界
        */
        if(inZ == 0)
        {
//            trace("not in zone");
            return 1;//not In zone
        }
        var key = mx*10000+my;
        /*
        限制不与其它建筑冲突
        */
        var v = mapDict.get(key, []);
        if(len(v) > 0)
        {
            for(var i = 0; i < len(v); i++)
            {
                if(v[i][2] == 1)//不可行走区域
                    return v[0];
            }
        }
        return null;
    }
}
class FriendScene extends MyNode
{
    var island;
    var fm;
    var initOver = 0;
    var papayaId;
    var movLayer;

    var soldiers;
    var curNum;
    var menuLayer;

    function FriendScene(pid, c)
    {
        papayaId = pid;
        curNum = c;
        bg = node();
        init();
        island = new FlowIsland(this, 1);
        addChild(island);

        menuLayer = new MyNode();
        menuLayer.bg = node();
        menuLayer.init();
        addChild(menuLayer);

        fm = new FriendMenu(this);
        menuLayer.addChild(fm);

        global.httpController.addRequest("friendC/getFriend", dict([["uid", global.user.uid], ["papayaId", pid]]), getFriendOver, null);
    }
    function visitNext()
    {
        curNum += 1;
        var friends = global.friendController.showFriend;
        if(curNum >= len(friends))
        {
            curNum--;
            return;//end
        }
        else
        {
            var friendScene = new FriendScene(friends[curNum].get("id"), curNum);
            global.director.replaceScene(friendScene);
            global.director.pushView(new VisitDialog(friendScene), 1, 0);
        }
    }

    function getFriendOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            global.friendController.updateValue(papayaId, [con.get("fid"), con.get("level")]);
            soldiers = con.get("soldiers");

            movLayer = new MovLayer(this);
            island.addChild(movLayer);
            initOver = 1;
        }
    }

    function update(diff)
    {
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }

    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
