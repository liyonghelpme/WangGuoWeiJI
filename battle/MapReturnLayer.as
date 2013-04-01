class MapReturnLayer extends MyNode
{
    var fly;
    function MapReturnLayer(f)
    {
        fly =f;
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
        temp = bg.addsprite("black.png").anchor(0, 0).pos(-11, 422).size(822, 79).color(100, 100, 100, getParam("bannerOpacity"));
        but0 = new NewButton("mapReturn.png", [48, 40], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], onBack, null);
        but0.bg.pos(52, 453);
        addChild(but0);
        but0 = new NewButton("blueButton.png", [131, 40], getStr("randomWar", null), null, 20, FONT_NORMAL, [100, 100, 100], onMultiplayer, null);
        but0.bg.pos(715, 452);
        addChild(but0);
        bg.addlabel(getStr("Multiplayer", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(546, 453).color(100, 100, 100);
    }
    function onBack() {
        global.director.popScene(); 
    }
    function finishCallback() {
        sureToChallenge = 0;
    }
    var sureToChallenge = 0;
    function onMultiplayer() {
        sureToChallenge = gotoRandChallenge(sureToChallenge, finishCallback);
        if(sureToChallenge == 0)
        {
            var cs = new ChallengeScene(null, null, null, null, CHALLENGE_OTHER, null);
            global.director.pushScene(cs);
        }
    }

    function closeDialog()
    {
        global.director.popView();
    }
}
