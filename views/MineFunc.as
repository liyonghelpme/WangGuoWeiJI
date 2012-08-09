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
        var needTime = mineProduction.get("time")*1000;
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
        var needTime = mineProduction.get("time");

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
        var needTime = mineProduction.get("time")*1000;
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
            flowBanner = baseBuild.bg.addsprite("flowBanner.png").pos(bSize[0]/2, -11).anchor(50, 100);
            var pl = flowBanner.addsprite("crystalBig.png").anchor(50, 50).pos(43, 30);
            var sca = getSca(pl, [63, 42]);
            pl.scale(sca);
            flowBanner.addaction(sequence(delaytime(rand(2000)), repeat(moveby(500, 0, -20), delaytime(300), moveby(500, 0, 20))));
        }
    }

    //空闲状态 水晶矿没有开启
    override function whenFree()
    {
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
            var level = baseBuild.buildLevel;
            var crystal = mineProduction.get("crystal")+mineProduction.get("levelCoff")*level;

            global.httpController.addRequest("mineC/harvest", dict([["uid", global.user.uid], ["crystal", crystal]]), null, null);
            flowBanner.removefromparent();
            flowBanner = null;
            planting.removeSelf();
            planting = null;
            
            var gain = dict([["crystal", crystal]]);
            global.director.curScene.addChild(new FlyObject(baseBuild.bg, gain, null));

            planting = new MinePlant(baseBuild, dict([["objectTime", time()/1000]]));
            baseBuild.addChild(planting);

            global.user.updateMine(baseBuild);

            return 1;
        }
        return 0;
    }

    function doUpgrade(cost)
    {
        global.httpController.addRequest("mineC/upgradeMine", dict([["uid", global.user.uid]]), null, null); 
        global.user.doCost(cost);
        baseBuild.buildLevel += 1;
        global.user.updateMine(baseBuild);
    }
    function sureToUpgrade()
    {
        var cost = dict([["colorCrystal", mineProduction.get("colorCrystal")]]);
        var buyable = global.user.checkCost(cost);
        global.director.pushView(new ResourceWarningDialog(
                        getStr("upgradeMineTit", null), getStr("upgradeMineCon", null), sureToUpgrade, buyable, cost, "colorCrystal.png"), 1, 0);
    }
    //工作时间长度
    override function initWorking(data)
    {
        if(baseBuild.state == Working)
        {
            var startTime = data.get("objectTime");//serverTime 秒为单位
            startTime = server2Client(startTime); 
            //trace("startTime", data.get("objectTime"), startTime);//objectTime 

            var privateData = dict([["objectTime", startTime]]);//客户端时间 
            planting = new MinePlant(baseBuild, privateData);
            baseBuild.addChild(planting);
        }
    }
    override function getStartTime()
    {
        if(planting != null)
            return client2Server(planting.objectTime);
        return 0;
    }
}
