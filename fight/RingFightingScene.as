
/*
场景 背景地图  和 菜单栏 组成

数据可以缓存在 全局user中 也可以每次进入格斗场场景再同步

弹出对话框控制机制


将数据模型 和 view 分离开来
*/
class RingFightingScene extends MyNode
{
    var map;
    var menu;

    var dialogController;

    var initOver = 0;
    /*
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
    */
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
        //if(global.user.db.get("fightTip") == null)
        var ret = checkTip(FIGHT_TIP);
        if(ret == null)
            dialogController.addCmd(dict([["cmd", "noTip"],  ["kind", FIGHT_TIP]]));//["word", getStr("fightTip", null)],

        if(global.fightModel.initOver == 0)
        {
            global.fightModel.initData();
        }
    }



    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    //var initOver = 0;
    function update(diff)
    {
        //初始化 我方数据 记录 新的擂台 结束 地图显示

        if(initOver == 0 && global.fightModel.initOver)
        {
            map.updateData();
            menu.updateData();
            initOver = 1;
        }
        else if(initOver)
        {
            var needUpdate = 0;
            var failYet = global.fightModel.checkFail();
            
            if(inRefresh && global.fightModel.initArena)
            {
                inRefresh = 0;
                needUpdate = 1;
            }
            if(failYet || needUpdate)
            {
                menu.updateData();
                map.updateData();
            }
        }
    }
    

    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

    function makeArena(kind)
    {
        global.fightModel.makeArena(kind);
        map.updateData();//更新擂台 更新挑战者
        menu.updateData();
    }

    var inRefresh = 0;
    function getOtherArena()
    {
        if(inRefresh == 0)
        {
            inRefresh = 1;
            global.fightModel.getOtherArena();
        }
    }
}
