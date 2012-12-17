class ParamController 
{
    var initYet = 0;
    var AnimateParams = dict();
    function ParamController()
    {
        global.httpController.addRequest("fetchParams", dict(), fetchOver, null);
        global.httpController.addRequest("fetchAnimate", dict(), fetchAni, null);
        global.httpController.addRequest("getTaskData", dict(), fetchTask, null);
        global.httpController.addRequest("getAllSolIds", dict(), getAllSolIds, null);
    }
    function fetchOver(rid, rcode, con, param)
    {
        if(rcode != -1)
        {
            con = json_loads(con);
            AnimateParams = con;
            initYet = 1;
        }
    }
    function getAllSolIds(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            soldierKey = con["soldierKey"];
            soldierData = dict(con["soldierData"]);
            Keys[SOLDIER] = soldierKey;
            CostData[SOLDIER] = soldierData;
        }
    }
    function fetchAni(rid, rcode, con, param)
    {
        if(rcode != -1)
        {
            con = json_loads(con);
            pureMagicData = dict(con["ani"]);
            magicAnimate = dict(con["sol"]);
            ParticleKey = con["pKey"];
            ParticleData = dict(con["pData"]);
            Keys[PARTICLES] = ParticleKey;
            CostData[PARTICLES] = ParticleData;
        }
    }
    /*
    更新数据得 重新Keys CostData 调整 
    脚本中 的task的commandlist使用的 是 数组的形式 主要是为了方便生成
    服务器 直接返回json_loads 就变成了 dict的形式

    */
    function fetchTask(rid, rcode, con, param)
    {
        con = json_loads(con);
        trace("fetchTask", len(con), len(allTasksData));
        allTasksData = dict(con["taskData"]);
        allTasksKey = con["taskKey"];
        Keys[TASK] = allTasksKey;
        CostData[TASK] = allTasksData;
    }
}
