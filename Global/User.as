/*
TODO:
    清理 所有本地 db 数据库
*/
class User
{
    var uid=-1;
    var papayaId;
    var papayaName;

    var resource;
    var updateList;
    
    //建筑物的view 实体

    //地图的建筑物占有块数据

    //士兵的view 实体
    
    //当前可用的最大的建筑物的编号
    var maxBid;
    var maxSid;
    var starNum;

    //所有修改db的行为都对应修改 服务器数据
    var db;
    var rated = 0;
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
    //eid --->kind level owner
    //
    var equips;
    var maxEid;
    var tasks;

    var taskListener = [];

    var herbs;
    var serverTime;
    var clientTime;

    var lastVisitNeibor = 0;
    var mine;

    var maxGiftId = 0;
    var skills;

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
    更新任务状态:
        任务id 任务 完成数目 任务是否完成 任务是否进入下一个阶段


    */
    //addTaskNum or just FinishIt
    function updateTask(id, num, fin, sta)
    {
        var val = tasks.get(id, [0, 0]);
        //任务已经完成没有必要继续  
        if(val[1] == 1)
            return;
        var need = getData(TASK, id).get("need");
        //任务的数量已经满足 则没有必要增加
        if(val[0] >= need && num != 0)
            return;

        //增加任务数目
        if(num != 0)
        {
            val[0] += num;
            global.httpController.addRequest("taskC/doTask", dict([["uid", uid], ["tid", id], ["num", num]]), null, null);
        }
        /*
        //完成某个任务 检测是否进入下一个阶段
        else if(fin != 0)
        {
            val[1] = fin;
            global.httpController.addRequest("taskC/finishTask", dict([["uid", uid], ["tid", id]]), null, null);
        }
        */

        /*
        //累计任务进入下一个阶段
        if(sta == 1)
        {
            val[0] = 0;
            val[1] = 0;
            val[2]++;
        }
        */
        tasks.update(id, val);
        db.put("tasks", tasks);

        //global.httpController.addRequest("taskC/updateTask", dict([["uid", uid], ["tid", id], ["num", num], ["fin", fin], ["stage", val[2]]]), null, null);

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
    //buildingKind 1
    function getAllBuildingKinds()
    {
        var b = buildings.values();
        var res = dict();
        for(var i = 0; i < len(b); i++)
        {
            res.update(b[i].get("id"), 1);
        }
        return res;
    }
    function getAllEquipKinds()
    {
        var e = equips.values();
        var res = dict();
        for(var i = 0; i < len(e); i++)
        {
            res.update(e[i].get("kind"), 1);
        }
        return res;
    }
    //士兵必须是没有转职的兵力id%10 == 0
    function getAllSoldierKinds()
    {
        var s = soldiers.values();
        var res = dict();
        for(var i = 0; i < len(s); i++)
        {
            res.update(s[i].get("id"), 1);
        }
        return res;
    }
    //id--->
    function initBuildings(b)
    {
        var keys = b.keys();
        buildings = dict();
        maxBid = -1;
        for(var i = 0; i < len(keys); i++)
        {
            buildings.update(int(keys[i]), b.get(keys[i]));
            if(int(keys[i]) > maxBid)
                maxBid = int(keys[i]);
        }
        maxBid++;
    }
    function initSoldiers(s)
    {
        var keys = s.keys();
        soldiers = dict();
        maxSid = -1;
        for(var i = 0; i < len(keys); i++)
        {
            var k = int(keys[i]);
            soldiers.update(k, s.get(keys[i]));
            if(k > maxSid)
                maxSid = k;
        }
        maxSid++;
    }
    function initThings(d)
    {
        var keys = d.keys();
        var temp = dict();
        for(var i = 0; i < len(keys); i++)
        {
            var k = int(keys[i]);
            temp.update(k, d.get(keys[i]));
        }
        return temp;
    }
    function initEquips(eq)
    {
        equips = dict();
        var key = eq.keys();
        maxEid = -1;
        for(var i = 0; i < len(key); i++)
        {
            var k = int(key[i]);
            if(k > maxEid)
                maxEid = k;
            equips.update(k, eq.get(key[i]));
        }
        maxEid += 1;
//        trace("equips", equips, maxEid, eq);

    }

    function initStarNum()
    {
        starNum = db.get("starNum");
        if(starNum == null)
        {
            global.httpController.addRequest("getStars", dict([["uid", global.user.uid]]), getStarOver, null);
        }
//        trace("init starNum", starNum);
        //resource.update("starNum", s);
    }
    //big small ---> difficult
    function getStarOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            starNum = con.get("res");
            trace("getStarOver", starNum);
            db.put("starNum", starNum);
        }
    }
    //编号5-9的物品掉落次数有限 不超过3次
    function getFallNum(id)
    {
//        trace("fallNum", fallNum);
        return fallNum.get(id, 0);
    }
    function updateFallNum(id)
    {
        var v = fallNum.get(id, 0);
        v += 1;
        fallNum.update(id, v);
        db.put("fallNum", fallNum);
    }
    function setRated()
    {
        rated = 1;
        db.put("rated", rated);
    }
    //5-->次数 6 次数
    var fallNum = dict();

    //今日已经挑战的进行的挑战记录
    var challengeRecord = [];
    //今日的挑战得分
    var rankScore = 0;
    //今日的挑战排名
    var rankOrder = 0;
    //challengeNum 当前已经挑战的次数

    function checkChallengeYet(oid)
    {
        var ret = challengeRecord.index(oid);
        if(ret == -1)
            return 0;
        return 1;
    }
    function addChallengeRecord(oid)
    {
        challengeRecord.append(oid);
    }
    

    function changeGoodsNum(kind, id, num)
    {
        if(kind == TREASURE_STONE || kind == MAGIC_STONE)
        {
            var k = getGoodsKey(kind, id);
            var v = treasureStone.get(k, 0);
            v += num;
            treasureStone[k] = v;
            db.put("treasureStone", treasureStone);
            if(kind == TREASURE_STONE)
                global.msgCenter.sendMsg(UPDATE_TREASURE, id);
            else if(kind == MAGIC_STONE)
                global.msgCenter.sendMsg(UPDATE_MAGIC_STONE, id);
        }
        else if(kind == DRUG)
        {
            changeDrugNum(id, num);
        }
        else if(kind == HERB)
        {
            changeHerbNum(id, num);
        }
    }
    function getGoodsNum(kind , id)
    {
        if(kind == TREASURE_STONE || kind == MAGIC_STONE)
            return treasureStone.get(getGoodsKey(kind, id), 0);
        if(kind == DRUG)
            return drugs.get(id, 0);
        if(kind == HERB)
            return herbs.get(id, 0);

        if(kind == EQUIP)
        {
            var ev = equips.values();
            var count = 0;
            for(var i = 0; i < len(ev); i++)
            {
                if(ev[i].get("kind") == id)
                    count += 1;
            }
            return count;
        }
        return 0;
    }
    //所有装备页面 宝石数量更新数据


    function buyTreasureStone(id)
    {
        var cost = getCost(TREASURE_STONE, id);
        doCost(cost);

        changeGoodsNum(TREASURE_STONE, id, 1);

    }

    function buyMagicStone(id)
    {
        var cost = getCost(MAGIC_STONE, id);
        doCost(cost);

        changeGoodsNum(MAGIC_STONE, id, 1); 
    }

    function getNewGiftId()
    {
        return maxGiftId++;
    }
    //soldierId dict([[skillId, level], ...])
    function initSkill(sk)
    {
        skills = dict();
        for(var i = 0; i < len(sk); i++)
        {
            var k = sk[i];
            var v = skills.get(k[0], dict());
            v.update(k[1], k[2]);
            skills.update(k[0], v);
        }
    }
    var treasureStone;
    var week;
    var updateState;
    var registerTime;
    var heartRank;
    //sendMsg 需要castlePage 响应 
    function initDataOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);

            uid = con.get("uid");//记忆用户uid 新手任务选择英雄时使用
            var newState = con.get("newState");
            if(newState == 0)//未完成新手任务 则进入新手欢迎页面 替换当前的经营页面
            {
                global.director.replaceScene(new WelcomeDialog());
                return;
            }
            registerTime = con.get("registerTime");

            week = con.get("week");
            updateState = con.get("updateState");

            maxGiftId = con.get("maxGiftId");

            var temp = con.get("skills");//soldierId  skillId level
            initSkill(temp);


            resource = con.get("resource");

            var heart = con.get("heart");
            resource.update("weekNum", heart["weekNum"]);
            resource.update("accNum", heart["accNum"]);
            resource.update("liveNum", heart["liveNum"]);
            heartRank = heart.get("rank");
            
            //con.get("starNum")
            initStarNum();

            initBuildings(con.get("buildings"));
            initSoldiers(con.get("soldiers"));
            drugs = initThings(con.get("drugs"));
            initEquips(con.get("equips"));

            herbs = initThings(con.get("herbs"));
            tasks = initThings(con.get("tasks"));

            challengeRecord = con.get("challengeRecord");
            rankScore = con.get("rank")[0];
            if(rankScore > MAX_SCORE)
                rankScore = MAX_SCORE;
            rankOrder = con.get("rank")[1];

            mine = con.get("mine");
            mine["id"] = MINE_BUILD; 
            mine["bid"] = MINE_BID;

            rated = db.get("rated");
            if(rated == null)
            {
                rated = 0;
                db.put("rated", 0);
            }
            
            serverTime = con.get("serverTime");
            clientTime = time()/1000;

            treasureStone = dict(con.get("treasure"));

            //资源更新 需要 更新本地数据库
            db.put("resource", resource);
            //闯关星 和 资源分开
            //db.put("starNum", starNum);
            db.put("buildings", buildings);
            db.put("soldiers", soldiers);
            db.put("drugs", drugs);
            db.put("equips", equips);
            db.put("herbs", herbs);
            db.put("tasks", tasks);
            db.put("treasureStone", treasureStone);
            

            
            initYet = 1;        
            global.msgCenter.sendMsg(INITDATA_OVER, null);
        }
        else
        {
            useLocalDB();
//            trace("user local database replaced");
            initYet = 1;
            global.msgCenter.sendMsg(INITDATA_OVER, null);
        }
    }
    function updateRankScore(add)
    {
        rankScore += add;
        if(rankScore > MAX_SCORE)
            rankScore = MAX_SCORE;
    }

    function initData()
    {
        global.httpController.addRequest("login", dict([["papayaId", papayaId], ["papayaName", papayaName]]), initDataOver, null);
    }
    function useLocalDB()
    {
        resource = dict([["silver", 1000], ["gold", 1000], ["crystal", 1000], ["level", 10], ["people", 5], ["papaya", 1000]]);
        starNum = [[[3], [3], [3], [3], [3], [3]], [[3], [3], [3], [3], [3], [3]], [[3], [3], [3], [3], [3], [3]], [[3], [3], [3], [3], [3], [3]], [[0], [0], [0], [0], [0], [0]]]; 
        buildings = dict([
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

            ]);
        soldiers = dict([[0, dict([["id", 0], ["name", "liyong"], ["level", 0]])]]); 
    }

    function updateMine(build)
    {
        mine["level"] = build.buildLevel;
        mine["objectTime"] = build.getStartTime();
    }
    function tempSetData()
    {
        resource = dict();
        buildings = dict();
        soldiers = dict();
        drugs = dict();
        equips = dict();
        herbs = dict();
        tasks = dict();
        mine = null;
        treasureStone = dict();
        starNum = null;
        maxGiftId = 0;
        skills = null;


        oldPos = db.get("oldPos");
        if(oldPos == null)
            oldPos = dict();

        //记录金币掉落次数
        fallNum = db.get("fallNum");
        if(fallNum == null || type(fallNum) != type(dict())) 
        {
            fallNum = dict();
            db.put("fallNum", fallNum);
        }

        lastVisitNeibor = db.get("lastVisitNeibor");
        if(lastVisitNeibor == null)
        {
            lastVisitNeibor = 0;
            db.put("lastVisitNeibor", lastVisitNeibor);
        }
    }
    function setLastVisitNeibor(p)
    {
        lastVisitNeibor = p;
        db.put("lastVisitNeibor", lastVisitNeibor);
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
        if(starNum != null)
            return starNum[big][small];
        return 0;
    }
    function updateStar(big, small, star)
    {
        if(starNum != null)
        {
            starNum[big][small] = star;
            db.put("starNum", starNum);
        }
    }
    var initYet = 0;
    function getInitYet()
    {
        return initYet;
    }
    function initPapaya()
    {
    }
    var oldPos = null;
    function User()
    {
        papayaId = ppy_userid();
        if(papayaId == null)
            return;
        papayaName = ppy_username();
        db = c_opendb();

        tempSetData();
        updateList = [];
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



    function getKindEquip(kind)
    {
        var evi = equips.items();
        var res = [];
        for(var i = 0; i < len(evi); i++)
        {
            if(evi[i][1].get("kind") == kind)
                res.append(evi[i][0]);//eid 
        }
        return res;
    }

    

    //kindId ownerid
    //装备是独立的显示

    
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

    function makeDrug(id)
    {
        changeGoodsNum(DRUG, id, 1);

        setValue(NOTIFY, 1);
    }
    function makeEquip(eid, id)
    {
        equips.update(eid, dict([["kind", id], ["level", 0], ["owner", -1]]));
        db.put("equips", equips);
        setValue(NOTIFY, 1);
    }

    function buySomething(kind, id, cost)
    {
        doCost(cost);
        var value;
//        trace("buy Something", kind, id);
        if(kind == DRUG)
        {
            changeGoodsNum(DRUG, id, 1);
        }

        //通知所有监听器修改数据
        setValue(NOTIFY, 1);

    }
    function buyEquip(eid, id, cost)
    {
        doCost(cost);
        equips.update(eid, dict([["kind", id], ["level", 0], ["owner", -1]]));
        db.put("equips", equips);
        setValue(NOTIFY, 1);
    }

    function getNewEquip(eid, id, level)
    {
        equips.update(eid, dict([["kind", id], ["level", level], ["owner", -1]]));
        db.put("equips", equips);
    }

    function getNewEid()
    {
        return maxEid++;
    }




    /*
    药品储存， 一次性使用 在某个对象身上 drug+id
    */
    /*
    规划开始 和 规划取消 函数
    */

    /*
    成功修改所有建筑物的坐标
    */

    function getNewBid()
    {
        return maxBid++;
    }



    //var bkeys = ["id", "px", "py", "state", "dir", "objectId", "objectTime"];
    function updateBuildingDB()
    {
        db.put("buildings", buildings);
    }

    function sellBuild(build)
    {
        buildings.pop(build.bid);
        //allBuildings.remove(build);
        db.put("buildings", buildings);
    }
    function tempUpdateBuilding(build)
    {
        buildings.update(build.bid, dict([["id", build.id], ["px", build.getPos()[0]], ["py", build.getPos()[1]], ["state", build.state], ["dir", build.dir], ["objectId", build.getObjectId()], ["objectTime", build.getStartTime()]]));
    }
    /*
    修改建筑物的数据实体
    */
    function updateBuilding(build)
    {
        if(build.sid == MINE_BID)
            return;

        buildings.update(build.bid, dict([["id", build.id], ["px", build.getPos()[0]], ["py", build.getPos()[1]], ["state", build.state], ["dir", build.dir], ["objectId", build.getObjectId()], ["objectTime", build.getStartTime()]]));
        db.put("buildings", buildings);
    }
    /*
    这些值是本地的 偶尔需要写回到远程数据库 
    */
    function setValue(key, value)
    {
        resource.update(key, value);
        db.put("resource", resource);

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
    /*
    修改士兵的数据实体
    经营页面 和 闯关页面的士兵实体 都需要有以下属性
    */
    //士兵类型 名字 当前生命值 经验 等级
    function updateSoldiers(soldier)
    {
        //怪兽 敌方士兵 不更新数据
        if(soldier.sid == -1)
        {
            return;
        }
        soldiers.update(soldier.sid, dict([["id", soldier.id], ["name", soldier.myName], ["health", soldier.health], ["exp", soldier.exp], ["dead", soldier.dead], ["level", soldier.level], ["addAttack", soldier.addAttack], ["addDefense", soldier.addDefense], ["addAttackTime", soldier.addAttackTime], ["addDefenseTime", soldier.addDefenseTime], ["addHealthBoundary", soldier.addHealthBoundary], ["addHealthBoundaryTime", soldier.addHealthBoundaryTime] ]));
        //updateSoldierDB();
        db.put("soldiers", soldiers);
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

    /*
    修正数据， 显示士兵的view
    */
    // eid [kind sid]
    function getSoldierEquip(sid)
    {
        /*
        士兵sid为-1 表示怪兽和敌方士兵不能使用自己装备
        */
        if(sid == -1)
        {
            return [];
        }
        var solEquips = [];
        var key = equips.keys();
        for(var i = 0; i < len(key); i++)
        {
            var edata = equips.get(key[i]) ;
            if(edata.get("owner") == sid)
                solEquips.append(key[i]);
        }
        return solEquips;
    }
    function getSoldierEquipData(sid)
    {
        if(sid == -1)
        {
            return [];
        }
         
        var solEquips = [];
        var key = equips.keys();
        for(var i = 0; i < len(key); i++)
        {
            var edata = equips.get(key[i]) ;
            if(edata.get("owner") == sid)
                solEquips.append(edata);
        }
        return solEquips;
    }

    //根据装备属性生成装备类型
    function checkSoldierEquip(sid, eid)
    {
        var edata = equips.get(eid);
        var kind = edata.get("kind");
        kind = getData(EQUIP, kind).get("kind");

        trace("equipKind", kind);

        var key = equips.keys();
        for(var i = 0; i < len(key); i++)
        {
            var eData = equips.get(key[i]);
            var k = eData.get("kind");
            var detail = getData(EQUIP, k);
            //trace("detail", detail.get("kind"), detail.get("owner"));
            if(detail.get("kind") == kind && eData.get("owner") == sid)
                return 0;
        }
        return 1;
    }
    function checkUseLevel(sid, eid)
    {
        var sdata = soldiers.get(sid);
        var edata = equips.get(eid);
        edata = getData(EQUIP, edata.get("kind"));
        if(sdata.get("level") < edata.get("useLevel"))
        {
            return [0, edata.get("useLevel"), sdata.get("level")];
        }
        return [1];
    }

    function getEquipData(eid)
    {
        return equips.get(eid);
    }

    function getAllEquipNum()
    {
        return len(equips);
    }
    function getAllEquip()
    {
        return equips.keys();
    }
    function getAllDrug()
    {
        var res = [];
        var key = drugs.keys();
        for(var i = 0; i < len(key); i++)
        {
            var k = key[i];
            if(drugs[k] > 0)
                res.append(k);
        }
        return res;
    }
    function getAllHerb()
    {
        var res = [];
        var key = herbs.keys();
        for(var i = 0; i < len(key); i++)
        {
            var k = key[i];
            if(herbs[k] > 0)
                res.append(k);
        }
        return res;
    }
    function getAllDrugNum()
    {
        var key = drugs.keys();
        var count = 0;
        for(var i = 0; i < len(key); i++)
        {
            var k = key[i];
            count += drugs[k];
        }
        return count;
    }
    function getAllHerbNum()
    {
        var key = herbs.keys();
        var count = 0;
        for(var i = 0; i < len(key); i++)
        {
            var k = key[i];
            count += herbs[k];
        }
        return count;
    }

    function getAllGoodsNum(kind)
    {
        var key = treasureStone.keys();
        var count = 0;
        for(var i = 0; i < len(key); i++)
        {
            var k = key[i];
            var gKind = getGoodsKindAndId(k);
            if(gKind[0] == kind)
            {
                count += treasureStone[k];
            }
        }
        return count;
    }

    function getAllGoods(kind)
    {
        var key = treasureStone.keys();
        var res = [];
        for(var i = 0; i < len(key); i++)
        {
            var k = key[i];
            var gKind = getGoodsKindAndId(k);
            if(gKind[0] == kind)
            {
                if(treasureStone[k] > 0)
                    res.append(gKind[1]);
            }
        }
        return res;
    }

    //usedEquip Id
    //取下 士兵的装备 放回到储藏室
    //通知士兵去掉装备 可以 优化 map sid -> 士兵
    function unloadThing(tid)
    {
//        trace("unloadThing", tid);
        var edata = equips.get(tid);
        var sid = edata.get("owner");
        edata["owner"] = -1;
        db.put("equips", equips);
        
        global.msgCenter.sendMsg(SOL_UNLOADTHING, sid);
        //var sol = allSoldiers.get(sid); 
        //if(sol != null)
        //    sol.useEquip(-1);
        //global.director.curScene.unloadThing(sid);
    }
    //士兵必须是活的才可以转职

    //减少药品数量

    function changeDrugNum(id, num)
    {
        var v = drugs.get(id, 0);
        v += num;
        drugs[id] = v;
        db.put("drugs", drugs);
    }
    function changeHerbNum(id, num)
    {
        var v = herbs.get(id, 0);
        v += num;
        herbs[id] = v;
        db.put("herbs", herbs);

        setValue(NOTIFY, 1);
    }
    function useThing(kind, tid, soldier)
    {
//        trace("useThing", kind, tid, soldier.id);
        var num;
        if(kind == DRUG)
        {
            global.httpController.addRequest("soldierC/useDrug", dict([["uid", uid], ["sid", soldier.sid], ["tid", tid]]), null, null);


            changeGoodsNum(DRUG, tid, -1);

            soldier.useDrug(tid);
        }
        else if(kind == EQUIP)
        {
            global.httpController.addRequest("soldierC/useEquip", dict([["uid", uid], ["sid", soldier.sid], ["eid", tid]]), null, null);

            var edata = equips.get(tid);
            edata["owner"] = soldier.sid;
            db.put("equips", equips);
            soldier.useEquip(tid);
            return 1;
        }
    }

    function getSoldierData(sid)
    {
//        trace("getSoldierData", sid, soldiers);
        return soldiers.get(sid);
    }
    function sellSoldier(soldier)
    {
        var key = equips.keys();
        for(var i = 0; i < len(key); i++)
        {
            var k = key[i];
            var eData = equips[k];
            if(eData["owner"] == soldier.sid)
                eData["owner"] = -1;
        }
        db.put("equips", equips);
        soldiers.pop(soldier.sid);
        db.put("soldiers", soldiers);

    }

    function getLevelUpReward()
    {
        //kind = 6 7 8 9 10

        var ret = dict();
        var sil = 0;
        var cry = 0;
        var gold = 0;
        //掉落10-15 编号的物品
        for(var i = 10; i < 15; i++)
        {
            var kind = i;

            var fallData = getData(FALL_THING, kind);
            //银币是百分比值
            var reward = getFallObjValue(kind);
            var level = global.user.getValue("level");
            //水晶是等级相关
            if(reward.get("crystal") != 0)
                reward.update("crystal", 3+level/reward.get("crystal"));//等级/10的水晶数量   

            sil += reward["silver"];
            cry += reward["crystal"];
            gold += reward["gold"];

        }
        ret.update("silver", sil);
        ret.update("gold", gold);
        ret.update("crystal", cry);
        doAdd(ret);
//        trace("levelUp reward", ret);
        return ret;
    }
    /*
    function getLevelUpReward()
    {
        var ret = dict();
        var level = getValue("level");
        var sil = 0;
        var gol = 0;
        var cry = 0;
        for(var i = 0; i < 10; i++)
        {
            var reward = getGain(FALL_THING, i/2+5);
            if(reward["silver"] != 0)
            {
                reward["silver"] += global.user.getValue("level")/5*5;
            }
            sil += reward["silver"];
            gol += reward["gold"];
            cry += reward["cry"];
        }
        ret.update("silver", sil);
        ret.update("gold", gol);
        ret.update("crystal", cry);

        doAdd(ret);
//        trace("levelUp reward", ret);
        return ret;
    }
    */
    /*
    改变用户经验 有可能自动升级
    */
    function changeValue(key, add)
    {
        trace("changeValue", key, add);
        var v = resource.get(key, 0);
        v += add;
        if(key == "exp")
        {
            var level = getValue("level");
            var oldLevel = level;
            var addCityDefense = 0;
            while(1)
            {
                var needExp = getLevelUpNeedExp(level);
                //升级村庄防御力上升
                if(v >= needExp)
                {
                    v -= needExp;
                    for(var i = 0; i < len(levelDefense); i++)
                    {
                        if(level < levelDefense[i][0])
                            break;
                    }
                    i = min(i, len(levelDefense)-1);
                    addCityDefense += levelDefense[i][1];

                    level += 1;
                }
                else 
                    break;
            }
            setValue("level", level);
            changeValue("cityDefense", addCityDefense);
            trace("levelUp", level, addCityDefense, v, needExp);

            if(level != oldLevel)
            {
                var ret = global.msgCenter.checkCallback(LEVEL_UP);
                //如果不在经营页面 则 直接增加一些5 6 7 8 9的奖励 
                if(ret == 0)
                {
//                    trace("not in business page!");
                    var rew = getLevelUpReward();//生成奖励时已经增加
                    global.httpController.addRequest("levelUp", dict([["uid", uid], ["level", level], ["rew", rew], ["cityDefense", addCityDefense]]), null, null);
                }
                //经验界面掉落 5 6 7 8 9 奖励
                else
                {
                    global.msgCenter.sendMsg(LEVEL_UP, null);
                    global.httpController.addRequest("levelUp", dict([["uid", uid], ["level", level], ["rew", dict()], ["cityDefense", addCityDefense]]), null, null);
                }
            }
        }
        setValue(key, v);
    }

    //获取任何物品首先获得 相应类别 再 获取 对应id的值

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

    //可建造 可移动 更新建筑物的map 不可建造 px py sx sy obj kind
    //map --->[[obj, 1, 1]] 不可建造 不可移动
    //map ---->[[obj, 0, 1]] 可以建造 不可移动
    //block 不可建造 可以移动
    //士兵检测冲突 
    //建筑物检测冲突


    //一个MAP中的对象需要实现以下
    /*
    清楚Farm的上边界 移动冲突
    只在清楚状态的时候 清理建筑物状态
    包括建筑和士兵
    士兵不需要设置 底部颜色
    */

   
    /*
    士兵移动冲突检测
    训练场
    建筑物
    河流
    */
    
    
    /*
    建筑物检测建造冲突
    检测冲突， 值返回还有几个对象，每次移动的时候把自己从中清除即可
    i++ i--
    建筑物 士兵 sx sy pos
    */
    
    /*
    冲突是一种关系，涉及到两个方面，必须要同时改变两个状态
    mapDict  存储数字 和 存储对象之间 
    比较：对象便于进行反向 引用   
    */

    /*
    只能控制一个建筑物 所以冲突状态是确定
    必须把该建筑移动到没有冲突的位置 才可以移动其它建筑
    */

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
        trace("doAdd", add);
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
    function getOldPos(sid)
    {
        return oldPos.get(sid);        
    }
    //经营页面 每一段时间记录一次士兵位置
    //经营页面退出时记录士兵位置
    function storeOldPos(allSoldiers)
    {
        if(oldPos == null)
            return;
        var value = allSoldiers.values();
        for(var i = 0; i < len(value); i++)
        {
            var sol = value[i];
            oldPos.update(sol.sid, sol.getPos());
        }
        db.put("oldPos", oldPos);
    }
    //通知其它部分更新 装备等级数据
    function upgradeEquip(eid)
    {
        var e = equips.get(eid);
        e["level"] += 1;
        db.put("equips", equips);
        global.msgCenter.sendMsg(UPDATE_EQUIP, eid);
    }
    function breakEquip(eid)
    {
        var e = equips.get(eid);
        e["level"] -= 1;
        e["level"] = max(e["level"], 0);
        db.put("equips", equips);
        global.msgCenter.sendMsg(UPDATE_EQUIP, eid);
    }

    //全部卖出
    function sellDrug(kind)
    {
        drugs.pop(kind);
    }

    function sellEquip(eid)
    {
        equips.pop(eid);
    }

    function getCurSkillNum(sid)
    {
        var sk = skills.get(sid, dict()); 
        return len(sk);
    }
    function getSolSkills(sid)
    {
        return skills.get(sid, dict());
    }
    function getSolSkillLevel(sid, skillId)
    {
        var v = skills.get(sid);
        return v.get(skillId, -1);
    }

    function giveupSkill(soldierId, skillId)
    {
        var v = skills.get(soldierId);
        v.pop(skillId);

        global.msgCenter.sendMsg(UPDATE_SKILL, [soldierId, skillId]);
    }
    function buySkill(soldierId, skillId)
    {
        var cost = getCost(SKILL, skillId);
        doCost(cost);
        var v = skills.get(soldierId, dict());
        v.update(skillId, 0);
        skills.update(soldierId, v);

        global.msgCenter.sendMsg(UPDATE_SKILL, [soldierId, skillId]);
    }
    function upgradeSkill(soldierId, skillId)
    {
        var v = skills.get(soldierId, []);
        v[skillId] += 1;
        global.msgCenter.sendMsg(UPDATE_SKILL, [soldierId, skillId]);
    }
    function collectHeart()
    {
        var l = getValue("liveNum");
        changeValue("crystal", l);
        changeValue("liveNum", -l);
    }
}
