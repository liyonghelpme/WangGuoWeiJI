class MapBanner extends MyNode
{
    function MapBanner()
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
        temp = bg.addsprite("black.png").anchor(0, 0).pos(-11, 422).size(822, 79).color(100, 100, 100, 70);
        but0 = new NewButton("mapReturn.png", [48, 40], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], , null);
        but0.bg.pos(52, 453);
        addChild(but0);
        but0 = new NewButton("blueButton.png", [131, 40], getStr("Multiplayer", null), null, 20, FONT_NORMAL, [100, 100, 100], onMultiplayer, null);
        but0.bg.pos(715, 452);
        addChild(but0);
        bg.addlabel(getStr("Multiplayer", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(546, 453).color(100, 100, 100);
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
