/*
加速物品接口：
    data 成员返回名字
    getAccCost 接口返回 加速消耗
    sureToAcc 确认加速接口
*/
/*
所有经营页面显示的对话框 
在进入时 关闭菜单 在退出的时候显示菜单
*/
class AccDialog extends MyNode
{
    var accObj;
    function AccDialog(o)
    {
        accObj = o;
        bg = sprite("roleName.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addsprite("roleNameClose.png").pos(526, 34).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        bg.addlabel(getStr("accTitle", null), null, 30, FONT_BOLD).pos(265, 31).anchor(50, 50).color(0, 0, 0);
        bg.addlabel(getStr("accContent", ["[NAME]", accObj.data.get("name"), "[NUM]", str(accObj.getAccCost())]), null, 25, FONT_NORMAL, 263, 118, ALIGN_LEFT).pos(177, 86).color(0, 0, 0);
        var peop = bg.addsprite("soldier0.png").pos(61, 86);
        peop.prepare();
        var bsize = peop.size();
        var sca = min(111*100/bsize[0], 111*100/bsize[1]);
        peop.scale(sca);

        var but = bg.addsprite("roleNameBut0.png").size(180, 65).pos(152, 265).anchor(50, 50).setevent(EVENT_TOUCH, acc);
        but.addlabel(getStr("ok", null), null, 35).anchor(50, 50).color(100, 100, 100).pos(90, 32);
        but = bg.addsprite("roleNameBut1.png").size(180, 65).pos(370, 265).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        but.addlabel(getStr("cancel", null), null, 35).anchor(50, 50).color(100, 100, 100).pos(90, 32);

        showCastleDialog();
    }
    function closeDialog()
    {
        closeCastleDialog();
        //global.director.popView();
    }
    function acc()
    {
        accObj.sureToAcc();
        //global.director.popView();
        closeCastleDialog();
    }
}
