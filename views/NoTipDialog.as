/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class NoTipDialog extends MyNode
{

    var kind;
    //word
    function NoTipDialog(k)
    {
        kind = k;

        bg = sprite("tipBack.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50).size(506, 333);
        init();
        bg.addlabel(getStr(TIP_WORD[kind], null), "fonts/heiti.ttf", 35).anchor(50, 50).pos(261, 33).color(100, 100, 100);

        var but0 = new NewButton("noTip.png", [93, 23], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(410, 278);
        addChild(but0);

        //行间距 25
        var w = getStr(TIP_CON[kind], null);
        var word = stringLines(w, 18, 25, [0, 0, 0], FONT_NORMAL);
        word.pos(46, 130);
        bg.add(word);

        but0 = new NewButton("closeBut.png", [40, 39], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeNoTip, null);
        but0.bg.pos(474, 88);
        addChild(but0);
        //bg.addsprite("closeBut.png").anchor(50, 50).pos(470, 84).setevent(EVENT_TOUCH, closeNoTip);
    }
    function closeNoTip()
    {
        global.director.popView();
    }
    function closeDialog()
    {
        trace("closeNoTip", kind);
        var readYet = global.user.db.get("readYet", dict());
        if(type(readYet) != type(dict()))
        {
            readYet = dict();
        }
        readYet.update(kind, 1);
        global.user.db.put("readYet", readYet);

        /*
        if(kind == CHALLENGE_TIP)
            global.user.db.put("readYet", 1);
        else if(kind == TRAIN_TIP)
            global.user.db.put("trainTip", 1);
        else if(kind == FIGHT_TIP)
            global.user.db.put("fightTip", 1);
        */

        global.director.popView();
    }
}
