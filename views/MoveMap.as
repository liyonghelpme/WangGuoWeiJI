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
    var blockBuilding = new MyNode();
    //静止障碍物
    var staticObstacle;// = dict();
    var moveZone;//士兵移动范围
    var buildZone;//建筑物范围

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
        if(getParam("DEBUG"))
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
        }
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
    
    function checkInFlow(zone, p)
    {   
        for(var i = 0; i < len(zone); i++)
        {
            var difx = p[0] - zone[i][0];
            var dify = p[1] - zone[i][1];
            if(difx > 0 && difx < zone[i][2] && dify > 0 && dify < zone[i][3])
                return 1;
        }
        return 0;
    }
    //只检测士兵冲突没有检测建筑物冲突
    function checkPosCollision(mx, my, ps)
    {
        var inZ = checkInFlow(moveZone, ps);
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

        if(staticObstacle.get(key, null) != null)
        {
            return blockBuilding;
        }
        return null;
    }

    //检测掉落物品的 冲突性
    function checkFallGoodCol(rx, ry)
    {
        var inZ = checkInFlow(moveZone, [rx*SIZEX, ry*SIZEY]);
        if(inZ == 0)
            return 1;

        var key = getMapKey(rx, ry);
        var v = mapGridController.mapDict.get(key, null);
        if(v != null)
            return 1;
        if(staticObstacle.get(key, null) != null)
        {
            return 1;
        }
        return 0;
    }

    /*
    function checkBuildInZone(px, py, sx, sy)
    {
        var width = (sx+sy)*SIZEX;
        var height = (sx+sy)*SIZEY;
        for(var i = 0; i < len(moveZone); i++)
        {
            var difx = px - moveZone[i][0];
            var dify = py - moveZone[i][1];
            if(difx > width/2 && difx < (moveZone[i][2]-width/2) && dify > height && dify < (moveZone[i][3]-height))
                return 1;
        }
        return 0;
    }
    */
    //检测建筑物位置冲突 建筑物的底座宽度 高度 减去范围在范围内部
    function checkCollision(build)
    {
        var inZ = checkInFlow(buildZone, build.getPos());
        //var inZ = checkBuildInZone(build.getPos()[0], build.getPos()[1], build.sx, build.sy);
        if(!inZ)
            return 1;

        var map = getBuildMap(build);
        var sx = map[0];
        var sy = map[1];
        var initX = map[2];
        var initY = map[3];
        for(var i = 0; i < sx; i++)
        {
            var curX = initX+i;
            var curY = initY+i;
            for(var j = 0; j < sy; j++)
            {
                //var key = curX*10000+curY;
                var key = getMapKey(curX, curY);
                var v = mapGridController.mapDict.get(key, []);
                if(len(v) > 0)
                {
                    for(var k = 0; k < len(v); k++)
                    {
                        if(v[k][0] != build && v[k][1] == 1)//不可建造
                        {
                            return v[k];
                        }
                    }
                }
                if(staticObstacle.get(key, null) != null)
                {
                    return blockBuilding;
                }
                curX -= 1;
                curY += 1;
            }
        }
        return null;
    }
    //新建增加筑物
    function addBuilding(chd, z)
    {
        addChildZ(chd, z);
        mapGridController.addBuilding(chd);
    }
    //卖出建筑物 取消建造
    function removeBuilding(chd)
    {
        removeChild(chd);
        mapGridController.removeBuilding(chd);
    }
    
    function addSoldier(sol)
    {
        addChildZ(sol, MAX_BUILD_ZORD);
        mapGridController.addSoldier(sol);
    }

    function removeSoldier(sol)
    {
        removeChild(sol);
        mapGridController.removeSoldier(sol);
    }
}
