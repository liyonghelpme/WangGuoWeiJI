class CastleScene extends MyNode
{
    var hideTime = 0;
    var inHide = 0;
    var mc = null;
    var ml = null;
    var Planing = 0;
    var keepMenuLayer;
    /*
    把经营页面 和 菜单在 场景构造的时候 初始化
    如果 将菜单页面作为一个可以弹出 和 压入的 view来处理  

    使用keepMenuLayer 来保持 menuLayer的层次关系
    因为其它对话框很难加入 zord参数 来控制层次 暂时使用这种空白的层来
    */

    var mapDict;
    function CastleScene(showLoading)
    {
        bg = node();
        init();
        mapDict = dict();

        mc = new CastlePage(this, showLoading);
        ml = new MenuLayer(this);
        
        keepMenuLayer = new MyNode();
        keepMenuLayer.bg = node();
        keepMenuLayer.init();


        addChild(mc);
        addChild(keepMenuLayer);
        keepMenuLayer.addChild(ml);

        //addChild(ml);

    }
    function quitGame(n, e, p, kc)
    {
        //global.director.popScene();//退出场景 保存数据
        global.director.quitGame(n, e, p, kc);
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
        //global.staticScene = this;
        bg.setevent(EVENT_KEYDOWN, quitGame);
        bg.focus(1);
        //c_sensor(SENSOR_ACCELEROMETER, menuDisappear);
        global.sensorController.addCallback(this);
        global.msgCenter.registerCallback(SHOW_DIALOG, this);
        global.msgCenter.registerCallback(INITDATA_OVER, this);
        global.msgCenter.registerCallback(NEW_USER, this);
        global.msgCenter.registerCallback(BEGIN_BUILD, this);
        global.msgCenter.registerCallback(FINISH_STORY, this);
    }
    var realDisappear = 0;
    var inSen = 0;
    function senBegan(acc)
    {
    }
    function isBuildOrPlan()
    {
        return (curBuild != null) || (Planing == 1);
    }
    function senDone(acc)
    {
        /*
        if(inSen == 0 && !isBuildOrPlan())
        {
            if(acc > 20000)
            {
                if(realDisappear == 0 && inHide == 0)
                {
                    realDisappear = 1;
                    ml.hideMenu(0);
                }
                else if(realDisappear == 1 && curBuild == null)
                {
                    realDisappear = 0;
                    ml.showMenu(0);
                }
                inSen = 1;
            }
        }
        */
    }
    function senEnded(acc)
    {
        inSen = 0;
    }

    function receiveMsg(param)
    {
//        trace("receiveMsg", param);
        var msid = param[0];
        if(msid == SHOW_DIALOG && !isBuildOrPlan())
        {
            var p = param[1];
            if(p == 0)//显示对话框
                disableMenu();
            else if(p == 1)//关闭对话框
                enableMenu();
        }
        else if(msid == INITDATA_OVER)
        {
            global.msgCenter.sendMsg(LOAD_PROCESS, 70);
            mc.initDataOver();
            global.msgCenter.sendMsg(LOAD_PROCESS, 85);
            ml.initDataOver();
            global.msgCenter.sendMsg(LOAD_PROCESS, 100);
        }
        //加载新手 页面
        //这里的 不能 100 Loading 页面自删除存在bug
        else if(msid == NEW_USER)
        {
            //global.msgCenter.sendMsg(LOAD_PROCESS, 99);
            //删除loading页面
            trace("newUser CastleScene 本身替换了默认场景 导致底部为空 最好采用pushScene方式 来避免");
            //global.director.popView();
            global.director.replaceScene(new WelcomeDialog());
        }
        else if(msid == BEGIN_BUILD)
        {
            beginBuild(param[1]);
        }
        
    }
    override function exitScene()
    {
        global.sensorController.removeCallback(this);
        //c_sensor(SENSOR_ACCELEROMETER);
        bg.setevent(EVENT_KEYDOWN, null);
        //global.staticScene = null;
        global.timer.removeTimer(this);

        global.msgCenter.removeCallback(FINISH_STORY, this);
        global.msgCenter.removeCallback(BEGIN_BUILD, this);
        global.msgCenter.removeCallback(SHOW_DIALOG, this);
        global.msgCenter.removeCallback(INITDATA_OVER, this);
        global.msgCenter.removeCallback(NEW_USER, this);
        super.exitScene();
    }

    var planView = null;
    function doPlan()
    {
        ml.beginBuild();
        Planing = 1;
        mc.buildLayer.keepPos();

        //mc.buildLayer.buildKeepPos();
        //mc.buildLayer.soldierKeepPos();

        planView = new BuildMenu(this, null);
        global.director.pushView(planView, 0, 0);
    }
    function finishPlan()
    {
        if(curBuild != null && curBuild.colNow == 1)
        {
            trace("collision now", curBuild.colNow);
            return;
        }

        mc.buildLayer.finishPlan();
        closePlan();
    }
    function disableMenu()
    {
        if(realDisappear == 0)
            ml.beginBuild();
    }
    function enableMenu()
    {
        if(realDisappear == 0)
            ml.finishBuild();
    }
    function onSell()
    {
        curBuild.doSell();
        //global.director.popView();
        if(curBuild.selled == 0)//当前农田已经卖出了 需要设置当前建筑为空
            curBuild = null;
    }
    function cancelPlan()
    {
        //mc.buildLayer.restoreBuildPos();
        //mc.buildLayer.restoreSoldierPos();
        mc.buildLayer.restorePos();
        closePlan();
    }
    function closePlan()
    {
        Planing = 0;
        ml.finishBuild();
        global.director.popView();
        planView = null;
        curBuild = null;
    }
    /*
    当前选择的建筑物， 
    规划状态下的建筑物
    建造状态下的建筑物

    结束建造和结束规划需要清理
    */
    var curBuild = null;
    function getCurSelBuild()
    {
        return curBuild;
    }
    /*
    设置选择的建筑物全局菜单
    设置Plan当前移动 移动的建筑物
    */
    function setBuilding(p)
    {
        var build = p[1];
        if(curBuild != null && curBuild.colNow == 1)
            return 0;
        if(curBuild != null)
            curBuild.finishBottom();
        curBuild = build;
        planView.setBuilding(p);
        return 1;
    }

    /*
    与beginBuild 是相对的函数
    移动需要将建筑物置于最高层
    重新调整建筑物的zOrd 用于显示

    建造时： castleScene CastlePage 都有curBuild 用于防止其它操作发生
    */
    function finishBuild()
    {
        var other = mc.buildLayer.checkCollision(curBuild);
        if(other != null)
            return;

        var p = curBuild.getPos();
        global.httpController.addRequest("buildingC/finishBuild", dict([["uid", global.user.uid], ["bid", curBuild.bid], ["kind", curBuild.id], ["px", p[0]], ["py", p[1]], ["dir", curBuild.dir], ["color", curBuild.buildColor]]), null, null);

        var id = curBuild.id; //building.get("id");

        var cost = getCost(BUILD, id);
        var gain = getGain(BUILD, id);
        var showData = cost2Minus(cost);

        showData.update(gain);
        global.director.curScene.addChild(new PopBanner(showData));//自己控制

        var buildId = curBuild.id;
        trace("curBuild", buildId);
        mc.finishBuild();

        global.user.buyBuilding(curBuild);
        trace("finishBuild");
        global.taskModel.finishBuildTask(curBuild.id, 1);
        closeBuild();

        //在关闭 选择菜单之后再显示任务奖励菜单
    }

    function cancelBuild()
    {
        mc.cancelBuild();
        closeBuild();
    }
    /*
    结束建造的时候， 恢复菜单
    */
    function closeBuild()
    {
        trace("closeBuild");
        curBuild = null;
        ml.finishBuild();
        global.director.popView();
    }
    function onSwitch()
    {
        curBuild.onSwitch();
    }
    /*
    计时隐藏： 当前没有显示 震动显示 或者 关闭菜单显示
    clearHideTime 或者震动
    优先级： 建造规划 > 震动 > 对话框 > 时间
    当前建造 规划 状态 则也不显示 
    realDisappear == 0  对话框操作 
    realDisappear == 0  时间作用 
    怎么知道当前正在 建造所以不显示菜单
    */
    function clearHideTime()
    {
        hideTime = 0;
        /*
        if(realDisappear == 0 && !isBuildOrPlan())//not disappear
        {
            ml.showMenu(1000);
        }
        */
        if(!isBuildOrPlan())
            ml.showMenu(1000);
    }
    function update(diff)
    {
        hideTime += diff;
        if(hideTime >= 10000)
        {
            hideTime = 0;
            if(!isBuildOrPlan())
                ml.hideMenu(1000);
            /*
            if(realDisappear == 0 && !isBuildOrPlan())//not disappear
            {
                ml.hideMenu(1000);
            }
            */
        }
    }
    //var building = null;
    /*
    开始建造的时候 将菜单释放
    */
    function beginBuild(id)
    {
        var building = getData(BUILD, id);

        ml.beginBuild();   
        curBuild = mc.beginBuild(building);
        global.director.pushView(new BuildMenu(this, [PLAN_BUILDING, curBuild]), 0, 0);
    }
    var inGame = 0;
    var gameId = -1;
    function showGame(sol, gid)
    {
        inGame = 1;
        gameId = gid;
        curBuild = sol;
        ml.beginBuild();//隐藏菜单
        mc.moveToBuild(curBuild);//移动屏幕中心到游戏士兵位置
    }
    function finishGame()
    {
        inGame = 0;
        gameId = -1;
        curBuild = null;
        ml.finishBuild();
        mc.closeGlobalMenu();//还原场景状态
    }
    /*
    关闭全局菜单的时候 可以删除
    全局菜单 可能是 建筑物的 也可以是 士兵的

    没有打开全局菜单 也没有进行建造或者规划
    */
    function showGlobalMenu(build, callback)
    {
        if(curMenuBuild == null && curBuild == null)
        {
            curMenuBuild = build;
            ml.beginBuild();
            //ml.removeSelf();
            //ml = null;
            mc.moveToBuild(build);
            callback();
        }
    }
    /*
    两种方式 关闭全局菜单 来自于 建筑物自己 来自于 经营页面其它元素
    第一个参数表示来源
    finishBuild行为
    */
    var curMenuBuild = null;
    function closeGlobalMenu(build)
    {
        if(curMenuBuild != null)
        {
            if(build == curMenuBuild)//自己关闭
            {
            }
            else//其它人关闭
            {
            }
            curMenuBuild.closeGlobalMenu();
            global.director.popView();
            curMenuBuild = null;
            ml.finishBuild();
            mc.closeGlobalMenu();
        }
        //关闭菜单栏子菜单
        ml.cancelAllMenu();
    }

    function onMap()
    {
        global.director.pushScene(new MapScene());
    }
    function onStore()
    {
        global.director.pushView(new Store(this), 1, 0);
    }
}
