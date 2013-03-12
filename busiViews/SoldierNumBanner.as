class SoldierNumBanner extends MyNode
{
    var solNum;
    var map;
    function SoldierNumBanner(m)
    {
        map = m;
        initView();
    }
    function initView()
    {
bg = sprite("build126.png", ARGB_8888).pos((864 + 30) + 30, 800).anchor(50, 100);
        init();
solNum = bg.addlabel("50", getFont(), 22, FONT_BOLD).pos(30, 11).anchor(50, 50).color(0, 0, 0);
        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function updateSolNum(num)
    {
        solNum.text(num);
    }
    var accMoved = 0;
    var lastPoints;
    function touchBegan(n, e, p, x, y, points)
    {
        accMoved = 0;
        lastPoints = n.node2world(x, y);
        map.touchBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPoint = lastPoints;
        lastPoints = n.node2world(x, y);
        accMoved += abs(lastPoints[0]-oldPoint[0])+abs(lastPoints[1]-oldPoint[1]);
        map.touchMoved(n, e, p, x, y, points)
    }
    function touchEnded(n, e, p, x, y, points)
    {
        if(accMoved < 20)
            global.director.pushView(new SoldierMax(), 1, 0); 
        map.touchEnded(n, e, p, x, y, points)
    }
}
