class InviteDialog extends MyNode
{
    function InviteDialog()
    {
        initView();
        var l = new InviteList(this);
        addChild(l);
    }
    function initView()
    {
        bg = node();
        init();
        bg.addsprite("loginBack.png").anchor(50, 50).pos(399, 255).size(621, 324).color(100, 100, 100, 100);
        bg.addsprite("inviteTitle.png").anchor(50, 50).pos(404, 126).color(100, 100, 100, 100);
        var but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(707, 95);
        addChild(but0);
bg.addlabel(getStr("inviteReward", ["[NUM]", str(getParam("inviteRewardSilver"))]), getFont(), 20).anchor(50, 50).pos(408, 391).color(21, 46, 50);
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
