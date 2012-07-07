class LevupDialog extends MyNode
{
    const POS = [[165, 186], [377, 186]]
    function LevupDialog()
    {
        bg = sprite("dialogLoginBack.png");
        var dia = bg.addsprite("dialogLevup.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        var but0 = dia.addsprite("roleNameBut1.png").pos(78, 326).size(173, 53).setevent(EVENT_TOUCH, closeDialog);
        but0.addlabel(getStr("ok", null), null, 25).pos(86, 27).anchor(50, 50).color(100, 100, 100);

        but0 = dia.addsprite("roleNameBut0.png").pos(291, 326).size(173, 53);
        but0.addlabel(getStr("share", null), null, 25).pos(86, 27).anchor(50, 50).color(100, 100, 100);

        dia.addsprite("soldier0.png").pos(165, 186).anchor(50, 50).size(109, 108);
        dia.addsprite("soldier1.png").pos(377, 186).anchor(50, 50).size(109, 108);

        dia.addlabel("name", null, 17).pos(165, 250).anchor(50, 50).color(0, 0, 0);
        dia.addlabel("name", null, 17).pos(377, 250).anchor(50, 50).color(0, 0, 0);

        dia.addlabel(str(global.user.getValue("level")), null, 35).pos(502, 60).anchor(50, 50).color(100, 100, 100);

        showCastleDialog();
    }
    function closeDialog()
    {
        closeCastleDialog();
        //global.director.popView();
    }

}
