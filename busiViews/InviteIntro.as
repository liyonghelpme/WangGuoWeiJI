class InviteIntro extends MyNode
{
    function InviteIntro()
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
        temp = bg.addsprite("systemCompetitionBack.png").anchor(50, 50).pos(412, 227).size(506, 333).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [40, 39], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(634, 149);
        addChild(but0);
        but0 = new NewButton("roleNameBut0.png", [91, 37], getStr("inviteRank", null), null, 17, FONT_NORMAL, [100, 100, 100], onInviteRank, null);
        but0.bg.pos(384, 341);
        addChild(but0);
        but0 = new NewButton("violetBut.png", [91, 38], getStr("inputeInviteCode", null), null, 17, FONT_NORMAL, [100, 100, 100], onInputeInviteCode, null);
        but0.bg.pos(482, 342);
        addChild(but0);
        but0 = new NewButton("blueButton.png", [91, 38], getStr("shareInvite", null), null, 17, FONT_NORMAL, [100, 100, 100], onShareInvite, null);
        but0.bg.pos(580, 342);
        addChild(but0);
        line = stringLines(getStr("inviteContent", ["[GOLD]", str(PARAMS["inviteGold"]), "[CODE]", str(global.user.getInviteCode())]), 18, 23, [0, 0, 0], FONT_NORMAL );
        line.pos(212, 197);
        bg.add(line);
        bg.addlabel(getStr("inviteFriend", null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(406, 95).color(100, 100, 100);
    }
    function onShareInvite()
    {
        global.director.popView();
        doShare(getStr("inviteShare", ["[NAME]", global.user.name, "[CODE]", str(global.user.getInviteCode())]), null, null, null, null);
    }

    function onInputeInviteCode()
    {
        global.director.popView();
        global.director.pushView(new InviteInput(), 1, 0);
    }

    function onInviteRank()
    {
        global.director.popView();
        global.director.pushView(new RankDialog(INVITE_RANK), 1, 0);
    }

    function closeDialog()
    {
        global.director.popView();
    }

}
