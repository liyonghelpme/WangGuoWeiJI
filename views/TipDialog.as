class TipDialog extends MyNode
{
    function TipDialog()
    {
        bg = sprite("dialogTip.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addsprite("dialogTipNext.png").pos(549, 388).anchor(50, 50);
        bg.addsprite("close2.png").pos(632, 108).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
bg.addlabel("tip", "fonts/heiti.ttf", 30, FONT_NORMAL, 486, 236, ALIGN_LEFT).pos(89, 131).color(0, 0, 0);
bg.addlabel(getStr("pageNO", ["[NUM]", str(0)]), "fonts/heiti.ttf", 30).pos(68, 389).anchor(0, 50).color(0, 0, 0);
        showCastleDialog();
    }

    function closeDialog()
    {
        //global.director.popView();
        closeCastleDialog();
    }
}
