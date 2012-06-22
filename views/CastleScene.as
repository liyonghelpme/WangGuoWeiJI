class CastleScene extends MyNode
{
    var hideTime = 0;
    var inHide = 0;
    var mc = null;
    var ml = null;
    var Planing = 0;
    /*
    把经营页面 和 菜单在 场景构造的时候 初始化
    如果 将菜单页面作为一个可以弹出 和 压入的 view来处理  
    */
    function CastleScene()
    {
        bg = node();
        init();

        mc = new CastlePage(this);
        ml = new MenuLayer(this);
        addChild(mc);
        addChild(ml);
    }
    function quitGame(n, e, p, kc)
    {
        global.director.quitGame(n, e, p, kc);
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
        global.staticScene = this;
        bg.setevent(EVENT_KEYDOWN, quitGame);
        bg.focus(1);
    }
    override function exitScene()
    {
        bg.setevent(EVENT_KEYDOWN, null);
        global.staticScene = null;
        global.timer.removeTimer(this);
        super.exitScene();
    }
    var planView = null;
    function doPlan()
    {
        ml.beginBuild();
        Planing = 1;
        global.user.buildKeepPos();
        planView = new BuildMenu(this, null);
        global.director.pushView(planView);
    }
    function finishPlan()
    {
        var ret = global.user.checkBuildCol();
        trace("buildCollision", ret);
        if(ret == 1)
            return;
        global.user.finishPlan();
        closePlan();
    }
    function onSell()
    {
        curBuild.doSell();
        //global.director.popView();
        curBuild = null;
    }
    function cancelPlan()
    {
        global.user.restoreBuildPos();
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
    */
    function setBuilding(build)
    {
        if(curBuild != null && curBuild.colNow == 1)
            return 0;
        if(curBuild != null)
            curBuild.finishBottom();
        curBuild = build;
        planView.setBuilding(build.data);
        return 1;
    }
    /*
    与beginBuild 是相对的函数
    移动需要将建筑物置于最高层
    重新调整建筑物的zOrd 用于显示
    */
    function finishBuild()
    {
        //var other = checkCollision(mc.curBuild, global.user.allBuildings);
        var other = global.user.checkCollision(curBuild);
        if(other != null)
            return;
        var id = building.get("id");

        var cost = getCost(BUILD, id);
        global.user.doCost(cost);
        //var gain = getBuildGain(id);
        var gain = getGain(BUILD, id);
        global.user.doAdd(gain);
        trace("finish Build", cost, gain);
        mc.finishBuild();
        //curBuild.setPos(curBuild.getPos());
        closeBuild();
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
        ml.finishBuild();
        //ml = new MenuLayer(this);
        //addChild(ml);
        global.director.popView();
        building = null;
        curBuild = null;
    }
    function onSwitch()
    {
        trace("switch");
        curBuild.onSwitch();
        //mc.onSwitch(); 
    }
    function clearHideTime()
    {
        hideTime = 0;
        if(inHide == 1)
        {
            inHide = 0;
            ml.showMenu();
        }
    }
    function update(diff)
    {
        hideTime += diff;
        if(hideTime >= 10000)
        {
            hideTime = 0;
            if(inHide == 0)
            {
                inHide = 1;
                ml.hideMenu();
            }
        }
    }
    var building = null;
    /*
    开始建造的时候 将菜单释放
    */
    function build(id)
    {
        building = getData(BUILD, id);
        //building.update("state", 0);
        //ml.removeSelf();
        //ml = null;
        ml.beginBuild();   
        curBuild = mc.beginBuild(building);
        global.director.pushView(new BuildMenu(this, building));
    }
    function buySoldier(id)
    {

        var cost = getCost(SOLDIER, id);
        global.user.doCost(cost);
        var sol = mc.buySoldier(id);
        global.director.pushView(new RoleName(this, sol));
    }
    function nameSoldier(sol, name)
    {
        sol.setName(name);
    }
    /*
    关闭全局菜单的时候 可以删除
    全局菜单 可能是 建筑物的 也可以是 士兵的
    */
    function showGlobalMenu(build, callback)
    {
        if(curMenuBuild == null)
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
            //ml = new MenuLayer(this);
            //addChild(ml);
        }
    }

    function onMap()
    {
        global.director.pushScene(new MapScene());
    }
    function onStore()
    {
        global.director.pushView(new Store(this), 1, 0);
    }
    function onRole()
    {
        global.director.pushView(new SoldierStore(this), 1, 0);
    }
}
