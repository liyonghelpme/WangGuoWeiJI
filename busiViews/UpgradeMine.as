class UpgradeMine extends MyNode
{
    var mine;
    function UpgradeMine(m)
    {
        mine = m;
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
        temp = bg.addsprite("back.png").anchor(0, 0).pos(172, 102).size(472, 282).color(100, 100, 100, 100);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(188, 139).size(440, 233).color(100, 100, 100, 100);
        temp = bg.addsprite("nonFullWhiteBack.png").anchor(0, 0).pos(203, 150).size(410, 193).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(218, 75).size(380, 53).color(100, 100, 100, 100);
        bg.addlabel(getStr("upgradeMineInc", ["[NUM]", str(getParam("mineIncNum"))]), "fonts/heiti.ttf", 21).anchor(50, 50).pos(409, 325).color(28, 15, 4);
        bg.addlabel(getStr("upgradeMineTit", null), "fonts/heiti.ttf", 32).anchor(50, 50).pos(408, 101).color(32, 33, 40);

        var mineCost = mine.funcBuild.getLevelUpCost();
        but0 = new NewButton("roleNameBut0.png", [157, 49], getStr("upgradeButWord", ["[KIND]", "silver.png", "[NUM]", str(mineCost["silver"])]), null, 25, FONT_NORMAL, [100, 100, 100], onUpgrade, null);
        but0.bg.pos(307, 383);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [157, 49], getStr("cancel", null), null, 25, FONT_NORMAL, [100, 100, 100], onCancel, null);
        but0.bg.pos(506, 383);
        addChild(but0);
        
        var mineData = getData(MINE_PRODUCTION, mine.buildLevel);
        temp = bg.addsprite("build"+str(mine.id)+".png", getHue(mineData["color"])).anchor(50, 50).pos(299, 234).color(100, 100, 100, 100);
        sca = getSca(temp, [155, 146]);
        temp.scale(sca);

        mineData = getData(MINE_PRODUCTION, mine.buildLevel+1);
        temp = bg.addsprite("build"+str(mine.id)+".png", getHue(mineData["color"])).anchor(50, 50).pos(514, 234).color(100, 100, 100, 100);
        sca = getSca(temp, [155, 146]);
        temp.scale(sca);
        temp = bg.addsprite("taskArrow.png").anchor(50, 50).pos(407, 241).size(40, 50).color(100, 100, 100, 100).rotate(-90);
    }
    function onCancel()
    {
        global.director.popView();
    }
    function onUpgrade()
    {
        var cost = mine.funcBuild.getLevelUpCost();
        var ret = checkResLack(cost);
        if(!ret)
            return;
        global.director.popView();
        mine.funcBuild.doUpgrade();        
    }
}
