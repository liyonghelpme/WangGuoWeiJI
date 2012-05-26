class User
{
    var resource;
    var updateList;
    var allBuildings;
    var allEquips;
    var allDrugs;
    var mapDict;
    var blockBuilding;
    var allSoldiers;
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
    function User()
    {
        resource = dict([["silver", 10000], ["gold", 10000], ["crystal", 10000], 
        ["level", 10], ["people", 0], ["papaya", 1000],
        ["starNum", 
            [
            [
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            [3,3,3,3,3, 0, 0, 0, 0, 0],
            ],
            [
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            ],
            [
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            ],
            [
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            ],
            [
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
            ],
            ]
            ]]);
        blockBuilding = new MyNode();
        updateList = [];
        allBuildings = [];
        mapDict = dict();
        allEquips = dict();
        allDrugs = dict();
        allSoldiers = [];
        /*
        在初始化数据之后 初始化 建筑物
        */
        //initBuilding();
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
    var buildings = dict([
            [0, dict([
            ["id", 200], ["px", 1504], ["py", 640], ["state", Free], ["dir", 0], ["build", null],
            ])],
            [1, dict([
            ["id", 202], ["px", 1664], ["py", 656], ["state", Free], ["dir", 0], ["build", null],
            ])],
            [2, dict([
            ["id", 204], ["px", 1280], ["py", 720], ["state", Free], ["dir", 0], ["build", null],
            ])],
            [3, dict([
            ["id", 206], ["px", 1728], ["py", 848], ["state", Free], ["dir", 0], ["build", null],
            ])],
        ]);

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
    function buySomething(kind, id, cost)
    {
        doCost(cost);
        changeValue(replaceStr(KindsPre[kind], ["[ID]", id]), 1);
    }

    function addSoldier(sol)
    {
        allSoldiers.append(sol); 
    }
    function removeSoldier(sol)
    {
        allSoldiers.remove(sol);
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

    function finishPlan()
    {
        for(var i = 0; i < len(allBuildings); i++)
        {
            allBuildings[i].finishPlan();
        }
    }
    function setValue(key, value)
    {
        resource.update(key, value);
        for(var i = 0; i < len(updateList); i++)
        {
            updateList[i].updateValue(resource);
        }
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
    function updateMap(build)
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
                v.append(build);
                mapDict.update(key, v);

                curX -= 1;
                curY += 1;
            }
        }
        trace("updateMap", map, len(mapDict), mapDict);
    }
    /*
    只在清楚状态的时候 清理建筑物状态
    */
    function clearMap(build)
    {
        var map = getBuildMap(build);
        var sx = map[0];
        var sy = map[1];
        var initX = map[2];
        var initY = map[3];
        trace("clearMap", map, mapDict);
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
                else//剩余建筑检测状态
                {
                    for(var k = 0; k < len(v); k++)
                    {
                        v[k].setColPos();
                    }
                    mapDict.update(key, v);
                }
                curX -= 1;
                curY += 1;
            }
        }
    }
    
    /*
    检测冲突， 值返回还有几个对象，每次移动的时候把自己从中清除即可
    i++ i--
    */
    function checkCollision(build)
    {
        var map = getBuildMap(build);
        var sx = map[0];
        var sy = map[1];
        var initX = map[2];
        var initY = map[3];
        trace("checkCol", map, mapDict);
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

    function checkBuildCol()
    {
        var vals = mapDict.values();
        for(var i = 0; i < len(vals); i++)
        {
            if(len(vals[i]) > 1)
                return 1;
        }
        return 0;
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
