class ParamController 
{
    var initYet = 0;
    //存在一份临时数据用于调试
    var AnimateParams = dict();
    function ParamController()
    {
        global.httpController.addRequest("fetchParams", dict(), fetchOver, null);
        global.httpController.addRequest("fetchAnimate", dict(), fetchAni, null);
        global.httpController.addRequest("getTaskData", dict(), fetchTask, null);
        global.httpController.addRequest("getAllSolIds", dict(), getAllSolIds, null);
        global.httpController.addRequest("getAllFallGoods", dict(), getAllFallGoods, null);
        global.httpController.addRequest("getStaticData", dict([["did", "building"]]), getStaticData, "building");
    }
    function getStaticData(rid, rcode, con, param)
    {
        if(rcode != -1)
        {
            con = json_loads(con);
            if(param == "building")
            {
                buildingKey = con["key"]; 
                buildingData = con["data"];
                Keys[BUILD] = buildingKey;
                CostData[BUILD] = dict(buildingData);
            }
        }
    }
    function fetchOver(rid, rcode, con, param)
    {
        trace("fetchOver", rid, rcode, con, param);
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
    function getAllFallGoods(rid, rcode, con, param)
    {
        if(rcode != -1)
        {
            con = json_loads(con);
            MoneyGameGoodsKey = con["MoneyGameGoodsKey"];
            MoneyGameGoodsData = dict(con["MoneyGameGoodsData"]);
            Keys[MONEY_GAME_GOODS] = MoneyGameGoodsKey;
            CostData[MONEY_GAME_GOODS] = MoneyGameGoodsData;
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
