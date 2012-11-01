class ChallengeFail extends MyNode
{
    var param;
    var map;
    var board;
    var button0;
    var button1;
    function ChallengeFail(m, p)
    {
        map = m;
        param = p;
        initView();
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        //-403
        board = bg.addsprite("dialogRoundOver.png").anchor(50, 50).pos(398, 201).size(542, 403).color(100, 100, 100, 100);

        var levelStr = bg.addlabel(getStr("noLevelUp", null), "fonts/heiti.ttf", 17, FONT_NORMAL, 334, 0, ALIGN_LEFT).anchor(0, 0).pos(210, 252).color(11, 11, 11);
        var sols = param.get("levelUpSol");
        if(len(sols) > 0)
        {
            var nstr = "";
            for(var i = 0; i < len(sols); i++)
            {
                nstr += sols[i].myName+"、";
            }
            levelStr.text(getStr("solExp", ["[NAMES]", nstr]));
        }
        bg.addlabel(getStr("equipGood", null), "fonts/heiti.ttf", 17).anchor(0, 50).pos(209, 188).color(40, 37, 37);
        bg.addlabel(getStr("youFail", null), "fonts/heiti.ttf", 19).anchor(0, 50).pos(209, 229).color(64, 32, 32);
        temp = bg.addsprite("dialogBoss.png", ARGB_8888).anchor(0, 0).pos(540, 191).size(187, 207).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [156, 52], getStr("tryAgain", null), null, 27, FONT_NORMAL, [100, 100, 100], onTryAgain, null);
        but0.bg.pos(287, 401);
        addChild(but0);
        button0 = but0;

        but0 = new NewButton("roleNameBut1.png", [156, 52], getStr("ok", null), null, 27, FONT_NORMAL, [100, 100, 100], onQuit, null);
        but0.bg.pos(509, 402);
        addChild(but0);
        button1 = but0;
        temp = bg.addsprite("roundFail.png").anchor(50, 50).pos(412, 58).size(148, 52).color(100, 100, 100, 100);
        temp = bg.addsprite("roundTip.png").anchor(0, 0).pos(151, 119).size(79, 59).color(100, 100, 100, 100);

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

    function tryAgain()
    {
        global.director.popScene();
        var mon = getRoundMonster(map.kind, map.small);
        var argument = dict([["big", map.kind], ["small", map.small], ["soldier", mon]]);
        global.director.pushScene(new BattleScene(argument));
        /*
        map.kind,  map.small,
            mon,
            CHALLENGE_MON, null, null
            )
        );
        */
    }
    function onQuit()
    {
        rollUp(closeDialog);
    }
    function onTryAgain()
    {
        rollUp(tryAgain);
    }
    function closeDialog()
    {
        global.director.popScene();
    }
}
