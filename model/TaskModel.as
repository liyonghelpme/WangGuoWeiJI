class TaskModel
{
    var initYet = 0;
    var buyTaskRecord;
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
    //完成购买任务得到奖励提示
    function finishBuyTask(kind, id)
    {
        var tid = kind*100000+id;
        var find = buyTaskRecord.index(tid);
        if(find == -1)
        {
            global.httpController.addRequest("taskC/finishBuyTask", dict([["uid", global.user.uid], ["tid", tid]]), null, null);
            buyTaskRecord.append(tid);
            global.user.db.put("buyTaskRecord", buyTaskRecord);
            var gData = getData(kind, id);
            trace("finishTask", gData, kind, id);
            global.director.pushView(new MyWarningDialog(getStr("finishBuyTitle", null), getStr("finishBuyCon", ["[NAME]", gData.get("name")]), null), 1, 0);
            
        }
    }
}
