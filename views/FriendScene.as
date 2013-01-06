class MovLayer extends MoveMap
{
    var kind;
    const FlowZone = [[136, 242, 605, 300], [306, 116, 372, 169]];
    function MovLayer(sc, k)
    {
        kind = k;
        scene = sc;
        staticObstacle = dict();
        bg = node();
        init();
        moveZone = FlowZone;
        buildZone = FlowZone;
        gridLayer = bg.addnode();

        mapGridController = new MapGridController(this);
    }
    //代理来自士兵的touch事件
    //坐标需要首先针对n 转化成 世界坐标
    //再进行其它计算
    //违背了封闭原则 访问了没有权限访问的浮岛数据
    function touchBegan(n, e, p, x, y, points)
    {
        scene.island.touchBegan(n, e, p, x, y, points);
    }

    function touchMoved(n, e, p, x, y, points)
    {
        scene.island.touchMoved(n, e, p, x, y, points);
    }

    function touchEnded(n, e, p, x, y, points)
    {
        scene.island.touchEnded(n, e, p, x, y, points);
    }

    //timer 初始化后 再初始化士兵
    override function enterScene()
    {
        super.enterScene();
        solTimer = new Timer(200);
        initSoldiers();
    }

    override function exitScene()
    {
        removeSoldiers();
        super.exitScene();
        solTimer.stop();
        solTimer = null;
    }
    //var allSoldiers = []; mapGridController 中存放
    //显示不超过50 个士兵
    //如果水晶不为 null 则 随机选择士兵给予1个单位水晶
    function initSoldiers()
    {
        var sol = scene.soldiers;
        var key = sol.keys();
        var val = sol.values();
        //访问好友有水晶可拿
        //好友拥有的水晶数量
        trace("randSoldier cry", scene.crystal);
        for(var i = 0; i < len(val); i++)
        {
            var hasCry = 0;
            if(scene.crystal != null && i < scene.crystal)
            {
                hasCry = 1;
            }
            var s = new FriendSoldier(val[i], this, hasCry, key[i]);
            addChild(s);
            mapGridController.addSoldier(s);
        }
    }
    function initBuildings()
    {
        printD(["initBuildings", scene.buildings]);
        for(var i = 0; i < len(scene.buildings); i++)
        {

            var pdata = scene.buildings[i];
            var b = new Building(this, getData(BUILD, pdata["id"]), pdata);
            b.setBid(FRIEND_MINE);
            b.setPos([pdata.get("px"), pdata.get("py")]);
            addChild(b);

            mapGridController.allBuildings.append(b);
            mapGridController.updateMap(b);
        }
    }

    function removeSoldiers()
    {
        mapGridController.removeAllSoldiers();
    }


}
/*
邻居：访问消除装天 可以挑战 赠送礼物
普通好友：只能访问 消除状态
*/
class FriendScene extends MyNode
{
    var island;
    var fm;
    var initOver = 0;
    var papayaId;
    var movLayer;

    var soldiers;
    var buildings;
    var curNum;
    var menuLayer;
    var kind;
    var user;
    var dialogController;

    //需要收获的水晶数量
    var crystal;
    function getUid()
    {
        return user.get("uid");
    }
    //user 包含uid id name level 等数据
    //好友的 姓名 头像等数据
    //user 来自： 排行榜  访问好友 访问邻居
    //至少包含数据： uid id name level 
    //RankBase: uid PapayaId  name level
    //FriendList: 
    //        Neibor：   yet yet yet
    //        PapayaFriend: uid name level papayaId
    //        RecommandFriend: 
    function FriendScene(pid, c, k, cry, u)
    {
        kind = k;
        papayaId = pid;
        curNum = c;
        crystal = cry;
        user = u;

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
        
        if(kind == VISIT_NEIBOR)
        {
            global.user.setLastVisitNeibor(curNum+1);
        }
        else if(kind == VISIT_OTHER)
        {
            global.user.setLastVisitOther(curNum+1);
        }
        //访问邻居但是数据没有初始化 好友模块在登录时应该初始化邻居数据  && kind == VISIT_NEIBOR
        //点击上方浮动岛屿 没有初始化 邻居数据时  需要等待
        initData();
        dialogController = new DialogController(this);
    }
    function initData()
    {
        if(papayaId == null)
        {
            //global.timer.addTimer(this);
        }
        else
            global.httpController.addRequest("friendC/getFriend", dict([["uid", global.user.uid], ["papayaId", papayaId]]), getFriendOver, null);
    }

