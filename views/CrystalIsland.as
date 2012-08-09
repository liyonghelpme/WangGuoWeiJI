/*
初始用户的水晶矿属性 类似于用户建筑物
*/
class CrystalLayer extends MyNode
{
    var scene;
    var mapDict = dict();
    var allBuildings = [];
    function CrystalLayer(s)
    {
        scene = s;
        bg = node();
        bg.addsprite("transmitter.png").anchor(50, 50).pos(707, 237).setevent(EVENT_TOUCH, onTransmitter);
        init();
        initMine();
    }
    function onTransmitter()
    {
    }
    function touchBegan(n, e, p, x, y, points)
    {
    }

    function touchMoved(n, e, p, x, y, points)
    {
    }

    function touchEnded(n, e, p, x, y, points)
    {
    }
    //MINE_BID 在更新建筑物数据的时候 判定BID 是 矿 则进行其它处理
    function initMine()
    {
        var mine = global.user.mine;
        if(mine != null)
        {
            var data = getData(BUILD, mine.get("id"));
            var building = new Building(this, data, mine);
            building.setBid(mine.get("bid"));
            addChildZ(building, MAX_BUILD_ZORD);
            building.setPos([mine.get("px"), mine.get("py")]);
            addBuilding(building);
        }
    }
    function addBuilding(b)
    {
        allBuildings.append(b);
    }
}
class MineScene extends MyNode
{
    var back;
    var menu;

    function MineScene()
    {
        bg = node();
        init();
        back = new CrystalIsland(this);
        addChild(back);
        menu = new MineMenu(this);
        addChild(menu);
    }

    var curMenuBuild = null;
    function showGlobalMenu(build, callback)
    {
        if(curMenuBuild == null)
        {
            curMenuBuild = build;
            menu.hideMenu();
            back.moveToBuild(build);
            callback();
        }
    }

    function closeGlobalMenu()
    {
        if(curMenuBuild != null)
        {
            curMenuBuild.closeGlobalMenu();
            global.director.popView();
            curMenuBuild = null;
            menu.showMenu();
            back.returnToOldPos();
        }
    }
}
class CrystalIsland extends MyNode
{
    var scene;
    var touchDelegate;
    var mineLayer;

    function CrystalIsland(s)
    {
        scene = s;
        bg = sprite("island1.jpg");
        init();
            
        mineLayer = new CrystalLayer(this);
        addChild(mineLayer);


        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;


        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }

    function returnToOldPos()
    {
        if(oldScale != null)
        {
            touchDelegate.scaleToOld(oldScale, oldPos);
            oldScale = null;
            oldPos = null;
        }
    }
    var oldScale = null;
    var oldPos = null;

    function moveToBuild(build)
    {
        oldScale = bg.scale();
        touchDelegate.scaleToMax(150);
        oldPos = bg.pos();
        var bSize = build.bg.size();
        var bPos = build.getPos();
        bPos[1] -= bSize[1]/2;
        moveToPoint(bPos[0], bPos[1]);
    }

    function moveToPoint(tarX, tarY)
    {
        var worldPos = bg.node2world(tarX, tarY);
        var sSize = global.director.disSize;
        var difx = sSize[0]/2-worldPos[0];
        var dify = sSize[1]/2-worldPos[1];
        var curPos = bg.pos();
        curPos[0] += difx;
        curPos[1] += dify;

        var backSize = bg.size();
        bg.pos(0, 0);
        var maxX = 0;
        var maxY = 0;
        var w2 = bg.node2world(backSize[0], backSize[1])
        var minX = sSize[0]-w2[0];
        var minY = sSize[1]-w2[1];

        curPos[0] = min(max(minX, curPos[0]), maxX);
        curPos[1] = min(max(minY, curPos[1]), maxY);
        bg.pos(curPos);
    }

    function touchBegan(n, e, p, x, y, points)
    {
        scene.closeGlobalMenu();
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
}
