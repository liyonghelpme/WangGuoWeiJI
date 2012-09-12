/*
    var scene;
    var solTimer;
    var mapDict = dict();
*/
class MovLayer extends MoveMap
{
    var kind;
    const FlowZone = [[136, 242, 605, 300], [306, 116, 372, 169]];
    function MovLayer(sc, k)
    {
        kind = k;
        scene = sc;
        bg = node();
        init();
        moveZone = FlowZone;
        gridLayer = bg.addnode();
        solTimer = new Timer(200);
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

    override function enterScene()
    {
        super.enterScene();
        initSoldiers();
        if(kind == VISIT_NEIBOR)
            initMine();
    }

    override function exitScene()
    {
        removeSoldiers();
        if(kind == VISIT_NEIBOR)
            removeMine();

        super.exitScene();
        solTimer.stop();
        solTimer = null;
    }
    var allSoldiers = [];
    //显示不超过50 个士兵
    //如果水晶不为 null 则 随机选择士兵给予1个单位水晶
    function initSoldiers()
    {
        var sol = scene.soldiers;
        var val = sol.values();
        for(var i = 0; i < len(val); i++)
        {
            var hasCry = 0;
            if(scene.crystal != null && i < scene.crystal)
            {
                hasCry = 1;
            }
            var s = new FriendSoldier(val[i], this, hasCry);
            addChild(s);
            allSoldiers.append(s);
        }
    }
    var mine = null;
    function initMine()
    {
        mine = bg.addsprite("build300.png", ARGB_8888).pos(768, 352).anchor(50, 100); 
    }

    function removeMine()
    {
        if(mine != null)
        {
            mine.removefromparent();
            mine = null;
        }
    }

    function removeSoldiers()
    {
        for(var i = 0; i < len(allSoldiers); i++)
            allSoldiers[i].removeSelf();
        allSoldiers = [];
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
    var curNum;
    var menuLayer;
    var kind;
    var user;

    //需要收获的水晶数量
    var crystal;
    function getUid()
    {
        return user.get("uid");
    }
    //user 包含uid id name level 等数据
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
        //访问邻居但是数据没有初始化 好友模块在登录时应该初始化邻居数据
        if(papayaId == null && kind == VISIT_NEIBOR)
        {
            //等待邻居数据初始化结束 
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

        if(curNum >= len(friends))
        {
            curNum--;
            return;//end
        }
        else
        {
            var friendScene = new FriendScene(friends[curNum].get("id"), curNum, kind, friends[curNum].get("crystal"), friends[curNum]);
            global.director.replaceScene(friendScene);
            global.director.pushView(new VisitDialog(friendScene), 1, 0);
        }
    }

    function getFriendOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            global.friendController.updateValue(papayaId, [con.get("fid"), con.get("level"), con.get("name")]);
            soldiers = con.get("soldiers");

            movLayer = new MovLayer(this, kind);//连接的是FlowIsland
            island.addChild(movLayer);
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
        global.timer.addTimer(this);
    }

    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
