class MinePlant extends MyNode
{
    var building;
    var curState;
    var passTime;
    var objectTime;
    function MinePlant(b, d)
    {
        building = b;
        objectTime = d.get("objectTime");
        bg = node();
        init();
        curState = 0;
    }
    function getLeftTime()
    {
        var mineData = getData(MINE_PRODUCTION, building.buildLevel);
        var needTime = mineData.get("time")*1000;
        var leftTime = (needTime-passTime)/1000;
        //trace("LeftTime", needTime, passTime);
        return leftTime;
    }
    /*
    0x3fffffff ms ---》 298天后数据溢出
    所以这里初始化passTime 
    */
    override function enterScene()
    {
        super.enterScene();
        var now = time()/1000;
        var mineData = getData(MINE_PRODUCTION, building.buildLevel);
        var needTime = mineData.get("time");

        if((now-objectTime) > needTime)//矿不考虑 腐败问题
            passTime = needTime*1000;
        else
            passTime = (now-objectTime)*1000;
        trace("now", now, objectTime, passTime);
        global.timer.addTimer(this);
    }
    function update(diff)
    {
        passTime += diff;
        var mineData = getData(MINE_PRODUCTION, building.buildLevel);
        var needTime = mineData.get("time")*1000;
        if(passTime >= needTime && curState == 0)//成熟但是状态没有更新 设置浮动的图标
        {
            curState = 1;
            building.funcBuild.setFlowBanner();
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    function getAccCost()
    {
        var leftTime = getLeftTime();
        return calAccCost(leftTime);
    }
    function finish()
    {
        var leftTime = getLeftTime();
        objectTime -= leftTime;
        passTime += leftTime*1000;
    }
}

class Mine extends FuncBuild
{
    var planting;

    function Mine(b)
    {
        baseBuild = b;
        planting = null;
    }
    override function getLeftTime()
    {
        if(planting != null)
            return planting.getLeftTime();
        return 0;
    }

    var flowBanner = null;
    function setFlowBanner()
    {
        if(flowBanner == null)
        {
            var bSize = baseBuild.bg.size();
            flowBanner = baseBuild.bg.addsprite("flowBanner.png").pos(bSize[0]/2, -11).anchor(50, 100).setevent(EVENT_TOUCH, whenBusy);
            var fSize = flowBanner.prepare().size();
            var pl = flowBanner.addsprite("crystalBig.png").anchor(50, 50).pos(fSize[0]/2, 20);
            var sca = getSca(pl, [63, 42]);
            pl.scale(sca);
            flowBanner.addaction(sequence(delaytime(rand(2000)), repeat(moveby(500, 0, -20), delaytime(300), moveby(500, 0, 20))));
        }
    }

    //空闲状态 水晶矿没有开启
    //水晶框没有空闲状态 只有工作状态
    override function whenFree()
    {
        global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("notOpenMine", ["[LEV]", str(PARAMS["MineMinLevel"])]), [100, 100, 100], null));
        return 1;
    }
    /*
    收获之后水晶矿的状态不变 Working
    重新初始化新的plant

    收获结束
    */

    override function whenBusy()
    {
        if(planting.curState == 1)//成熟则收获
        {
            var gain = getProduction(baseBuild.buildLevel);
            global.httpController.addRequest("mineC/harvest", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["gain", json_dumps(gain)]]), null, null);
            flowBanner.removefromparent();
            flowBanner = null;
            planting.removeSelf();
            planting = null;
            
            global.director.curScene.addChild(new FlyObject(baseBuild.bg, gain, null));

            planting = new MinePlant(baseBuild, dict([["objectTime", time()/1000]]));
            baseBuild.addChild(planting);

            //global.user.updateMine(baseBuild);
            global.user.updateBuilding(baseBuild);

            global.taskModel.doAllTaskByKey("harvestCrystalMine", gain["crystal"]);

            return 1;
        }
        return 0;
    }

    function doUpgrade()
    {
        var cost = getLevelUpCost();
        global.httpController.addRequest("mineC/upgradeMine", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["cost", json_dumps(cost)]]), null, null); 
        global.user.doCost(cost);
        baseBuild.buildLevel += 1;
        var mineData = getData(MINE_PRODUCTION, baseBuild.buildLevel);
        baseBuild.changeDirNode.texture("build"+str(baseBuild.id)+".png", getHue(mineData["color"]));

        global.user.updateBuilding(baseBuild);
        var it = cost.items();
        var temp = baseBuild.bg.addnode();
        var bSize = baseBuild.bg.size();

        var pic = temp.addsprite(it[0][0]+".png").anchor(0, 50).pos(0, -30).size(30, 30);
var word = temp.addlabel("-" + str(it[0][1]), getFont(), 25).anchor(0, 50).pos(35, -30).color(0, 0, 0);
        var wSize = word.prepare().size();

        var offX = bSize[0]/2-(35+wSize[0])/2;
        pic.pos(offX, -30);
        word.pos(offX+35, -30);

        temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
    }
    function sureToUpgrade()
    {
        global.director.pushView(new UpgradeMine(baseBuild), 1, 0);
    }
    //工作时间长度
    //
    override function initWorking(data)
    {
        //var userLevel = global.user.getValue("level");
        //等级足够开启建筑物
        //userLevel >= PARAMS["MineMinLevel"] && 
        //if(baseBuild.state != PARAMS["buildMove"])//非移动状态
        if(baseBuild.state == PARAMS["buildWork"])
        {
            //baseBuild.setState(PARAMS["buildWork"]);
            var startTime = data.get("objectTime");//serverTime 秒为单位
            startTime = server2Client(startTime); 
            //trace("startTime", data.get("objectTime"), startTime);//objectTime 

            var privateData = dict([["objectTime", startTime]]);//客户端时间 
            planting = new MinePlant(baseBuild, privateData);
            baseBuild.addChild(planting);
        }
    }
    function getLevelUpCost()
    {
        if(baseBuild.buildLevel < (len(mineProductionData)-1))   
        {
            var mCost = getLevelCost(BUILD, baseBuild.id, baseBuild.buildLevel+1);//当前等级的 下一个等级需要的花销
            return mCost;
        }
        return dict();
    }
    override function getStartTime()
    {
        if(planting != null)
            return client2Server(planting.objectTime);
        return 0;
    }
    override function finishBuild()
    {
        //等级足够开启建筑物
        //userLevel >= PARAMS["MineMinLevel"] && 
        //if(baseBuild.state != PARAMS["buildMove"])//非移动状态
        //建造结束 水晶框状态进入 工作状态
        baseBuild.setState(PARAMS["buildWork"]);
        if(baseBuild.state == PARAMS["buildWork"])
        {
            //baseBuild.setState(PARAMS["buildWork"]);
            var startTime = time()/1000; 
            var privateData = dict([["objectTime", startTime]]);//客户端时间 
            planting = new MinePlant(baseBuild, privateData);
            baseBuild.addChild(planting);
        }
    }
    override function getAccCost()
    {
        return planting.getAccCost();
    }

    override function doAcc()
    {
        var leftTime = planting.getLeftTime();
        var cost = dict([["gold", planting.getAccCost()]]);
        global.user.doCost(cost);
        global.httpController.addRequest("buildingC/accWork", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["gold", planting.getAccCost()], ["leftTime", leftTime]]), null, null);
        planting.finish();
        global.user.updateBuilding(baseBuild);

        var showData = cost; 
        showMultiPopBanner(cost2Minus(showData));
    }
}
