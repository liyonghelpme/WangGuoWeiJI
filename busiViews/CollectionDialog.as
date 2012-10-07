class CollectionDialog extends MyNode
{
    var gloryText;
    function CollectionDialog()
    {
        initView();
        addChild(new CollectionList());
    }
    function initView()
    {
        bg = node();
        init();
        bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        var but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        bg.addsprite("loginBack.png").anchor(0, 0).pos(30, 79).size(739, 386).color(100, 100, 100, 100);
        but0 = new NewButton("blueButton.png", [113, 42], getStr("collectionTip", null), null, 20, FONT_NORMAL, [100, 100, 100], onCollectionTip, null);
        but0.bg.pos(652, 43);
        addChild(but0);
        bg.addsprite("collectionTitle.png").anchor(50, 50).pos(154, 48).size(183, 86).color(100, 100, 100, 100);
        gloryText = bg.addlabel(getStr("gloryText", null), "fonts/heiti.ttf", 35).anchor(0, 50).pos(86, 48).color(43, 25, 9);
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function onCollectionTip()
    {
    }

}
