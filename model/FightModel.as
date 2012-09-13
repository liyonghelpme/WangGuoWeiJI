class FightModel
{
    var initOver = 0;
    var initMyData = 0;
    var initRecord = 0;
    var initArena = 0;

    var challengers;
    var myArena;
    var mostEarlyTime = 0;
    var myRecords;
    var otherArenas;


    var MIN_RECORD = 0;
    var MAX_RECORD = null;

    const FIGHT_NUM = 20;//获取20个数据
    var curOffBegin = 0;

    var inConnect = 0;

    var inInit = 0;
    function FightModel()
    {
        global.timer.addTimer(this); 
    }
    function update(diff)
    {
        if(initOver == 0 && initMyData && initRecord && initArena)
        {
            initOver = 1;
        }
    }
    function initData()
    {
        if(initOver == 0 && inInit == 0)
        {
            inInit = 1;
            //获取擂台数据
            global.httpController.addRequest("fightC/getMyArena", dict([["uid", global.user.uid]]), getMyArenaOver, null);
            //初始挑战记录
            global.httpController.addRequest("fightC/getArenaRecord", dict([["uid", global.user.uid]]), getRecordOver, null);
            //初始化可以挑战的数量
            global.httpController.addRequest("fightC/getArenaNum", dict([["uid", global.user.uid]]), getNumOver, null); 
        }
    }
    
    function getRecordOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var temp = con.get("record");
            myRecords = dict();
            for(var i = 0; i < len(temp); i++)
                myRecords.update(temp[i][0], temp[i][1]);//oid ---> time

            initRecord = 1;
        }
    }

    function getMyArenaOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            //uid--->time
            challengers = [];
            var temp = con.get("challengers");

            if(len(temp) > 0)
                mostEarlyTime = temp[0][1];
            for(var i = 0; i < len(temp); i++)
            {
                //challengers.update(temp[i][0], temp[i][1]);//uid time
                challengers.append(dict([["uid", temp[i][0]], ["time", temp[i][1]], ["name", temp[i][2]], ["level", temp[i][3]], ["total", temp[i][4]], ["suc", temp[i][5]]]));
            }
            myArena = null;
            temp = con.get("arena");
            if(len(temp) > 0)
                myArena = dict([["failNum", temp[0][0]], ["kind", temp[0][1]]]);

            //检测失败 清空数据
            checkFail();
            initMyData = 1;
        }
    }

    function getNumOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            MAX_RECORD = con.get("arenaNum");
            curOffBegin = rand(MAX_RECORD);
            getOtherArena();
        }
    }

    //record 比 擂台要早初始化 才能检测
    //初始其它人擂台数据
    function getOtherOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var temp = con.get("arena");
            otherArenas = [];
            for(var i = 0; i < len(temp); i++)
            {
                if(temp[i][0] != global.user.uid && myRecords.get(temp[i][0]) == null)
                    otherArenas.append(dict([["uid", temp[i][0]], ["failNum", temp[i][1]], ["kind", temp[i][2]], ["name", temp[i][3]], ["level", temp[i][4]], ["total", temp[i][5]], ["suc", temp[i][6]] ]));
            }

            curOffBegin += len(temp);
            curOffBegin %= MAX_RECORD;

            initArena = 1;
            inConnect = 0;

            /*
            if(initOver)//已经初始化结束 则 更新其它擂台显示
            {
                menu.updateData();
                map.updateData();
            }
            */
        }
    }

    function getOtherArena()
    {
        if(inConnect == 0)
        {
            inConnect = 1;
            initArena = 0;//未获取
            global.httpController.addRequest("fightC/getRandArena", dict([["uid", global.user.uid], ["offset", curOffBegin], ["limit", FIGHT_NUM]]), getOtherOver, null);
        }
    }

    //挑战过不能再挑战
    function addRecord(oid)
    {
        var now = time()/1000;
        now = client2Server(now);
        myRecords.update(oid, now);
        for(var i = 0; i < len(otherArenas); i++)
        {
            if(otherArenas[i].get("uid") == oid)
            {
                otherArenas[i].pop(i);
                break;
            }
        }
    }


    function checkRecord(oid)
    {
        return myRecords.get(oid);
    }
    function removeChallenger(oid)
    {
        for(var i = 0; i < len(challengers); i++)
        {
            if(challengers[i].get("uid") == oid)
            {
                challengers.pop(i);
                break;
            }
        }
    }

    /*
    失败两种条件 失败10次
    超时
    清除擂台
    清除挑战数据


    有擂台 
        有挑战者 超时
        失败次数太多
    没有擂台
        有挑战者
    */
    function checkFail()
    {
        if(myArena != null)
        {
            //delete Arena ----> delete challengeRecord 
            //deleteArena insertChallengeRecord
            //check has challengeRecord no arena delete challengeRecord
            if(myArena.get("failNum") >= PARAMS.get("maxFailNum"))
            {
                clearMyArena();
                return 1;
            }
            else if(len(challengers) > 0)//有挑战者没有解决
            {
                var now = time()/1000;
                now = client2Server(now);
                var diff = now - mostEarlyTime;
                if(diff > PARAMS.get("failTime"))
                {
                    clearMyArena();     
                    return 1;
                }
            }
        }
        else if(len(challengers) > 0)
        {
            clearMyArena();
            return 1;
        }
        return 0;
    }

    //清理士兵
    function clearMyArena()
    {
        myArena = null;
        challengers = [];
        mostEarlyTime = 0;

        //menu.updateData();
        //map.updateData();

        global.httpController.addRequest("fightC/defenseTimeOut", dict([["uid", global.user.uid]]), null, null);
    }

    function makeArena(kind)
    {
        myArena = dict([["failNum", 0], ["kind", kind]]);
        challengers = [];
        //map.updateData();//更新擂台 更新挑战者
        //menu.updateData();
    }
}
