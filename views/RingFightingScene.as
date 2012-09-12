
/*
场景 背景地图  和 菜单栏 组成

数据可以缓存在 全局user中 也可以每次进入格斗场场景再同步

弹出对话框控制机制
*/
class RingFightingScene extends MyNode
{
    var map;
    var menu;

    var dialogController;

    var initOver = 0;
    var initMyData = 0;
    var initRecord = 0;
    var initArena = 0;

    var challengers;
    var myArena;
    var mostEarlyTime = 0;
    var myRecords;
    var otherArenas;
    var inConnect = 0;

    var MIN_RECORD = 0;
    var MAX_RECORD = null;

    const FIGHT_NUM = 20;//获取20个数据
    var curOffBegin = 0;
    function RingFightingScene()
    {
        bg = node();
        init();
        map = new FightMap(this);
        addChild(map);
        menu = new FightMenu(this);
        addChild(menu);
        
        dialogController = new DialogController(this);
        //主要用于更新状态 也可以把场景参数传入
        addChild(dialogController);

        dialogController.addCmd(dict([["cmd", "loading"]]));//但是要保证

        //获取擂台数据
        global.httpController.addRequest("fightC/getMyArena", dict([["uid", global.user.uid]]), getMyArenaOver, null);
        //初始挑战记录
        global.httpController.addRequest("fightC/getArenaRecord", dict([["uid", global.user.uid]]), getRecordOver, null);
        //初始化可以挑战的数量
        global.httpController.addRequest("fightC/getArenaNum", dict([["uid", global.user.uid]]), getNumOver, null); 
    }
    function getNumOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            MAX_RECORD = con.get("arenaNum");
            curOffBegin = rand(MAX_RECORD);
            inConnect = 1;
            global.httpController.addRequest("fightC/getRandArena", dict([["uid", global.user.uid], ["offset", curOffBegin], ["limit", FIGHT_NUM]]), getOtherOver, null);
        }
    }
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
                otherArenas.append(dict([["uid", temp[i][0]], ["failNum", temp[i][1]], ["kind", temp[i][2]], ["name", temp[i][3]], ["level", temp[i][4]]]));
            }
            initArena = 1;
            inConnect = 0;
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
                challengers.append(dict([["uid", temp[i][0]], ["time", temp[i][1]], ["name", temp[i][2]], ["level", temp[i][3]] ]));
            }
            myArena = null;
            temp = con.get("arena");
            if(len(temp) > 0)
                myArena = dict([["failNum", temp[0][0]], ["kind", temp[0][1]]]);

            initMyData = 1;
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
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }

    function update(diff)
    {
        //初始化 我方数据 记录 新的擂台 结束 地图显示
        if(initOver == 0 && initMyData && initRecord && initArena)
        {
            map.updateData();
            menu.updateData();
            initOver = 1;
        }
    }

    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
