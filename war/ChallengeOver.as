class ChallengeOver extends MyNode
{
    var map;
    var param;
    var roundStar;
    var levelUpStr = null;
    var button1;
    var board;
    //构建逻辑
    //根据逻辑构建view
    //但是view 不能独立构建成模板
    //除非view 内容是可以方便调整
    //构建view 模板 ----> 构建逻辑 --->调整view 结构
    function ChallengeOver(m, p)
    {
        map = m;
        param = p;
        initLogic();
        initView();
    }

    //挑战邻居  水晶
    //挑战其它人  得分 水晶
    //高分不再奖励水晶
    function initLogic()
    {
        var star = param["star"];
        //UI 组件做成内容可替换的
        var i;

        var sols = param.get("deadSols");
        if(len(sols) > 0)
        {
            var nstr = "";
            for(i = 0; i < len(sols); i++)
            {
                if(i < len(sols)-1)
                    nstr += sols[i].myName+"、";
                else
                    nstr += sols[i].myName;
            }
            levelUpStr = getStr("deadSols", ["[NAMES]", nstr]);
        }
        else
            levelUpStr = null;
            //levelUpStr = getStr("noLevelUp", null);
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        var i;
        board = bg.addsprite("dialogRoundOver.png").anchor(50, 50).pos(398, 201).size(542, 403).color(100, 100, 100, 100);
        roundStar = bg.addsprite("round"+str(param["star"])+"Star.png").anchor(50, 50).pos(402, 136).size(137, 56).color(100, 100, 100, 100);

        var its = param["reward"].items();
        var rewStr = "";
        for(i = 0; i < len(its); i++)
        {   
            if(i < (len(its)-1))
            {
                rewStr += str(its[i][1])+getStr(its[i][0], null)+"、";   
            }
            else
                rewStr += str(its[i][1])+getStr(its[i][0], null);   
        }
        temp = bg.addlabel(getStr("youGetReward", ["[REWARDS]", rewStr]), "fonts/heiti.ttf", 17, FONT_NORMAL).color(11, 11, 11).pos(213, 207);

        if(levelUpStr != null)
            temp = bg.addlabel(levelUpStr, "fonts/heiti.ttf", 17, FONT_NORMAL, 334, 0, ALIGN_LEFT).anchor(0, 0).pos(213, 237).color(11, 11, 11);

        temp = bg.addsprite("dialogPrincess.png").anchor(0, 0).pos(563, 174).size(121, 197).color(100, 100, 100, 100);

        but0 = new NewButton("roleNameBut1.png", [156, 52], getStr("ok", null), null, 27, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(400, 402);
        addChild(but0);
        button1 = but0;

        if(param["win"])
            temp = bg.addsprite("roundWin.png").anchor(50, 50).pos(410, 57).size(149, 51).color(100, 100, 100, 100);
        else
            temp = bg.addsprite("roundFail.png").anchor(50, 50).pos(412, 58).size(148, 52).color(100, 100, 100, 100);
    }
    //分享之后 回到 经营页面任务
    function closeDialog()
    {
        //global.taskModel.doAllTaskByKey("newRoundWin", 1);
        global.director.popScene();
    }

    var callback;
    function update(diff)
    {
        rollTime += diff; 
        if(rollTime >= 500)
        {
            global.timer.removeTimer(this);
            callback();        
        }
    }
    var rollTime = 0;
    function rollUp(cb)
    {
        var bSize = board.size();
        bg.addaction(moveby(500, 0, -bSize[1]));
        button1.setCallback(null);

        rollTime = 0;
        callback = cb;
        global.timer.addTimer(this);
    }
    function shareNow()
    {
        doShare(getStr("enjoyGame", ["[NAME]", global.user.name]), null, null, null, null);
        global.director.popScene();
    }
    function onShare()
    {
        rollUp(shareNow);
    }
    function onOk()
    {
        rollUp(closeDialog);
    }

}
