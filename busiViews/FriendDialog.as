class FriendDialog extends MyNode
{
    var views = [];
    var titles = ["dialogNeibor.png", "dialogOtherFriend.png"];
    var showTitle;
    var kind;
    //从邻居页面访问好友 删除旧的场景 再替换新的场景 replaceScene
    function FriendDialog(k)
    {
        kind = k;
        bg = node();
        init();
bg.addsprite("back.png", ARGB_8888).anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
bg.addsprite("diaBack.png", ARGB_8888).anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
bg.addsprite("loginBack.png", ARGB_8888).anchor(0, 0).pos(30, 79).size(739, 386).color(100, 100, 100, 100);
        var but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeBut, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        /*
        but0 = new NewButton("blueButton.png", [113, 42], getStr("neiborTip", null), null, 20, FONT_NORMAL, [100, 100, 100], onNeiborTip, null);
        but0.bg.pos(650, 43);
        addChild(but0);
        */
        but0 = new NewButton("roleNameBut0.png", [87, 42], getStr("neibor", null), null, 20, FONT_NORMAL, [100, 100, 100], switchView, 0);
        but0.bg.pos(530, 42);
        addChild(but0);
        
        but0 = new NewButton("violetBut.png", [113, 42], getStr("otherPlayer", null), null, 20, FONT_NORMAL, [100, 100, 100], switchView, 1);
        but0.bg.pos(650, 43);
        addChild(but0);

bg.addsprite("dialogFriendTitle.png", ARGB_8888).anchor(0, 0).pos(65, 10).color(100, 100, 100, 100);
showTitle = bg.addsprite("dialogNeibor.png", ARGB_8888).anchor(50, 50).pos(398, 108).color(100, 100, 100, 100);
        
        views = [new Neibor(this), new OtherPlayer(this)];

        switchView(0);
    }
    function onNeiborTip()
    {
    }
    function closeBut()
    {
        global.director.popView();
    }
    var curSel = -1;
    function switchView(sel)
    {
        if(curSel != sel)
        {
            if(curSel != -1)
                views[curSel].removeSelf();
            curSel = sel;
            addChild(views[curSel]);
            showTitle.texture(titles[curSel], UPDATE_SIZE);
        }
    }

    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

    var showRefresh = null;
    function update(diff)
    {
        if(curSel != -1)
        {
            //trace("initYet", views[curSel].initYet);
            if(views[curSel].initYet != 1)
            {
                if(showRefresh == null)
                {
showRefresh = bg.addsprite("", ARGB_8888).addaction(repeat(animate(2000, "feed0.png", "feed1.png", "feed2.png", "feed3.png", "feed4.png", "feed5.png", "feed6.png", "feed7.png"))).anchor(50, 50).pos(402, 239);
                }
            }
            else
            {
                if(showRefresh != null )
                {
                    showRefresh.removefromparent();
                }
            }
        }
    }
}
