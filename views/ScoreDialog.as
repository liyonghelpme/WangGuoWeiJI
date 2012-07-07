class ScoreDialog extends MyNode
{
    function ScoreDialog()
    {
        bg = sprite("dialogLoginBack.png").size(global.director.disSize[0], global.director.disSize[1]);
        var dia = bg.addsprite("dialogScore.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        var but0 = dia.addsprite("roleNameBut1.png").pos(143, 340).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog).size(174, 55);
        but0.addlabel(getStr("nextTime", null), null, 25).anchor(50, 50).pos(87, 27);

        but0 = dia.addsprite("roleNameBut0.png").pos(363, 340).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog).size(174, 55);
        but0.addlabel(getStr("ok", null), null, 25).anchor(50, 50).pos(87, 27);

        showCastleDialog();
    }
    function closeDialog()
    {
        closeCastleDialog();
        //global.director.popView();
    }
}
