class RoundWin extends MyNode
{
    var map;
    var param;
    function RoundWin(m, p)
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
        temp = bg.addsprite("dialogRoundOver.png").anchor(50, 50).pos(405, 210).size(434, 317).color(100, 100, 100, 100);
        temp = bg.addsprite("round"+str(param["star"])+"Star.png").anchor(0, 0).pos(354, 133).size(109, 45).color(100, 100, 100, 100);
        bg.addlabel(getStr("conSucSavePrincess", null), "fonts/heiti.ttf", 17).anchor(0, 50).pos(254, 197).color(64, 32, 32);
        temp = bg.addsprite("dialogPrincess.png").anchor(0, 0).pos(536, 186).size(97, 157).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [125, 41], getStr("share", null), null, 22, FONT_NORMAL, [100, 100, 100], onShare, null);
        but0.bg.pos(315, 367);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [125, 41], getStr("ok", null), null, 22, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(492, 368);
        addChild(but0);
        okBut = but0;

        temp = bg.addsprite("roundWin.png").anchor(50, 50).pos(414, 92).size(120, 41).color(100, 100, 100, 100);
        bg.addlabel(str(param["reward"].get("silver", 0)), "fonts/heiti.ttf", 22).anchor(0, 50).pos(307, 243).color(18, 11, 6);
        temp = bg.addsprite("silver.png").anchor(0, 0).pos(268, 227).size(30, 30).color(100, 100, 100, 100);
        bg.addlabel(str(param["reward"].get("crystal", 0)), "fonts/heiti.ttf", 22).anchor(0, 50).pos(307, 281).color(18, 11, 6);
        temp = bg.addsprite("crystal.png").anchor(0, 0).pos(271, 266).size(29, 29).color(100, 100, 100, 100);

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
