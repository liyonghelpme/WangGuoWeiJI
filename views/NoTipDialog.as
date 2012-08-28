/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class NoTipDialog extends MyNode
{
    function NoTipDialog()
    {
        bg = sprite("noTipDialog.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addlabel(getStr("roundTip", null), null, 30, FONT_BOLD).anchor(50, 50).pos(253, 34).color(100, 100, 100);
        bg.addsprite("noTip.png").setevent(EVENT_TOUCH, closeDialog).pos(405, 264).anchor(50, 50);
        var word = stringLines(getStr("noTip", null), 20, 32, [0, 0, 0]);
        word.pos(67, 137);
        bg.add(word);
        bg.addsprite("close2.png").anchor(50, 50).pos(461, 96).setevent(EVENT_TOUCH, closeNoTip);
    }
    function closeNoTip()
    {
        global.director.popView();
    }
    function closeDialog()
    {
        global.user.db.put("readYet", 1);
        global.director.popView();
    }
}