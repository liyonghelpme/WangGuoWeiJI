

class Building extends MyNode
{
    var isBuilding = 1;
    //move rotate 
    var map;
    var data;
    var bid;

    var state;
    var lastPoints;

    var id;
    var sx;
    var sy;
    //建造初始化位置
    var kind;
    //建筑物功能
    var funcs;
    var dir;
    //缓存冲突标记
    var oldPos;
    //first check in full

    //提供建筑类型相关特殊功能的代理 Farm House
    var funcBuild = null;
    

    var bottom = null;
    var objectList;

    /*
    在设置完特殊建筑之后设置相应的建筑的
    锚点 50 100
    左上角坐标  (sx+sy)/2*SIZEX  (sx+sy)*SIZEY
    要保证左上角和SIZEX SIZEY 网格
    所有建筑都有方向属性， 只是农田不能改变方向而已
    */
    var aniNode = null;

    var changeDirNode;
    //水晶矿需要等级信息 民居也需要等级信息
    var buildLevel = 0;
    var buildColor = 0;

    var featureColor = null;
    var shadow = null;
    function Building(m, d, privateData)
    {
        bid = -1;
        map = m;
        data = d;
        id = data.get("id");
        sy = data.get("sy");
        sx = data.get("sx");
        kind = data.get("kind");
        funcs = data.get("funcs");
        bg = node();
        init();//尽早初始化 node

        //购买建筑 随机颜色
        if(privateData == null)
        {
            privateData = dict();
            buildColor = global.user.getLastColor();
        }
        else
            buildColor = privateData.get("color", 0);

        objectList = privateData.get("objectList", []);
        buildLevel = privateData.get("level", 0);

        if(funcs == FARM_BUILD)
            funcBuild = new Farm(this);
        else if(funcs == HOUSE_BUILD)
            funcBuild = new House(this);
        else if(funcs == DECOR_BUILD)
            funcBuild = new Decor(this);
        //取消static 木板建筑
        //else if(funcs == STATIC_BOARD)
        //    funcBuild = new StaticBuild(this); 
        //是否进入工作状态由用户等级决定----> Free 状态/工作状态 ----->
        //initWorking ---> level> and Not MoveState
        else if(funcs == MINE_KIND)
        {
            funcBuild = new Mine(this);
        }
        else if(funcs == RING_FIGHTING)
        {
            funcBuild = new RingFighting(this); 
        }
        else if(funcs == LOVE_TREE)//没有卖出 有升级
        {
            funcBuild = new LoveTree(this);
        }
        else if(funcs == CAMP)//类似于 Farm 招募 加速招募 卖出 招募士兵的类型ID
        {
            funcBuild = new Camp(this);
        }
        else 
            funcBuild = new Castle(this);


        if(funcs != LOVE_TREE)
            changeDirNode = bg.addsprite("build"+str(id)+".png", ARGB_8888, ALPHA_TOUCH).anchor(50, 100);
        else//爱心树图片和等级相关
            changeDirNode = bg.addsprite("build"+str(id+buildLevel)+".png", ARGB_8888, ALPHA_TOUCH).anchor(50, 100);
        
        //非本身颜色的建筑物颜色 根据编号设定颜色
        //1 采用标准特征色
        //2 采用其他特征色
        if(data["hasFeature"] && buildColor != 0)
        {
            var fc = COLOR_INDEX[buildColor];
            fc = getHue(fc);
            featureColor = changeDirNode.addsprite("build"+str(id)+"_f.png", fc);
        }
        var offY = 0;
        if(data.get("isoView") == 1)
        {
            offY = (sy+sx)*SIZEY/2;
        }

        var bSize = changeDirNode.prepare().size();

        //新建筑需要确定初始化位置 
        //如果建筑物是平底的 则 高度需要补偿 否则高度正常
        bg.size(bSize[0], bSize[1]+offY).anchor(50, 100).pos(ZoneCenter[kind][0], ZoneCenter[kind][1]);

        changeDirNode.pos(bSize[0]/2, bSize[1]);

        //.pos(ZoneCenter[kind][0], ZoneCenter[kind][1]).anchor(50, 100);
        


        dir = privateData.get("dir", 0);
        setState(privateData.get("state", PARAMS["buildMove"]));
        setDir(dir);

        var npos = normalizePos(bg.pos(), sx, sy);
        setPos(npos);
        setColPos();


        /*
        初始化农作物 工作状态
        */
        funcBuild.initWorking(privateData);

        /*
        初始化动画
        动画加在 bg 上， 则 旋转时不能准确控制方向
        动画加在changeDirNode 上 需要 在enterScene 和 exitScene 是调用动画node函数
        */
        if(data.get("hasAni") == 1 )
        {
            aniNode = new BuildAnimate(this);
            changeDirNode.add(aniNode.bg);
        }


        //alphatouch 变向node
        changeDirNode.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        changeDirNode.setevent(EVENT_MOVE, touchMoved);
        changeDirNode.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function getObjectId()
    {
        return funcBuild.getObjectId();
    }
    function getStartTime()
    {
        return funcBuild.getStartTime();
    }
    function setBid(b)
    {
        bid = b;
    }
    function setMap(m)
    {
        map = m;
    }
    override function enterScene()
    {
        super.enterScene();
        funcBuild.enterScene();
        if(aniNode != null)
            aniNode.enterScene();

        if(funcs == CAMP && state == PARAMS["buildFree"])
        {
            global.msgCenter.removeCallback(CALL_SOL, this);
            global.msgCenter.removeCallback(MOVE_TO_CAMP, this);


            global.msgCenter.registerCallback(CALL_SOL, this);
            global.msgCenter.registerCallback(MOVE_TO_CAMP, this);

        }

        if(funcs == FARM_BUILD && state == PARAMS["buildFree"])
        {
            global.msgCenter.removeCallback(MOVE_TO_FARM, this);
            global.msgCenter.registerCallback(MOVE_TO_FARM, this);
        }
    }
    var inTask = 0;
    //空闲建筑 则 工作
    //重新进入 场景 需要主动 的显示
    //消息激励 来 出现 兵营的 arrow 或者 士兵商店提示
    function receiveMsg(param)
    {
        var msgId = param[0];
        var p = param[1];
        if(msgId == CALL_SOL)
        {
            if(state == PARAMS["buildFree"])
            {
                global.director.pushView(new CallSoldier(this), 1, 0);
            }
        }
        else if(msgId == MOVE_TO_CAMP)
        {
            if(state == PARAMS["buildFree"])
            {
                map.map.moveToBuild(this); 
                global.taskModel.showHintArrow(bg, bg.size(), MOVE_TO_CAMP);
            }
        }
        //多个农田怎么办？ 最后一个肯定会存在
        else if(msgId == MOVE_TO_FARM)
        {
            if(state == PARAMS["buildFree"])
            {
                map.map.moveToBuild(this); 
                global.taskModel.showHintArrow(bg, bg.size(), MOVE_TO_FARM);
            }
        }
    }

    override function exitScene()
    {
        global.msgCenter.removeCallback(MOVE_TO_FARM, this);
        global.msgCenter.removeCallback(CALL_SOL, this);
        global.msgCenter.removeCallback(MOVE_TO_CAMP, this);
        if(aniNode != null)
            aniNode.exitScene();
        funcBuild.exitScene();
        super.exitScene();
    }

    function setDir(d)
    {
        dir = d;
        if(dir == 0)
            changeDirNode.scale(100, 100);
        else 
            changeDirNode.scale(-100, 100);

        var bSize = bg.size();
        var shadowDir = dir;
        if(data["symmetry"])
            shadowDir = 0;
        if(data["hasShadow"])
        {
            if(shadow == null) 
            {
                if(!data["isoView"])
                {
                    shadow = sprite("build"+str(id)+"Shadow"+str(shadowDir)+".png").color(100, 100, 100, 30).anchor(50, 100).pos(bSize[0]/2, bSize[1]);
                }
                else
                {
                    var offY = (sy+sx)*SIZEY/2;
                    shadow = sprite("build"+str(id)+"Shadow"+str(shadowDir)+".png").color(100, 100, 100, 30).anchor(50, 100).pos(bSize[0]/2, bSize[1]-offY);
                }
            }
            else
                shadow.texture("build"+str(id)+"Shadow"+str(shadowDir)+".png");
            if(!data["upShadow"])
                bg.add(shadow, -1);
            else
                bg.add(shadow);//阴影在建筑物上面
        }

    }
    function onSwitch()
    {
        if(data.get("changeDir") == 0)
            return;

        dirty = 1;

        dir = 1-dir;
        if(dir == 0)
            changeDirNode.scale(100, 100);
        else 
            changeDirNode.scale(-100, 100);
        
        global.user.updateBuilding(this);
    }
    //remove OldPosition map 
    //set NewPosition map
    override function setZord(z)
    {
        var zOrd = bg.pos()[1];
        var par = bg.parent();

        if(par != null)
        {
            bg.removefromparent();
            par.add(bg, zOrd);
        }
    }

    /*
    更新建筑物的zOrd 根据当前的y值进行排序
    每次设置新的坐标前 清楚旧的坐标map 构建新的坐标map
    可以在移动开始的时候 清楚坐标映射 PARAMS["buildMove"] 状态 和 Planing 状态
    在放下的时候 重新映射

    
    设置位置 检测冲突 设置zord
    */
    override function setPos(p)
    {
//        trace("setPos", p);
        var curPos = p;
        var zOrd = curPos[1];
        if(state == PARAMS["buildMove"] || (Planing && global.director.curScene.curBuild == this))
            zOrd = MAX_BUILD_ZORD;
//        trace("setZord", zOrd);
        bg.pos(p);
        var par = bg.parent();
        if(par == null)
            return;
        bg.removefromparent();
        //if(funcs == FARM_BUILD && zOrd != MAX_BUILD_ZORD)
        //    zOrd = 0;
        par.add(bg, zOrd);
    }

    /*
    检测所有的建筑的碰撞效率较低， 可以采用hash表的方式
    不在大区域中， 则显示后色底色
    根据建筑当前所在位置的状态设定建筑的颜色


    建筑物范围检测应该是有buildLayer 决定 而不是由自身决定
    不要对包含者 的成员做过多假定
    */
    var colNow = 0;
    function setColPos()
    {
        colNow = 0;
        //var z = buildCheckInZone();
        //var ret = checkInZone(bg.pos());
        /*
        if(ret == 0)
        {
            setColor(NotBigZone);
            colNow = 1;
        }
        */
        //else
        //{
            var other = map.checkCollision(this);
            if(other != null)
            {
                setColor(NotBigZone);
                colNow = 1;
            }
            else
            {
                setColor(InZone);
            }
        //}
    }
    /*
    进入规划模式， 保存旧的坐标 
    检测是否移动
    每个建筑物 每个士兵 需要本地保存状态 知道当前处于Planing 状态或者 buildLayer 存在一个函数用于确定是否Planing
    依赖于上层逻辑保证了唯一性但是不能保证自身的独立性 需要依赖于未知的对象的接口
    所有建筑物对外提供接口：
    keepPos finishPlan
    用于外界控制建筑的规划状态
    依赖于外界确定自己是否是当前规划中建筑
    新建造建筑物 Planing == 1
    */
    var dirty = 0;
    var Planing = 0;
    function keepPos()
    {
        //trace("beginKeepPos");
        oldPos = getPos();
        dirty = 0;
        Planing = 1;
    }
    /*
    取消规划模式
    */
    function restorePos()
    {
        map.mapGridController.clearMap(this);//清理map 之后 再设置map
        setPos(oldPos);
        map.mapGridController.updateMap(this);//重新设定map
        finishPlan();
    }
    /*
    状态可以做成 位与的形式
    经营页面的建筑物
    水晶矿的建筑物 检测当前是否处于Planing状态

    每次进入场景 以及变换状态
    */
    function setState(s)
    {
        state = s;
        if(funcs == CAMP)
        {
            global.msgCenter.removeCallback(CALL_SOL, this);
            if(state == PARAMS["buildFree"])
            {
                global.msgCenter.registerCallback(CALL_SOL, this);
            }
        }
        if((state == PARAMS["buildMove"]) || Planing == 1)
        {
            var bSize = bg.size();
            /*
            如果方块的大小恰好和建筑物的底座一样大小 那么要求建筑物底座必须要一定大小
            +40 +20
            */
            if(bottom == null)
            {
                bottom = sprite().pos(bSize[0]/2, bSize[1]-(sx+sy)/2*SIZEY).anchor(50, 50).size((sx+sy)*SIZEX+20, (sx+sy)*SIZEY+10).color(100, 100, 100, 100);
                bg.add(bottom, -1);
            }
            //half transparent + color
        }

    }

    /*
    建造时，防止重叠， 将建筑物放在最高层，建造结束调整建筑物的位置
    建造完成更新局部数据
    */
    function finishBuild()
    {
        setState(PARAMS["buildFree"]);
        trace("finishBuild", state, Planing);
        finishBottom();
        setZord(null);
        funcBuild.finishBuild();
        global.user.updateBuilding(this);
    }
    /*
    建造结束 或者 规划结束需要清理 底层图标
    */
    function finishBottom()
    {
//        trace("finishBottom", getPos());
        bg.color(100, 100, 100, 100);
        bottom.removefromparent();
        bottom = null;
    }
    /*
    被点击， 且在规划模式，则设置背景
    每次移动的时候都要首先清楚建筑当前的map映射
    放下之后，立即又要生成建筑的新坐标map映射

    每次touchBegan 向 父亲节点传播
    */
    var accMove = 0;
    function touchBegan(n, e, p, x, y, points)
    {
        accMove = 0;
        lastPoints = n.node2world(x, y);         
        
        //如果当前显示了菜单则再次点击是关闭菜单
        if(!showMenuYet)
            map.touchBegan(n, e, p, x, y, points); 


        if(Planing)
        {
            var setSuc = global.director.curScene.setBuilding([PLAN_BUILDING, this]);
            if(setSuc)
            {
                if(bottom == null)
                {
                    setState(state);
                }
            }
        }

        /*
        规划状态 如果点击 则需要更新
        */
        if(state == PARAMS["buildMove"] || Planing)
        {
            dirty = 1;
            map.mapGridController.clearMap(this);
        }

    }
    function finishPlan()
    {
        dirty = 0;
        Planing = 0;
        if(bottom != null)
        {
            finishBottom();
            setZord(null);
            //bottom.removefromparent();
            //bottom = null;
        }
    }
    function setColor(inZ)
    {
        if(bottom == null)
            return;
        if(inZ != InZone)
        {
            //bg.color(93, 4, 1, 30);//red
            bottom.texture("red2.png");
        }
        else
        {
            //bg.color(3, 93, 81, 30);//green
            bottom.texture("green2.png");
        }
    }
    /*
    移动量积累到一定程度才移动建筑物
    生成新的网格位置
    判断新位置是否越界 如果是 则回复旧位置
    手指位置最近的有效位置 

    A B 对象之间存在冲突， 应该存在一个冲突对象列表
    构成冲突关系
    */
    //var accDifX = 0;
    //var accDifY = 0;
    function moveBack(newPos)
    {
        //accDifX += difx;
        //accDifY += dify;

        //var curPos = bg.pos();
        setPos(newPos);
    }
    /*
    规范化当前的手指位置， 测试位置是否合法

    如果建筑物自身不在移动状态则将touch 事件 向父亲传播
    多点触摸的话也要传递给父亲
    */
    function touchMoved(n, e, p, x, y, points)
    {

        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0] - oldPos[0];
        var dify = lastPoints[1] - oldPos[1];
        if(state == PARAMS["buildMove"] || Planing)
        {
            if(global.director.curScene.curBuild != this)
                return;
            var parPos = bg.parent().world2node(lastPoints[0], lastPoints[1]);
            var newPos = normalizePos(parPos, sx, sy)
            setPos(newPos);
            setColPos();
            if(len(points) >= 3)//-1 0 1
            {
                map.touchMoved(n, e, p, x, y, points);
            }
        }
        else
        {
            accMove += abs(difx) + abs(dify);
            if(!showMenuYet)
                map.touchMoved(n, e, p, x, y, points);
        }
    }

