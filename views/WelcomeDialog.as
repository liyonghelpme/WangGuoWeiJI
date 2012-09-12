/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png


增加分行距
*/
class WelcomeDialog extends MyNode
{
    function WelcomeDialog()
    {
        bg = node();
        init();
        var prW = new BackWord(this, getStr("welcomeWord", null), 30, 15, [100, 100, 100], 800, 0, 4, closeDialog, FONT_BOLD);//100ms 打字速度
        prW.setPos([39, 174]);
        //得到字符串包括换行符号 的总字符长度 totalNum 打印
        prW.setCommand([[PRINT, getWordLen(getStr("welcomeWord", null))]]);
        addChild(prW);//tick = 50ms 2tick = 100ms
    }
    function closeDialog()
    {
        //global.director.popScene();
        global.director.replaceScene(new NewBattle());
    }
}
