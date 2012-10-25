class BusiSoldier extends MyNode
{
    //在同时处理建筑物和士兵的模块 通过这个标志区分两者
    //或者传递参数的时候， 通过明显的变量区分
    var isBuilding = 0;
    /*
    和建筑物应该在同一个图层上面 这样有正常的遮挡关系
    */
    var map; 
    //var kind;
    var sid;
    var id;
    var sx = 1;
    var sy = 1;
    var state = SOL_FREE;
    var tar = null;
    //var mobj;
    //var cus = null;
    var myName;
    var shadow;
    //50 /s 
    var speed = 5;

    var movAni;
    var shiftAni;
    var data;

    //用于在setMap 和clear Map中设定 农田的上边界 
    var funcs = BUSI_SOL;

    //var inspire = INSPIRE;
    //var inspirePic = null;

    var healthBoundary;
    var health;

    //var attack;
    //var defense;
    var physicAttack;
    var physicDefense;
    var purePhyDefense;

    var magicAttack;
    var magicDefense;
    var pureMagDefense;

    //var base;

    var attSpeed;
    var attRange;
    
    var exp;
    var dead;
    var level;
    //const showSize = 50;

    var recoverSpeed;
    //当前只有士兵才有特征色
    //var featureColor;
    //var featureMov;


    /*
    需要在行走的时候开始动画
    updateMap 是view相关数据是由动作生成的
    战斗页面生命值不能回复 只有在经营页面生命值才回复
    用户在游戏中 才回复 还是 上次回复的时间计算生命值回复时间
    战斗中不会计算生命值回复

    生命值上限 由 基础职业+等级增加+装备

    等级分成两种：
    职业等级
    普通等级

    攻击速度1500 慢 1000 中等 500 快

    */


    var bloodTotalLen = 134;
    var bloodHeight = 9;
    var bloodScaX = 72*100/139;//根据怪兽的体积计算血条长度 
    var bloodScaY = 9*100/12;
    var firstBuy = 0;
    //var myEquips;
    function initData(privateData)
    {
        if(privateData == null)
        {
            firstBuy = 1;
            privateData = dict();
        }
        //myEquips = global.user.getSoldierEquipData(sid);

        level = privateData.get("level", 0);

        addAttack = privateData.get("addAttack", 0);
        addAttackTime = privateData.get("addAttackTime", 0);
        addDefense = privateData.get("addDefense", 0);
        addDefenseTime = privateData.get("addDefenseTime", 0);
        addHealthBoundary = privateData.get("addHealthBoundary", 0);
        addHealthBoundaryTime = privateData.get("addHealthBoundaryTime", 0);

        health = privateData.get("health", 0);
        recoverSpeed = data.get("recoverSpeed");
        initAttackAndDefense(this);
        if(firstBuy)
            health = healthBoundary;
        
        exp = privateData.get("exp", 0);
        dead = privateData.get("dead", 0);
        

        attSpeed = data.get("attSpeed");
        attRange = data.get("range");


    }
    var recoverTime = 0;
    //[[lev, [health, magicDefense, physicDefense, physicAttack, magicAttack]], ...]
    //if i >= len(stage)
    //计算裸 基本属性

    var addAttack = 0;
    var addAttackTime = 0;
    var addDefense = 0;
    var addDefenseTime = 0;
    var addHealthBoundary = 0;
    var addHealthBoundaryTime = 0;

    //攻击药水 防御药水 在闯关的1个回合中暂时提升士兵能力 100 attack 100 defense
    //复活药水 复活士兵 增加 0 
    //取消增加经验药水
    //%生命 %攻击 %防御 加百分比的药水在 使用的时候将会转化成 增加数值
    function doRelive()
    {
        dead = 0;
        health = healthBoundary;
        global.user.updateSoldiers(this);
        global.msgCenter.sendMsg(RELIVE_SOL, [sid, global.user.getSoldierData(sid)]);
    }
    //计算药水使用在 当前士兵身上的效果值
    //dict({k:v})
    function getDrugEffect(tid)
    {
        var pureData = getSolPureData(id, level);
        var dd = getGain(DRUG, tid);
        var it = dd.items()[0];
        var k = it[0];
        var v = it[1];
        if(k.find("percent") != 0)
            return dd;

        var ret = dict();
        if(dd.get("percentHealth") != null)
            ret.update("health", pureData["healthBoundary"]*dd.get("percentHealth")/100);
        if(dd.get("percentAttack") != null)
        {
            var purePhyAttack = pureData["physicAttack"];
            var pureMagAttack = pureData["magicAttack"];
            var attack = dd.get("percentAttack")*max(purePhyAttack, pureMagAttack)/100;
            ret.update("attack", attack);
        }
        if(dd.get("percentDefense") != null)
        {
            var purePhyDef = pureData["physicDefense"];
            var pureMagDef = pureData["magicDefense"];
            var defense = dd.get("percentDefense")*max(purePhyDef, pureMagDef)/100;
            ret.update("defense", defense);
        }
        if(dd.get("percentHealthBoundary") != null)
        {
            var pureHealthBoundary = pureData["healthBoundary"];
            var healthBoundary = dd.get("percentHealth")*pureHealthBoundary/100;
            ret.update("healthBoundary", healthBoundary); 
        }
        return ret;
    }

    function useDrug(tid)
    {
        var dd = getData(DRUG, tid);    
        changeHealth(dd.get("health"));

        var pureData = getSolPureData(id, level);
        var pureHealthBoundary;

        if(dd.get("healthBoundary") != 0)
        {
            addHealthBoundary = dd.get("healthBoundary");
            addHealthBoundaryTime = dd.get("effectTime");
        }
        else if(dd.get("percentHealth") != 0)
        {
            pureHealthBoundary = pureData["healthBoundary"];
            changeHealth(dd.get("percentHealth")*pureHealthBoundary/100);
        }
        else if(dd.get("percentHealthBoundary") != 0)
        {
            pureHealthBoundary = pureData["healthBoundary"];
            addHealthBoundary = dd.get("percentHealth")*pureHealthBoundary/100;
            addHealthBoundaryTime = dd.get("effectTime");
        }
        else if(dd.get("percentAttack") != 0)
        {
            var purePhyAttack = pureData["physicAttack"];
            var pureMagAttack = pureData["magicAttack"];
            addAttack = dd.get("percentAttack")*max(purePhyAttack, pureMagAttack)/100;
            addAttackTime = dd.get("effectTime");
        }
        else if(dd.get("percentDefense") != 0)
        {
            var purePhyDef = pureData["physicDefense"];
            var pureMagDef = pureData["magicDefense"];
            addDefense = dd.get("percentDefense")*max(purePhyDef, pureMagDef)/100;
            addDefenseTime = dd.get("effectTime");
        }
        else if(dd.get("attack") != 0)
        {
            addAttack = dd.get("attack");
            addAttackTime = dd.get("effectTime");
        }
        else if(dd.get("defense") != 0)
        {
            addDefense = dd.get("defense");
            addDefenseTime = dd.get("effectTime");
        }
        else if(dd.get("relive") == 1)//x% life dead = 0
        {
//            trace("reliveSoldier", sid);
            dead = 0;
            //health = dd.get("effectTime")*healthBoundary/100; 
            health = healthBoundary;
            //复活本士兵

        }
        initAttackAndDefense(this);
        initHealth();
        global.user.updateSoldiers(this);

        if(dd.get("relive") == 1)
            global.msgCenter.sendMsg(RELIVE_SOL, [sid, global.user.getSoldierData(sid)]);
    }

    function updateState()
    {
        initAttackAndDefense(this);
        initHealth();
    }
    //参数  -1 表示去掉某件装备
    //其它表示 装备某个类型的装备
    //关闭装备菜单 士兵选择使用某个装备
    function useEquip(tid)
    {
        updateState();
        //initAttackAndDefense(this);
        //initHealth();
        global.user.updateSoldiers(this);
    }
    function updateTransData()
    {
        data = getData(SOLDIER, id);
        //id = data.get("id");
        //var colStr = "red";
        load_sprite_sheet("soldierm"+str(id)+".plist");
        changeDirNode.texture("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png");
        //initAttackAndDefense(this);
        //initHealth();
        updateState();
        if(movAni != null)
        {
            movAni.stop();
        }
        movAni = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
    }

    function updateStaticData()
    {
        id = global.user.getSoldierData(sid)["id"];
        updateTransData();
    }

    //杀死该士兵后
    //view 消失 user 场景对象消失
    /*
    function killMonster()
    {
        dead = 1;
        global.user.updateSoldiers(this);//更新死亡状态
        map.removeChild(this); 
    }
    */
    //闯关页面士兵死亡  经营页面 在进入场景的时候会根据数据重新生成士兵

    function doTrain()
    {
        //killMonster();
    }
    var changeDirNode;
    /*
    所有和bg 相关的 需要改变方向的需要修改成changeDirNode
    改变纹理的movAni
    改变方向的setDir
    改变位置的shift不变
    添加子节点不变
    */
    var backBanner;
    var bloodBanner;

    function initHealth()
    {
        var bx = bloodTotalLen*health/healthBoundary;
        bloodBanner.size(bx, bloodHeight);
    }
    //购买士兵 以烟雾显示
    //烟雾显示 一定时间
    //控制士兵不能乱跑 命名结束 之后 才可以
    var oldState = null;
    function setSmoke()
    {
        bg.addaction(fadein(1000));
        bg.addaction(movAni);
        oldState = state;
        state = SOL_NAME;
        clearMoveState();//停止移动
        map.addChildZ(new MonSmoke(map, null, this, PARAMS["smokeSkillId"], null), MAX_BUILD_ZORD);
    }
    function finishName()
    {
        if(oldState != null)
        {
            state = oldState;
            oldState = null;
        }
    }

    function BusiSoldier(m, d, privateData, s)
    {
        sid = s;
        data = d;
        map = m;
        speed = getParam("busiSoldierSpeed");
        id = data.get("id");
        //var colStr = "red";
        load_sprite_sheet("soldierm"+str(id)+".plist");

        bg = node().scale(PARAMS["SOL_SHOW_SIZE"]);
        init();
        changeDirNode = bg.addsprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 100);

        var bSize = changeDirNode.prepare().size();

        var oldPos = global.user.getOldPos(sid);
        if(oldPos == null)//默认出现位置 中心
            oldPos = TRAIN_CENTER;

        bg.size(bSize).anchor(50, 100).pos(oldPos);
        changeDirNode.pos(bSize[0]/2, bSize[1]);

        shadow = sprite("roleShadow.png").pos(bSize[0]/2, bSize[1]).anchor(50, 50).size(data.get("shadowSize"), 32);

        changeDirNode.add(shadow, -1);
        initData(privateData);


        var nPos = normalizePos(bg.pos(), sx, sy);
        setPos(nPos);
        
        //死亡士兵 打开药店 不需要更新地图
        //设置当前位置为MapDict
        if(map != null)
            curMap = map.mapGridController.updateMap(this);

        movAni = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
        shiftAni = moveto(0, 0, 0);
        if(privateData != null)
            myName = privateData.get("name", "");
        else
            myName = "";
        //showInspire();

        if(data.get("sx") < 2)
        {
            bloodScaX = 70*100/139;//大体积 采用144的长度 中等体积 采用普通长度    
        }
        else 
        {
            bloodScaX = 139*100/139;
        }

        backBanner = bg.addsprite("mapSolBloodBan.png").pos(bSize[0]/2, -10).anchor(50, 100).scale(bloodScaX, bloodScaY).visible(0);
        bloodBanner = backBanner.addsprite("mapSolBlood.png").pos(2, 2);

        initHealth();

        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function setSid(s)
    {
        sid = s;
    }
    /*
    function doSell()
    {
        global.director.pushView(new SellDialog(this), 1, 0);
    }
    */
    function sureToSell()
    {
        global.httpController.addRequest("soldierC/sellSoldier", dict([["uid", global.user.uid], ["sid", sid]]), null, null);
        var cost = getCost(SOLDIER, id);
        cost = changeToSilver(cost);
        global.user.doAdd(cost);
        //global.director.curScene.addChild(new FlyObject(bg, cost, sellOver));
        //修改view
        //修改数据
        //global.msgCenter.sendMsg(BUYSOL, null);
        clearSol();
        global.msgCenter.sendMsg(SELL_SOL, sid);
    }
    //卖出士兵之后接受消息清除自身
    function clearSol()
    {
        if(map != null) 
            //map.sellSoldier(this);
            map.removeSoldier(this);
        global.msgCenter.sendMsg(BUYSOL, null);
        global.user.sellSoldier(this);
    }
    function sellOver()
    {
    }
    function changeMoney(gain)
    {
        var temp = bg.addnode();
        var it = gain.items();
        var curY = -30;
        for(var i = 0; i < len(it); i++)
        {
            var g = it[i];
            temp.addsprite(g[0]+".png").anchor(0, 50).pos(0, curY).size(30, 30);
temp.addlabel("+" + str(g[1]), "fonts/heiti.ttf", 25).anchor(0, 50).pos(35, curY).color(0, 0, 0);
            curY -= 30;
        }
        temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
    }
    //使用药品应该出现生命图标
    function changeExp(add)
    {
        if(add == 0)
            return;
        exp += add;
        var ne = getLevelUpExp(id, level);
        if(exp >= ne)
        {
            for(; 1; )
            {
                ne = getLevelUpExp(id, level);
                if(exp >= ne)
                {
                    exp -= ne;
                    level += 1;
                }
                else 
                    break;
            }
            initAttackAndDefense(this);
            initHealth();
            if(dead == 0)
                health = healthBoundary;
        }

        var temp = bg.addnode().scale(100*100/PARAMS["SOL_SHOW_SIZE"]);
        temp.addsprite("exp.png").anchor(0, 50).pos(0, -30).size(30, 30);
        temp.addlabel("+" + str(add), "fonts/heiti.ttf", 25).anchor(0, 50).pos(35, -30).color(6, 26, 46);
        temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
    }
    function changeHealth(add)
    {
        if(add == 0)
            return;
        health += add;
        health = min(healthBoundary, health);

        var temp = bg.addnode().scale(100*100/PARAMS["SOL_SHOW_SIZE"]);
        temp.addsprite("drug0.png").anchor(0, 50).pos(0, -30).size(30, 30);
        temp.addlabel("+" + str(add), "fonts/heiti.ttf", 25).anchor(0, 50).pos(35, -30).color(6, 26, 46);
        temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
    }
    /*
    修改士兵的id
    修改士兵的攻击力 防御力 经验
    修改士兵的显示状态
    */
    function doTransfer()
    {
        //var proLevel = id%10;
        //var solOrMon = data.get("solOrMon");
        //var ret = checkTransfer(level, data);

        //if(proLevel < 3 && (proLevel+1)*5 <= level && solOrMon == 0)//每5级可以转职一次
        //if(ret == 1)
        {
        //改变形象bg  改变数据 id 
            //global.httpController.addRequest("soldierC/doTransfer", dict([["uid", global.user.uid], ["sid", sid]]), null, null);
            id += 1;
            //global.user.updateSoldiers(this);//更新士兵类型
            //var d = getData(SOLDIER, id);
            //updateStaticData();
            updateTransData();
            global.user.updateSoldiers(this);//更新士兵类型
            global.msgCenter.sendMsg(TRANSFER_SOL, sid);//发送士兵转职消息
        }
    }
    var accMove = 0;
    var lastPoints;
    /*
    规划状态下士兵的Zord 只有在冲突的时候才会设置成最大
    */
    function touchBegan(n, e, p, x, y, points)
    {
        accMove = 0;
        lastPoints = n.node2world(x, y);
        if(Planing)
        {
            var setSuc = global.director.curScene.setBuilding([PLAN_SOLDIER, this]);
            //点击成功设置bottom
            if(setSuc)
            {   
                setBottom();
            }
            //if(global.director.curScene.curBuild == this)
            map.mapGridController.clearSolMap(this); 
        }
        else //if(curStatus == NO_STATUS)
            map.touchBegan(n, e, p, x, y, points);
    }

    function setBottom()
    {
        if(bottom == null)
        {
            var bSize = bg.size();
            /*
            如果方块的大小恰好和建筑物的底座一样大小 那么要求建筑物底座必须要一定大小
            +40 +20
            士兵脚底是方块中心
            士兵的sx sy 与 建筑不同
            */
            bottom = sprite().pos(bSize[0]/2, bSize[1]).anchor(50, 50).size((sx+sy)*SIZEX+20, (sx+sy)*SIZEY+10).color(100, 100, 100, 100);
            bg.add(bottom, -1);
        }
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0] - oldPos[0];
        var dify = lastPoints[1] - oldPos[1];
        accMove += abs(difx)+abs(dify);

        //如果当前的建筑物不是可操作的建筑物 则移动背景地图
        if(Planing && global.director.curScene.curBuild == this)
        {
            var parPos = bg.parent().world2node(lastPoints[0], lastPoints[1]);
            var newPos = normalizePos(parPos, sx, sy)
            setPos(newPos);
            setColPos();

            if(len(points) >= 3)//多个手指允许缩放操作
            {
                map.touchMoved(n, e, p, x, y, points);
            }
        }
        else //if(curStatus == NO_STATUS)
            map.touchMoved(n, e, p, x, y, points); 
    }
    /*
    根据当前位置 判断是否冲突 决定底座的颜色 
    需要设置士兵的curMap 来计算冲突

    colNow 记录当前的冲突状态
    判定是否在移动区域中checkInTrain

    curMap = map.mapGridController.updatePosMap([sx, sy, tar[0], tar[1], this]);
    */
    function setColPos()
    {
        colNow = 0;
        //根据当前位置计算地图映射
        var curP = bg.pos();
        var cmap = getPosMap(sx, sy, curP[0], curP[1]);
        //根据映射检测冲突

        var col = map.checkPosCollision(cmap[2], cmap[3], bg.pos(), this);
        //trace("setSolColor", curP, cmap, col);

        if(col != null)
        {
            colNow = 1;
            setZord(MAX_BUILD_ZORD);
        }

        if(bottom != null)
        {
            if(colNow)
                bottom.texture("red2.png");
            else
                bottom.texture("green2.png");
        }

    }
    function showGlobalMenu()
    {
        showMenuYet = 1;
        var func1;
        var solOrMon = data.get("solOrMon");
        //怪兽没有装备
        if(solOrMon == 1)
            func1 = ["photo", "drug"];
        //普通士兵装备
        else
            func1 = ["photo", "drug", "equip"];
            
        var func2;
        var isHero = data.get("isHero");
        if(isHero == 0)
        {
            if(curStatus != NO_STATUS)
            {
                func2 = ["menu"+str(curStatus), "singleTrain", "gather"];
            }
            else
                func2 = ["singleTrain", "gather"];
        }
        else
        {
            if(curStatus != NO_STATUS)
                func2 = ["menu"+str(curStatus), "singleTrain", "skill", "gather"];
            else
                func2 = ["singleTrain", "skill", "gather"];
        }
          
        //快速编译解决依赖关系
        global.director.pushView(new SoldierMenu(this, func1, func2), 0, 0); 
    }
    function closeGlobalMenu()
    {
        showMenuYet = 0;
    }
    var showMenuYet = 0;
    function touchEnded(n, e, p, x, y, points)
    {
        //正在建造 且为当前建筑
        if(Planing && global.director.curScene.curBuild == this )
        {
            if(colNow == 0)
            {
                setPos(bg.pos());
                //不冲突调整zord正常
                //冲突zord设置最大
            }
            curMap = map.mapGridController.updateMap(this);//设置当前冲突位置
        }
        //没有建造 且 没有 显示菜单 且 没有状态
        if(showMenuYet == 0 && !Planing)//&& curStatus == NO_STATUS
        {
            if(accMove < 20)
                global.director.curScene.showGlobalMenu(this, showGlobalMenu);
        }
        //没有状态
        //if(curStatus == NO_STATUS)
        map.touchEnded(n, e, p, x, y, points);
        //没有规划
    }

    function setName(n)
    {
        myName = n;
        global.httpController.addRequest("soldierC/setName", dict([["uid", global.user.uid], ["sid", sid], ["name", myName]]), null, null);
        global.user.updateSoldiers(this);
    }
    /*
    更新装备调整实体状态
    更新技能不用调整
    */
    override function enterScene()
    {
        super.enterScene();
        map.solTimer.addTimer(this);
        global.msgCenter.registerCallback(UPDATE_EQUIP, this);
        global.msgCenter.registerCallback(USE_DRUG, this);
        global.msgCenter.registerCallback(SELL_SOL, this);
        global.msgCenter.registerCallback(TRANSFER_SOL, this);
    }
    function receiveMsg(param)
    {
        var mid = param[0];
        if(mid == UPDATE_EQUIP)
        {
            //更新装备状态
            var eid = param[1];
            if(global.user.getEquipData(eid).get("owner") == sid)
            {
                updateState();
                //initAttackAndDefense(this);//升级装备之后 更新士兵属性
                //initHealth();
            }
        }
        else if(mid == USE_DRUG)
        {
            var useSid = param[1][0];
            var tid = param[1][1];
            if(useSid == sid)
            {
                updateState();
            }
        }
        else if(mid == SELL_SOL)
        {
            var sellSid = param[1];
            if(sid == sellSid)
            {
                clearSol();
            }
        }
        else if(mid == TRANSFER_SOL)
        {
            var tranSid = param[1];
            if(sid == tranSid)
            {
                //更新士兵id
                //id = global.user.getSoldierData(sid)["id"]; 
                //var d = getData(SOLDIER, id);
                updateStaticData();
            }
        }
    }

    var newTar = null;
    function setTarPos(x, y)
    {
        clearMoveState();

        var posMap = getPosMap(sx, sy, x, y);//士兵的目标位置  
        posMap = [posMap[2], posMap[3]];
        newTar = setBuildMap([sx, sy, posMap[0], posMap[1]]);
        curMap = map.mapGridController.updatePosMap([sx, sy, newTar[0], newTar[1], this]);
        
        //没有在移动 则 开始移动
        if(state != SOL_POS)//防止多次点击设置移动状态 多次添加移动action的问题
            changeDirNode.addaction(movAni);
        setTarDir();
        //设定新的目的位置
        state = SOL_POS;
    }


    function clearMoveState()
    {
        map.mapGridController.clearSolMap(this);
        shiftAni.stop();
        if(state != SOL_POS)//没有在移动
            movAni.stop();
    }

    function setTarDir()
    {
        var difx = newTar[0] - bg.pos()[0];
        if(difx < 0)
            changeDirNode.scale(100, 100);
        else
            changeDirNode.scale(-100, 100);
    }

    //8 目标位置
    function getTar()
    {
        var curPos = bg.pos();
        var posMap = getPosMap(sx, sy, curPos[0], curPos[1]);  
        posMap = [posMap[2], posMap[3]];
        var allPos = [
            [posMap[0]+0, posMap[1]+-2],
            [posMap[0]+-1, posMap[1]+-1],
            [posMap[0]+-2, posMap[1]+0],
            [posMap[0]+-1, posMap[1]+1],
            [posMap[0]+0, posMap[1]+2],
            [posMap[0]+1, posMap[1]+1],
            [posMap[0]+2, posMap[1]+0],
            [posMap[0]+1, posMap[1]+-1],
        ];
        var start = rand(len(allPos));
        var moveable = 0;
        for(var i = 0; i < len(allPos); i++)
        {
            var cur = (start+i)%len(allPos);
            var curMap2 = allPos[cur];
            var tPos = setBuildMap([sx, sy, curMap2[0], curMap2[1]]);
            var col = map.checkPosCollision(curMap2[0], curMap2[1], tPos, this);
            if(col == null)
            {
                moveable = 1;
                break;   
            }
        }
        if(!moveable)
        {
            clearMoveState();
            map.mapGridController.clearSolMap(this);
            bg.pos(TRAIN_CENTER);
        }
        //trace("move TarGetPos", start+i);
        //trace("getTar", moveable);
        if(moveable == 1)
        {
            var tmap = allPos[(start+i)%len(allPos)];
            return setBuildMap([sx, sy, tmap[0], tmap[1]]);
        }
        //不可移动且不再训练场则自动移动到训练场
        return null;
    }
    /*
    每个人物有不同长度的动画 那么标准API不能静态的处理 只能依赖于custom 但是这个效率比较低
    所以可以设定所有人物动画长度相同
    */
    function setDir()
    {
        var difx = tar[0] - bg.pos()[0];
        if(difx < 0)
            changeDirNode.scale(100, 100);
        else
            changeDirNode.scale(-100, 100);
    }
    /*
    function showInspire()
    {
        if(inspire == 1)
        {
            var bsize = bg.size();
            inspirePic = bg.addsprite("soldierMorale.png").pos(bsize[0]/2, -5).anchor(50, 100);
        }
    }
    */
    //var inspireTime = 0;
    //士兵当前占用的map映射格子 
    var curMap = null;
    function doMove()
    {
        shiftAni.stop();
        var oldPos = bg.pos();
        setPos(oldPos);
        var dist = distance(bg.pos(), tar);
        if(oldPos[0] == tar[0] && oldPos[1] == tar[1])
        {
            movAni.stop();
            //featureMov.stop();
            state = SOL_FREE;
            return;
        }
        var t = dist*1000/speed;
        shiftAni = moveto(t, tar[0], tar[1]);
        bg.addaction(shiftAni);
    }
    function update(diff)
    {
        recoverTime += diff;
        if(recoverTime >= RECOVER_TIME)
        {
            //需要优化生命值数据
            //回复累计1min
            if(health < healthBoundary)
            {
                var addHealth = min(recoverSpeed, healthBoundary-health);
                global.httpController.cacheHealthRecover(dict([["sid", sid], ["addHealth", addHealth]]));
            }
            health += recoverSpeed;
            health = min(health, healthBoundary);
            recoverTime = 0;
            initHealth();

        }


        if(Planing)//规划中停止移动
            return;

        if(showMenuYet == 1)//显示全局菜单停止移动 
            return;
        //到达目的地之后 进入等待状态
        //SOL_POS 状态 移动到目的地
        if(inGame == 1 || state == SOL_POS)//正在游戏中 或者正在移动结束
        {
            if(state == SOL_POS)
            {
                shiftAni.stop();
                var oldPos = bg.pos();
                setPos(oldPos);
                var dist = distance(bg.pos(), newTar);
                if(oldPos[0] == newTar[0] && oldPos[1] == newTar[1])
                {
                    movAni.stop();
                    state = SOL_FREE;
                    return;
                }
                var t = dist*1000/speed;
                shiftAni = moveto(t, newTar[0], newTar[1]);
                bg.addaction(shiftAni);
            }
            return;
        }

        //设子map映射在没有到达的位置
        if(state == SOL_FREE)
        {
            tar = getTar();
            //trace("moveTarPos", tar);
            if(tar != null)
            {
                state = SOL_MOVE; 
                map.mapGridController.clearSolMap(this);
                curMap = map.mapGridController.updatePosMap([sx, sy, tar[0], tar[1], this]);
                changeDirNode.addaction(movAni);
                setDir();
                doMove();
            }
        }
        else if(state == SOL_MOVE)
        {
            doMove();
        }
        //休息一段时间
        else if(state == SOL_WAIT)
        {
        }
        //正在命名 停止移动
        else if(state == SOL_NAME)
        {
        }
    }
    /*
    一个对象清空map状态的时候需要清除相应地图块的士兵和建筑物
    */

    //检测士兵当前是否冲突
    var colNow = 0;

    var startPos = null;
    var startMap = null;
    var Planing = 0;
    function keepPos()
    {
        Planing = 1;
        bg.stop();//停止所有移动 设定状态 为空闲 

        startPos = getPos();
        startMap = curMap;
        state = SOL_FREE;
        map.mapGridController.clearSolMap(this); //清理自身的map
    }

    function restorePos()
    {
        map.mapGridController.clearSolMap(this); 
        setPos(startPos);
        curMap = startMap;
        finishPlan();
    }
    var bottom = null;
    function finishPlan()
    {
        Planing = 0;
        finishBottom();
    }
    //冲突的时候士兵将显示在最高的位置
    function finishBottom()
    {
        if(bottom != null)
        {
            bottom.removefromparent();
            bottom = null
        }
    }

    override function exitScene()
    {
        global.msgCenter.removeCallback(SELL_SOL, this);
        global.msgCenter.removeCallback(USE_DRUG, this);
        global.msgCenter.removeCallback(UPDATE_EQUIP, this);
        map.solTimer.removeTimer(this);
        super.exitScene();
    }
    override function setPos(p)
    {
        bg.pos(p);
        var par = bg.parent();
        if(par != null)
        {
            bg.removefromparent();
            var zOrd = p[1];
            par.add(bg, zOrd);
        }
    }
    var curStatus = NO_STATUS;
    var status = null;
    function showCurStatus()
    {
        if(curStatus == NO_STATUS)
            return;
        if(status != null)
        {
            status.removefromparent();
            status = null;
        }

        var bsize = bg.size();
        var pic;
        var rd;
        status = bg.addsprite("soldierStatus.png").pos(bsize[0]/2, -5).anchor(50, 100);
        if(curStatus == EXP_GAME)
        {
            rd = rand(PARAMS["ExpGameNum"]);
            pic = status.addsprite("drum"+str(rd)+".png").anchor(50, 50).pos(34, 24);
        }
        else if(curStatus == PICK_GAME)
        {
            rd = rand(PARAMS["MoneyGameNum"]); 
            pic = status.addsprite("goods"+str(rd)+".png").anchor(50, 50).pos(34, 24);
        }
        else
        {
            pic = status.addsprite("status"+str(curStatus)+".png").anchor(50, 50).pos(34, 24);
        }
        var sca = getSca(pic, [45, 45]);
        pic.scale(sca);
    }

    //保证只有5 个士兵有状态
    function realClearStatus()
    {
        if(status != null)
        {
            curStatus = NO_STATUS;
            status.removefromparent();
            status = null;
        }
    }
    function clearStatus()
    {
        //用户手动清除状态 可能系统已经清除状态了
        global.taskModel.doCycleTaskByKey("eliminate", 1);
        global.taskModel.doDayTaskByKey("eliminate", 1);
        if(status != null)
        {
            realClearStatus();
        }   
    }
    //生命值少于2/3
    //返回是否有了状态
    function genBloodAndTransferStatus()
    {
        if(inGame)
            return;
        if(status == null)
        {
            var rd = rand(100);
            if(health < healthBoundary*2/3) 
            {
                //if(rd < 50)
                //curStatus = BLOOD_STATUS;
                curStatus = HEART_STATUS;
                //else
                //    curStatus = HEART_STATUS;
            }
            else
            {
                var tranLev = getTransferLevel(this);
                if(level >= tranLev && tranLev != -1)
                {
                    curStatus = TRANSFER_STATUS;
                }
            }
            showCurStatus();
        }
        return curStatus;
    }
    var possible = null;
    function initPossible()
    {
        possible = [];
        var i;
        possible.append(statusPossible[0][1]);
        for(i = 1; i < len(statusPossible); i++)
        {
            possible.append(statusPossible[i][1]+possible[i-1]);
        }
    }
    /*
    生成加经验游戏 和 捡银币游戏
    30 70 概率
    */
    function genNewStatus()
    {
        if(inGame)
            return;
        if(curStatus == NO_STATUS)
        {
            var rd = rand(100);
            if(rd < 30)
            {
                curStatus = EXP_GAME;  
            }
            else 
                curStatus = PICK_GAME;
            /*
            if(possible == null)
                initPossible();
            for(var i = 0; i < len(possible); i++)
            {
                if(rd <= possible[i])
                {
                    break;
                }
            }
            */
            //curStatus = statusPossible[min(i, len(statusPossible)-1)][0];
            showCurStatus();
        }
    }
    //清除随机奖励金钱状态
    //清除所有状态 重新生成所有生命值 转职状态
    //由士兵控制的状态
    function clearRandomStatus()
    {
        realClearStatus();
    }
    //游戏1 不动
    //游戏2 点击左右移动 点击移动的目的地 最近的方块区域
    var inGame = 0;
    var gameId = -1;
    function beginGame(gId)
    {
        /*
        inGame = 1;
        gameId = gId;
        clearMoveState();
        map.mapGridController.clearSolMap(this);
        */
        realBeginGame(gId);
        //单人游戏 隐藏所有其他士兵 在游戏结束时显示其他士兵
        map.hideSoldier(this);
        
        bg.pos(PARAMS["GAME_X"], PARAMS["GAME_Y"]);
        var nPos = normalizePos(bg.pos(), sx, sy);
        setPos(nPos);

        map.map.moveToBuild(this);
    }
    function endGame()
    {
        map.showSoldier(this);
        map.map.moveToNormal(this);
        realEndGame();
        //inGame = 0;
        //gameId = -1;
    }

    //game 1 3 4 共用的 去除特定游戏的代码
    function realBeginGame(gId)
    {
        inGame = 1;
        gameId = gId;
        clearMoveState();
        map.mapGridController.clearSolMap(this);
    }
    //游戏结束 需要重新显示没有参与游戏的士兵
    function realEndGame()
    {
        inGame = 0;
        gameId = -1;
        bg.visible(1);
    }
}
