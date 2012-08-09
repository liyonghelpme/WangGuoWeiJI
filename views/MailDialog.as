/*
FlowView
ROW_NUM
ITEM_NUM
PANEL_WIDTH
PANEL_HEIGHT

cl flowNode
getRange
updateTab

*/
class MailDialog extends MyNode
{
    var selected = -1;
    var giftView = null;
    var moreView = null;
    var requestView = null;

    var views;
    function MailDialog()
    {
        bg = sprite("dialogMail.png");
        init();
        var but0 = bg.addsprite("roleNameBut0.png").size(128, 40).anchor(0, 0).pos(250, 18).setevent(EVENT_TOUCH, switchView, 0);
        but0.addlabel(getStr("friGift", null), null, 25).pos(64, 20).anchor(50, 50);

        but0 = bg.addsprite("roleNameBut0.png").size(128, 40).anchor(0, 0).pos(400, 18).setevent(EVENT_TOUCH, switchView, 1);
        but0.addlabel(getStr("moreGame", null), null, 25).pos(64, 20).anchor(50, 50)

        but0 = bg.addsprite("roleNameBut0.png").size(128, 40).anchor(0, 0).pos(550, 18).setevent(EVENT_TOUCH, switchView, 2);
        but0.addlabel(getStr("request", null), null, 25).pos(64, 20).anchor(50, 50)

        bg.addsprite("close2.png").pos(746, 18).setevent(EVENT_TOUCH, closeDialog);
        
        giftView = new GiftView([7, 154], [786, 310]);
        moreView = new MoreView([7, 85], [786, 385]);
        requestView = new RequestView([7, 85], [786, 385]);

        views = [giftView, moreView, requestView];

        switchView(null, null, 0, null, null, null);
    }
    function switchView(n, e, p, x, y, points)
    {
        if(selected != p)
        {
            if(selected != -1)
                views[selected].removeSelf();
            selected = p;
            addChild(views[selected]);
            views[selected].updateTab();
        }
    }

    function closeDialog()
    {
        global.director.popView();
    }
}
