class ParamController 
{
    var initYet = 0;
    //存在一份临时数据用于调试
    var AnimateParams = dict();
    function ParamController()
    {
        //fetchParams 必须是第一个发送的 请求 获取 所有参数
        //查看没有debug状态下的参数
        AnimateParams = GameParam; 
        trace("inDebug", GameParam["DEBUG"]);
        if(GameParam["DEBUG"])
        {
            global.httpController.addRequest("fetchParams", dict(), fetchOver, null);
            global.httpController.addRequest("getString", dict(), getString, null);
            global.httpController.addRequest("fetchAnimate", dict(), fetchAni, null);
            global.httpController.addRequest("getTaskData", dict(), fetchTask, null);
            global.httpController.addRequest("getAllSolIds", dict(), getAllSolIds, null);
            global.httpController.addRequest("getAllFallGoods", dict(), getAllFallGoods, null);
            global.httpController.addRequest("getStaticData", dict([["did", "building"]]), getStaticData, "building");
            global.httpController.addRequest("getMapMonster", dict(), getMapMonster, null);
            global.httpController.addRequest("getStaticData", dict([["did", "mapBlood"]]), getStaticData, "mapBlood");
        }
        else
        {

        }
    }
    function updateParams()
    {

    }
    function getString(rid, rcode, con, param)
    {
        if(rcode != -1)
        {
            con = json_loads(con);
            //strings = dict(con["strings"]);
            //先不改物品名称
            WORDS = dict(con["WORDS"]);
            strings = dict(con["names"]);
        }
    }
    function getMapMonster(rid, rcode, con, param)
    {
        if(rcode != -1)
        {
            con = json_loads(con);
            mapMonsterKey = con["mapMonsterKey"];
            mapMonsterData = dict(con["mapMonsterData"]);
        }
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
            else if(param == "mapBlood")
            {
                mapBloodKey = con["key"];
                mapBloodData = con["data"];
                Keys[MAP_INFO] = mapBloodKey;
                CostData[MAP_INFO] = dict(mapBloodData);
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
            global.msgCenter.sendMsg(FETCH_PARAM_OVER, null);
            global.user.currentSoldierId = getParam("currentSoldier");
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
