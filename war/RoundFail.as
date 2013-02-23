class RoundFail extends MyNode
{
    var map;
    var param;
    var okBut;

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
        line = maxWidthLine(getStr("challengeTip", null), 16, getParam("tipOffY"), [40, 37, 37], getParam("failTipWidth"));
        line.pos(255, 199);
        bg.add(line);
        temp = bg.addsprite("dialogBoss.png", ARGB_8888).anchor(0, 0).pos(517, 199).size(150, 166).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [125, 41], getStr("tryAgain", null), null, 20, FONT_NORMAL, [100, 100, 100], onTryAgain, null);
        but0.bg.pos(315, 367);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [125, 41], getStr("ok", null), null, 20, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(492, 368);
        addChild(but0);
        okBut = but0;

        temp = bg.addsprite("roundFail.png").anchor(50, 50).pos(415, 93).color(100, 100, 100, 100);
        temp = bg.addsprite("roundTip.png").anchor(0, 0).pos(206, 142).size(64, 47).color(100, 100, 100, 100);

        global.taskModel.showHintArrow(okBut.bg, okBut.bg.prepare().size(), SHARE_WIN, returnBusiness);
    }

    function returnBusiness()
    {
        global.director.popScene();//闯关场景
        global.director.popScene();//选关场景 

        trace(" 返回经营场景 reEnterScene");
        //改变当前用户经验到2级
        global.user.changeExpLevel(1);
        global.taskModel.doAllTaskByKey("newRoundWin", 1);
        global.httpController.addRequest("logC/finishNewStage", dict([["uid", global.user.uid], ["stage", 1]]), null, null);
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
