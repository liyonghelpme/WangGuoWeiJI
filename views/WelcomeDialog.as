/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class WelcomeDialog extends MyNode
{
    function WelcomeDialog()
    {
        bg = node();
        init();
        var prW = new PrintWord(this, getStr("welcomeWord", null), 22, 5, [100, 100, 100], 640, 0, 6, closeDialog);
        prW.setPos([100, 120]);
        addChild(prW);//tick = 50ms 2tick = 100ms
    }
    function closeDialog()
    {
        //global.director.popScene();
        global.director.replaceScene(new NewBattle());
    }
}
