//避免多重继承Camp 所以使用CampWorkNode 作为更新节点
class CampWorkNode extends MyNode
{
    var func;
    var flowBanner = null;
    function CampWorkNode(f)
    {
        func = f;
        bg = node();
        init();
    }
    //加速时间 <= 0 进入完成状态
    //考虑 加速时间到 时建筑物 打开招募对话框 自动关闭
    function update(diff)
    {
        var leftTime = func.getLeftTime();
        if(leftTime <= 0 && flowBanner == null)
        {
            var bSize = func.baseBuild.bg.size();
            flowBanner = func.baseBuild.bg.addsprite("callFlow.png").pos(bSize[0]/2, -5).anchor(50, 100);
            flowBanner.addaction(sequence(delaytime(rand(2000)), repeat(moveby(500, 0, -20), delaytime(300), moveby(500, 0, 20))));
            
            //兵营结束招募 提示 用户收获
            global.taskModel.showHintArrow(func.baseBuild.bg, func.baseBuild.bg.size(), HARVEST_SOL);
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    function clearFlowBanner()
    {
        if(flowBanner != null)
        {
            flowBanner.removefromparent();
            flowBanner = null;
        }
    }
}
class Camp extends FuncBuild
{
    var objectId = -1;
    var objectTime = 0;
    var workNode;
    function Camp(b)
    {
        baseBuild = b;
        workNode = new CampWorkNode(this);
    }
    //BUYSOL 信号发出 自动移动 当前屏幕
    override function whenBusy()
    {
        var leftTime = getLeftTime();
        if(leftTime <= 0)//收获 但是更新士兵数据需要构造一个虚拟的士兵对象来调用 user接口来初始化士兵数据
        {
            workNode.removeSelf();
            workNode.clearFlowBanner();

            var sid = global.user.getNewSid();
            var newSol = new BusiSoldier(null, getData(SOLDIER, objectId), null, sid);
            global.user.updateSoldiers(newSol);
            global.msgCenter.sendMsg(BUYSOL, sid);//购买新的士兵 通知经营页面添加士兵
            global.httpController.addRequest("buildingC/finishCall", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["sid", sid]]), null, null);//收获之后 命名士兵
            

            baseBuild.state = PARAMS["buildFree"];
            global.user.updateBuilding(baseBuild);

            return 1;
        }
        return 0;
    }
    override function initWorking(data)
    {
        if(data == null)
            return null;
        if(baseBuild.state != PARAMS["buildWork"])
            return;
        objectId = data.get("objectId"); 
        objectTime = server2Client(data.get("objectTime")); 
        baseBuild.addChild(workNode);
    }
    override function doAcc()
    {
        var gold = getAccCost();
        var cost = dict([["gold", gold]]);
        global.user.doCost(cost);
        var needTime = getData(SOLDIER, objectId)["time"];
        var now = time()/1000;
        objectTime = now - needTime; 
        global.user.updateBuilding(baseBuild);

        global.httpController.addRequest("buildingC/accWork", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["objectKind", SOLDIER], ["gold", gold]]), null, null);

        var showData = cost; 
        global.director.curScene.addChild(new PopBanner(cost2Minus(showData)));//自己控制


    }
    override function getAccCost()
    {
        var leftTime = getLeftTime();
        return max(leftTime/3600, 1); 
    }

    function beginWork(sid)
    {
        baseBuild.setState(PARAMS["buildWork"]); 
        objectId = sid;
        objectTime = time()/1000; 
        global.user.updateBuilding(baseBuild);
        baseBuild.addChild(workNode);//开始更新工作状态 直到 收获士兵
    }
    override function getObjectId()
    {
        if(baseBuild.state == PARAMS["buildWork"])
            return objectId;
        return -1;
    }
    override function getLeftTime()
    {
        //计算剩余时间采用本地时间
        if(baseBuild.state == PARAMS["buildWork"])
        {
            var needTime = getData(SOLDIER, objectId)["time"];
            var now = time()/1000;
            var passTime = now-objectTime;
            return max(needTime-passTime, 0);
        }
        return 0;
    }
    override function getStartTime()
    {
        if(baseBuild.state == PARAMS["buildWork"])
            return client2Server(objectTime); 
        return 0;
    }
}
