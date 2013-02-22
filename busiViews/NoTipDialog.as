class NoTipDialog extends MyNode
{
    var kind;
    function NoTipDialog(k)
    {
        kind = k;
        initView();
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("systemCompetitionBack.png").anchor(50, 50).pos(413, 227).size(506, 333).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [40, 39], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(634, 149);
        addChild(but0);
        but0 = new NewButton("noTip.png", [99, 29], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeNoTip, null);
        but0.bg.pos(570, 339);
        addChild(but0);

        bg.addlabel(getStr(TIP_WORD[kind], null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(411, 92).color(100, 100, 100);
        
        var w = getStr(TIP_CON[kind], null);
        line = stringLines(w, 20, 30, [0, 0, 0], FONT_NORMAL);
        line.pos(206, 191);
        bg.add(line);
    }
    function closeDialog()
    {
        global.director.popView();
    }

    function closeNoTip()
    {
        global.director.popView();

        var readYet = global.user.db.get("readYet", dict());
        if(type(readYet) != type(dict()))
        {
            readYet = dict();
        }
        readYet.update(kind, 1);
        global.user.db.put("readYet", readYet);
    }
}
