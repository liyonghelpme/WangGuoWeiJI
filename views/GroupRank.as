class GroupRank extends RankBase
{
    var scene;
    override function initData()
    {
        var rankOrder = global.user.rankOrder;
        data = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8], [0, 9]];
    }
    function GroupRank(p, s, sc)
    {
        scene = sc;
        bg = node().pos(p).size(s).clipping(1);
        init();
        flowNode = bg.addnode(); 
        initData();
        updateTab();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
}
