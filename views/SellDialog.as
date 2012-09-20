class SellDialog extends MyNode
{
    var sellObj;
    function SellDialog(o)
    {
        sellObj = o;
        bg = sprite("roleName.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        //bg.addsprite("roleNameClose.png").pos(526, 34).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
bg.addlabel(getStr("sellTitle", null), "fonts/heiti.ttf", 30, FONT_BOLD).pos(243, 29).anchor(50, 50).color(0, 0, 0);
bg.addlabel(getStr("sellContent", ["[NAME]", sellObj.data.get("name")]), "fonts/heiti.ttf", 25, FONT_NORMAL, 263, 118, ALIGN_LEFT).pos(177, 86).color(0, 0, 0);
        var peop = bg.addsprite("soldier0.png").pos(61, 86);
        peop.prepare();
        var bsize = peop.size();
        var sca = min(111*100/bsize[0], 111*100/bsize[1]);
        peop.scale(sca);

        var but = bg.addsprite("roleNameBut0.png").size(145, 46).pos(152, 265).anchor(50, 50).setevent(EVENT_TOUCH, sell);
but.addlabel(getStr("ok", null), "fonts/heiti.ttf", 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
        but = bg.addsprite("roleNameBut1.png").size(145, 46).pos(350, 265).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
but.addlabel(getStr("cancel", null), "fonts/heiti.ttf", 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);

        showCastleDialog();
    }
    function sell()
    {
        sellObj.sureToSell(); 
        //global.director.popView();
        closeCastleDialog();
    }
    function closeDialog()
    {
        //global.director.popView();
        closeCastleDialog();
    }
}

