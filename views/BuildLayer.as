class BuildLayer extends MyNode
{
    var map;
    var solTimer = null;
    //var mapDict = dict();//建筑物 士兵 所在的block
    //var allBuildings = [];
    //var allSoldiers = dict();

    var mapGridController;
    var blockBuilding;

    var gridLayer;

    function BuildLayer(m)
    {
        map = m;
        mapGridController = new MapGridController(this);
        bg = node();
        gridLayer = bg.addnode();
        blockBuilding = new MyNode();
        init();
    }
    var Planing = 0;

    /*
    px /= SIZEX;
    py /= SIZEY;
    //trace("getBuildMap", px+sx, py+1);
    return [sx, sy, px+sx, py+1];
    */
    function updateMapGrid()
    {
        gridLayer.removefromparent();
        gridLayer = bg.addnode();
        var k = mapGridController.mapDict.keys();
        for(var i = 0; i < len(k); i++)
        {
            var x = k[i]/10000;
            var y = k[i]%10000;
            var p = setBuildMap([1, 1, x, y]);

            var sp = gridLayer.addsprite("red2.png").size(SIZEX, SIZEY).pos(p).anchor(50, 100);
        }
        //trace("len grid", len(k));
    }

    function checkPosCollision(mx, my, ps, sol)
    {
        //trace("checkPosCollision", mx, my, ps, sol);
        var inZ = checkInTrain(ps);
        /*
        限制上下边界
        */
        if(inZ == 0)
        {
            return 1;//not In zone
        }
        var key = getMapKey(mx, my);
        /*
        限制不与其它建筑冲突
        */
        var v = mapGridController.mapDict.get(key, null);
        if(v != null)
        {
            for(var i = 0; i < len(v); i++)
            {
                //if(v[i][2] == 1)//不可行走区域
                if(v[i][0] != sol)//行走冲突
                    return v[i];
            }
        }
        //trace("checkPosCollision", v, inZ);
        /*
        检测不与静态河流冲突
        */
        if(obstacleBlock.get(key, null) != null)
        {
//            trace("colWithRiver", key);
            return blockBuilding;
        }
        return null;
    }

    function checkFallGoodCol(rx, ry)
    {
        var inZ = checkInZone([rx*SIZEX, ry*SIZEY]);
        if(inZ == 0)
            return 1;
        //var key = rx*10000+ry;
        var key = getMapKey(rx, ry);
        var v = mapGridController.mapDict.get(key, null);
        if(v != null)
            return 1;
        if(obstacleBlock.get(key, null) != null)
        {
            return 1;
        }
        return 0;
    }

    //检测建筑物位置冲突
    function checkCollision(build)
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
                //var key = curX*10000+curY;
                var key = getMapKey(curX, curY);
                var v = mapGridController.mapDict.get(key, []);
                if(len(v) > 0)
                {
                    for(var k = 0; k < len(v); k++)
                    {
                        if(v[k][0] != build && v[k][1] == 1)//不可建造
                        {
                            return v[k];
                        }
                    }
                }
                //trace("col key", key);
                if(obstacleBlock.get(key, null) != null)
                {
//                    trace("colWithRiver", key);
                    return blockBuilding;
                }
                curX -= 1;
                curY += 1;
            }
        }
        return null;
    }

    function sellBuild(build)
    {
        removeChild(build);
        //allBuildings.remove(build);
        mapGridController.allBuildings.remove(build);
        global.user.sellBuild(build);
    }

    function sellSoldier(soldier)
    {
        removeChild(soldier);
        //allSoldiers.pop(soldier.sid);
        mapGridController.allSoldiers.pop(soldier.sid);
        global.user.sellSoldier(soldier);
    }
    /*
    闯关页面士兵死亡 则 通知
    */
    function initDataOver()
    {
        initBuilding();
        removeSoldiers();
        initSoldiers();

    }
    /*
    避免在receivMsg 的时候 删除代理
    可能存在这样一种情况 虽然 对象退出了场景 导致这个消息没有被接受到
    但是再次进入场景的时候 需要重新获得消息
    或者进入场景的时候根据数据重新根据数据 构建view

    进入场景 


    士兵移动 timer 
    士兵状态 内部更新 还是 全局更新
    mapGridController 管理所有的数据
    */
    override function enterScene()
    {
        solTimer = new Timer(200);
        super.enterScene();
        initSoldiers();
        global.msgCenter.registerCallback(RELIVE_SOL, this);
        global.msgCenter.registerCallback(SOL_TRANSFER, this);
        global.msgCenter.registerCallback(SOL_UNLOADTHING, this);

        global.timer.addTimer(this); 
    }
    const UPDATE_STATUS_TIME = 10000;
    const MAX_STATUS_SOL = 5;
    var passTime = UPDATE_STATUS_TIME;

    //随机5 个 士兵 出现状态
    //sid 
    function update(diff)
    {
        passTime += diff;
        if(passTime > UPDATE_STATUS_TIME)
        {
            passTime = 0;

            var soldiers = mapGridController.allSoldiers.values();
            var rd = rand(len(soldiers));
            var i;
            for(i = 0; i < len(soldiers); i++)
                soldiers[i].clearRandomStatus();

            for(i = 0; i < len(soldiers); i++)
                soldiers[i].genBloodAndTransferStatus();

            //生成随机奖励金银币状态
            for(i  = 0; i < len(soldiers) && i < MAX_STATUS_SOL; i++)
            {
                var n = (rd+i)%len(soldiers);
                var so = soldiers[n];
                so.genNewStatus();
            }
        }
    }
    /*
    注册消息类型------> MSG_ID------>对象 ------>参数[]
    */
    function receiveMsg(msg)
    {
//        trace("receiveMsg", msg);
        if(msg[0] == RELIVE_SOL)
        {
            //sid sdata
            var sdata = msg[1];
            var data = getData(SOLDIER, sdata[1].get("id"));
            var soldier = new BusiSoldier(this, data, sdata[1], sdata[0]);
            addChildZ(soldier, MAX_BUILD_ZORD);

            mapGridController.allSoldiers.update(soldier.sid, soldier);
            
        }
        else if(msg[0] == SOL_TRANSFER)
        {
            doTransfer(msg[1]);
        }
        else if(msg[0] == SOL_UNLOADTHING)
        {
            unloadThing(msg[1]);
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        global.user.storeOldPos(mapGridController.allSoldiers);
        global.msgCenter.removeCallback(RELIVE_SOL, this);
        global.msgCenter.removeCallback(SOL_TRANSFER, this);
        global.msgCenter.removeCallback(SOL_UNLOADTHING, this);
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
        //allBuildings.append(chd);
        mapGridController.allBuildings.append(chd);
        mapGridController.updateMap(chd);
        //global.user.addBuilding(chd);
    }
    function removeBuilding(chd)
    {
        removeChild(chd);
        //allBuildings.remove(build);
        mapGridController.allBuildings.remove(chd);
        mapGridController.clearMap(chd);
        //global.user.removeBuilding(chd);
    }

    function addSoldier(sol)
    {
        //士兵第一次添加
        if(mapGridController.allSoldiers.get(sol.sid) == null)
        {
            addChildZ(sol, MAX_BUILD_ZORD);
            sol.setPos(sol.getPos());
            mapGridController.allSoldiers.update(sol.sid, sol);
        }
    }
    function removeSoldier(sol)
    {
        removeChild(sol);
        mapGridController.allSoldiers.pop(sol.sid);
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

        var item = global.user.buildings.items();
        for(var i = 0; i < len(item); i++)
        {
            var bid = item[i][0];
            var bdata = item[i][1];

            data = getData(BUILD, bdata.get("id"));
            build = new Building(this, data, bdata);
            build.setBid(bid);


            //默认z值
            addChildZ(build, MAX_BUILD_ZORD);
            //调整Z值
            build.setPos([bdata.get("px"), bdata.get("py")]);
            //设置MAP数据 需要根据坐标设置冲突
            //global.user.addBuilding(build);
            //allBuildings.append(build);

            mapGridController.allBuildings.append(build);
            mapGridController.updateMap(build);
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
        //id name
        var item = global.user.soldiers.items(); 
        trace("initSoldiers", item)
        for(var i = 0; i < len(item); i++)
        {
            var sid = item[i][0];
            var sdata = item[i][1];
            var data = getData(SOLDIER, sdata.get("id"));
            if(sdata.get("dead", 0) == 1)//死亡士兵不显示
                continue;
            var soldier = new BusiSoldier(this, data, sdata, sid);
            addChildZ(soldier, MAX_BUILD_ZORD);
            //global.user.addSoldier(soldier);
            mapGridController.allSoldiers.update(soldier.sid, soldier);
        }
    }
    function removeSoldiers()
    {
        var solArr = mapGridController.allSoldiers.values();
        for(var i = 0; i < len(solArr); i++)
        {
            var sol = solArr[i];
            mapGridController.clearSolMap(sol);
            sol.removeSelf();
        }
        mapGridController.allSoldiers = dict();
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


    function keepPos()
    {
        Planing = 1;
        buildKeepPos();
        soldierKeepPos();
    }
    function buildKeepPos()
    {
        for(var i = 0; i < len(mapGridController.allBuildings); i++)
        {
            mapGridController.allBuildings[i].keepPos();
        }
    }
    //关闭士兵自动位置保存功能
    function soldierKeepPos()
    {
        var allSoldiers = mapGridController.allSoldiers;
        for(var i = 0; i < len(allSoldiers); i++)
            allSoldiers[i].keepPos();
    }
    function restorePos()
    {
        restoreBuildPos();
        restoreSoldierPos();
        clearPlanState();
    }

    function clearPlanState()
    {
        Planing = 0;
    }
    function restoreBuildPos()
    {
        for(var i = 0; i < len(mapGridController.allBuildings); i++)
        {
            mapGridController.allBuildings[i].restorePos();
        }
    }
    function restoreSoldierPos()
    {
        var allSoldiers = mapGridController.allSoldiers;
        for(var i = 0; i < len(allSoldiers); i++)
        {
            allSoldiers[i].restorePos();
        }
    }

    function finishPlan()
    {
        var changedBuilding = [];
        for(var i = 0; i < len(mapGridController.allBuildings); i++)
        {
            if(mapGridController.allBuildings[i].dirty == 1)
            {
                global.user.tempUpdateBuilding(mapGridController.allBuildings[i]);
                var cur = mapGridController.allBuildings[i];
                var p = cur.getPos();
                changedBuilding.append([cur.bid, p[0], p[1], cur.dir]);
            }
            mapGridController.allBuildings[i].finishPlan();
        }
        global.user.updateBuildingDB();
        if(len(changedBuilding) > 0)
            global.httpController.addRequest("buildingC/finishPlan", dict([["uid", global.user.uid], ["builds", changedBuilding]]), null, null);

        var allSoldiers = mapGridController.allSoldiers;
        for(i = 0; i < len(allSoldiers); i++)
        {
            allSoldiers[i].finishPlan();
        }
        clearPlanState();
    }

    function doTransfer(sid)
    {
        var sol = mapGridController.allSoldiers.get(sid);
        if(sol != null)
            sol.doTransfer();
    }
    function unloadThing(sid)
    {
        var sol = mapGridController.allSoldiers.get(sid); 
        if(sol != null)
            sol.useEquip(-1);
    }
}
