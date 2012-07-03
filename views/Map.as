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
    var small;
    function Map(k, sm, s, sc)
    {
        scene = sc;
        kind = k;
        small = sm;
        bg = sprite("map"+str(k)+".jpg").pos(MAP_INITX, global.director.disSize[1]/2-3*MAP_OFFY-MAP_INITY);
        grid = bg.addnode("mapGrid.png").pos(MAP_INITX, MAP_INITY).size(6*MAP_OFFX, 5*MAP_OFFY).clipping(1).color(100, 100, 100, 30);
        grid.addsprite("mapGrid.png").color(100, 100, 100, 50);

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
    function defenseBreak(def)
    {
        var reward = getRandomMapReward(kind, small);

        stopGame();
        if(def.color == 0)
            global.director.pushView(new BreakDialog(0, 0, reward, this), 1, 0);
        else
            global.director.pushView(new BreakDialog(1, 2, reward, this), 1, 0);
    }
    /*
    color kind
    我方人物 是颜色 0  敌方颜色 1 
    敌方 放置 rx ry
    我方放置 rx ry 0 0 ry+1
    0-12 0-4
    */
    /*
    var myRx = 0;//++
    var myRy = 0;
    var eneRx = 12;//--
    var eneRy = 0;
    */
    function getKey(xk, yk)
    {
        return xk*10000+yk;
    }
    function getInitPos(soldier)
    {
        var yk;
        var xk;
        var key;
        var val;
        var i;
        var j;
        var col;
        if(soldier.color == 0)
        {
            for(yk = 0; yk < 5; yk++)
            {
                if((yk+soldier.sy) > 5)
                    continue;
                for(xk = 1; xk < 6; xk++)
                {
                    if((xk+soldier.sx) > 6)
                        continue;
                    col = 0;    
                    for(i = 0; i < soldier.sy && !col; i++)
                    {
                        for(j = 0; j < soldier.sx && !col; j++)
                        {
                            key = getKey(xk+j, yk+i);
                            val = mapDict.get(key, []);
                            if(len(val) > 0)
                            {
                                col = 1;
                                break;
                            }
                        }
                    }
                    if(col == 1)
                        continue;
                    return getSolPos(xk, yk, soldier.sx, soldier.sy);
                }
            }
        }
        else
        {
            for(yk = 0; yk < 5; yk++)
            {
                if((yk+soldier.sy) > 5)
                    continue;
                for(xk = 7; xk < 12; xk++)
                {
                    if((xk+soldier.sx) > 12)
                        continue;

                    col = 0;    
                    for(i = 0; i < soldier.sy && !col; i++)
                    {
                        for(j = 0; j < soldier.sx && !col; j++)
                        {
                            key = getKey(xk+j, yk+i);
                            val = mapDict.get(key, []);
                            if(len(val) > 0)
                            {
                                col = 1;
                                break;
                            }
                        }
                    }
                    if(col == 1)
                        continue;

                    return getSolPos(xk, yk, soldier.sx, soldier.sy);
                }
            }
        }
        return [-1, -1];
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
    //忽略 防御装置的 冲突处理问题 MAP_SOL_DEFENSE 不能阻挡士兵
    function checkDirCol(sol, tar)
    {
        var myPos = sol.getPos();
        var dir = tar.getPos()[0] - myPos[0];
        if(dir > 0)
            dir = 1;
        else
            dir = -1;
        var solMap = getSolMap(myPos, sol.sx, sol.sy);
        for(var j = 0; j < sol.sy; j++)//遍历每一行
        {
            //根据y值得到相应的map行
            var it = soldiers.get(solMap[1]+j, []);
            for(var i = 0; i < len(it); i++)
            {
                var col = it[i];
                if(col == sol || col == tar || col.state == MAP_SOL_DEAD || col.state == MAP_SOL_DEFENSE)
                    continue;
                var dist = (col.getPos()[0]-myPos[0])*dir;
                //trace("colDist", dist);
                if(dist >= 0 && dist < (col.getVolumn()+sol.getVolumn()))
                    return col;
            }
        }
        return null;
    }
    function checkCol(sol)
    {
        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy);
        for(var j = 0; j < sol.sy; j++)
        {
            var key = oldMap[0]*10000+oldMap[1]+j;
            var res = mapDict.get(key, null);
            if(res != null)
                return res;
        }
        return null;
    }
    /*
    设定士兵的坐标映射和每行所有的士兵

    多行士兵 属于多个row 
    左上角作为起始row 
    */
    function setMap(sol)
    {
        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy);
        for(var i = 0; i < sol.sy; i++)
        {
            var row = soldiers.get(oldMap[1]+i, []);
            row.append(sol);
            soldiers.update(oldMap[1]+i, row);

            for(var j = 0; j < sol.sx; j++)
            {
                var key = (oldMap[0]+j)*10000+oldMap[1]+i;
                mapDict.update(key, sol);
            }
        }
        trace("setMap", oldMap, sol.sy);
    }
    /*
    每个位置只有一个士兵
    清除某个位置的士兵 清除某行的士兵

    i 行 j 列
    */
    function clearMap(sol)
    {
        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy);
        for(var i = 0; i < sol.sy; i++)
        {
            var row = soldiers.get(oldMap[1]+i)
            row.remove(sol);
            for(var j = 0; j < sol.sx; j++)
            {
                var key = (oldMap[0]+j)*10000+oldMap[1]+i;
                mapDict.pop(key);
            }
        }
    }

    function getAllLevelUp()
    {
        var levelUpSol = [];
        trace("mySoldiers", mySoldiers);
        for(var i = 0; i < len(mySoldiers); i++)
        {
            var ne = getLevelNeedExp(mySoldiers[i].data.get("expId"), mySoldiers[i].level);
            if(mySoldiers[i].exp >= ne)
            {
                mySoldiers[i].getLevelUp();

                levelUpSol.append(mySoldiers[i]);
            }
            global.user.updateSoldiers(mySoldiers[i]);
        }
        return levelUpSol;
    }
    //保持所有我方士兵的引用 检测如果杀死对方奖励我方经验
    //我方士兵如果没有死亡
    
    //存储所有我方士兵实体 当战斗结束之后清算奖励 只变更我方士兵的数据状态
    var mySoldiers = [];
    function finishArrage()
    {
        var it = soldiers.values();
        grid.removefromparent();
        for(var i = 0; i < len(it); i++)
        {
            for(var j = 0; j < len(it[i]); j++)
            {
                var so = it[i][j];
                //占有多行的士兵只 清理一次
                so.finishArrage();
                //占有多行的士兵只加入一次
                if(so.isMySoldier() == 1 && so.addToMySol() == 0)//我方士兵且 不为防御装置 且没有加入我方士兵列表
                {
                    mySoldiers.append(so);
                }
            }
        }

    }
    //初始化敌人士兵
    function initSoldier(s)
    {
        for(var i = 0; i < len(s); i++)
        {
            var so = new Soldier(this, s[i], -1);  
            /*
            设定人物位置会设定人物的zord 
            所以要在添加了人物之后 设定位置

            */

            var nPos = getInitPos(so);
            if(nPos[0] == -1)
                continue;
            addChild(so);
            so.setPos(nPos); 
            setMap(so);
        }
        //trace("soldiers", soldiers);
        trace("allSoldiers", len(soldiers));
    }
    /*
    用户点击 下方block 则在地图上生成一个士兵
    士兵位置第一个合理空位
    士兵头顶有一个close icon 取消士兵
    */
    function addSoldier(sid)
    {
        var sdata = global.user.getSoldierData(sid);
        var so = new Soldier(this, [0, sdata.get("id")], sid);
        var nPos = getInitPos(so);
        if(nPos[0] == -1)
            return null;
        addChild(so);
        so.setPos(nPos);
        setMap(so);
        return so;
    }

    function calHurts(so)
    {
        var it = so.hurts.values();
        var totalExp = so.gainexp;
        var totalHurt = 0;
        var i;
        //根据总的经验总的伤害计算经验分配
        for(i = 0; i < len(it); i++)
        {
            totalHurt += it[i][1];
        }
        for(i = 0; i < len(it); i++)
        {
            it[i][0].changeExp(totalExp*it[i][1]/totalHurt);
        }
    }

    function soldierDead(so)
    {
        removeSoldier(so);
        var v = soldiers.values(); 
        var myCount = 0;
        var eneCount = 0;
        for(var i = 0; i < len(v); i++)
        {
            for(var j = 0; j < len(v[i]); j++)
            {
                if(v[i][j].color == 0 && v[i][j].state != MAP_SOL_DEFENSE && v[i][j].state != MAP_SOL_DEAD)
                {
                    myCount++;
                }
                else if(v[i][j].color == 1 && v[i][j].state != MAP_SOL_DEFENSE && v[i][j].state != MAP_SOL_DEAD) 
                {
                    eneCount++;
                }
                if(myCount > 0 && eneCount > 0)
                    break;
            }
            if(myCount > 0 && eneCount > 0)
                break;
        }
        trace("myCount", myCount, eneCount);

        var reward = getRandomMapReward(kind, small);
        if(myCount == 0)
        {
            stopGame();
            global.director.pushView(new BreakDialog(0, 0, reward, this), 1, 0);
        }
        else if(eneCount == 0)
        {
            stopGame();
            global.director.pushView(new BreakDialog(1, 2, reward, this), 1, 0);
        }
    }
    function removeSoldier(so)
    {
        clearMap(so); 
        so.removeSelf();
    }
    /*
    布局时点击士兵头部 清除士兵数据 
    */
    function clearSoldier(so)
    {
        removeSoldier(so);
        scene.clearSoldier(so);
    }

    var defenses = [];
    function initDefense()
    {
        var defense = mapInfo.get(kind);
        var d = new MapDefense(this, 0, defense[0]);
        var i;
        var row;
        addChildZ(d, 0);
        for(i = 0; i < 5; i++)
        {
            row = soldiers.get(i, []);
            row.append(d);
            soldiers.update(i, row);
        }
        defenses.append(d);

        d = new MapDefense(this, 1, defense[1]);
        addChildZ(d, 0);
        for(i = 0; i < 5; i++)
        {
            row = soldiers.get(i, []);
            row.append(d);
            soldiers.update(i, row);
        }
        defenses.append(d);

        trace("soldiers each row", soldiers);
    }
    function getDefense(id)
    {
        return defenses[id];
    }

    function update(diff)
    {
    }
    function quitMap(n, e, p, kc)
    {
        if(kc == KEYCODE_BACK)
            global.director.popScene();
    }
    function stopGame()
    {
        myTimer.gameStop();
        var val = soldiers.values();
        for(var i = 0; i < len(val); i++)
        {
            for(var j = 0; j < len(val[i]); j++)
            {
                val[i][j].stopGame();
            }
        }
    }
    function continueGame()
    {
        myTimer.gameRestart();
        var val = soldiers.values();
        for(var i = 0; i < len(val); i++)
        {
            for(var j = 0; j < len(val[i]); j++)
            {
                val[i][j].continueGame();
            }
        }
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