    /*
    访问邻居 木瓜好友 推荐好友的下一个
    */

    function visitNext()
    {
        var friends;
        curNum += 1;
        friends = global.friendController.getFriends(kind);

        if(kind == VISIT_NEIBOR)
            global.user.setLastVisitNeibor(curNum);
        else if(kind == VISIT_OTHER)
            global.user.setLastVisitOther(curNum);

        if(curNum >= len(friends))
        {
            curNum--;
            return;//end
        }
        else
        {
            var friendScene = new FriendScene(friends[curNum].get("id"), curNum, kind, friends[curNum].get("crystal"), friends[curNum]);
            //global.director.replaceScene(friendScene);
            global.director.curScene.addChildZ(friendScene, -1);
            global.director.pushView(new VisitDialog(friendScene, FRIEND_DIA_INFRIEND), 1, 0);
        }
    }

    function makeFakeBuilding()
    {
        trace("building data", user);
        //访问没有获取到数据的好友
        if(mineLevel != null)
            buildings.append(dict([["id", PARAMS["mineId"]], ["px", 768], ["py", 352], ["state", PARAMS["buildFriend"]], ["dir", 0], ["objectId", -1], ["objectTime", 0], ["level", mineLevel], ["color", 0] ]));

        //buildings.append(dict([ ["id", PARAMS["loveTreeId"]], ["px", 480], ["py", 416], ["state", PARAMS["buildFriend"]], ["dir", 0], ["objectId", -1], ["objectTime", 0], ["level", heartLevel], ["color", 0]  ] ));
        trace("buildings", buildings);
    }

    function helpOpen()
    {
        helperList.append(global.user.uid);
        papayaIdName.append([global.user.papayaId, global.user.name]);
    }
    var hasBox = 0;
    var helperList = [];
    var papayaIdName = [];

    var mineLevel;
    //var heartLevel;
    function getFriendOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            global.friendController.updateValue(papayaId, [con.get("fid"), con.get("level"), con.get("name")]);
            soldiers = con.get("soldiers");
            buildings = [];
            mineLevel = con["mineLevel"];
            //heartLevel = con["heartLevel"];
            makeFakeBuilding(); 

            hasBox = con["hasBox"];
            helperList = con["helperList"];
            papayaIdName = con["papayaIdName"];

            movLayer = new MovLayer(this, kind);//连接的是FlowIsland
            movLayer.initBuildings();
            island.addChild(movLayer);
            fm.updateState();//菜单更新状态
            initOver = 1;
        }
    }

    function update(diff)
    {
        if(papayaId == null && kind == VISIT_NEIBOR)
        {
            if(global.friendController.initNeiborYet == 1)
            {
                var neibors = global.friendController.getFriends(kind);
                if(len(neibors) == 0)
                {
                    global.director.popScene();
                    return;
                }
                curNum %= len(neibors);
                papayaId = neibors[curNum].get("id");
                global.httpController.addRequest("friendC/getFriend", dict([["uid", global.user.uid], ["papayaId", papayaId]]), getFriendOver, null);
            }
        }
    }

    override function enterScene()
    {
        super.enterScene();
        global.timer.removeTimer(this);//首先清理Timer 再重新注册
        global.timer.addTimer(this);
        if(kind == VISIT_NEIBOR)
            global.taskModel.doAllTaskByKey("visitNeibor", 1);
    }

    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