    function showGlobalMenu()
    {
        acced = 0;
        selled = 0;
        showMenuYet = 1;
        var func = getBuildFunc(funcs);
        var temp = [0, 0];
        temp[0] = copy(func[0]);
        temp[1] = copy(func[1]);

        func = temp;
        
        if(funcs == CAMP)
        {
            if(state == PARAMS["buildWork"])
            {
                func[1].append("acc");
            }
        }
        global.director.pushView(new BuildWorkMenu(this, func[0], func[1]), 0, 0);
    }
    var showMenuYet = 0;
    /*
    如果用户手指移动 一定的范围 表示没有意图打开建筑物对话框
    当前移动建筑不是 自身不能处理
    */
    function doFree()
    {
        var ret = funcBuild.whenFree();
        if(ret == 0)
        {
            if(showMenuYet == 0)
            {
                global.director.curScene.showGlobalMenu(this, showGlobalMenu);
            }
        }
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var oldShowMenuYet = showMenuYet;
        var ret;
        if((state == PARAMS["buildMove"]) || Planing)
        {
            if(global.director.curScene.curBuild != this)
                return;
            if(colNow == 0 && state != PARAMS["buildMove"])//无冲突规划状态 清除zord 和 底座
            {
                setZord(null);
                //finishBottom();
            }
                
            map.mapGridController.updateMap(this);
        }
        /*
        如果移动过多则不打开建筑物菜单
        建筑物私有对象如果没有处理改功能， 那就采用统一的弹出功能菜单的方案
        例如 城堡 民居 装饰物
        */
        else if(state == PARAMS["buildFree"] && accMove < 20)
        {
            doFree();

        }
        /*
        工作中的农田显示
        */
        else if(state == PARAMS["buildWork"])
        {
            if(showMenuYet == 0)
            {
                ret = funcBuild.whenBusy();
                if(ret == 0)
                {
                    global.director.curScene.showGlobalMenu(this, showGlobalMenu);
                }
            }
        }
        //doFree 有可能改变当前的菜单状态
        if(!oldShowMenuYet)
            map.touchEnded(n, e, p, x, y, points);
        else
            map.map.scene.closeGlobalMenu(this);//关闭全局菜单
    }
    /*
    来自上层的点击信息，关闭打开的全局菜单
    应该由场景的 来关闭view
    */
    function closeGlobalMenu()
    {
        showMenuYet = 0;
        //global.director.popView();
    }

