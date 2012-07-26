const SLOW_MOVE_TIME = 70000;
const FAST_MOVE_TIME = 50000;
const NEW_CLOUD_TIME = 9000;

class Cloud extends MyNode
{
    var map;
    function Cloud(m, k)
    {
        map = m;
        var y = rand(300);
        bg = sprite("cloud"+str(k)+".png", ARGB_8888).pos(-700, y);
        init();
        if(k == 2 || k == 5)
            bg.addaction(sequence(
                    moveto(FAST_MOVE_TIME+rand(3000), 3000, 0), callfunc(remove)));
        else
            bg.addaction(sequence(
                    moveto(SLOW_MOVE_TIME+rand(3000), 3000, 0), callfunc(remove)));
    }
    function remove()
    {
        removeSelf();
        map.remove(this);
    }
}

class Water extends MyNode
{
    function Water()
    {
        bg = node();
        var left = bg.addnode().pos(610, 362);
        var l0 = left.addsprite().pos(42, 21).addaction(repeat(animate(
            2000, 
            "rl1_0.png", "rl2_0.png", "rl3_0.png", "rl4_0.png", "rl5_0.png", "rl6_0.png", "rl7_0.png", "rl8_0.png" )));
        var l1 = left.addsprite().pos(338, 75).addaction(repeat(animate(
            2000,
            "rl1_1.png", "rl2_1.png", "rl3_1.png", "rl4_1.png", "rl5_1.png", "rl6_1.png", "rl7_1.png", "rl8_1.png" )));

        var l2 = left.addsprite().pos(297, 315).addaction(repeat(animate(
            2000,
            "rl1_2.png", "rl2_2.png", "rl3_2.png", "rl4_2.png", "rl5_2.png", "rl6_2.png", "rl7_2.png", "rl8_2.png" )));
        var l3 = left.addsprite().pos(372, 406).addaction(repeat(animate(
            2000,
            "rl1_3.png", "rl2_3.png", "rl3_3.png", "rl4_3.png", "rl5_3.png", "rl6_3.png", "rl7_3.png", "rl8_3.png" )));
        var l4 = left.addsprite().pos(358, 628).addaction(repeat(animate(
            2000,
            "rl1_4.png", "rl2_4.png", "rl3_4.png", "rl4_4.png", "rl5_4.png", "rl6_4.png", "rl7_4.png", "rl8_4.png" )));
        var rPos = [
        [239, 224],
        [134, 339],
        [237, 484],
        [346, 685]
        ];
        var right = bg.addnode().pos(1825, 363);
        var r0 = right.addsprite().pos(rPos[0]).addaction(repeat(animate(
            2000,
            "rr1_0.png", "rr2_0.png","rr3_0.png","rr4_0.png","rr5_0.png","rr6_0.png","rr7_0.png","rr8_0.png"
        )));
        var r1 = right.addsprite().pos(rPos[1]).addaction(repeat(animate(
            2000,
            "rr1_1.png", "rr2_1.png","rr3_1.png","rr4_1.png","rr5_1.png","rr6_1.png","rr7_1.png","rr8_1.png"
        )));
        var r2 = right.addsprite().pos(rPos[2]).addaction(repeat(animate(
            2000,
            "rr1_2.png", "rr2_2.png","rr3_2.png","rr4_2.png","rr5_2.png","rr6_2.png","rr7_2.png","rr8_2.png"
        )));
        var r3 = right.addsprite().pos(rPos[3]).addaction(repeat(animate(
            2000,
            "rr1_3.png", "rr2_3.png","rr3_3.png","rr4_3.png","rr5_3.png","rr6_3.png","rr7_3.png","rr8_3.png"
        )));
    }
}
class Sky extends MyNode
{
    function Sky()
    {
        bg = node();
        bg.addsprite("sky0.png", RGB_565).pos(0, 0);
        bg.addsprite("sky1.png", RGB_565).pos(1000, 0);
        bg.addsprite("sky2.png", RGB_565).pos(2000, 0);
        
    }
}
class BuildLayer extends MyNode
{
    var map;
    //var buildings = null;
    var solTimer = null;
    function BuildLayer(m)
    {
        map = m;
        bg = node();
        init();
        //buildings = global.user.buildings;
        //initBuilding();
        //initSoldiers();
    }

