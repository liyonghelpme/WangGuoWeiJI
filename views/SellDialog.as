class SellDialog extends MyNode
{
    var sellObj;
    function SellDialog(o)
    {
        sellObj = o;
        bg = sprite("roleName.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addsprite("roleNameClose.png").pos(526, 34).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        bg.addlabel(getStr("sellTitle", null), null, 30, FONT_BOLD).pos(265, 31).anchor(50, 50).color(0, 0, 0);
        bg.addlabel(getStr("sellContent", ["[NAME]", sellObj.data.get("name")]), null, 25, FONT_NORMAL, 263, 118, ALIGN_LEFT).pos(177, 86).color(0, 0
        var peop = bg.addsprite("soldier0.png").pos(61, 86);
        peop.prepare();
        var bsize = peop.size();
        var sca = min(111*100/bsize[0], 111*100/bsize[1]);
        peop.scale(sca);

        var but = bg.addsprite("roleNameBut0.png").size(180, 65).pos(152, 265).anchor(50, 50).setevent(EVENT_TOUCH, sell);
        but.addlabel(getStr("ok", null), null, 35).anchor(50, 50).color(100, 100, 100).pos(90, 32);
        but = bg.addsprite("roleNameBut1.png").size(180, 65).pos(370, 265).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        but.addlabel(getStr("cancel", null), null, 35).anchor(50, 50).color(100, 100, 100).pos(90, 32);
    }
    function sell()
    {
        sellObj.sureToSell(); 
        global.director.popView();
    }
    function closeDialog()
    {
        global.director.popView();
    }
}

