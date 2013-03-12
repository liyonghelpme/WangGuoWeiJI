class ScoreDialog extends MyNode
{
    function initView()
    {
        bg = node();
        bg.add(showFullBack());
        init();
        var but0;
        var line;
        var temp;
        var sca;
temp = bg.addsprite("back.png", ARGB_8888).anchor(0, 0).pos(150, 93).size(520, 312).color(100, 100, 100, 100);
temp = bg.addsprite("loginBack.png", ARGB_8888).anchor(0, 0).pos(169, 137).size(481, 252).color(100, 100, 100, 100);
temp = bg.addsprite("smallBack.png", ARGB_8888).anchor(0, 0).pos(201, 65).size(418, 57).color(100, 100, 100, 100);
temp = bg.addsprite("scoreWhite.png", ARGB_8888).anchor(0, 0).pos(195, 177).size(384, 176).color(100, 100, 100, 100);
temp = bg.addsprite("scroll.png", ARGB_8888).anchor(0, 0).pos(223, 114).size(374, 57).color(100, 100, 100, 100);
temp = bg.addsprite("scoreStar.png", ARGB_8888).anchor(0, 0).pos(233, 196).size(217, 38).color(100, 100, 100, 100);
        
        //bg.addsprite("rightBalloon.png").anchor(0, 0).pos(698, 26).size(133, 380);
        //bg.addsprite("leftBalloon.png").anchor(0, 0).pos(-23, 46).size(150, 335);
        //temp = bg.addsprite("leftBalloon.png").anchor(0, 0).pos(41, 73).size(136, 302).color(100, 100, 100, 100);
        //temp = bg.addsprite("rightBalloon.png").anchor(0, 0).pos(649, 41).size(136, 342).color(100, 100, 100, 100);
temp = bg.addsprite("leftBalloon.png", ARGB_8888).anchor(0, 0).pos(41, 73).size(136, 302).color(100, 100, 100, 100);
temp = bg.addsprite("rightBalloon.png", ARGB_8888).anchor(0, 0).pos(666, 37).size(120, 343).color(100, 100, 100, 100);


temp = bg.addsprite("princess.png", ARGB_8888).anchor(0, 0).pos(463, 156).size(212, 264).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("scoreNow", null), null, 27, FONT_NORMAL, [100, 100, 100], onRate, null);
        but0.bg.pos(299, 403);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("nextTime", null), null, 27, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(519, 403);
        addChild(but0);
bg.addlabel(getStr("scoreSecTitle", null), getFont(), 20).anchor(50, 50).pos(416, 145).color(43, 25, 9);
temp = bg.addlabel(getStr("feedbackHandle", null), getFont(), 18, FONT_NORMAL, 252, 0, ALIGN_LEFT).anchor(0, 0).pos(211, 254).color(28, 15, 4);
bg.addlabel(getStr("loveGame", null), getFont(), 30).anchor(50, 50).pos(425, 94).color(32, 33, 40);


    }
    function ScoreDialog()
    {
        initView();
    }
    function onRate()
    {
        closeDialog();
        global.user.setRated();
        global.msgCenter.sendMsg(RATE_GAME, null);

        openUrl(getStr("rateUrl", null));
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
