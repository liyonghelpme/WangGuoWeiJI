/*
防御装置位置

只负责检测 冲突
不负责更新 mapGrid

mapGridController 负责更新
checkPosCollision
checkInFlow

一重继承 super 可以访问 
二重继承 super 不能访问

采用组合方式 将 moveMap 作为成员 那么所有的访问 需要 额外的 一层引用
*/
class FightMap extends MoveMap
{
    var arena = [];

    function FightMap(sc)
    {
        scene = sc;
        bg = sprite("map5.jpg");
        init();

        moveZone = [
        [63, 203, 1000, 337],
        ];
        gridLayer = bg.addnode();
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;

        var defense = mapInfo.get(5);
        bg.addsprite("map5Def0.png", ARGB_8888).pos(defense[0]);
        bg.addsprite("map5Def1.png", ARGB_8888).pos(defense[1]);


        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);


        mapGridController = new MapGridController(this);

        solTimer = new Timer(200);
    }

    /*
    在进入场景之后 初始化士兵 所以 timer 在 进入场景之后 初始化
    或者在场景构造中 初始化 那么需要在退出场景中 销毁
    */
    override function enterScene()
    {
        super.enterScene();
    }
    override function exitScene()
    {
        super.exitScene();
        solTimer.stop();
        solTimer = null;
    }
    function touchBegan(n, e, p, x, y, points)
    {
        touchDelegate.tBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        touchDelegate.tMoved(n, e, p, x, y, points);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        touchDelegate.tEnded(n, e, p, x, y, points);
    }
    function updateData()
    {
        var i;
        for(i = 0; i < len(arena); i++)
        {
            arena[i].removeSelf();
        }
        arena = [];
        var others = scene.otherArenas;
        for(i = 0; i < len(others); i++)
        {
            var so = new FightSoldier(this, others[i], 1); 
            arena.append(so);
            addChild(so);
        }
    }


}
