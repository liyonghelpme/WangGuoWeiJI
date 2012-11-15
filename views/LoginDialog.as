class LoginDialog extends MyNode
{
    //与商店相同的编号
    //const reward = [[SILVER, 1000], [GOLD, 1000], [CRYSTAL, 100], [SILVER, 2000]];
    /*
    根据用户当前连续登录的数据得到需要得到的奖励
    */

    const PICS = dict([
    [SILVER, "silverBig.png"],
    [GOLD, "goldBig.png"],
    [CRYSTAL, "crystalBig.png"],
    ]);
    const POS = [[97, 229], [233, 229], [369, 229]];
    const WORDS = [[108, 174], [241, 174], [375, 174], [504, 174]];
    const REWARD = [[97, 270], [233, 270], [369, 270]];
    var curCmd;


    function LoginDialog(cc)
    {
        curCmd = cc;
        bg = node();
        bg.add(showFullBack());
        init();

        var loginDays = curCmd.get("loginDays");//global.user.getValue("loginDays");
        var now = loginDays-1;

        bg.addsprite("back.png").anchor(0, 0).pos(99, 79).size(604, 344);
        bg.addsprite("loginBack.png").anchor(0, 0).pos(122, 128).size(557, 277);
        bg.addsprite("whiteBox.png").anchor(0, 0).pos(544, 192).size(109, 153);
        bg.addsprite("loginQuestion.png").anchor(50, 50).pos(601, 260).size(62, 64);

        bg.addsprite("whiteBox.png").anchor(0, 0).pos(412, 192).size(109, 153);


        //bg.addsprite("白色框.png").anchor(0, 0).pos(0, 0).size(115, 159);
        //bg.addsprite("被粘贴的图层.png").anchor(0, 0).pos(3, 3).size(109, 153);
        //bg.addsprite("whiteBox.png").anchor(0, 0).pos(279, 192).size(115, 153);
        bg.addsprite("blueBox.png").anchor(0, 0).pos(279, 192).size(115, 153);


        bg.addsprite("hook.png").anchor(0, 0).pos(258, 171).size(53, 42);
        bg.addsprite("whiteBox.png").anchor(0, 0).pos(147, 192).size(109, 153);
        bg.addsprite("hook.png").anchor(0, 0).pos(129, 171).size(53, 42);


        bg.addlabel(getStr("infoFri", null), "fonts/heiti.ttf", 19).anchor(50, 50).pos(400, 370).color(66, 46, 28);
        var but0 = new NewButton("roleNameBut0.png", [190, 60], getStr("share", null), null, 30, FONT_NORMAL, [100, 100, 100], shareGift, null);
        but0.bg.pos(251, 420);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [190, 60], getStr("ok", null), null, 30, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(545, 421);
        addChild(but0);
        bg.addsprite("scroll.png").anchor(0, 0).pos(130, 101).size(541, 67);
        bg.addlabel(getStr("continLogin", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(395, 139).color(43, 25, 9);
        bg.addsprite("smallBack.png").anchor(0, 0).pos(159, 49).size(484, 62);
        bg.addlabel(getStr("loginReward", null), "fonts/heiti.ttf", 32).anchor(50, 50).pos(402, 82).color(32, 33, 40);



        var rew = getLoginReward(now);
        var its = rew.items();
        bg.addsprite(its[0][0]+".png").anchor(50, 50).pos(202, 265).size(60, 58);
        bg.addlabel(getStr("dayN", ["[NUM]", str(now)]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(205, 213).color(43, 25, 9);
        bg.addlabel(str(its[0][1]), "fonts/heiti.ttf", 18).anchor(50, 50).pos(201, 307).color(43, 25, 9);
        
        now += 1;
        rew = getLoginReward(now);
        its = rew.items();
        bg.addlabel(getStr("dayN", ["[NUM]", str(now)]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(334, 213).color(43, 25, 9);
        bg.addsprite(its[0][0]+".png").anchor(50, 50).pos(334, 265).size(60, 58);
        bg.addlabel(str(its[0][1]), "fonts/heiti.ttf", 18).anchor(50, 50).pos(334, 307).color(43, 25, 9);
        bg.addlabel(getStr("today", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(333, 332).color(43, 25, 9);


        now += 1;
        rew = getLoginReward(now);
        its = rew.items();
        bg.addlabel(getStr("dayN", ["[NUM]", str(now)]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(466, 213).color(43, 25, 9);
        bg.addlabel(str(its[0][1]), "fonts/heiti.ttf", 18).anchor(50, 50).pos(467, 307).color(43, 25, 9);
        bg.addsprite(its[0][0]+".png").anchor(50, 50).pos(467, 262).size(61, 57);
        bg.addlabel(getStr("tomorrow", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(467, 332).color(43, 25, 9);

        now += 1;
        bg.addlabel(getStr("dayN", ["[NUM]", str(now)]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(599, 213).color(43, 25, 9);

        bg.addsprite("rightBalloon.png").anchor(0, 0).pos(698, 26).size(133, 380);
        bg.addsprite("leftBalloon.png").anchor(0, 0).pos(-23, 46).size(150, 335);

    }
    function closeDialog()
    {
        closeCastleDialog();
        var loginDays = curCmd.get("loginDays");//global.user.getValue("loginDays");
        var reward = getLoginReward(loginDays);
//        trace("loginReward", loginDays, reward);
        global.user.doAdd(reward);
        /*
        global.user.changeValue("silver", reward.get("silver"));
        global.user.changeValue("crystal", rew.get("crystal"));
        */
    }
    function shareGift()
    {
        closeDialog();
    }
}
