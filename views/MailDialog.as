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
    function MailDialog()
    {
        bg = sprite("dialogMail.png");
        init();
        var but0 = bg.addsprite("roleNameBut0.png").size(128, 40).anchor(0, 0).pos(388, 18).setevent(EVENT_TOUCH, switchView, 0);
        but0.addlabel(getStr("friGift", null), null, 25).pos(64, 20).anchor(50, 50);
        but0 = bg.addsprite("roleNameBut0.png").size(128, 40).anchor(0, 0).pos(520, 18).setevent(EVENT_TOUCH, switchView, 1);
        but0.addlabel(getStr("moreGame", null), null, 25).pos(64, 20).anchor(50, 50)

        bg.addsprite("close2.png").pos(746, 18).setevent(EVENT_TOUCH, closeDialog);

        switchView(null, null, 0, null, null, null);
    }
    function switchView(n, e, p, x, y, points)
    {
        if(selected != p)
        {
            if(selected == 0)
                giftView.removeSelf();
            else if(selected == 1)
                moreView.removeSelf();
            selected = p;
            if(p == 0)
            {
                if(giftView == null)
                    giftView = new GiftView([7, 154], [786, 310]);
                addChild(giftView);
            }
            else if(p == 1)
            {
                if(moreView == null)
                    moreView = new MoreView([7, 85], [786, 385]);
                addChild(moreView);
            }
        }
    }

    function closeDialog()
    {
        global.director.popView();
    }
}
