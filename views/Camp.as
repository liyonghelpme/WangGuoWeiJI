//避免多重继承Camp 所以使用CampWorkNode 作为更新节点

//检测objectList 头部类型---> id, number---->
//计时结束 生产头部类型

//计时方式:
//  id--->needTime 
// startTime += 
class FastCallback extends MyNode
{
    var workNode;
    var switchTime = 0;
    function FastCallback(w)
    {
        workNode = w;
        bg = node();
        init();
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }
    function update(diff)
    {
        var solId;
        var sid;
        var newName;
        if(len(workNode.cacheShowSoldier) > 0)
        {
            switchTime += diff;
            if(switchTime >= getParam("SwitchTime"))
            {
                switchTime = 0;
                var singleSol = workNode.cacheShowSoldier.pop(0);
                sid = singleSol[0];
                solId = singleSol[1];
                newName = singleSol[2];
                var newSol = new BusiSoldier(null, getData(SOLDIER, solId), null, sid);
                newSol.setName(newName);
                global.user.updateSoldiers(newSol);
                global.msgCenter.sendMsg(BUYSOL, newSol.sid);
            }
        }
        else
        {
            workNode.removeCallback();
        }
    }
    override function exitScene()
    {
        global.myAction.removeAct(this);
        super.exitScene();
    }
}
class CampWorkNode extends MyNode
{
    var func;
    var flowBanner = null;
    var cacheShowSoldier = [];
    var fastCallback = null;
    function removeCallback()
    {
        fastCallback.removeSelf();
        fastCallback = null;
    }
    function startCallback()
    {
        if(fastCallback == null)
        {
            fastCallback = new FastCallback(this);
            fastCallback.switchTime = getParam("SwitchTime");
            addChild(fastCallback);
        }
    }
    function CampWorkNode(f)
    {
        trace("init Camp Node");
        func = f;
        bg = node();
        init();
    }


    //每个兵营都初始化一次名字？
    //加速时间 <= 0 进入完成状态
    //考虑 加速时间到 时建筑物 打开招募对话框 自动关闭
    function update(diff)
    {
        var solId;
        var sid;
        var newName;

        //trace("readyList", func.baseBuild.readyList, flowBanner, func.baseBuild.objectList);
        //有士兵需要收获
        if(len(func.baseBuild.readyList) > 0 && flowBanner == null)
        {
            var bSize = func.baseBuild.bg.size();
            flowBanner = func.baseBuild.bg.addsprite("callFlow.png").pos(bSize[0]/2, -5).anchor(50, 100);
            flowBanner.addaction(sequence(repeat(moveby(500, 0, -20), delaytime(300), moveby(500, 0, 20))));
        }
        //购买士兵 信号移动到士兵所在位置
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
                    //加入到readyList 中去
                    solId = objectList[0][0];
                    global.httpController.addRequest("buildingC/campReadySoldier", dict([["uid", global.user.uid], ["bid", func.baseBuild.bid], ["solId",  solId]]), null, null);//收获之后 命名士兵
                    trace("objectList Num", objectList[0]);
                    objectList[0][1] -= 1;
                    if(objectList[0][1] <= 0)
                        objectList.pop(0);
                    
                    var num = func.baseBuild.readyList.get(solId, 0);
                    num++;
                    func.baseBuild.readyList.update(solId, num);

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
        //需要等待baseBuild init结束才能
        baseBuild.addChild(workNode);
    }
    //如果有士兵可以收获则 返回1
    //一次收获1个士兵
    function harvestSoldier()
    {
        //每次只出现一个
        if(len(baseBuild.readyList) > 0)
        {
            workNode.clearFlowBanner();
            var readies = baseBuild.readyList.items();
            //kind number
            var solList = [];
            for(var i = 0; i < len(readies); i++)
            {
                var r = readies[i];
                for(var j = 0; j < r[1]; j++)
                {
                    var solId = r[0];
                    var sid = global.user.getNewSid();
                    var newName = getNewName();
                    workNode.cacheShowSoldier.append([sid, solId, newName]);
                    solList.append([sid, solId, newName]);
                }
            }
            global.httpController.addRequest("buildingC/campHarvestSoldier", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["sols",  json_dumps(solList)]]), null, null);//收获之后 命名士兵
            baseBuild.readyList = dict();
            global.user.updateBuilding(baseBuild);

            workNode.startCallback();
            return 1;
        }
        return 0;
    }
    override function whenFree()
    {
        return harvestSoldier();
    }
    //BUYSOL 信号发出 自动移动 当前屏幕
    override function whenBusy()
    {
        //工作时 点击士兵一次性收获多个?
        return harvestSoldier();
    }
    /*
    兵营总是在工作状态
    检测objectList
    队列不空则工作 
    兵营没有工作状态

    如果readyList 不空则显示可以收获 注意数量不为0
    */
    override function initWorking(data)
    {
        if(data == null)
            return null;
        if(len(baseBuild.objectList) > 0)
        {
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
