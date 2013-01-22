class ChallengeMsgDialog extends MyNode
{
    var challengeMsg;
    var totalCost;
    function ChallengeMsgDialog(cm)
    {
        challengeMsg = cm[0];
        totalCost = cm[1];
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
        temp = bg.addsprite("back.png").anchor(0, 0).pos(150, 91).size(520, 312).color(100, 100, 100, 100);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(169, 135).size(481, 252).color(100, 100, 100, 100);
        temp = bg.addsprite("nonFullWhiteBack.png").anchor(0, 0).pos(184, 175).size(314, 182).color(100, 100, 100, 100);
        temp = bg.addsprite("scroll.png").anchor(0, 0).pos(223, 114).size(374, 57).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 63).size(418, 57).color(100, 100, 100, 100);
        bg.addlabel(getStr("cityBeAttackedTitle", null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(425, 93).color(32, 33, 40);
        bg.addlabel(getStr("cityBeAttacked", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(408, 147).color(43, 25, 9);
        temp = bg.addsprite("dialogPrincess.png").anchor(50, 50).pos(578, 262).size(102, 165).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 27, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(414, 402);
        addChild(but0);

        var initX = 210;
        var initY = 200;
        var diffY = 42; 

        var TestTime = getclass("com.liyong.testTime.TestTime");
        //UI 固定坐标 停靠Dock 缩放
        for(var i = 0; i < 3 && i < len(challengeMsg); i++)
        {
            temp = bg.addsprite("levelUpStar.png").anchor(50, 50).pos(210, initY).size(34, 33).color(100, 100, 100, 100);
            bg.addlabel(str(challengeMsg[i]["level"]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(209, initY).color(0, 0, 0);
            bg.addlabel(challengeMsg[i]["name"], "fonts/heiti.ttf", 23).anchor(0, 50).pos(233, initY).color(0, 0, 0);
            var now = TestTime.callobj("getTime", challengeMsg[i]["time"]);

            temp = picNumWord(getStr("attackTime", ["[YEAR]", str(now["year"]), "[MON]", str(now["mon"]), "[DAY]", str(now["day"])]), 18, [0, 0, 0], 0);
            temp.pos(383, initY).color(38, 37, 36);
            bg.add(temp);

            initY += diffY;
        }
        
        temp = picNumWord(getStr("totalRobNum", ["[SIL]", str(totalCost["silver"]), "[KIND1]", "silver.png", "[CRY]", str(totalCost["crystal"]), "[KIND2]", "crystal.png"]), 18, [0, 0, 0], 0).pos(197, 350).anchor(0, 50);//文字相对于node是0 50
        bg.add(temp);
    }
    function onOk()
    {
        closeDialog();
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
