class LoginDialog extends MyNode
{
    //与商店相同的编号
    const reward = [[SILVER, 1000], [GOLD, 1000], [CRYSTAL, 100], [SILVER, 2000]];
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
    const REWARD = [[97, 263], [233, 263], [369, 263]];
    function LoginDialog()
    {
        bg = sprite("dialogLoginBack.png").size(global.director.disSize[0], global.director.disSize[1]);
        init();
        var dia = bg.addsprite("dialogLogin.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);  
        dia.addsprite("roleNameClose.png").pos(590, 31).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        var but0 = dia.addsprite("roleNameBut1.png").pos(61, 354).size(209, 61).setevent(EVENT_TOUCH, closeDialog);
        but0.addlabel(getStr("nextTime", null), null, 25).pos(104, 30).anchor(50, 50);
        but0 = dia.addsprite("roleNameBut0.png").pos(323, 354).size(209, 61).setevent(EVENT_TOUCH, shareGift);
        but0.addlabel(getStr("shareGift", null), null, 25).pos(104, 30).anchor(50, 50);

        var loginDays = global.user.getValue("loginDays");
        //第0天登录怎么办?
        var now = loginDays-1;
        loginDays = (loginDays-1)%len(reward);
        trace("now", now, loginDays);

        for(var i = 0; i < 3; i++)
        {
            dia.addlabel(str(now), null, 25).pos(WORDS[i]).anchor(0, 50).color(79, 44, 14);        
            dia.addsprite(PICS.get(reward[loginDays][0])).pos(POS[i]).anchor(50, 50).size(57, 53);
            dia.addlabel(str(reward[loginDays][1]), null, 25).color(68, 4, 7).anchor(50, 50).pos(REWARD[i]);
            loginDays += 1;
            loginDays %= len(reward);
            now += 1;
        }
        dia.addlabel(str(now), null, 25).pos(WORDS[i]).anchor(0, 50).color(79, 44, 14);        
        dia.addsprite("loginQuestionMark.png").pos(495, 203).anchor(50, 0);

        showCastleDialog();

    }
    function closeDialog()
    {
        closeCastleDialog();
        //global.director.popView();
    }
    function shareGift()
    {
        closeDialog();
    }
}
