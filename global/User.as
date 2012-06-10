class User
{
    var uid;
    var resource;
    var updateList;
    
    //建筑物的view 实体
    var allBuildings;

    //地图的建筑物占有块数据
    var mapDict;
    var blockBuilding;

    //士兵的view 实体
    var allSoldiers;
    
    //当前可用的最大的建筑物的编号
    var maxBid;
    var maxSid;
    var db;
    /*
    存放当前场景所有冲突的建筑物
    每次一个建筑物移动，则检测当前的冲突状态
    */
    //var colRelation;
    //当前最大开启的等级是：
    //每个关卡10个难度， 6个小关 5个大关
    //当前状态 大关 小关 难度
    //当前开启的maxLevel = (大关-1)*6*10 + 小关*10 + 难度
    /*
    从服务器获取数据后 初始化---> 用户数据
    再初始化用户的建筑数据
    */

    function initData()
    {
        var keys = ["silver", "gold", "crystal", "level", "people", "papaya", "starNum"];
        var value = db.get("silver", "gold", "crystal", "level", "people", "papaya", "starNum");
        resource = dict();
        for(var i = 0; i < len(keys); i++)
        {
            resource.update(keys[i], value[i]);
        }
        //bid kind px py state direction workId workStartTime
        //var bkeys = ["id", "px", "py", "state", "dir", "objectId", "objectTime"];
        //var build = db.get("buildings");
        maxBid = -1;
        buildings = db.get("buildings");
        var it = buildings.items();
        for(i = 0; i < len(it); i++)
        {
            if(it[i][0] > maxBid)
                maxBid = it[i][0];
        }
        maxBid++;


        it = drugData.items();
        for(i = 0; i < len(it); i++)
        {
            var name = replaceStr(GoodsPre[DRUG], ["[ID]", it[i][0]]);
            var drugNum = db.get(name);
            if(drugNum != null)
                resource.update(name, drugNum);
        }

        it = equipData.items();
        for(i = 0; i < len(it); i++)
        {
            name = replaceStr(GoodsPre[EQUIP], ["[ID]", it[i][0]]);
            var equipNum = db.get(name);
            if(equipNum != null)
                resource.update(name, equipNum);
        }

        soldiers = db.get("soldiers");
        maxSid = -1;
        it = soldiers.items();
        for(i = 0; i < len(it); i++)
        {
            if(it[i][0] > maxSid)
                maxSid = it[i][0];
        }
        maxSid++;
        trace("maxBid maxSid", maxBid, maxSid);

    }
    //士兵数据实体
    var soldiers;
    function User()
    {
        uid = ppy_userid();
        db = c_opendb();
        trace("initUser", uid, db);
        var inYet = db.get(str(uid));
        trace("first login", inYet);
        if(inYet == null)
        {
            trace("first login");
            db.put(str(uid), 1),
            db.put("silver", 1000, "gold", 1000, "crystal", 1000, "level", 10, "people", 0, "papaya", 1000);
            db.put("starNum", [
            [
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            ],

            [
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            ],

            [
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            ],

            [
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            ],

            [
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            ],

            ]);
            /*
            由客户端 提供新的建筑物的bid 这样的好处是服务器只进行 数据库的唯一性验证 如果出错，则返回失败给客户端
            */
            //bid kind px py state direction workId workStartTime
            db.put("buildings",dict([
            [0, dict([
            ["id", 200], ["px", 1504], ["py", 640], ["state", Free], ["dir", 0], ["objectId", 0], ["objectTime", 0]
            ])],
            [1, dict([
            ["id", 202], ["px", 1664], ["py", 656], ["state", Free], ["dir", 0], ["objectId", 0], ["objectTime", 0]
            ])],
            [2, dict([
            ["id", 204], ["px", 1280], ["py", 720], ["state", Free], ["dir", 0], ["objectId", 0], ["objectTime", 0]
            ])],
            [3, dict([
            ["id", 206], ["px", 1728], ["py", 848], ["state", Free], ["dir", 0], ["objectId", 0], ["objectTime", 0]
            ])],

            ]));
            db.put("soldiers", dict([[0, dict([["id", 0], ["name", "liyong"]])]]));
        }
        initData();
        blockBuilding = new MyNode();
        updateList = [];
        allBuildings = [];
        mapDict = dict();
        allSoldiers = [];
        /*
        在初始化数据之后 初始化 建筑物
        */
    }
    /*
    如果建筑数据未初始化 则首先初始化
    再将每个建筑加入到图层中
    当经营页面 退出的时候 可以释放这些数据
    */
    function checkInitBuildingYet()
    {
        trace("checkInitBuilding", len(allBuildings), len(buildings));
        return len(allBuildings) < len(buildings);
    }
    function addBuilding(build)
    {
        allBuildings.append(build);
        updateMap(build);
    }
    function removeBuilding(build)
    {
        allBuildings.remove(build);
        clearMap(build);
    }
    /*
    保存当前建筑物的所有状态
    由实体变成数据
    */
    function clearAllBuilding()
    {
        allBuildings = [];
        mapDict = dict();
    }
    //静态建筑 和用户建造的动态建筑的数据 开始工作的时间
    //进入游戏之后 用户可能会卖出建筑物 这时 这个数据需要失效
    //所以只能有效构造一次建筑页面
    //之后需要从allBuildings 数组来进行构造建筑页面
    //由数据得到实体 由实体得到数据
    //bid:xxx
    //data:
    //建筑物数据实体
    var buildings;

    /*如果所有对象统一编码 比较难控制 还是采用分类的方法处理*/
    /*
    装备分为两种，空闲的没有使用 这个直接放到仓库数据中 resource  equip+id 用于做键值
    被某个士兵使用的装备 则包含士兵的引用 士兵也有 对物品的引用  一个士兵有多个装备
    */
    function buyResource(kind, id, cost, gain)
    {
        doCost(cost);
        doAdd(gain);
    }
    /*
    soldiers 
    drugs 数据库如何得到建筑物的键值不存在
    遍历所有物品ID 来得到没有的物品则设置值为0
    GoodsPre 和 KindsPre 是相互映射的 主要是 药品和装备
    */

    function buySomething(kind, id, cost)
    {
        doCost(cost);
        changeValue(replaceStr(GoodsPre[kind], ["[ID]", id]), 1);
    }

    function addSoldier(sol)
    {
        allSoldiers.append(sol); 
    }
    function clearSolMap(sol)
    {
        if(sol.curMap != null)
        {
            var key = sol.curMap[0]*10000+sol.curMap[1];
            var v = mapDict.get(key, null);
            if(v != null)
            {
                v.remove(sol);
            }
        }
    }
    function removeSoldier(sol)
    {
        allSoldiers.remove(sol);
        clearSolMap(sol);
    }
    function buyEquip(id, cost)
    {
        doCost(cost);
        changeValue("equip"+str(id), 1);
    }
    /*
    药品储存， 一次性使用 在某个对象身上 drug+id
    */
    function buyDrug(id, cost)
    {
        doCost(cost);
        changeValue("drug"+str(id), 1);
    }
    /*
    规划开始 和 规划取消 函数
    */
    function buildKeepPos()
    {
        for(var i = 0; i < len(allBuildings); i++)
        {
            allBuildings[i].keepPos();
            //allBuildings[i].oldPos = allBuildings.getPos();
        }
    }
    function restoreBuildPos()
    {
        for(var i = 0; i < len(allBuildings); i++)
        {
            allBuildings[i].restorePos();
            //allBuildings[i].setPos(allBuildings[i].oldPos);
        }
    }

    /*
    成功修改所有建筑物的坐标
    */
    function finishPlan()
    {
        for(var i = 0; i < len(allBuildings); i++)
        {
            allBuildings[i].finishPlan();
            updateBuilding(allBuildings[i]);
        }
    }
    function getNewBid()
    {
        return maxBid++;
    }

    function updateDB(key, value)
    {
        db.put(key, value);
    }

    //var bkeys = ["id", "px", "py", "state", "dir", "objectId", "objectTime"];
    function updateBuildingDB(build)
    {
        db.put("buildings", buildings);
        /*
        var bDB = db.get("buildings");
        for(var i = 0; i < len(bDB); i++)
        {
            if(bDB[i][0] == build.bid)
            {
                break;
            }
        }
        //新建筑
        if(i == len(bDB))
        {
            bDB.append([build.bid, [build.id, build.getPos()[0], build.getPos()[1], build.state, build.dir, build.getObjectId(), build.getStartTime()]]); 
        }
        //旧建筑
        else
        {
            bDB[i][1] = [build.id, build.getPos()[0], build.getPos()[1], build.state, build.dir, build.getObjectId(), build.getStartTime()];

        }
        db.put("buildings", bDB);
        */
    }
    /*
    function removeBuildDB(build)
    {
        var bDB = db.get("buildings");
        for(var i = 0; i < len(bDB); i++)
        {
            if(bDB[i][0] == build.bid)
            {
                break;
            }
        }
        if(i < len(bDB))
        {
            bDB.pop(i);
        }
        db.put("buildings", bDB);
    }
    */
    function sellBuild(build)
    {
        buildings.pop(build.bid);
        //removeBuildDB(build);
        updateBuildingDB(null);
    }
    /*
    修改建筑物的数据实体
    */
    function updateBuilding(build)
    {
        buildings.update(build.bid, dict([["id", build.id], ["px", build.getPos()[0]], ["py", build.getPos()[1]], ["state", build.state], ["dir", build.dir], ["objectId", build.getObjectId()], ["objectTime", build.getStartTime()]]));
        updateBuildingDB(null);
    }
    function setValue(key, value)
    {
        resource.update(key, value);
        updateDB(key, value);
        for(var i = 0; i < len(updateList); i++)
        {
            updateList[i].updateValue(resource);
        }
    }
    function getNewSid()
    {
        return maxSid++;
    }
    /*
    保证数据库和内存数据的同构 就比较方便
    */
    function updateSoldierDB(soldier)
    {
        db.put("soldiers", soldiers);
        /*
        var sDB = db.get("soldiers");
        sDB.update(soldier.sid, dict([["id", soldier.id], ["name", soldier.myName]]));
        db.put("soldiers", sDB);
        */
    }
    /*
    修改士兵的数据实体
    */
    //ID name
    function updateSoldiers(soldier)
    {
        soldiers.update(soldier.sid, dict([["id", soldier.id], ["name", soldier.myName]]));
        updateSoldierDB(null);
    }
    function sellSoldier(soldier)
    {
        soldiers.pop(soldier.sid);
        updateSoldierDB(null);
    }

    function changeValue(key, add)
    {
        var v = resource.get(key, 0);
        v += add;
        setValue(key, v);
    }
    function getValue(key)
    {
        return resource.get(key, 0);
    }
    function addListener(obj)
    {
        updateList.append(obj); 
    }
    function removeListener(obj)
    {
        updateList.remove(obj);
    }
    /*
    参数：建筑
    得到建筑左上角第一块的中心所在的网格编号
    遍历所有的网格
    生成Key的方式 是有X*系数+y的方式 保证系数>y
    */
    /*
    建筑和士兵 都有 sx sy 属性 都可以得到 位置
    */
    function updateMap(build)
    {
        var p = build.getPos();
        return updatePosMap([build.sx, build.sy, p[0], p[1], build]);
    }
    function updateRxRyMap(rx, ry, obj)
    {
        var key = rx*10000+ry;
        var v = mapDict.get(key, []);
        v.append(obj);
        mapDict.update(key, v);
    }
    function removeRxRyMap(rx, ry, obj)
    {
        var key = rx*10000+ry;
        var v = mapDict.get(key, null);
        if(v != null)
            v.remove(obj);
    }
    function updatePosMap(sizePos)
    {
        var map = getPosMap(sizePos[0], sizePos[1], sizePos[2], sizePos[3]);
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
                v.append(sizePos[4]);
                mapDict.update(key, v);

                curX -= 1;
                curY += 1;
            }
        }
        trace("updateMap", map, len(mapDict));//, mapDict);
        return [initX, initY];
    }
    //一个MAP中的对象需要实现以下
    /*
    只在清楚状态的时候 清理建筑物状态
    包括建筑和士兵
    士兵不需要设置 底部颜色
    */
    function clearMap(build)
    {
        var map = getBuildMap(build);
        var sx = map[0];
        var sy = map[1];
        var initX = map[2];
        var initY = map[3];
        trace("clearMap", map);//, mapDict);
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
                v.remove(build);
                //没有建筑则删除
                if(len(v) == 0)
                    mapDict.pop(key);
                else//剩余建筑 士兵 掉落物品不用检测状态
                {
                    /*
                    for(var k = 0; k < len(v); k++)
                    {
                        v[k].setColPos();
                    }
                    */
                    mapDict.update(key, v);
                }
                curX -= 1;
                curY += 1;
            }
        }
    }
   
    /*
    士兵移动冲突检测
    训练场
    建筑物
    河流
    */
    function checkPosCollision(mx, my, ps)
    {
        //var inZ = checkInZone(ps);
        var inZ = checkInTrain(ps);
        /*
        限制上下边界
        */
        if(inZ == 0)
        {
            trace("not in zone");
            return 1;//not In zone
        }
        var key = mx*10000+my;
        /*
        限制不与其它建筑冲突
        */
        var v = mapDict.get(key, []);
        if(len(v) > 0)
            return v[0];
        /*
        检测不与静态河流冲突
        */
        if(obstacleBlock.get(key, null) != null)
        {
            trace("colWithRiver", key);
            return blockBuilding;
        }
        return null;
    }
    function checkFallGoodCol(rx, ry)
    {
        var inZ = checkInZone([rx*sizeX, ry*sizeY]);
        if(inZ == 0)
            return 1;
        var key = rx*10000+ry;
        var v = mapDict.get(key, null);
        if(v != null)
            return 1;
        if(obstacleBlock.get(key, null) != null)
        {
            return 1;
        }
        return 0;
    }
    /*
    检测冲突， 值返回还有几个对象，每次移动的时候把自己从中清除即可
    i++ i--
    建筑物 士兵 sx sy pos
    */
    function checkCollision(build)
    {
        var map = getBuildMap(build);
        var sx = map[0];
        var sy = map[1];
        var initX = map[2];
        var initY = map[3];
        trace("checkCol", map);//, mapDict);
        for(var i = 0; i < sx; i++)
        {
            var curX = initX+i;
            var curY = initY+i;
            for(var j = 0; j < sy; j++)
            {
                var key = curX*10000+curY;
                var v = mapDict.get(key, []);
                if(len(v) > 0)
                {
                    for(var k = 0; k < len(v); k++)
                    {
                        if(v[k] != build)
                        {
                            trace("colWithBuild", v[k]);
                            return v[k];
                        }
                    }
                }
                //trace("col key", key);
                if(obstacleBlock.get(key, null) != null)
                {
                    trace("colWithRiver", key);
                    return blockBuilding;
                }
                curX -= 1;
                curY += 1;
            }
        }
        return null;
    }
    /*
    冲突是一种关系，涉及到两个方面，必须要同时改变两个状态
    mapDict  存储数字 和 存储对象之间 
    比较：对象便于进行反向 引用   
    */

    /*
    只能控制一个建筑物 所以冲突状态是确定的
    */
    function checkBuildCol()
    {
        for(var i = 0; i < len(allBuildings); i++)
        {
            if(allBuildings[i].colNow == 1)
            {
                trace("building col", allBuildings[i]);
                return 1;
            }
        }
        return 0;
        /*
        var vals = mapDict.values();
        for(var i = 0; i < len(vals); i++)
        {
            if(len(vals[i]) > 1)
                return 1;
        }
        return 0;
        */
        /*
        for(var i = 0; i < len(allBuildings); i++)
        {
            if(allBuildings[i].col != 0)
                return 1;
        }
        return 0;
        */
    }
    function checkCost(cost)
    {
        var buyable = dict([["ok", 1]]);
        var its = cost.items();
        for(var i = 0; i < len(its); i++)
        {
            var key = its[i][0];
            var value = its[i][1];
            var cur = resource.get(key, 0);
            if(cur < value)
            {
                buyable.update("ok", 0);
                buyable.update(key, value-cur);
            }
        }
        return buyable;
    }
    function doAdd(add)
    {
        var its = add.items();
        for(var i = 0; i < len(its); i++)
        {
            var key = its[i][0];
            var value = its[i][1];
            changeValue(key, value);
        }
    }
    function doCost(cost)
    {
        var its = cost.items();
        for(var i = 0; i < len(its); i++)
        {
            var key = its[i][0];
            var value = its[i][1];
            changeValue(key, -value);
        }
    }
}
