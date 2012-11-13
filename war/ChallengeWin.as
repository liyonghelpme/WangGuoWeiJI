class ChallengeWin extends MyNode
{
    var map;
    var param;
    var roundStar;
    var rewardStr;
    var levelUpStr;
    var button0;
    var button1;
    var board;
    //构建逻辑
    //根据逻辑构建view
    //但是view 不能独立构建成模板
    //除非view 内容是可以方便调整
    //构建view 模板 ----> 构建逻辑 --->调整view 结构
    function ChallengeWin(m, p)
    {
        map = m;
        param = p;
        initLogic();
        initView();
    }

    //闯关高分不再奖励水晶
    function initLogic()
    {
        var star = param["star"];
        var curStar = global.user.getCurStar(map.kind, map.small);
        if(curStar < star)
        {
            global.user.updateStar(map.kind, map.small, star);
        }

        //UI 组件做成内容可替换的
        var reward = param["reward"];
        rewardStr = "";
        var i;
        for(i = 0; i < len(reward); i++)
        {
            global.user.changeGoodsNum(HERB, reward[i][0], reward[i][1]);
            var hData = getData(HERB, reward[i][0]);
            
            if(i < (len(reward)-1))
                rewardStr += hData.get("name")+"X"+str(reward[i][1])+", ";
            else
                rewardStr += hData.get("name")+"X"+str(reward[i][1]);
        }

        var sols = param.get("levelUpSol");
        if(len(sols) > 0)
        {
            var nstr = "";
            for(i = 0; i < len(sols); i++)
            {
                nstr += sols[i].myName+"、";
            }
            levelUpStr = getStr("solExp", ["[NAMES]", nstr]);
        }
        else
            levelUpStr = getStr("noLevelUp", null);
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        board = bg.addsprite("dialogRoundOver.png").anchor(50, 50).pos(398, 201).size(542, 403).color(100, 100, 100, 100);
        roundStar = bg.addsprite("round"+str(param["star"])+"Star.png").anchor(50, 50).pos(402, 136).size(137, 56).color(100, 100, 100, 100);
        line = stringLines(getStr("rewardList", ["[NAMES]", rewardStr]), 17, 28, [11, 11, 11], FONT_NORMAL );
        line.pos(213, 207);
        bg.add(line);

        temp= bg.addlabel(levelUpStr, "fonts/heiti.ttf", 17, FONT_NORMAL, 334, 0, ALIGN_LEFT).anchor(0, 0).pos(213, 237).color(11, 11, 11);

        bg.addlabel(getStr("roundShare", null), "fonts/heiti.ttf", 17).anchor(0, 50).pos(212, 310).color(40, 37, 37);
        bg.addlabel(getStr("sucWord", null), "fonts/heiti.ttf", 19).anchor(0, 50).pos(212, 184).color(64, 32, 32);
        temp = bg.addsprite("dialogPrincess.png").anchor(0, 0).pos(563, 174).size(121, 197).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [156, 52], getStr("share", null), null, 27, FONT_NORMAL, [100, 100, 100], onShare, null);
        but0.bg.pos(287, 401);
        addChild(but0);
        
        global.taskModel.showHintArrow(but0.bg, but0.bg.prepare().size(), SHARE_WIN);

        button0 = but0;
        but0 = new NewButton("roleNameBut1.png", [156, 52], getStr("ok", null), null, 27, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(509, 402);
        addChild(but0);
        button1 = but0;
        temp = bg.addsprite("roundWin.png").anchor(50, 50).pos(410, 57).size(149, 51).color(100, 100, 100, 100);
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
        button0.setCallback(null);
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
