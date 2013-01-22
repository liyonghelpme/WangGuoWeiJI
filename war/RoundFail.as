class RoundFail extends MyNode
{
    var map;
    var param;
    function RoundFail(m, p)
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
        temp = bg.addsprite("dialogRoundOver.png").anchor(50, 50).pos(405, 210).size(434, 317).color(100, 100, 100, 100);
        line = stringLines(getStr("challengeTip", null), 16, 20, [40, 37, 37], FONT_NORMAL );
        line.pos(255, 199);
        bg.add(line);
        temp = bg.addsprite("dialogBoss.png", ARGB_8888).anchor(0, 0).pos(517, 199).size(150, 166).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [125, 41], getStr("tryAgain", null), null, 20, FONT_NORMAL, [100, 100, 100], onTryAgain, null);
        but0.bg.pos(315, 367);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [125, 41], getStr("ok", null), null, 20, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(492, 368);
        addChild(but0);
        temp = bg.addsprite("roundFail.png").anchor(50, 50).pos(415, 93).size(118, 42).color(100, 100, 100, 100);
        temp = bg.addsprite("roundTip.png").anchor(0, 0).pos(206, 142).size(64, 47).color(100, 100, 100, 100);
    }
    function onTryAgain()
    {
        global.director.popScene();
        global.director.pushScene(new BattleScene(map.scene.argument));
    }
    function onOk()
    {
        global.director.popScene();
    }
}
