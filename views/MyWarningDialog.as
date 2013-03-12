class MyWarningDialog extends MyNode
{
    var callback;
    function MyWarningDialog(title, words, cb)
    {
        callback = cb;
bg = sprite("roleName.png", ARGB_8888).pos(global.director.disSize[0] / 2, global.director.disSize[1] / 2).anchor(50, 50);
        init();
bg.addlabel(title, getFont(), 30, FONT_BOLD).pos(243, 29).anchor(50, 50).color(0, 0, 0);
bg.addlabel(words, getFont(), 25, FONT_NORMAL, 263, 118, ALIGN_LEFT).pos(177, 86).color(0, 0, 0);
var peop = bg.addsprite("soldier0.png", ARGB_8888).pos(61, 86);
        peop.prepare();
        var bsize = peop.size();
        var sca = min(111*100/bsize[0], 111*100/bsize[1]);
        peop.scale(sca);

        var but;
        if(callback == null)
        {
but = bg.addsprite("roleNameBut0.png", ARGB_8888).size(145, 46).pos(251, 265).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
but.addlabel(getStr("ok", null), getFont(), 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
        }
        else
        {
but = bg.addsprite("roleNameBut0.png", ARGB_8888).size(145, 46).pos(152, 265).anchor(50, 50).setevent(EVENT_TOUCH, onOk);
but.addlabel(getStr("ok", null), getFont(), 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
but = bg.addsprite("roleNameBut1.png", ARGB_8888).size(145, 46).pos(350, 265).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
but.addlabel(getStr("cancel", null), getFont(), 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
        }

        showCastleDialog();
    }
    function onOk()
    {
        closeCastleDialog();
        callback();
    }
    function closeDialog()
    {
        closeCastleDialog();
    }
}

