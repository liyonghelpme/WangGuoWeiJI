class DetailDialog extends MyNode
{
    var soldier;
    function DetailDialog(sol)
    {
        soldier = sol;
        bg = sprite("dialogDetail.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addlabel(soldier.myName+"("+soldier.data.get("name")+")", null, 30).anchor(50, 50).pos(280, 26).color(0, 0, 0);
        bg.addsprite("roleNameClose.png").pos(499, 9).setevent(EVENT_TOUCH, closeDialog);
        bg.addlabel(getStr("attVal", null), null, 20).pos(36, 95).color(0, 0, 0);
        bg.addlabel(getStr("defVal", null), null, 20).pos(36, 125).color(0, 0, 0);
        bg.addlabel(getStr("health", null), null, 20).pos(36, 155).color(0, 0, 0);
        bg.addlabel(getStr("attSpeed", null), null, 20).pos(36, 185).color(0, 0, 0);
        bg.addlabel(getStr("attRange", null), null, 20).pos(36, 215).color(0, 0, 0);
        bg.addlabel(getStr("recLife", null), null, 20).pos(36, 245).color(0, 0, 0);
        bg.addlabel(getStr("levVal", null), null, 20).pos(36, 275).color(0, 0, 0);
        bg.addlabel(getStr("nextTrans", null), null, 20).pos(36, 305).color(0, 0, 0);

        trace("soldierpng", soldier.id);
        bg.addsprite("soldier"+str(soldier.id)+".png").pos(460, 283).anchor(50, 50).size(90, 90);
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
