


/*
地图大小： 13 * 5  1100 * 425   84.6 85 
士兵： anchor 50 100

在arrange 结束之后 建立每行士兵 每次士兵切换行则 更新状态
*/
class Map extends MyNode
{
    var kind;
    var touchDelegate;
    var scene;
    var walkZone = 
    [MAP_INITX+MAP_OFFX/2, MAP_INITY+MAP_OFFY, MAP_INITX+MAP_OFFX*12+MAP_OFFX/2, MAP_INITY+MAP_OFFY*5];

    //getSolMap = map[1] 行号作为 key
    var soldiers = dict();

    /*
    gx*10000+gy = 士兵key
    */
    var mapDict = dict();

    /*
    士兵anchor 50 100
    */

    var grid;
    var myTimer;
    //color kind
    function Map(k, s, sc)
    {
        scene = sc;
        kind = k;
        bg = sprite("map"+str(k)+".jpg");
        grid = bg.addsprite("mapGrid.png").pos(MAP_INITX, MAP_INITY).color(100, 100, 100, 50);
        bg.prepare();
        init();
        var bSize = bg.size();
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;
        var ani = getMapAnimate(kind);
        trace("animate", ani);
        /*
        多个类型动画， 每个动画多个位置
        */
        for(var i = 0; i < len(ani); i++)
        {
            var allPos = ani[i][1];
            for(var j = 0; j < len(allPos); j += 2)
            {
                var a = sprite().pos(allPos[j], allPos[j+1]);
                a.addaction(repeat(ani[i][0]()));
                bg.add(a, 1000);
            }
        }
        if(kind == 2)
        {
            var shadow = sprite("mapShadow.png").pos(0, 0).size(bSize[0], bSize[1]);
            bg.add(shadow, 10000);
        }


        initSoldier(s);
        initDefense();
        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    /*
    color kind
    我方人物 是颜色 0  敌方颜色 1 
    敌方 放置 rx ry
    我方放置 rx ry 0 0 ry+1
    0-12 0-4
    */
    var myRx = 0;//++
    var myRy = 0;
    var eneRx = 12;//--
    var eneRy = 0;
    function getInitPos(soldier)
    {
        if(soldier.color == 0)
        {
            var p = getSolPos(myRx, myRy);
            myRy++;
            if(myRy == 5)
            {
                myRx++;
                myRy = 0;
            }
            return p;
        }
        else
        {
            p = getSolPos(eneRx, eneRy);
            eneRy++;
            if(eneRy == 5)
            {
                eneRx--;
                eneRy = 0;
            }
            return p;
        }
    }
    /*
    首先根据当前格子和方向 得到所有可能的冲突
    接着计算对方是否在我方向上  且对方的距离比体积小
   
    得到自己的map   得到目标 计算移动方向dir
    得到两个格子的对象
       在自己的前方对象 dir*difx > 0 距离小于 碰撞体积 则返回冲突对象 

    只考虑x方向的距离
    */
    //考虑同一行的士兵是否在我们之间
    function checkDirCol(sol, tar)
    {
        var myPos = sol.getPos();
        var dir = tar.getPos()[0] - myPos[0];
        if(dir > 0)
            dir = 1;
        else
            dir = -1;
        var solMap = getSolMap(myPos);
        var it = soldiers.get(solMap[1], []);
        for(var i = 0; i < len(it); i++)
        {
            var col = it[i];
            if(col == sol || col == tar || col.state == MAP_SOL_DEAD || col.state == MAP_SOL_DEFENSE)
                continue;
            var dist = (col.getPos()[0]-myPos[0])*dir;
            trace("colDist", dist);
            if(dist >= 0 && dist < (col.getVolumn()+sol.getVolumn()))
                return col;
        }
        return null;
    }
    /*
    function checkDirCol(sol, tar)
    {
        var myPos = sol.getPos();
        var myMap = getSolMap(myPos);
        var dir = tar.getPos()[0] - sol.getPos()[0];
        if(dir > 0)
            dir = 1;
        else
            dir = -1;
        var key = myMap[0]*10000+myMap[1];
        var col = mapDict.get(key, []);
        key = (myMap[0]+1)*10000+myMap[1]; 
        col.extend(mapDict.get(key, []));
        for(var i = 0; i < len(col); i++)
        {
            if(col[i] != sol && col[i] != tar)
            {
                var dist = (col[i].getPos()[0]-myPos[0])*dir;
                if(dist >= 0 && dist < 60)//碰撞体积
                {
                    return col[i];      
                }
            }
        }
        return null;
    }
    */
    function checkCol(sol)
    {
        var oldMap = getSolMap(sol.getPos());
        var key = oldMap[0]*10000+oldMap[1];
        return mapDict.get(key, null);
    }
    /*
    设定士兵的坐标映射和每行所有的士兵
    */
    function setMap(sol)
    {
        var oldMap = getSolMap(sol.getPos());
        var key = oldMap[0]*10000+oldMap[1];
        var row = soldiers.get(oldMap[1], []);
        row.append(sol);
        soldiers.update(oldMap[1], row);
        mapDict.update(key, sol);
    }
    /*
    每个位置只有一个士兵
    清除某个位置的士兵 清除某行的士兵
    */
    function clearMap(sol)
    {
        var oldMap = getSolMap(sol.getPos());
        var key = oldMap[0]*10000+oldMap[1];
        var row = soldiers.get(oldMap[1])
        row.remove(sol);
        mapDict.pop(key);
    }
    function finishArrage()
    {
        var it = soldiers.items();
        grid.removefromparent();
        for(var i = 0; i < len(it); i++)
        {
            for(var j = 0; j < len(it[i][1]); j++)
            {
                it[i][1][j].finishArrage();
            }
        }

    }
    /*
    function getRandPos()
    {
        var rx = rand(13);
        var ry = rand(5);
        var key = rx*10000+ry;
        var u = mapDict.get(key, null);
        if(u == null)
        {
            mapDict.update(key, 1);
            return getSolPos(rx, ry);
        }
        for(var i = 0; i < 13; i++)
        {
            for(var j = 0; j < 5; j++)
            {
                key = (rx+i)%13*10000+(ry+j)%5;
                u = mapDict.get(key, null);
                if(u == null)
                {
                    mapDict.update(key, 1);
                    return getSolPos((rx+i)%13, (ry+j)%5);
                }
            }
        }
        return getSolPos(rx, ry);
    }
    */
    function initSoldier(s)
    {
        for(var i = 0; i < len(s); i++)
        {
            var so = new Soldier(this, s[i]);  
            /*
            设定人物位置会设定人物的zord 
            所以要在添加了人物之后 设定位置

            */
            addChild(so);
            so.setPos(getInitPos(so)); 
            setMap(so);

            //var soMap = getSolMap(so);
            //trace("soldier", s[i], soMap);
            /*
            var myrow = soldiers.get(soMap[1], []);
            soldiers.update(soMap[1], myrow);
            myrow.append(so);
            */


        }
        //trace("soldiers", soldiers);
        trace("allSoldiers", len(soldiers));
    }
    function initDefense()
    {
        var defense = mapInfo.get(kind);
        var d = new MapDefense(this, 0, defense[0]);
        var i;
        var row;
        addChildZ(d, 0);
        for(i = 0; i < 5; i++)
        {
            row = soldiers.get(i);
            row.append(d);
        }

        d = new MapDefense(this, 1, defense[1]);
        addChildZ(d, 0);
        for(i = 0; i < 5; i++)
        {
            row = soldiers.get(i);
            row.append(d);
        }

    }
    function update(diff)
    {
    }
    function quitMap(n, e, p, kc)
    {
        if(kc == KEYCODE_BACK)
            global.director.popView();
    }
    override function enterScene()
    {
        trace("enterScene map");
        myTimer = new Timer(500);
        super.enterScene();
        bg.setevent(EVENT_KEYDOWN, quitMap);
        bg.focus(1);
    }
    override function exitScene()
    {
        trace("exitScene map");
        bg.setevent(EVENT_KEYDOWN, null);
        super.exitScene();
        myTimer.stop();
        myTimer = null;
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
}
