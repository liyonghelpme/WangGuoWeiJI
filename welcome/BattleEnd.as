
class BattleEnd extends MyNode
{
    var dialogController;
    function BattleEnd()
    {
        bg = node();
        init();

        dialogController = new DialogController(this);
        addChild(dialogController);
        var prW = new BackWord(this, getStr("battleEnd0", null), 30, 15, [100, 100, 100], getParam("printWidth"), 0, getParam("printTick"), closeDialog, FONT_BOLD);
        prW.setPos([69, 223]);
        var cmd = [];
        cmd.append([SET_TIME, getParam("printTick")]);
        cmd.append([PRINT, getWordLen(getStr("battleEnd0", null))-2]);
        cmd.append([SET_TIME, 10]);
        cmd.append([PRINT, getWordLen(getStr("battleEnd0", null))-1]);
        cmd.append([SET_TIME, 20]);
        cmd.append([PRINT, getWordLen(getStr("battleEnd0", null))]);
        cmd.append([SET_TIME, getParam("printTick")]);
        cmd.append([BACK_PRINT, 46]);
        cmd.append([SET_WORD, "battleEnd1"]);
        cmd.append([PRINT, getWordLen(getStr("battleEnd1", null))]);
        cmd.append([WAIT_PRINT, 1000]);

        prW.setCommand(cmd);
        addChild(prW);//tick = 50ms 2tick = 100ms
    }
    function closeDialog()
    {
        global.director.replaceScene(new SelectHero());
    }
}
