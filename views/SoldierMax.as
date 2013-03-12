/*
非全局菜单显示的时候 隐藏场景菜单
显示结束的时候 回复场景菜单

pushView view
关闭view的时候 需要回复

menu检测自己不是最高层 则消失 当自己是最高层则显示

*/
/*
构建对话框的时候 关闭场景的菜单栏
关闭对话框的时候需要重性显示场景的对话框
*/
class SoldierMax extends MyNode
{
    function SoldierMax()
    {
bg = sprite("dialogDetail.png", ARGB_8888).pos(global.director.disSize[0] / 2, global.director.disSize[1] / 2).anchor(50, 50);
        init();
bg.addlabel(getStr("trainZone", null), getFont(), 30).anchor(50, 50).pos(264, 26).color(0, 0, 0);
bg.addsprite("roleNameClose.png", ARGB_8888).pos(499, 9).setevent(EVENT_TOUCH, closeDialog);
        var contentNode = bg.addnode().pos(40, 112);
contentNode.addlabel(getStr("curSolSolBound", ["[NUM1]", str(global.user.getSolNum()), "[NUM2]", str(global.user.getPeopleNum())]), getFont(), 20, FONT_BOLD).color(0, 0, 0);
contentNode.addlabel(getStr("solTip", null), getFont(), 20, FONT_NORMAL, 432, 214, ALIGN_LEFT).color(0, 0, 0).pos(0, 72);

        showCastleDialog();
    }

    function closeDialog()
    {
        closeCastleDialog();
    }
}
