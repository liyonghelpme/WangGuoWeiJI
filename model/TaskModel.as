const TASK_COFF = 100000;
function getBuyTaskKindAndId(tid)
{
    return [tid/TASK_COFF, tid%TASK_COFF];
}
function getBuyTaskTid(kind, id)
{
    return kind*TASK_COFF+id;
}
class TaskModel
{
    var initYet = 0;
    var buyTaskRecord = null;
    var needToFinishBuyTask = null;
    function TaskModel()
    {
        global.msgCenter.registerCallback(INITDATA_OVER, this);
    }
    function receiveMsg(param)
    {
        var msid = param[0];
        if(msid == INITDATA_OVER)
        {
            buyTaskRecord = global.user.db.get("buyTaskRecord");
            needToFinishBuyTask = global.user.db.get("needToFinishBuyTask");//kind Id
            if(needToFinishBuyTask == null)
                needToFinishBuyTask = dict();
            if(buyTaskRecord == null)
            {
                global.httpController.addRequest("taskC/getBuyTask", dict([["uid", global.user.uid]]), initTaskOver, null);
            }
            else
            {
                initYet = 1;
            }
        }
    }
    function initTaskOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            buyTaskRecord = con.get("tasks");
            global.user.db.put("buyTaskRecord", buyTaskRecord);
            initYet = 1;
        }
    }
    //kind 0 一次 1 循环 2 每日
    //key 任务特征码
    //param 任务参数
    function finishTask(kind, key, id, param)
    {
        if(key == "buy")
        {
            finishBuyTask(param[0], param[1]);
        }

    }
    //完成购买任务得到奖励提示 但是需要去任务界面 点击获取奖励
    function finishBuyTask(kind, id)
    {
        var tid = getBuyTaskTid(kind, id);
        var find = buyTaskRecord.index(tid);
        var find2 = needToFinishBuyTask.get(tid);
        if(find == -1 && find2 == null)
        {
            /*
            global.httpController.addRequest("taskC/finishBuyTask", dict([["uid", global.user.uid], ["tid", tid]]), null, null);
            buyTaskRecord.append(tid);
            global.user.db.put("buyTaskRecord", buyTaskRecord);
            */
            needToFinishBuyTask.update(tid, 1);
            global.user.db.put("needToFinishBuyTask", needToFinishBuyTask);

            var gData = getData(kind, id);
            //trace("finishTask", gData, kind, id);
            //global.director.pushView(new MyWarningDialog(getStr("finishBuyTitle", null), getStr("finishBuyCon", ["[NAME]", gData.get("name")]), null), 1, 0);
            global.director.curScene.addChild(new TaskFinish(getStr("buyObj", ["[NAME]", gData.get("name")])));
            
        }
    }
    //点击奖励物品飞到上方
    function receiveBuyTaskReward(kind, id)
    {
        var tid = getBuyTaskTid(kind, id);
        //记录已经奖励的物品
        global.httpController.addRequest("taskC/finishBuyTask", dict([["uid", global.user.uid], ["tid", tid], ["silver", 10], ["crystal", 0], ["gold", 0]]), null, null);
        global.user.changeValue("silver", 10);

        buyTaskRecord.append(tid);
        global.user.db.put("buyTaskRecord", buyTaskRecord);

        //删除已经奖励的记录
        needToFinishBuyTask.pop(tid);
        global.user.db.put("needToFinishBuyTask", needToFinishBuyTask);

    }

}
