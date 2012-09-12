/*
防御装置位置

只负责检测 冲突
不负责更新 mapGrid

mapGridController 负责更新
checkPosCollision
checkInFlow


重写Move_Zone 确定边界
*/
class MoveMap extends MyNode
{
    var scene;
    var touchDelegate;

    var solTimer;
    var mapGridController;
    var gridLayer;

    /*
    function MoveMap(sc)
    {
        scene = sc;
        bg = sprite("map5.jpg");
        init();

        gridLayer = bg.addnode();
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;

        var defense = mapInfo.get(5);
        bg.addsprite("map5Def0.png", ARGB_8888).pos(defense[0]);
        bg.addsprite("map5Def1.png", ARGB_8888).pos(defense[1]);


        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);

        solTimer = new Timer(200);
        mapGridController = new MapGridController(this);
    }
    */

    override function enterScene()
    {
        super.enterScene();
    }
    override function exitScene()
    {
        super.exitScene();
    }

    function updateMapGrid()
    {
        gridLayer.removefromparent();
        gridLayer = bg.addnode();
        var k = mapGridController.mapDict.keys();
        for(var i = 0; i < len(k); i++)
        {
            var x = k[i]/10000;
            var y = k[i]%10000;
            var p = setBuildMap([1, 1, x, y]);

            var sp = gridLayer.addsprite("red2.png").size(SIZEX, SIZEY).pos(p).anchor(50, 100);
        }
        //trace("len grid", len(k));
    }

    /*
    在进入场景之后 初始化士兵 所以 timer 在 进入场景之后 初始化
    或者在场景构造中 初始化 那么需要在退出场景中 销毁
    */

    /*
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
            var so = new FightSoldier(this); 
            arena.append(so);
            addChild(so);
        }
    }
    */

    var moveZone = [
    [63, 203, 1000, 337],
    ];
    function checkInFlow(p)
    {   
        for(var i = 0; i < len(moveZone); i++)
        {
            var difx = p[0] - moveZone[i][0];
            var dify = p[1] - moveZone[i][1];
            if(difx > 0 && difx < moveZone[i][2] && dify > 0 && dify < moveZone[i][3])
                return 1;
        }
        return 0;
    }
    function checkPosCollision(mx, my, ps)
    {
        var inZ = checkInFlow(ps);
        /*
        限制上下边界
        */
        if(inZ == 0)
        {
            return 1;//not In zone
        }
        var key = mx*10000+my;
        /*
        限制不与其它建筑冲突
        */
        var v = mapGridController.mapDict.get(key, []);
        if(len(v) > 0)
        {
            for(var i = 0; i < len(v); i++)
            {
                if(v[i][2] == 1)//不可行走区域
                    return v[0];
            }
        }
        return null;
    }
}
