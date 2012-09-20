/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class NoTipDialog extends MyNode
{

    var kind;
    function NoTipDialog(w, k)
    {
        kind = k;

        bg = sprite("noTipDialog.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
bg.addlabel(getStr("tips", null), "fonts/heiti.ttf", 30, FONT_BOLD).anchor(50, 50).pos(253, 34).color(100, 100, 100);


        bg.addsprite("noTip.png").setevent(EVENT_TOUCH, closeDialog).pos(423, 282).anchor(50, 50);
        var word = stringLines(w, 18, 32, [0, 0, 0], FONT_NORMAL);
        word.pos(53, 140);
        bg.add(word);
        bg.addsprite("close2.png").anchor(50, 50).pos(470, 84).setevent(EVENT_TOUCH, closeNoTip);
    }
    function closeNoTip()
    {
        global.director.popView();
    }
    function closeDialog()
    {
        if(kind == CHALLENGE_TIP)
            global.user.db.put("readYet", 1);
        else if(kind == TRAIN_TIP)
            global.user.db.put("trainTip", 1);
        else if(kind == FIGHT_TIP)
            global.user.db.put("fightTip", 1);

        global.director.popView();
    }
}