    function getName()
    {
        //if(funcs != MINE_KIND)
        return data.get("name");
        //return getStr("buildLevel", ["[NAME]", data.get("name"), "[LEV]", str(buildLevel)]);
    }

    /*
    返回当前工作状态的剩余时间 和建筑物类型相关
    */
    function getLeftTime()
    {
        return funcBuild.getLeftTime();
    }
    //view Value
    /*
    建筑物加速
    只提供功能 但是不会操作 view
    */
    var acced = 0;
    function doAcc()
    {
        var gold = funcBuild.getAccCost();
        var cost = dict([["gold", gold]]);
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            global.director.curScene.addChild(new UpgradeBanner(getStr("resLack", ["[NAME]", getStr("gold", null), "[NUM]", str(gold)]) , [100, 100, 100], null));
            return;            
        }

        if(state == PARAMS["buildWork"])
        {
            if(acced == 0)
            {
                acced += 1;
                global.director.curScene.addChild(new UpgradeBanner(getStr("sureToGenAcc", ["[NUM]", str(gold)]) , [100, 100, 100], null));
            }
            else
            {
                acced = 0;
                global.director.curScene.closeGlobalMenu(this);
                funcBuild.doAcc();

            }
        }
    }
    /*
    当buildLayer 加入 和清楚建筑物的时候， 相应的处理建筑物的状态
    通过 点击子菜单的 sell按钮来卖出 子菜单 直接 调用 建筑物的卖出函数 子菜单 再关闭自己
    通过 点击规划菜单的按钮来卖出

    建筑的函数 只提供功能， 但是 不会 去操作view

    卖出增加 银币
    卖出减少 人口 城堡防御力
    */
    var selled = 0;
    function doSell()
    {
        var cost = getCost(BUILD, id);
        trace("buildCost", cost);
        cost = changeToSilver(cost);
        trace("buildCost", cost);
        if(funcs == DECOR_BUILD && data.get("exp") > 0)
        {
            cost.update("silver", 0);
        }
        trace("buildCost", cost);


        if(selled == 0)
        {
            selled = 1;
            global.director.curScene.addChild(new UpgradeBanner(getStr("sureToSell", ["[NUM]", str(cost.get("silver", 0))]) , [100, 100, 100], null));
        }
        else
        {
            selled = 0; 
            global.director.curScene.closeGlobalMenu(this);
            
            global.httpController.addRequest("buildingC/sellBuilding", dict([["uid", global.user.uid], ["bid", bid], ["silver", cost.get("silver", 0)]]), null, null);

            //不使用飞行银币增加 使用黑色框 减去 人口 城堡防御力 增加银币
            //global.director.curScene.addChild(new FlyObject(bg, cost, sellOver));


            //逐渐调整 跳出 多个条目
            var showData = dict([["silver", cost.get("silver")], ["people", -data.get("people")], ["cityDefense", -data.get("cityDefense") ]]);
            global.user.doAdd(showData);
            //global.user.changeValue("people", -data.get("people"));//减去人口
            //global.user.changeValue("cityDefense", -data.get("cityDefense"));//减去防御力

            global.director.curScene.addChild(new PopBanner(showData));//自己控制
             
            //map.sellBuild(this);//没有清除建筑物的底座
            map.removeBuilding(this);
            global.user.sellBuild(this);
        }
    }

    function sellOver()
    {
//        trace("sellOver");
    }
    function doPhoto()
    {
        global.director.getPid(); 
    }
    var oldState = PARAMS["buildFree"];
    var lockAni = null;
    function waitLock(tar)
    {
        oldState = state;
        state = PARAMS["buildWait"];
        var bSize = bg.size();
        lockAni = bg.addnode();
        var HEI = -20;
        lockAni.addsprite().size(30, 30).pos(29, HEI).anchor(50, 100).addaction(
            repeat(
                animate(1000, "feed0.png", "feed1.png", "feed2.png", "feed3.png", "feed4.png", "feed5.png", "feed7.png" )
            )); 
        if(tar == "feeding")
            lockAni.addsprite("feeding.png").pos(48, HEI).anchor(0, 100);
        else if(tar == "harvesting")
            lockAni.addsprite("harvesting.png").pos(48, HEI).anchor(0, 100);
    }
    function removeLock()
    {
        state = oldState;
        if(lockAni != null)
        {
            lockAni.removefromparent();
            lockAni = null;
        }
    }

    function beginPlant(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            var cost = param[0];
            var id = param[1];

            global.user.doCost(cost);
            trace("removeLock");
            removeLock();
            funcBuild.beginPlant(id); 

            global.taskModel.finishTask(ONCE_TASK, "buy", 0, [PLANT, id]);
            global.taskModel.doCycleTaskByKey("plant", 1);
            global.taskModel.doDayTaskByKey("plant", 1);
        }
        else
        {
            removeLock();
        }
    }   
}
