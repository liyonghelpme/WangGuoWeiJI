class SearchDialog extends MyNode
{
    var inputView;
    var warnText;
    var inConnect = 0;
    function SearchDialog()
    {
        bg = node();
        init();
bg.addsprite("back.png", ARGB_8888).anchor(0, 0).pos(186, 134).size(448, 237).color(100, 100, 100, 100);
bg.addsprite("parchment.png", ARGB_8888).anchor(0, 0).pos(198, 160).size(422, 207).color(100, 100, 100, 100);
        inputView = v_create(V_INPUT_VIEW, 345, 215, 230, 50);


warnText = bg.addlabel(getStr("inputInvite", null), getFont(), 15).anchor(0, 50).pos(346, 276).color(43, 25, 9);
bg.addsprite("smallBack.png", ARGB_8888).anchor(50, 50).pos(415, 138).size(332, 57).color(100, 100, 100, 100);
bg.addlabel(getStr("searchPlayer", null), getFont(), 27).anchor(50, 50).pos(422, 138).color(32, 33, 40);
        var but0 = new NewButton("roleNameBut0.png", [138, 49], getStr("ok", null), null, 25, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(302, 367);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [138, 49], getStr("cancel", null), null, 25, FONT_NORMAL, [100, 100, 100], onCancel, null);
        but0.bg.pos(513, 368);
        addChild(but0);
bg.addsprite("searchPeople.png", ARGB_8888).anchor(0, 0).pos(236, 210).size(87, 91).color(100, 100, 100, 100);
    }
    //因为输入框是最高的view 会阻挡其他view 的显示所以需要关闭 之后显示结果
    function onOk()
    {
        if(inConnect)
            return;
        global.director.popView();
        var inCode = inputView.text();
        if(inCode == "")
        {
            warnText.text(getStr("notEmpty", null));
            warnText.color(100, 0, 0);
            return;
        }
        global.httpController.addRequest("friendC/sendNeiborInviteRequest", dict([["uid", global.user.uid], ["inviteCode", inCode]]), sendInviteOver, null);
        inConnect = 1;
    }
    function sendInviteOver(rid, rcode, con, param)
    {
        inConnect = 0;
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con["id"])
            {
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("neiReqSuc", null), [100, 100, 100], null));
            }
            else 
            {
                if(con["status"] == 0)
                {
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("errorCode", null), [100, 100, 100], null));
                }
                else if(con["status"] == 1)
                {
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("noCode", null), [100, 100, 100], null));
                }
                else
                {
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("reqYet", null), [100, 100, 100], null));
                }
            }
        }
    }
    function onCancel()
    {
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
