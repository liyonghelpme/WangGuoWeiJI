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


    var drugs;
    var equips;
    var soldierEquip;
    var sequipId;
    var tasks;

    var taskListener = [];

    var herbs;
    function getCurFinTaskNum()
    {
        var res = 0;
        var it = tasks.items();
        for(var i = 0; i < len(tasks); i++)
        {
            if(it[i][1][1] == 0)
            {
                var d = getData(TASK, it[i][0]);
                if(it[i][1][0] >= d.get("need"))
                    res += 1;
            }
        }
        return res;
    }
    function addTaskListener(obj)
    {
        for(var i = 0; i < len(taskListener); i++)
        {
            if(taskListener[i][0] == obj)
            {
                taskListener[i][1] = 0;
                return;
            }
        }
        taskListener.append([obj, 0]);
    }
    function removeTaskListener(obj)
    {
        for(var i = 0; i < len(taskListener); i++)
        {
            if(taskListener[i][0] == obj)
                taskListener[i][1] = 1;
        }
    }
    /*
    可以做一个1000ms的timer 定时清理已经退出的对象
    */
    //addTaskNum or just FinishIt
    function updateTask(id, num, fin)
    {
        var val = tasks.get(id, [0, 0]);
        //任务已经完成没有必要继续  
        if(val[1] == 1)
            return;
        var need = getData(TASK, id).get("need");
        //任务的数量已经满足 则没有必要增加
        if(val[0] >= need && num != 0)
            return;
        val[0] += num;
        val[1] = fin;
        tasks.update(id, val);
        db.put("tasks", tasks);
        for(var i = 0; i < len(taskListener);)
        {
            if(taskListener[i][1] == 1)
            {
                taskListener.pop(i);
            }
            else
            {
                taskListener[i][0].updateTaskState();
                i++;
            }
        }
    }

    function initData()
    {
        var keys = ["silver", "gold", "crystal", "level", "people", "papaya", "starNum", "loginDays"];
        var value = db.get("silver", "gold", "crystal", "level", "people", "papaya", "starNum", "loginDays");
        resource = dict();
        trace("visitDb", value);
        for(var i = 0; i < len(keys); i++)
        {
            if(value[i] != null)
                resource.update(keys[i], value[i]);
            else
                resource.update(keys[i], 0);
        }
        //resource.update("loginDays", 10);
        db.put("loginDays", resource.get("loginDays")+1);
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
        trace("initBuilding", maxBid);


        /*
        drugs id num
        equps id num
        */

        drugs = db.get("drugs");
        if(drugs == null)
            drugs = dict();

        equips = db.get("equips");
        if(equips == null)
            equips = dict();

        soldierEquip = db.get("soldierEquip");
        if(soldierEquip == null)
            soldierEquip = dict();

        herbs = db.get("herbs");
        if(herbs == null)
            herbs = dict();

        it = soldierEquip.items();
        sequipId = -1;
        for(i = 0; i < len(it); i++)
        {
            if(it[i][0] > sequipId)
                sequipId = it[i][0];
        }
        sequipId++;
        trace("maxSoldier EquipId", sequipId);

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

        //[id [finNum, getRewardYet]]
        tasks = db.get("tasks");
        if(tasks == null)
            tasks = dict();

    }
    function getTaskFinData(id)
    {
        return tasks.get(id, [0, 0]);
    }
    var soldierListener = [];
    function addSoldierListener(obj)
    {
        for(var i = 0; i < len(soldierListener); i++)
        {
            if(soldierListener[i][0] == obj)
            {
                soldierListener[i][1] = 0;
                return;
            }
        }
        soldierListener.append([obj, 0]);
    }
        
    function removeSoldierListener(obj)
    {
        for(var i = 0; i < len(soldierListener); i++)
        {
            if(soldierListener[i][0] == obj)
            {
                soldierListener[i][1] = 1;
            }
        }
    }

    //士兵数据实体
    //updateSoldiers 修改士兵本地数据
    var soldiers;
    function getCurStar(big, small)
    {
        var starNum = db.get("starNum");
        //0-4
        //0-5
        return starNum[big][small];
    }
    function updateStar(big, small, star)
    {
        var starNum = db.get("starNum");
        starNum[big][small] = star;
        db.put("starNum", starNum);
    }
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
            db.put("silver", 1000, "gold", 1000, "crystal", 1000, "level", 10, "people", 5, "papaya", 1000);
            db.put("loginDays", 1);
            db.put("starNum", [
            [
            [3],
            [3],
            [3],
            [3],
            [3],
            [3],
            ],

            [
            [3],
            [3],
            [3],
            [3],
            [3],
            [3],
            ],
            [
            [2],
            [0],
            [0],
            [0],
            [0],
            [0],
            ],

            [
            [0],
            [0],
            [0],
            [0],
            [0],
            [0],
            ],
            [
            [0],
            [0],
            [0],
            [0],
            [0],
            [0],
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
            //soldier id士兵职业类型 
            db.put("soldiers", dict([[0, dict([["id", 0], ["name", "liyong"], ["level", 0]])]]));

            //id num 
            db.put("drugs", dict([[0, 1]]));
            db.put("equips", dict([[0, 1]]));
            
            //eid [equipId sid]
            db.put("soldierEquip", dict([[0, [0, 0]]]))
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
    function getPeopleNum()
    {
        return getValue("people");
    }
    //每个士兵占用一个人口
    function getSolNum()
    {
        return len(soldiers);
    }
    /*
    如果建筑数据未初始化 则首先初始化
    再将每个建筑加入到图层中
    当经营页面 退出的时候 可以释放这些数据
    */
    function getDrugs()
    {
        return drugs;
    }
    //kindId ownerid
    function getUseThing(kind, tid)
    {
        if(kind == EQUIP)
            return soldierEquip.get(tid);
        return [0, 0];
    }
    function getThingNum(kind, id)
    {
        if(kind == DRUG)
            return drugs.get(id, 0);
        else if(kind == EQUIP)
            return equips.get(id, 0);
        return 0;
    }
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

    /*
     数据修改过程：
     修改内存结构
     修改数据库
     通知所有注册的监听器
    */

    function buySomething(kind, id, cost)
    {
        doCost(cost);
        var value;
        trace("buy Something", kind, id);
        if(kind == DRUG)
        {
            value = drugs.get(id, 0);
            value += 1;
            drugs.update(id, value);
            db.put("drugs", drugs);
        }
        else if(kind == EQUIP)
        {
            value = equips.get(id, 0);
            value += 1;
            equips.update(id, value);
            db.put("equips", equips);
        }


        //通知所有监听器修改数据
        setValue(NOTIFY, 1);

        //changeValue(replaceStr(GoodsPre[kind], ["[ID]", str(id)]), 1);
    }

    function changeHerb(id, num)
    {
        var val = herbs.get(id, 0);
        val += num;
        herbs.update(id, val);
        db.put("herbs", herbs);
        setValue(NOTIFY, 1);
    }

    function addSoldier(sol)
    {
        allSoldiers.append(sol); 
    }
    //清除士兵的一个格子的map
    function clearSolMap(sol)
    {
        if(sol.curMap != null)
        {
            var key = sol.curMap[0]*10000+sol.curMap[1];
            var v = mapDict.get(key, null);
            if(v != null)
            {
                removeMapEle(v, sol);
            }
        }
    }
    function removeSoldier(sol)
    {
        allSoldiers.remove(sol);
        clearSolMap(sol);
    }
    function removeAllSoldiers()
    {
        for(var i = 0; i < len(allSoldiers); i++)
        {
            var sol = allSoldiers[i];
            clearSolMap(sol);
            sol.removeSelf();
        }
        allSoldiers = [];
    }
    /*
    function buyEquip(id, cost)
    {
        doCost(cost);
        changeValue("equip"+str(id), 1);
    }
    */
    /*
    药品储存， 一次性使用 在某个对象身上 drug+id
    */
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
        for(var i = 0; i < len(updateList); )
        {
            if(updateList[i][1] == 1)
            {
                updateList.pop(i);
            }
            else
            {
                updateList[i][0].updateValue(resource);
                i++;
            }
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
    经营页面 和 闯关页面的士兵实体 都需要有以下属性
    */
    //士兵类型 名字 当前生命值 经验 等级
    function updateSoldiers(soldier)
    {
        soldiers.update(soldier.sid, dict([["id", soldier.id], ["name", soldier.myName], ["health", soldier.health], ["exp", soldier.exp], ["dead", soldier.dead], ["level", soldier.level]]));
        updateSoldierDB(null);
        for(var i = 0; i < len(soldierListener);)
        {
            if(soldierListener[i][1] == 1)
            {
                soldierListener.pop(i);
            }
            else
            {
                //监听器判断士兵的sid是否相等 因为有busisoldier 和 soldier两个对象需要处理
                soldierListener[i][0].updateSoldier(soldier);
                i++;
            }
        }
    }
    /*
    如果该士兵显示出来则更新状态
    否则只是更新士兵数据 
    */
    function doTransfer(sid)
    {
        for(var i = 0; i < len(allSoldiers); i++)
        {
            if(allSoldiers[i].sid == sid)
            {
                allSoldiers[i].doTransfer();
                return;
            }
        }
    }
    /*
    修正数据， 显示士兵的view
    */
    function doRelive(sid)
    {
        var sol = soldiers.get(sid); 
        trace("relive soldier", sol);
        if(sol.get("dead") == 1)
        {
            sol.update("dead", 0);
            soldiers.update(sid, sol);
            updateSoldierDB(null);
            global.msgCenter.sendMsg(RELIVE_SOL, [sid, sol]);
        }
    }
    function getSoldierEquip(sid)
    {
        var val = soldierEquip.values();
        var equips = [];
        for(var i = 0; i < len(val); i++)
        {
            if(val[i][1] == sid)
                equips.append(val[i][0]);
        }
        return equips;
    }

    //usedEquip Id
    function unloadThing(tid)
    {
        trace("unloadThing", tid);

        var useData = soldierEquip.pop(tid);
        var num = equips.get(useData[0], 0);
        equips.update(useData[0], num+1);
        db.put("soldierEquip", soldierEquip);
        db.put("equips", equips);

        var sid = useData[1];
        for(var i = 0; i < len(allSoldiers); i++)
        {
            if(allSoldiers[i].sid == sid)
            {
                allSoldiers[i].useEquip(-1);
                break;
            }
        }
    }
    function useThing(kind, tid, soldier)
    {
        trace("useThing", kind, tid, soldier.id);
        var num;
        if(kind == DRUG)
        {
            num = drugs.get(tid);
            drugs.update(tid, num-1);
            db.put("drugs", drugs);

            soldier.useDrug(tid);
        }
        else if(kind == EQUIP)
        {
            num = equips.get(tid);
            equips.update(tid, num-1);
            db.put("equips", equips);
            soldierEquip.update(sequipId++, [tid, soldier.sid]);
            db.put("soldierEquip", soldierEquip);
            trace("equips", equips, soldierEquip, sequipId);

            soldier.useEquip(tid);
        }
    }

    function getSoldierData(sid)
    {
        trace("getSoldierData", sid, soldiers);
        return soldiers.get(sid);
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
    //获取任何物品首先获得 相应类别 再 获取 对应id的值
    function getHerb(id)
    {
        return herbs.get(id, 0);
        //return getValue("herb"+str(id));   
    }
    function getValue(key)
    {
        return resource.get(key, 0);
    }
    /*
    所有异步的数据 需要同步的处理 因为 可能删除操作 在 更新的时候进行 可能导致部分不能被更新
    */
    function addListener(obj)
    {
        for(var i = 0; i < len(updateList); i++)
        {
            if(updateList[i][0] == obj)
            {
                updateList[i][1] = 0;
                return;
            }
        }
        updateList.append([obj, 0]); 
    }
    /*
    需要确保对象被合理的删除 
    遍历所有的监听对象 全部删除
    */
    function removeListener(obj)
    {
        for(var i = 0; i < len(updateList); i++)
        {
            if(updateList[i][0] == obj)
            {
                updateList[i][1] = 1;
            }
        }
    }
    /*
    参数：建筑
    得到建筑左上角第一块的中心所在的网格编号
    遍历所有的网格
    生成Key的方式 是有X*系数+y的方式 保证系数>y
    */
    /*
    建筑和士兵 都有 sx sy 属性 都可以得到 位置
    传入建筑物类型 如果是farm则需要扩充bound
    */
    function updateMap(build)
    {
        var p = build.getPos();
        return updatePosMap([build.sx, build.sy, p[0], p[1], build]);
    }
    //掉落物品更新 可以建造 可以移动
    //obj 可建造 0/1   可移动0/1
    function updateRxRyMap(rx, ry, obj)
    {
        var key = rx*10000+ry;
        var v = mapDict.get(key, []);
        v.append([obj, 1, 1]);
        mapDict.update(key, v);
    }
    function removeRxRyMap(rx, ry, obj)
    {
        var key = rx*10000+ry;
        var v = mapDict.get(key, null);
        if(v != null)
        {
            removeMapEle(v, obj);
            //v.remove(obj);
        }
    }
    //可建造 可移动 更新建筑物的map 不可建造 px py sx sy obj kind
    //map --->[[obj, 1, 1]] 不可建造 不可移动
    //map ---->[[obj, 0, 1]] 可以建造 不可移动
    //block 不可建造 可以移动
    //士兵检测冲突 
    //建筑物检测冲突
    function updatePosMap(sizePos)
    {
        var map = getPosMap(sizePos[0], sizePos[1], sizePos[2], sizePos[3]);
        var kind = sizePos[4].funcs;


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
        setFarmLandMap(map, sizePos, kind);


        //trace("updateMap", map, len(mapDict));//, mapDict);
        return [initX, initY];
    }
    function setFarmLandMap(map, sizePos, kind)
    {
        var curX;
        var curY;
        var key;
        var i;
        var v;

        var sx = map[0];
        var sy = map[1];

        if(kind == FARM_BUILD)
        {
            var bInitX = map[2];
            var bInitY = map[3] - 2;
            curX = bInitX;
            curY = bInitY;
            for(i = 0; i < (sy+1); i++)
            {
                key = curX*10000+curY;
                v = mapDict.get(key, []);
                v.append([sizePos[4], 0, 1]);
                mapDict.update(key, v);

                curX -= 1;
                curY += 1;
            }
            curX = bInitX+1;
            curY = bInitY+1;
            for(i = 0; i < sx; i++)
            {
                key = curX*10000+curY;
                v = mapDict.get(key, []);
                v.append([sizePos[4], 0, 1]);
                mapDict.update(key, v);
                
                curX += 1;
                curY += 1;
            }

        }
    }
    function clearFarmLandMap(map, build, kind)
    {
        var curX;
        var curY;
        var key;
        var i;
        var v;

        var sx = build.sx;
        var sy = build.sy;

        if(kind == FARM_BUILD)
        {
            var bInitX = map[2];
            var bInitY = map[3] - 2;
            curX = bInitX;
            curY = bInitY;
            for(i = 0; i < (sy+1); i++)
            {
                key = curX*10000+curY;
                v = mapDict.get(key, []);
                removeMapEle(v, build);
                if(len(v) == 0)
                    mapDict.pop(key);

                curX -= 1;
                curY += 1;
            }
            curX = bInitX+1;
            curY = bInitY+1;
            for(i = 0; i < sx; i++)
            {
                key = curX*10000+curY;
                v = mapDict.get(key, []);
                removeMapEle(v, build);
                if(len(v) == 0)
                    mapDict.pop(key);
                
                curX += 1;
                curY += 1;
            }

            
        }
    }
    //一个MAP中的对象需要实现以下
    /*
    清楚Farm的上边界 移动冲突
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
        //trace("clearMap", map);//, mapDict);
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
                //v.remove(build);
                //没有建筑则删除
                if(len(v) == 0)
                    mapDict.pop(key);
                /*
                不用更新dict
                else//剩余建筑 士兵 掉落物品不用检测状态
                {
                    for(var k = 0; k < len(v); k++)
                    {
                        v[k].setColPos();
                    }
                    mapDict.update(key, v);
                }
                */
                curX -= 1;
                curY += 1;
            }
        }

        clearFarmLandMap(map, build, build.funcs);
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
        {
            for(var i = 0; i < len(v); i++)
            {
                if(v[i][2] == 1)//不可行走区域
                    return v[0];
            }
            //return v[0];
        }
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
    建筑物检测建造冲突
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
                        if(v[k][0] != build && v[k][1] == 1)//不可建造
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
    只能控制一个建筑物 所以冲突状态是确定
    必须把该建筑移动到没有冲突的位置 才可以移动其它建筑
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
            if(key == "free")
                continue;
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
            if(key == "free")
                continue;
            changeValue(key, -value);
        }
    }
}
