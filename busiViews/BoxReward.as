class BoxReward extends MyNode
{
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        bg.add(showFullBack());
        temp = bg.addsprite("back.png").anchor(0, 0).pos(150, 91).size(520, 312).color(100, 100, 100, 100);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(169, 135).size(481, 252).color(100, 100, 100, 100);
        temp = bg.addsprite("nonFullWhiteBack.png").anchor(0, 0).pos(184, 175).size(314, 182).color(100, 100, 100, 100);
        temp = bg.addsprite("scroll.png").anchor(0, 0).pos(223, 114).size(374, 57).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 63).size(418, 57).color(100, 100, 100, 100);
        bg.addlabel(getStr("mysteriousGift", null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(408, 93).color(32, 33, 40);
        bg.addlabel(getStr("nextBoxRich", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(417, 147).color(43, 25, 9);
        bg.addlabel(getStr("conForGift", null), "fonts/heiti.ttf", 18).anchor(0, 50).pos(212, 208).color(28, 15, 4);

        var INITX = 214;
        var INITY = 236;
        var OFFY = 25;

        for(var i = 0; i < len(rewards); i++)
        {
            var kind = rewards[i][0];
            var id = rewards[i][1];
            var num = rewards[i][2];

            if(kind == SILVER || kind == CRYSTAL || kind == GOLD)
                bg.addlabel(getStr("boxReward0", ["[NUM]", str(num), "[KIND]", getStr(KIND2STR[kind], null)]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(INITX, INITY).color(20, 52, 27);
            else
            {
                var objData = getData(kind, id);
                bg.addlabel(getStr("boxReward1", ["[NUM]", str(num), "[KIND]", objData["name"]]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(INITX, INITY).color(20, 52, 27);
            }
            INITY += OFFY;
        }

        bg.addlabel(getStr("shareWithFriend", null), "fonts/heiti.ttf", 18).anchor(0, 50).pos(211, 330).color(64, 15, 29);
        temp = bg.addsprite("boxPrincess.png").anchor(0, 0).pos(527, 180).size(102, 165).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("share", null), null, 27, FONT_NORMAL, [100, 100, 100], onShare, null);
        but0.bg.pos(299, 402);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 27, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(519, 402);
        addChild(but0);
        temp = bg.addsprite("leftBalloon.png").anchor(0, 0).pos(41, 73).size(136, 302).color(100, 100, 100, 100);
        temp = bg.addsprite("rightBalloon.png").anchor(0, 0).pos(665, 39).size(120, 343).color(100, 100, 100, 100);
    }
    function onShare()
    {
        ppy_postnewsfeed(getStr("shareOpenBox", ["[NAME]", global.user.name]), null, null, null);
    }
    function onOk()
    {
        global.director.popView();
    }
    var rewards;
    function BoxReward(r)
    {
        rewards = r;
        initView();
    }
}
