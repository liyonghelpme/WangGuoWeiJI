
class BattleEnd extends MyNode
{
    function BattleEnd()
    {
        bg = node();
        init();
        var prW = new PrintWord(this, getStr("battleEnd", null), 22, 5, [100, 100, 100], 640, 0, 6, closeDialog);
        prW.setPos([100, 120]);
        addChild(prW);//tick = 50ms 2tick = 100ms
    }
    function closeDialog()
    {
        //global.director.popScene();
        global.director.replaceScene(new SelectHero());
    }
}
