class LevupDialog extends MyNode
{
    const POS = [[165, 186], [377, 186]]
    var cmd;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        bg.add(showFullBack());
        temp = bg.addsprite("back.png").anchor(0, 0).pos(150, 93).size(520, 312).color(100, 100, 100, 100);
        temp = bg.addsprite("parchment.png").anchor(0, 0).pos(168, 118).size(493, 298).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 65).size(418, 57).color(100, 100, 100, 100);

        temp = bg.addsprite("leftBalloon.png").anchor(0, 0).pos(41, 73).size(136, 302).color(100, 100, 100, 100);
        temp = bg.addsprite("rightBalloon.png").anchor(0, 0).pos(664, 39).size(120, 343).color(100, 100, 100, 100);

        temp = bg.addsprite("levelUpGoodsBack.png").anchor(0, 0).pos(437, 174).size(167, 144).color(100, 100, 100, 100);
        temp = bg.addsprite("unlockGoods.png").anchor(0, 0).pos(424, 165).size(81, 27).color(100, 100, 100, 100);

        temp = bg.addsprite("levelUpGoodsBack.png").anchor(0, 0).pos(224, 175).size(167, 144).color(100, 100, 100, 100);
        temp = bg.addsprite("unlockGoods.png").anchor(0, 0).pos(211, 166).size(81, 27).color(100, 100, 100, 100);
        temp = bg.addsprite("levelUpStar.png").anchor(0, 0).pos(589, 53).size(113, 113).color(100, 100, 100, 100);

        var initX = 311; 
        var initY = 243;
        var OFFX = 213;
        var thing = getLevelupThing();

        for(var i = 0; i < 2; i++)
        {
            var kind = thing[i][0];
            var id = thing[i][1].get("id");
            var data = getData(kind, id);
            
            var picName = replaceStr(KindsPre[kind], ["[ID]", str(id)]);
            temp = bg.addsprite(picName).anchor(50, 50).pos(initX, 243).color(100, 100, 100, 100);
            sca = getSca(temp, [86, 83]);
            temp.scale(sca);

            bg.addlabel(data["name"], "fonts/heiti.ttf", 20).anchor(50, 50).pos(initX, 302).color(43, 25, 9);

            initX += OFFX;
        }

        temp = altasWord("yellow", str(global.user.getValue("level") + 1));
        temp.pos(647, 115).anchor(50, 50);
        bg.add(temp);

        bg.addlabel(getStr("levelUpShare", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(410, 350).color(28, 15, 4);
        bg.addlabel(getStr("levelUp", null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(425, 94).color(32, 33, 40);
        but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("share", null), null, 27, FONT_NORMAL, [100, 100, 100], onShare, null);
        but0.bg.pos(299, 402);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 27, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(519, 402);
        addChild(but0);
    }
    function onShare()
    {
        
    }
    function LevupDialog(c)
    {
        cmd = c;
        initView();
    }
    function closeDialog()
    {
        global.director.popView();

        var cp = cmd.get("castlePage");
        cp.fallGoods.getLevelUpFallGoods();
//        trace("fallThing", cp);

        /*
        var level = global.user.getValue("level");
        if(level == 4 || level == 6 || level == 10)
        {
            if(global.user.rated == 0)
            {
                cp.dialogController.addCmd(dict([["cmd", "rate"]])); 
            }
        }
        */
    }

}
