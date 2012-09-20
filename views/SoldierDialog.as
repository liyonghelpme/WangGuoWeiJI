class SoldierDialog extends MyNode
{
    var allView = null;
    var deadView = null;
    var transferView = null;
    var title;

    function SoldierDialog(viewId)
    {
        bg = sprite("dialogFriend.png");
        init();
        bg.addsprite("dialogSoldier.png").anchor(50, 50).pos(163, 38);
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        title = bg.addsprite("dialogSoldierTitle.png").pos(336, 85);

        var but0 = bg.addsprite("roleNameBut0.png").pos(440, 41).size(99, 37).anchor(50, 50).setevent(EVENT_TOUCH, switchView, 0);
but0.addlabel(getStr("allSoldier", null), "fonts/heiti.ttf", 25).pos(50, 18).anchor(50, 50);
        but0 = bg.addsprite("roleNameBut0.png").pos(555, 41).size(99, 37).anchor(50, 50).setevent(EVENT_TOUCH, switchView, 1);
but0.addlabel(getStr("dead", null), "fonts/heiti.ttf", 25).pos(50, 18).anchor(50, 50);
        but0 = bg.addsprite("roleNameBut0.png").pos(670, 41).size(99, 37).anchor(50, 50).setevent(EVENT_TOUCH, switchView, 2);
but0.addlabel(getStr("transfer", null), "fonts/heiti.ttf", 25).pos(50, 18).anchor(50, 50);
        switchView(null, null, viewId, null, null, null);
    }
    //0 all
    //1 dead
    //2 transfer
    var selected = null;
    function switchView(n, e, p, x, y, points)
    {
        if(selected != p)
        {
            if(selected == 0)
                allView.removeSelf();
            else if(selected == 1)
                deadView.removeSelf();
            else if(selected == 2)
                transferView.removeSelf();
            selected = p;
            if(p == 0)
            {
                if(allView == null)
                    allView = new AllSoldier();
                addChild(allView);
                title.texture("dialogSoldierTitle.png");
            }
            else if(p == 1)
            {
                if(deadView == null)
                    deadView = new DeadSoldier();
                addChild(deadView);
                title.texture("dialogSoldierDead.png");
            }
            else if(p == 2)
            {
                if(transferView == null)
                    transferView = new TransferSoldier();
                addChild(transferView);
                title.texture("dialogSoldierTrans.png");
            }
        }
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
