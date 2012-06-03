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
                    moveto(10000+rand(3000), 3000, 0), callfunc(remove)));
        else
            bg.addaction(sequence(
                    moveto(20000+rand(3000), 3000, 0), callfunc(remove)));
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
    var buildings = null;
    var solTimer = null;
    function BuildLayer(m)
    {
        map = m;
        bg = node();
        init();
        buildings = global.user.buildings;
        initBuilding();
    }
    override function enterScene()
    {
        solTimer = new Timer(100);
        super.enterScene();
    }
    override function exitScene()
    {
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
    function addPureBuild(chd)
    {
        super.addChildZ(chd, MAX_BUILD_ZORD);
        //调整Zord
        chd.setPos(chd.getPos());
        //chd.setMap(this);
    }
    override function exitScene()
    {
        global.user.clearAllBuilding();
        super.exitScene();
    }
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
    function initBuilding()
    {
        trace("initBuilding", len(buildings));
        var item = buildings.items();
        for(var i = 0; i < len(item); i++)
        {
            var bid = item[i][0];
            var bdata = item[i][1];

            var data = getData(BUILD, bdata.get("id"));
            data.update("state", bdata.get("state"));
            data.update("dir", bdata.get("dir"));
            var build = new Building(this, data);
            build.setBid(bid);


            //默认z值
            addChildZ(build, MAX_BUILD_ZORD);
            //调整Z值
            build.setPos([bdata.get("px"), bdata.get("py")]);
            //设置数据 需要根据坐标设置冲突
            global.user.addBuilding(build);



        }
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

    function CastlePage(s)
    {
        scene = s;
        //场景居中， 没有缩放
        bg = node().size(MapWidth, MapHeight).pos(global.director.disSize[0]/2-MapWidth/2, global.director.disSize[1]/2-MapHeight/2);
        init();
        
        var sky = new Sky();
        addChildZ(sky, -2);


        bg.addsprite("flow0.png").pos(0, 48);
        bg.addsprite("flow2.png").pos(1650, 45).addaction(repeat(moveby(5000, 80, 0), moveby(5000, -80, 0)));
        bg.addsprite("flow1.png").pos(2352, 13).addaction(repeat(moveby(9000, 100, 0), moveby(9000, -100, 0)));


        farm = new FarmLand(this);
        addChild(farm);
        build = new BuildLand(this);
        addChild(build);
        train = new TrainLand(this);
        addChild(train);


        addChild(new Water());

        buildLayer = new BuildLayer(this);
        addChild(buildLayer);

        fallGoods = new FallGoods(this);
        addChild(fallGoods);

        
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;

        //touchDelegate.enterScene();
        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);

        //global.timer.addTimer(this);
        //initBuilding();

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
        curBuild = new Building(buildLayer, building);
        buildLayer.addBuilding(curBuild, MAX_BUILD_ZORD);
        //buildLayer.addChildZ(curBuild, MAX_BUILD_ZORD);
        var kind = building.get("kind");
        moveToPoint(ZoneCenter[kind][0], ZoneCenter[kind][1]);
        return curBuild;
    }
    function buySoldier(id)
    {
        var newSol = new BusiSoldier(buildLayer, getData(SOLDIER, id));
        buildLayer.addSoldier(newSol);
        return newSol;
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
    /*
    var showMenu = 0;
    var curShow = null;
    function showGlobalMenu(build)
    {
        showMenu = 1;   
        curShow = build;
        scene.showGlobalMenu(build);
    }
    */

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
    /*
    function selfCloseGlobalMenu()
    {
        showMenu = 0;
        touchBuild = null;
        scene.closeGlobalMenu();
    }
    */
    var touchBuild = null;
    function touchBegan(n, e, p, x, y, points)
    {
        scene.clearHideTime();
        scene.closeGlobalMenu(this);
        /*
        if(showMenu == 1)
        {
            showMenu = 0;
            curShow.closeGlobalMenu();
            curShow = null;
            //global.director.popView();//remove BuildMenu Now
            scene.closeGlobalMenu();
        }
        */
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
    }
    function remove(c)
    {
        clouds.remove(c);
    }
    var clouds = [];
    var lastTime = 0;
    function update(diff)
    {
        lastTime += diff;
        if(lastTime >= 10000)
        {
            if(len(clouds) < 8 && rand(3) == 0)
            {
                var r = rand(7);
                var c = new Cloud(this, r);
                addChildZ(c, -1);
            }
            lastTime = 0;
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
