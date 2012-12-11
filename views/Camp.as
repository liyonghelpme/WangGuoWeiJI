//避免多重继承Camp 所以使用CampWorkNode 作为更新节点

//检测objectList 头部类型---> id, number---->
//计时结束 生产头部类型

//计时方式:
//  id--->needTime 
// startTime += 
class CampWorkNode extends MyNode
{
    var func;
    var flowBanner = null;
    function CampWorkNode(f)
    {
        trace("init Camp Node");
        func = f;
        bg = node();
        init();
    }
    function getNewName()
    {
        var rd = rand(len(soldierName));
        var sname = getStr(soldierName[rd][0], "");
        soldierName.pop(rd);
        return sname;
    }
    //每个兵营都初始化一次名字？
    //加速时间 <= 0 进入完成状态
    //考虑 加速时间到 时建筑物 打开招募对话框 自动关闭
    function update(diff)
    {
        if(len(func.baseBuild.objectList) > 0)
        {
            var harvestYet = 0;
            var totalNeedTime = 0;
            while(1)
            {
                var leftTime = func.getRealLeftTime();
                var needTime = leftTime[1];//当前士兵需要的工作时间
                leftTime = leftTime[0];
                //剩余时间最小0
                //且正在工作
                var objectList = func.baseBuild.objectList;
                trace("finish camp", leftTime, objectList);
                if(leftTime <= 0 && len(objectList) > 0)
                {
                    var solId = objectList[0][0];
                    var sid = global.user.getNewSid();
                    var newSol = new BusiSoldier(null, getData(SOLDIER, solId), null, sid);
                    var newName = getNewName();
                    newSol.setName(newName);
                    global.user.updateSoldiers(newSol);
                    global.msgCenter.sendMsg(BUYSOL, newSol.sid);
                    
                    global.httpController.addRequest("buildingC/campHarvestSoldier", dict([["uid", global.user.uid], ["bid", func.baseBuild.bid], ["solId",  solId], ["sid", sid], ["name", newName]]), null, null);//收获之后 命名士兵
                    
                    trace("objectList Num", objectList[0]);
                    objectList[0][1] -= 1;
                    if(objectList[0][1] <= 0)
                        objectList.pop(0);

                    global.user.updateBuilding(func.baseBuild);
                    harvestYet = 1;

                    totalNeedTime += needTime;
                    func.objectTime += needTime;
                }
                else
                    break;
            }
            if(harvestYet)
            {
                global.msgCenter.sendMsg(CALL_SOL_FINISH, null);
                func.startWork();//更新工作时间
            }
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
        //需要等待baseBuild init结束才能
        baseBuild.addChild(workNode);
    }
    //BUYSOL 信号发出 自动移动 当前屏幕
    override function whenBusy()
    {
        //工作时 点击士兵一次性收获多个?
        return 0;
    }
    /*
    兵营总是在工作状态
    检测objectList
    队列不空则工作 
    兵营没有工作状态
    */
    override function initWorking(data)
    {
        if(data == null)
            return null;
        if(len(baseBuild.objectList) > 0)
        {
            //baseBuild.state = PARAMS["buildWork"];
            objectId = 0;
            objectTime = server2Client(data.get("objectTime")); 
        }
    }

    //需要自己计算剩余时间
    //修正objectTime
    //立即更新workNode
    function adjustObjectTime(needTime)
    {
        objectTime -= needTime;
        workNode.update(0);
        global.user.updateBuilding(baseBuild);
    }
    //更新兵营工作时间
    function startWork()
    {
        objectTime = time()/1000;
        global.user.updateBuilding(baseBuild);
        global.httpController.addRequest("buildingC/campUpdateWorkTime", dict([["uid", global.user.uid], ["bid", baseBuild.bid]]), null, null);
    }
    //
    function addSoldier(kind)
    {
        var objectList = baseBuild.objectList;
        var index = null;
        for(var i = 0; i < len(objectList); i++)
        {
            if(objectList[i][0] == kind)
            {
                index = objectList[i];
                break;
            }
        }
        if(index == null)
            objectList.append([kind, 1]);
        else
            index[1] += 1;
        global.user.updateBuilding(baseBuild);
    }

    //objectTime 是客户端时间
    //收获一个士兵 objectTime += leftTime 时间向后移动一下
    //harvestYet 来更新 远程工作时间
    //objectTime += needTime
    override function getLeftTime()
    {
        /*
        if(len(baseBuild.objectList) > 0)
        {
            //trace("camp leftTime", baseBuild.objectList);

            var sol = baseBuild.objectList[0];
            var needTime = getData(SOLDIER, sol[0])["time"];
            var now = time()/1000;
            var passTime = now-objectTime;
            return max(needTime-passTime, 0);
        }
        return 0;
        */
        return getRealLeftTime()[0];
    }
    function getRealLeftTime()
    {
        if(len(baseBuild.objectList) > 0)
        {
            //trace("camp leftTime", baseBuild.objectList);

            var sol = baseBuild.objectList[0];
            var needTime = getData(SOLDIER, sol[0])["time"];
            var now = time()/1000;
            var passTime = now-objectTime;
            return [max(needTime-passTime, 0), needTime];
        }
        return [0, 0];
    }
    override function getStartTime()
    {
        if(len(baseBuild.objectList) > 0)
            return client2Server(objectTime); 
        return 0;
    }
}
