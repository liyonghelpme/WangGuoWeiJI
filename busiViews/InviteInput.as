//弹出任何黑框的时候 都需要关闭 input文本条 因为会遮盖冲突
class InviteInput extends MyNode
{
    function InviteInput()
    {
        initView();
    }
    var inputView;
    var inConnect = 0;
    var warnText;
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
        but0 = new NewButton("blueButton.png", [91, 38], getStr("back", null), null, 17, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(580, 342);
        addChild(but0);
        but0 = new NewButton("roleNameBut0.png", [91, 37], getStr("ok", null), null, 17, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(468, 342);
        addChild(but0);
        temp = bg.addsprite("searchPeople.png").anchor(0, 0).pos(222, 200).size(87, 91).color(100, 100, 100, 100);
        inputView = v_create(V_INPUT_VIEW, 345, 212, 230, 50);


                            
        warnText = bg.addlabel(getStr("inputInvite", null), "fonts/heiti.ttf", 15).anchor(0, 50).pos(346, 276).color(43, 25, 9);
        bg.addlabel(getStr("inviteFriend", null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(406, 95).color(100, 100, 100);
    }
    function onOk()
    {
        if(inConnect)
            return;
        if(global.user.invite["inputYet"] == 1)
        {
            global.director.popView();
            global.director.curScene.addChild(new UpgradeBanner(getStr("inputYet", null) , [100, 100, 100], null));
            return;
        }
        if(global.user.getValue("level") >= PARAMS["inviteLevel"])
        {
            global.director.popView();
            global.director.curScene.addChild(new UpgradeBanner(getStr("level3Input", ["[LEV]", str(PARAMS["inviteLevel"])]) , [100, 100, 100], null));
            return;
        }

        var inCode = inputView.text();
        if(len(inCode) == 0 || checkNum(inCode) == 0)
        {
            warnText.text(getStr("inviteError", null));
            warnText.color(100, 9, 0);
            return;
        }

        if(int(inCode) == global.user.invite["inviteCode"])
        {
            global.director.popView();
            global.director.curScene.addChild(new UpgradeBanner(getStr("selfInvite", null) , [100, 100, 100], null));
            return;
        }

        inConnect = 1;
        global.httpController.addRequest("friendC/finishInvite", dict([["uid", global.user.uid], ["inviteCode", inCode]]), finishInvite, null); 
    }
    function finishInvite(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con["id"] == 0)
            {
                var status = con["status"];
                if(status == 2)
                {
                    global.director.popView();
                    global.director.curScene.addChild(new UpgradeBanner(getStr("noSuchUser", null) , [100, 100, 100], null));
                }
            }
            else
            {
                global.director.popView();
                global.director.curScene.addChild(new UpgradeBanner(getStr("inviteSuc", null) , [100, 100, 100], null));
            }
        }
        inConnect = 0;
    }
    function closeDialog()
    {
        if(inConnect)
            return;
        global.director.popView();
    }

    override function enterScene()
    {
        super.enterScene();
        v_root().addview(inputView);
    }
    
    override function exitScene()
    {
        inputView.removefromparent();
        super.exitScene();
    }
}
