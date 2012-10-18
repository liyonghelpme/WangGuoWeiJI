/*
const TASK_COFF = 100000;
function getBuyTaskKindAndId(tid)
{
    return [tid/TASK_COFF, tid%TASK_COFF];
}
function getBuyTaskTid(kind, id)
{
    return kind*TASK_COFF+id;
}
*/
/*
/*
确保所有 修改 localCycleTask 的地方 都 自动存储到了本地数据库

login 循环任务 用户第一次登录的时候 因为没有初始化localCycleTask 因此不能完成之后 只有同步服务器数据之后 才可以进行
*/
class TaskModel
{
    var initYet = 0;
    var buyTaskRecord = null;
    var needToFinishBuyTask = null;
    var localCycleTask = null;
    var localDayTask = null;
    function getFinishNum()
    {
        if(initYet)
        {
            var count = 0;
            var key = localCycleTask.keys();
            for(var i = 0; i < len(key); i++)
            {
                var ret = checkCycleFinish(key[i]);
                if(ret)
                    count++;
            }
            return len(needToFinishBuyTask)+count;//循环任务完成   
        }
        return 0;
    }
    function update(diff)
    {
        if(initYet == 0 && initBuyTask && initCycleTask && initDayTask)
        {
            initYet = 1;
            global.msgCenter.sendMsg(UPDATE_TASK, null);
        }
    }

