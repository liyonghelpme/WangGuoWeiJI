class CastlePage extends MyNode
{
    var touchDelegate;
    function CastlePage()
    {
        bg = sprite("busiBack.png");
        init();
        /*
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;
        touchDelegate.enterScene();
        */
    }
}