    /*
    闯关页面士兵死亡 则 通知
    */
    function initDataOver()
    {
        removeSoldiers();

        initBuilding();
        initSoldiers();

    }
    /*
    避免在receivMsg 的时候 删除代理
    可能存在这样一种情况 虽然 对象退出了场景 导致这个消息没有被接受到
    但是再次进入场景的时候 需要重新获得消息
    或者进入场景的时候根据数据重新根据数据 构建view

    进入场景 
    */
    override function enterScene()
    {
        solTimer = new Timer(200);
        super.enterScene();
        initSoldiers();
        global.msgCenter.registerCallback(RELIVE_SOL, this);

    }
    /*
    注册消息类型------> MSG_ID------>对象 ------>参数[]
    */
    function receiveMsg(msg)
    {
        trace("receiveMsg", msg);
        if(msg[0] == RELIVE_SOL)
        {
            //sid sdata
            var sdata = msg[1];
            var data = getData(SOLDIER, sdata[1].get("id"));
            var soldier = new BusiSoldier(this, data, sdata[1], sdata[0]);
            //soldier.setSid(sdata[0]);
            addChildZ(soldier, MAX_BUILD_ZORD);
            global.user.addSoldier(soldier);
        }
    }
    override function exitScene()
    {

        global.user.storeOldPos();
        global.msgCenter.removeCallback(RELIVE_SOL, this);
        removeSoldiers();

        super.exitScene();
        solTimer.stop();
        solTimer = null;
    }
    /*
    addChild 会隐藏调用addChildZ
    增加建筑需要注册map
    删除建筑时清理map
    初始化建筑物数据的时候, 构造这些数据对象

    应该把view和数据分离 addChildZ只是处理view 部分  
    而数据部分由user自身处理
    */
    /*
    设置zord
    */
    function addBuilding(chd, z)
    {
        addChildZ(chd, z);
        global.user.addBuilding(chd);
    }
    function removeBuilding(chd)
    {
        removeChild(chd);
        global.user.removeBuilding(chd);
    }

    function addSoldier(sol)
    {
        addChildZ(sol, MAX_BUILD_ZORD);
        sol.setPos(sol.getPos());
        global.user.addSoldier(sol);
    }
    function removeSoldier(sol)
    {
        removeChild(sol);
        global.user.removeSoldier(sol);
    }

    /*
    建筑物已经在allBuildings 和map中存在
    重新由数据加入到页面中
    但是建筑物的map属性需要重新设置
    */

    /*
    用于从上面的数据开始构造用户的建筑物
    这个需要在 上面的数组构造好之后进行 通常在用户下载完数据之后
    初始化 建筑图层的时候 将会 根据数据初始化相应的 allBuildings 建筑物实体  

    由数据变成实体

    数据保存在本地 每次重新进入可以重新从本地加载到数据

    新建和初始化建筑
    */

    /*
    初始化数组和map
    保证数据唯一性
    */
    /*
    buildings ----> allBuildings
    初始化 木牌
    //banner = bg.addsprite("build126.png").pos(864, 800).anchor(50, 100).size(60, 88).setevent(EVENT_TOUCH, onBanner);
    //solNum = banner.addlabel("50", null, 25, FONT_BOLD).pos(25, 23).anchor(50, 50).color(0, 0, 0);
    */
    function initBuilding()
    {
        var data;
        var build;
        //设置编号126 的木牌建筑
        //或者设置 木牌的
        /*
        var data = getData(BUILD, 126);
        var build = new Building(this, data, null);
        build.setBid(-1);
        var nPos = normalizePos([864, 800], 1, 1);
        addChildZ(build, MAX_BUILD_ZORD);
        build.setPos(nPos);
        global.user.addBuilding(build);
        */


        trace("initBuilding", len(global.user.buildings));
        var item = global.user.buildings.items();
        for(var i = 0; i < len(item); i++)
        {
            var bid = item[i][0];
            var bdata = item[i][1];

            data = getData(BUILD, bdata.get("id"));
            //data.update("state", bdata.get("state"));
            //data.update("dir", bdata.get("dir"));
            build = new Building(this, data, bdata);
            build.setBid(bid);


            //默认z值
            addChildZ(build, MAX_BUILD_ZORD);
            //调整Z值
            build.setPos([bdata.get("px"), bdata.get("py")]);
            //设置MAP数据 需要根据坐标设置冲突
            global.user.addBuilding(build);
        }
    }
    /*
    从user的 soldiers 数据 到 士兵状态转化
    user 的allSoldiers 关联 士兵的view 实体 这个可以和数据绑定在一起
    方案如下：
        soldiers -------士兵私有数据
        士兵的私有数据 ----- 士兵实体 
        这样耦合性太高  
    */
    /*
    从数据实体到 view 实体
    soldiers ----> allSoldiers
    */
    function initSoldiers()
    {
        trace("initSoldiers");
        //id name
        var item = global.user.soldiers.items(); 
        for(var i = 0; i < len(item); i++)
        {
            var sid = item[i][0];
            var sdata = item[i][1];
            trace("initSol", sid, sdata);
            var data = getData(SOLDIER, sdata.get("id"));
            if(sdata.get("dead", 0) == 1)//死亡士兵不显示
                continue;
            var soldier = new BusiSoldier(this, data, sdata, sid);
            //soldier.setSid(sid);
            addChildZ(soldier, MAX_BUILD_ZORD);
            global.user.addSoldier(soldier);
        }
    }
    function removeSoldiers()
    {
        global.user.removeAllSoldiers();
    }
        

