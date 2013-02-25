class NewChallengeFail extends MyNode
{
    var scene;
    var param;
    function NewChallengeFail(sc, p)
    {
        scene = sc;
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
        temp = bg.addsprite("dialogRoundOver.png").anchor(50, 50).pos(405, 206).size(434, 317).color(100, 100, 100, 100);
        line = maxWidthLine(getStr("challengeTip", null), 16, getParam("tipOffY"), [40, 37, 37], getParam("failTipWidth"));
        line.pos(255, 187);
        bg.add(line);
        temp = bg.addsprite("dialogBoss.png", ARGB_8888).anchor(0, 0).pos(517, 196).size(150, 166).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [125, 41], getStr("back", null), null, 20, FONT_NORMAL, [100, 100, 100], onBack, null);
        but0.bg.pos(315, 364);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [125, 41], getStr("ok", null), null, 20, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(492, 365);
        addChild(but0);
        temp = bg.addsprite("roundFail.png").anchor(50, 50).pos(415, 90).color(100, 100, 100, 100);
        temp = bg.addsprite("roundTip.png").anchor(0, 0).pos(206, 139).size(64, 47).color(100, 100, 100, 100);
bg.addlabel(str(param["score"]), getFont(), 20).anchor(0, 50).pos(413, 288).color(98, 2, 11);
        temp = bg.addsprite("dialogRankCup.png").anchor(0, 0).pos(378, 277).size(31, 26).color(100, 100, 100, 100);
    }
    function onBack()
    {
        global.director.popScene();
    }
    function onOk()
    {
        global.director.popScene();
    }
}