    function TaskModel()
    {
        global.msgCenter.registerCallback(INITDATA_OVER, this);
        global.timer.addTimer(this);
    }
    /*
    已经完成的购买任务
    需要领取奖励的购买任务----》完成之后 显示在 任务对话框页面---》finishTask--->任务对话框更新显示
    */
    var initBuyTask = 0;
    var initDayTask = 0;
    function receiveMsg(param)
    {
        var msid = param[0];
        if(msid == INITDATA_OVER)
        {
            buyTaskRecord = global.user.db.get("buyTaskRecord");
            needToFinishBuyTask = global.user.db.get("needToFinishBuyTask");//kind Id
            if(needToFinishBuyTask == null)
                needToFinishBuyTask = [];
            if(buyTaskRecord == null)
            {
                global.httpController.addRequest("taskC/getBuyTask", dict([["uid", global.user.uid]]), initTaskOver, null);
            }
            else
            {
                initBuyTask = 1;
            }

            localCycleTask = global.user.db.get("localCycleTask");
            if(localCycleTask == null)
            {
                localCycleTask = dict();
                global.user.db.put("localCycleTask", localCycleTask);
            }
            checkAvailableCycleTask();

            localDayTask = global.user.db.get("localDayTask");
            if(localDayTask == null)
            {
                localDayTask = dict();
                global.user.db.put("localDayTask", localDayTask);
            }

            //完成每日登录循环任务
            //第一次登录 没有初始化 localCycle 中的任务所以无法显示
            //显示 任务完成提示对话框 ----> 可以将需求发给 场景来处理
            var diff = checkFirstLogin();
            trace("loginTask", diff);
            //第一次登录初始化 每日任务
            if(diff >= 1)
            {
                doCycleTaskByKey("login", 1);
                getDayTaskFromServer();
            }
            else//同一天多次登录 不用初始化 每日任务
            {
                initDayTask = 1;
            }
        }
    }
    //清空每日任务 重新获取
    function getDayTaskFromServer()
    {
        localDayTask = dict();
        global.user.db.put("localDayTask", localDayTask);
        global.httpController.addRequest("taskC/getDayTask", dict([["uid", global.user.uid]]), getDayTaskOver, null);
    }
    //tid --->tid number 
    function getDayTaskOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var dayTid = con["dayTid"];
            for(var i = 0; i < len(dayTid); i++)
            {
                localDayTask.update(dayTid[i], dict([["tid", dayTid[0]], ["number", 0]]));
            }
            global.user.db.put("localDayTask", localDayTask);
            initDayTask = 1;
        }
    }

    function getCycleTask(tid)
    {
        return localCycleTask.get(tid);
    }
    var initCycleTask = 0;
    //检测所有任务 中等级满足 且local中没有的 任务 则向服务器同步数据
    function checkAvailableCycleTask()
    {
        var allTask = getAllDataList(TASK);
        var needSyn = [];
        trace("synTask", len(allTask));
        for(var i = 0; i < len(allTask); i++)
        {
            if(allTask[i]["level"] <= global.user.getValue("level") && allTask[i]["kind"] == CYCLE_TASK && localCycleTask.get(allTask[i]["id"]) == null)
            {
                needSyn.append(allTask[i]["id"]);
            }
        }
        trace("synTask", len(needSyn));
        if(len(needSyn) > 0)
        {
            global.httpController.addRequest("taskC/synCycleTask", dict([["uid", global.user.uid], ["needSyn", json_dumps(needSyn)] ]), synCycleTaskOver, null);
        }
        else
        {
            initCycleTask = 1; 
        }
    }
    function synCycleTaskOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var ret = con["ret"];
            //tid, number, stage
            for(var i = 0; i < len(ret); i++)
            {
                localCycleTask.update(ret[i][0], dict([["tid", ret[i][0]], ["number", ret[i][1]], ["stage", ret[i][2]]]));
            }
            global.user.db.put("localCycleTask", localCycleTask);
            initCycleTask = 1;
        }
    }
    function initTaskOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            buyTaskRecord = con.get("tasks");
            global.user.db.put("buyTaskRecord", buyTaskRecord);
            initBuyTask = 1;
        }
    }
    //kind 0 一次 1 循环 2 每日
    //key 任务特征码
    //param 任务参数
    //buy kind ID
    //只要 key 就可以了
    function finishTask(kind, key, id, param)
    {
        if(kind == ONCE_TASK)
        {
            if(key == "buy")
            {
                finishBuyTask(param[0], param[1]);
            }
        }

    }
    //完成购买任务得到奖励提示 但是需要去任务界面 点击获取奖励
    //完成任务发送消息
    function finishBuyTask(kind, id)
    {
        //var tid = getBuyTaskTid(kind, id);
        var tid = getGoodsKey(kind, id);
        var find = buyTaskRecord.index(tid);
        var find2 = needToFinishBuyTask.index(tid);
        if(find == -1 && find2 == -1)
        {
            needToFinishBuyTask.append(tid);
            global.user.db.put("needToFinishBuyTask", needToFinishBuyTask);

            var gData = getData(kind, id);
            global.director.curScene.addChild(new TaskFinish(getStr("buyObj", ["[NAME]", gData.get("name")])));
            global.msgCenter.sendMsg(UPDATE_TASK, null);
        }
    }
    function receiveBuyTaskReward(tid)
    {
        buyTaskRecord.append(tid);
        global.user.db.put("buyTaskRecord", buyTaskRecord);
        needToFinishBuyTask.remove(tid);
        global.user.db.put("needToFinishBuyTask", needToFinishBuyTask);
        global.msgCenter.sendMsg(UPDATE_TASK, null);
    }

    function finishCycleTask(tid)
    {
        var task = localCycleTask.get(tid);
        task["number"] = 0;
        task["stage"] += 1;
        task.pop("showYet");
        global.user.db.put("localCycleTask", localCycleTask);
        global.msgCenter.sendMsg(UPDATE_TASK, null);
    }
    //通过任务key 来 完成任务
    //本地循环任务还没有初始化成功所以 不能处理 loginTask 的初始化
    function doCycleTaskByKey(k, num)
    {
        trace("doCycleTaskByKey", k, num, len(localCycleTask));

        var allPossible = localCycleTask.keys();
        for(var i = 0; i < len(allPossible); i++)
        {
            var taskData = getData(TASK, allPossible[i]);
            if(taskData["key"] == k)
            {
                doCycleTask(allPossible[i], num);
                break;
            }
        }
    }
    /*
    每天第一次登录 初始化完任务模块 在进行登录任务完成判定
    */
    function doCycleTask(tid, num)
    {
        trace("doCycleTask", tid, num);
        if(localCycleTask.get(tid) != null)
        {
            var task = localCycleTask[tid];
            task["number"] += num;
            var ret = checkCycleFinish(tid);
            trace("cycleTask", task, ret);
            if(ret && task.get("showYet") == null)
            {
                task["showYet"] = 1;
                var taskData = getData(TASK, tid);
                global.director.curScene.addChild(new TaskFinish(replaceStr(taskData["title"], ["[NUM]", str(getCycleStageNum(tid, task["stage"])) ])));
            }

            global.user.db.put("localCycleTask", localCycleTask);
            global.msgCenter.sendMsg(UPDATE_TASK, null);
        }
    }
    function checkCycleFinish(tid)
    {
        var task = localCycleTask[tid];
        var needNum = getCycleStageNum(tid, task["stage"]);
        if(needNum != -1 && task["number"] >= needNum)
        {
            return 1;
        }
        return 0;
    }
    //多个任务可能有 相同的key 这样可以一起做
    //暂时没有实现
    function doDayTaskByKey(key, num)
    {
        trace("doDayTaskByKey", key, num); 
        var allPossible = localDayTask.keys();
        for(var i = 0; i < len(allPossible); i++)
        {
            var taskData = getData(TASK, allPossible[i]);
            if(taskData["key"] == key)
            {
                doDayTask(allPossible[i], num);
                break;
            }
        }
    }
    function getDayTask(tid)
    {
        return localDayTask.get(tid);
    }
    function doDayTask(tid, num)
    {
        if(localDayTask.get(tid) != null)
        {
            var task = localDayTask[tid];
            task["number"] += num;
            var ret = checkDayFinish(tid);
            trace("dayTask", task, ret);
            if(ret && task.get("showYet") == null)
            {
                task["showYet"] = 1;
                var taskData = getData(TASK, tid);
                global.director.curScene.addChild(new TaskFinish(taskData["title"]));
            }

            global.user.db.put("localDayTask", localDayTask);
            global.msgCenter.sendMsg(UPDATE_TASK, null);
        }
    }
    function checkDayFinish(tid)
    {
        var task = localDayTask[tid];
        var taskData = getData(TASK, tid);
        var needNum = taskData["num"];
        if(task["number"] >= needNum)
        {
            return 1;
        }
        return 0;
    }
    //领取所有每日任务奖励
    //清空所有每日任务记录
    function finishDayTask()
    {
        localDayTask = dict();
        global.user.db.put("localDayTask", localDayTask);
        global.msgCenter.sendMsg(UPDATE_TASK, null);
    }
}
