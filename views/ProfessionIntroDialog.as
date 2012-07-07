/*
首先检测资源是否足够 再去查看职业详细信息

等级不足未开启则不能显示信息
等级足够开启之后可以显示信息
*/
class ProfessionIntroDialog extends MyNode
{
    var solStore;
    var id;
    function ProfessionIntroDialog(ss, i)
    {
        solStore = ss;
        id = i;

        bg = sprite("roleName.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        var data = getData(SOLDIER, id);

        //bg.addsprite("roleNameClose.png").pos(526, 34).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        bg.addlabel(getStr("solIntro", ["[NAME]", data.get("name")]), null, 30, FONT_BOLD).pos(243, 29).anchor(50, 50).color(0, 0, 0);

        var des = soldierDes.get(data.get("desId"));
        des = getStr(des, null);
        bg.addlabel(des, null, 18, FONT_NORMAL, 287, 118, ALIGN_LEFT).pos(142, 84).color(0, 0, 0).anchor(0, 0);

        var peop = bg.addsprite("soldier"+str(id)+".png").anchor(50, 50).pos(89, 137);
        var sca = getSca(peop, [86, 97]);
        peop.scale(sca);

        if(solStore != null)
        {
            var but = bg.addsprite("roleNameBut0.png").size(145, 46).pos(152, 265).anchor(50, 50).setevent(EVENT_TOUCH, onBuy);
            but.addlabel(getStr("sureToBuy", null), null, 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
            but = bg.addsprite("roleNameBut1.png").size(145, 46).pos(350, 265).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
            but.addlabel(getStr("cancel", null), null, 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
        }
        else
        {
            but = bg.addsprite("roleNameBut0.png").size(145, 46).pos(237, 265).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
            but.addlabel(getStr("ok", null), null, 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
        }

        showCastleDialog();
    }
    function onBuy()
    {
        //global.director.popView();
        closeCastleDialog();
        solStore.buySoldier(id);
    }
    function closeDialog()
    {
        //global.director.popView();
        closeCastleDialog();
    }
}
