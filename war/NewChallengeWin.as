class NewChallengeWin extends MyNode
{
    var map;
    var param;
    function NewChallengeWin(m, p)
    {
        map = m;
        param = p;
        initView();
    }
    var okBut;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("dialogRoundOver.png").anchor(50, 50).pos(405, 206).size(434, 317).color(100, 100, 100, 100);
        temp = bg.addsprite("round"+str(param["star"])+"Star.png").anchor(0, 0).pos(354, 130).size(109, 45).color(100, 100, 100, 100);
        bg.addlabel(getStr("congrateYouGet", null), "fonts/heiti.ttf", 19).anchor(0, 50).pos(254, 193).color(64, 32, 32);
        temp = bg.addsprite("dialogPrincess.png").anchor(0, 0).pos(536, 183).size(97, 157).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [125, 41], getStr("share", null), null, 20, FONT_NORMAL, [100, 100, 100], onShare, null);
        but0.bg.pos(315, 364);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [125, 41], getStr("ok", null), null, 20, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(492, 365);
        addChild(but0);
        okBut = but0;
        global.taskModel.showHintArrow(okBut.bg, okBut.bg.prepare().size(), CHALLENGE_WIN_OK, finishNew);

        temp = bg.addsprite("roundWin.png").anchor(50, 50).pos(414, 89).color(100, 100, 100, 100);
        bg.addlabel(str(param["reward"]["silver"]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(301, 229).color(18, 11, 6);
        temp = bg.addsprite("silver.png").anchor(0, 0).pos(262, 215).size(30, 30).color(100, 100, 100, 100);
        bg.addlabel(str(param["reward"]["crystal"]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(301, 262).color(18, 11, 6);
        temp = bg.addsprite("crystal.png").anchor(0, 0).pos(265, 249).size(29, 29).color(100, 100, 100, 100);
        bg.addlabel(str(param["score"]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(302, 295).color(18, 11, 6);
        temp = bg.addsprite("dialogRankCup.png").anchor(0, 0).pos(266, 284).size(31, 26).color(100, 100, 100, 100);
    }
    function finishNew()
    {
        global.director.popScene();
        global.user.changeExpLevel(3);
        global.taskModel.doAllTaskByKey("challengeNow", 1);
        global.httpController.addRequest("logC/finishNewStage", dict([["uid", global.user.uid], ["stage", 3]]), null, null);
    }
    function onShare()
    {
        doShare(getStr("enjoyGame", ["[NAME]", global.user.name]), null, null, null, null);
        global.director.popScene();
    }
    function onOk()
    {
        global.director.popScene();
    }
}