    function touchBegan(n, e, p, x, y, points)
    {
        map.touchBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        map.touchMoved(n, e, p, x, y, points);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        map.touchEnded(n, e, p, x, y, points);
    }
}
class CastlePage extends MyNode
{
    var farm;
    var build;
    var train;
    var touchDelegate;

    var fallGoods;
    var scene;
    var buildLayer;

    var dialogController;
    var solNum;

    function getLoginReward(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var silver = con.get("silver");
            var crystal = con.get("crystal");
            var loginDays = con.get("loginDays");
            global.user.setValue("loginDays", loginDays);
            if(silver != 0 || crystal != 0)
                dialogController.addCmd(dict([["cmd", "login"], ["silver", silver], ["crystal", crystal], ["loginDays", loginDays]]));
        }
    }

    function initDataOver()
    {
        buildLayer.initDataOver();
        solNum.text(str(global.user.getSolNum()));

        global.httpController.addRequest("getLoginReward", dict([["uid", global.user.uid]]), getLoginReward, null);
    }

    function CastlePage(s)
    {
        scene = s;
        //场景居中， 没有缩放
        bg = node().size(MapWidth, MapHeight).pos(global.director.disSize[0]/2-MapWidth/2, global.director.disSize[1]/2-MapHeight/2);
        init();
        
        var sky = new Sky();
        addChildZ(sky, -2);


        var flow0 = bg.addsprite("flow0.png").pos(0, 48).setevent(EVENT_TOUCH, goFlow, 0);
        var banner = flow0.addsprite("build126.png").pos(262, 44).anchor(50, 100).size(60, 88).setevent(EVENT_TOUCH, onFlowBanner);
        banner.addlabel("50", null, 25, FONT_BOLD).pos(25, 23).anchor(50, 50).color(0, 0, 0);

        bg.addsprite("flow1.png").pos(1650, 25).addaction(repeat(moveby(5000, 80, 0), moveby(5000, -80, 0)));
        bg.addsprite("flow2.png").anchor(50, 100).pos(2431, 222).setevent(EVENT_TOUCH, goFlow, 1).addaction(repeat(moveby(9000, 100, 0), moveby(9000, -100, 0)));

        bg.addsprite("mapInIcon.png").pos(1473, 309).anchor(50, 100).addaction(repeat(moveby(500, 0, -20), moveby(500, 0, 20))).setevent(EVENT_TOUCH, onMap);


        farm = new FarmLand(this);
        addChild(farm);
        build = new BuildLand(this);
        addChild(build);
        train = new TrainLand(this);
        addChild(train);


        addChild(new Water());

        //px - (1+1)*32/2 = pYN  / 32 = 26
        //py - (1+1)*16 = pYN / 16 = 48
        //260048 特殊的固定建筑 不能移动 也不能任意的点击 由客户端确定的建筑
        banner = bg.addsprite("build126.png").pos(864+30+30, 800).anchor(50, 100).size(60, 88).setevent(EVENT_TOUCH, onBanner);
        solNum = banner.addlabel("50", null, 25, FONT_BOLD).pos(25, 23).anchor(50, 50).color(0, 0, 0);

        buildLayer = new BuildLayer(this);
        addChild(buildLayer);


        fallGoods = new FallGoods(this, buildLayer);
        addChild(fallGoods);

        
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;

        dialogController = new DialogController();
        addChild(dialogController);

        //dialogController.addCmd(dict([["cmd", "login"]]));
        //dialogController.addCmd(dict([["cmd", "rate"]]));
        //dialogController.addCmd(dict([["cmd", "levup"]]));
        //dialogController.addCmd(dict([["cmd", "victory"]]));
        //dialogController.addCmd(dict([["cmd", "fail"]]));

        //touchDelegate.enterScene();
        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);

        //global.timer.addTimer(this);
        //initBuilding();
    }
    function onFlowBanner()
    {
        //global.director.pushView(new SoldierMax(), 1, 0); 
    }
    function onBanner()
    {
        global.director.pushView(new SoldierMax(), 1, 0); 
    }
    function goFlow(n, e, p, x, y, points)
    {
        //global.director.pushScene(new FlowScene(p));
        global.director.pushView(new MyWarningDialog(getStr("notOpen", null), getStr("comeSoon", null), null), 1, 0);
    }
    function onMap()
    {
        global.director.pushScene(new MapScene());
    }


    var inBuilding = 0;
    var curBuild = null;
    /*
    初始建造时建筑的zord 为最大， 
    保证可以控制
    */
    function beginBuild(building)
    {
        inBuilding = 1;
        curBuild = new Building(buildLayer, building, null);
        curBuild.setBid(global.user.getNewBid());

        buildLayer.addBuilding(curBuild, MAX_BUILD_ZORD);
        //buildLayer.addChildZ(curBuild, MAX_BUILD_ZORD);
        var kind = building.get("kind");
        moveToPoint(ZoneCenter[kind][0], ZoneCenter[kind][1]);
        return curBuild;
    }
    function buySoldier(id)
    {
        var newSol = new BusiSoldier(buildLayer, getData(SOLDIER, id), null, global.user.getNewSid());

        //newSol.setSid(global.user.getNewSid());
        buildLayer.addSoldier(newSol);

        global.user.updateSoldiers(newSol);
        return newSol;
    }
    /*
    先缩放再移动 保留旧的缩放比例
    屏幕中心移动到建筑物 或者士兵
    */
    var oldScale = null;
    var oldPos = null;
    function moveToBuild(build)
    {
        oldScale = bg.scale();
        var sm = 150;
        if(build.isBuilding == 0)
            sm = 200;
        touchDelegate.scaleToMax(sm);

        oldPos = bg.pos();
        var bSize = build.bg.size();
        var bPos = build.getPos();
        bPos[1] -= bSize[1]/2;
        moveToPoint(bPos[0], bPos[1]);
    }
    function closeGlobalMenu()
    {
        if(oldScale != null)
        {
            touchDelegate.scaleToOld(oldScale, oldPos);
            oldScale = null;
            oldPos = null;
        }
    }
    function moveToPoint(tarX, tarY)
    {
        var worldPos = bg.node2world(tarX, tarY);
        var sSize = global.director.disSize;
        var difx = sSize[0]/2-worldPos[0];
        var dify = sSize[1]/2-worldPos[1];
        var curPos = bg.pos();
        curPos[0] += difx;
        curPos[1] += dify;

        var backSize = bg.size();
        bg.pos(0, 0);
        var maxX = 0;
        var maxY = 0;
        var w2 = bg.node2world(backSize[0], backSize[1])
        var minX = sSize[0]-w2[0];
        var minY = sSize[1]-w2[1];

        curPos[0] = min(max(minX, curPos[0]), maxX);
        curPos[1] = min(max(minY, curPos[1]), maxY);
        bg.pos(curPos);
    }

    function finishBuild()
    {
        inBuilding = 0; 
        curBuild.finishBuild();
        curBuild = null;
    }
    function cancelBuild()
    {
        inBuilding = 0;
        //buildLayer.removeChild(curBuild);
        //global.user.removeBuild()
        buildLayer.removeBuilding(curBuild);
        curBuild = null;
    }
    function onSwitch()
    {
        curBuild.onSwitch();
    }
    var touchBuild = null;
    function touchBegan(n, e, p, x, y, points)
    {
        scene.clearHideTime();
        scene.closeGlobalMenu(this);
        touchDelegate.tBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        touchDelegate.tMoved(n, e, p, x, y, points);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        touchDelegate.tEnded(n, e, p, x, y, points);
    }
    override function enterScene()
    {
        trace("castal Enter Scene");
        super.enterScene();
        global.timer.addTimer(this);
        global.msgCenter.registerCallback(BUYSOL, this);
        global.msgCenter.registerCallback(LEVEL_UP, this);
        solNum.text(str(global.user.getSolNum()));
    }

    function receiveMsg(msg)
    {
        trace("receiveMsg", msg);
        if(msg[0] == BUYSOL)
        {
            solNum.text(str(global.user.getSolNum()));
        }
        else if(msg[0] == LEVEL_UP)
        {
            dialogController.addCmd(dict([["cmd", "levup"], ["castlePage", this]]));
            //fallGoods.genLevelUpFallGoods();
        }
    }
    function remove(c)
    {
        clouds.remove(c);
    }
    var clouds = [];
    var lastTime = 1000000;
    var storeSolTime = 0;
    function update(diff)
    {
        lastTime += diff;
        if(lastTime >= NEW_CLOUD_TIME)
        {
            lastTime = 0;
            if(len(clouds) < 8 && rand(3) == 0)
            {
                var r = rand(7);
                var c = new Cloud(this, r);
                addChildZ(c, -1);
            }
        }

        //30s store 
        storeSolTime += diff;
        if(storeSolTime >= 30000)
        {
            storeSolTime = 0;
            global.user.storeOldPos();
        }
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(LEVEL_UP, this);
        global.msgCenter.removeCallback(BUYSOL, this);
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
