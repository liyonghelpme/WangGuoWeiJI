
class BattleEnd extends MyNode
{
    function BattleEnd()
    {
        bg = node();
        init();
        var prW = new BackWord(this, getStr("battleEnd0", null), 30, 15, [100, 100, 100], 800, 0, 4, closeDialog, FONT_BOLD);
        prW.setPos([41, 212]);
        var cmd = [];
        cmd.append([SET_TIME, 4]);
        cmd.append([PRINT, 25]);
        cmd.append([SET_TIME, 10]);
        cmd.append([PRINT, 26]);
        cmd.append([SET_TIME, 20]);
        cmd.append([PRINT, 27]);
        cmd.append([SET_TIME, 4]);
        cmd.append([BACK_PRINT, 17]);
        cmd.append([SET_WORD, "battleEnd1"]);
        cmd.append([PRINT, 28]);

        prW.setCommand(cmd);
        addChild(prW);//tick = 50ms 2tick = 100ms
    }
    function closeDialog()
    {
        //global.director.popScene();
        global.director.replaceScene(new SelectHero());
    }
}
