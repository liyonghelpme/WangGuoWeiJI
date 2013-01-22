class NewSoldierDialog extends MyNode
{
    var views = [];
    function NewSoldierDialog()
    {
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
        temp = bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        temp = bg.addsprite("rightBack.png").anchor(0, 0).pos(252, 77).size(518, 391).color(100, 100, 100, 100);
        temp = bg.addsprite("leftBack.png").anchor(0, 0).pos(32, 77).size(201, 390).color(100, 100, 100, 100);
        temp = bg.addsprite("infoBack.png").anchor(0, 0).pos(31, 246).size(203, 160).color(100, 100, 100, 60);
        temp = bg.addsprite("dialogSoldierTitle.png").anchor(50, 50).pos(514, 113).size(180, 42).color(100, 100, 100, 100);
        temp = bg.addsprite("dialogSoldier.png").anchor(0, 0).pos(73, 11).size(189, 62).color(100, 100, 100, 100);

        but0 = new NewButton("blueButton.png", [150, 44], getStr("checkEquip", null), null, 28, FONT_NORMAL, [100, 100, 100], onCheckEquip, null);
        but0.bg.pos(130, 435);
        addChild(but0);

        views = [new AllSoldier(this)];
        switchView(0);
    }

    var selected = null;
    function switchView(viewId)
    {
        if(selected != null)
        {
            views[selected].removeSelf();
        }
        selected = viewId;
        addChild(views[selected]);
    }
    function onCheckEquip()
    {
        views[0].onEquip();
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
