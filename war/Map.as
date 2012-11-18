/*
地图大小： 13 * 5  1100 * 425   84.6 85 
士兵： anchor 50 100

在arrange 结束之后 建立每行士兵 每次士兵切换行则 更新状态
*/
class Map extends MyNode
{
    var maxMapIds = 0;
    var roundGridController;
    var kind;
    var touchDelegate;
    var scene;
    //var curStar;
    var walkZone = 
    [MAP_INITX+MAP_OFFX/2, MAP_INITY+MAP_OFFY, MAP_INITX+MAP_OFFX*12+MAP_OFFX/2, MAP_INITY+MAP_OFFY*5];

    //var soldiers = dict();

    /*
    gx*10000+gy = 士兵key
    */
    //var mapDict = dict();

    /*
    士兵anchor 50 100
    */

    var grid;
    var myTimer;
    //color kind
    var small;

    var gridRow = null;
    var gridCol = null;
    function removeGrid()
    {
        if(gridRow != null)
        {
            gridRow.removefromparent();
            gridRow = null;
        }
        if(gridCol != null)
        {
            gridCol.removefromparent();
            gridCol = null;
        }
    }

    //start + length <= Max
    function checkInBoundary(sol, oldMap)
    {
        if(sol.color == MYCOLOR)
            return (oldMap[0] >= 1 && oldMap[0] <= (6-sol.sx) && oldMap[1] >= 0 && oldMap[1] <= (MAP_HEIGHT-sol.sy))
        return (oldMap[0] >= 7 && oldMap[0] <= (13-sol.sx) && oldMap[1] >= 0 && oldMap[1] <= (MAP_HEIGHT-sol.sy))
    }
    function checkSkillInBoundary(si, oldMap)
    {
        return (oldMap[0] >= 1 && oldMap[0] <= (MAP_WIDTH-si[0]) && oldMap[1] >= 0 && oldMap[1] <= (MAP_HEIGHT-si[1]))
    }

    function moveGrid(sol)
    {
        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy, sol.offY);
        var ret = checkInBoundary(sol, oldMap);
        if(ret == 0)
        {
            removeGrid();
            return;
        }

        var gp = getGridPos(oldMap);

        //newMap[0] = max(1, min(6-sx, newMap[0]));
        //newMap[1] = max(0, min(5-sy, newMap[1]));
        if(gridRow == null)
            gridRow = bg.addsprite("occGrid0.png").pos(MAP_INITX, gp[1]).size(MAP_OFFX*6, MAP_OFFY*sol.sy);
        gridRow.pos(MAP_INITX, gp[1]);
        if(gridCol == null)
            gridCol = bg.addsprite("occGrid0.png").pos(gp[0], MAP_INITY).size(MAP_OFFX*sol.sx, MAP_OFFY*5);
        gridCol.pos(gp[0], MAP_INITY);
    }
    var monEquips;
    function getEnemyEquips(sid)
    {
        var res = [];
        if(monEquips != null)
        {
            for(var i = 0; i < len(monEquips); i++)
            {
                if(monEquips[i]["owner"] == sid)
                    res.append(monEquips[i]);
            }
        }
        return res;
    }

    var shadow = null;
    var animateLayer = null;
    var mapPic;
    var gridSp = null;
    function initView()
    {
        bg = sprite("map"+str(kind)+".png", ARGB_8888).pos(0, 0);//.pos(MAP_INITX, global.director.disSize[1]/2-3*MAP_OFFY-MAP_INITY);
        init(); 
        grid = bg.addnode().pos(MAP_INITX, MAP_INITY).size(6*MAP_OFFX, 5*MAP_OFFY).clipping(1);//.color(100, 100, 100, 100);
        updateShadow();
    }
    function updateShadow()
    {
        if(shadow != null)
        {
            shadow.removefromparent();
            shadow = null;
        }
        if(animateLayer != null)
        {
            animateLayer.removefromparent();
            animateLayer = null;
        }
        if(gridSp != null)
        {
            gridSp.removefromparent();
            gridSp = null;
        }

        var fil = m_color(
            100, 0, 0, 0, 0,
            0, 100, 0, 0, 0,
            0, 0, 100, 0, 0,
            0, 0, 0, 30, 0
        );
        gridSp = grid.addsprite("mapGrid.png", ARGB_8888, fil);//.color(100, 100, 100, 100);//.color(100, 100, 100, 50)

        var bSize = bg.size();
         var mData = getData(MAP_INFO, kind);
         if(mData["hasMask"])
         {
            var tran = m_color(
            100, 0, 0, 0, 0,
            0, 100, 0, 0, 0,
            0, 0, 100, 0, 0,
            0, 0, 0, getParam("shadowOpacity"), 0);
            shadow = sprite("map"+str(kind)+"Shadow.png", UPDATE_SIZE, tran, ARGB_8888).pos(0, 0).size(bSize);
            bg.add(shadow, 10000);
        }
        if(mData["hasAnimation"])
        {
            animateLayer = node();
            bg.add(animateLayer, 1000);
            var ani = getMapAnimate(kind);
            for(var i = 0; i < len(ani); i++)
            {
                var allPos = ani[i][1];
                for(var j = 0; j < len(allPos); j += 2)
                {
                    var a = sprite().pos(allPos[j], allPos[j+1]);
                    a.addaction(repeat(ani[i][0](getParam("bubbleTime"))));
                    animateLayer.add(a);
                }
            }
        }
    }
    var gridLayer;
    function Map(k, sm, s, sc, eq)
    {
        roundGridController = new RoundGridController(this);
        monEquips = eq;
        scene = sc;
        kind = k;
        small = sm;
        initView();
        gridLayer = bg.addnode();

        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);

        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;

        if(s != null)//闯关 挑战 敌人预先确定 练级 怪兽根据用户士兵生成
            initSoldier(s);
        //练级没有防御血条
        if(scene.kind != CHALLENGE_TRAIN)
            initDefense();
    }
    function getStar()
    {
        var myDef = defenses[0];
        var leftHealth = myDef.health;
        if(leftHealth == myDef.healthBoundary)
            return 3;
        if(leftHealth >= myDef.healthBoundary*80/100)
            return 2;
        return 1;
    }
    function defenseBreak(def)
    {
        var reward = null;
        if(scene.kind == CHALLENGE_MON)
            reward = getRandomMapReward(kind, small);
        var levelUpSol = getAllLevelUp();

        stopGame();
        trace("MapDefenseBreak");
        if(def.color == MYCOLOR)
            challengeOver(0, 0, null, levelUpSol);
        else 
            challengeOver(1, getStar(), reward, levelUpSol);
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
    //每次从头开始寻找位置 而不是从上一个位置开始寻找
    function getInitPos(soldier)
    {
        var yk;
        var xk;
        var key;
        var val;
        var i;
        var j;
        var col;

        if(soldier.color == MYCOLOR)//自上而下 自右而左
        {
            for(xk = 5; xk > 1; xk--)
            {
                if((xk+soldier.sx) > 6)
                    continue;

                for(yk = 0; yk < 5; yk++)
                {
                    if((yk+soldier.sy) > 5)
                        continue;

                    //col = 0;    
                    col = roundGridController.checkCol(xk, yk, soldier.sx, soldier.sy);
                    if(len(col) > 0)
                        continue;
                    /*
                    for(i = 0; i < soldier.sy && !col; i++)
                    {
                        for(j = 0; j < soldier.sx && !col; j++)
                        {
                            key = getKey(xk+j, yk+i);
                            //val = mapDict.get(key, []);
                            val = roundGridController.get(key, []);
                            if(len(val) > 0)
                            {
                                col = 1;
                                break;
                            }
                        }
                    }
                    if(col == 1)
                        continue;
                    */
                    return getSolPos(xk, yk, soldier.sx, soldier.sy, soldier.offY);
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

                    col = roundGridController.checkCol(xk, yk, soldier.sx, soldier.sy);
                    if(len(col) > 0)
                        continue;
                    /*
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
                    */

                    return getSolPos(xk, yk, soldier.sx, soldier.sy, soldier.offY);
                }
            }
        }
        return [-1, -1];
    }
    /*
    计算士兵的位置map

    挑战 闯关 检测 格子冲突
    练级检测 所在行冲突
    也应该检测

    检测左上角开始的 sx sy 个格子
    以及相应的是否超出地图边界
    */
    function checkSolOutOrCol(sol)
    {
        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy, sol.offY);
        var inB = checkInBoundary(sol, oldMap)
        if(!inB)
            return 0;
        var col;
        if(scene.kind != CHALLENGE_TRAIN)
            col = checkCol(sol);
        else
            col = checkLineCol(sol);
        return col;
    }
    function checkCol(sol)
    {

        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy, sol.offY);

        var col = roundGridController.checkCol(oldMap[0], oldMap[1], sol.sx, sol.sy);
        if(len(col) > 0)
            return col;
        return null;

        /*
        for(var i = 0; i < sol.sx; i++)
        {
            for(var j = 0; j < sol.sy; j++)
            {
                var key = (oldMap[0]+i)*10000+oldMap[1]+j;
                var res = mapDict.get(key, null);
                if(res != null)
                    return res;
            }
        }
        return null;
        */
    }
    //多行士兵只算 起始行
    function checkLineCol(sol)
    {
        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy, sol.offY);
        for(var i = 0; i < MAP_WIDTH; i += sol.sx)
        {
            var col = roundGridController.checkCol(i, oldMap[1], sol.sx, sol.sy);
            if(len(col) > 0)
                return col;
        }
        return null;
        /*

        for(var i = 0; i < MAP_WIDTH; i++)
        {
            for(var j = 0; j < sol.sy; j++)
            {
                var key = i*10000+oldMap[1]+j;
                var res = mapDict.get(key, null);
                if(res != null)
                    return res;
            }
        }
        return null;
        */
    }
    /*
    设定士兵的坐标映射和每行所有的士兵

    多行士兵 属于多个row 
    左上角作为起始row 

    oldMap 的左上角 


    设定士兵soldiers 所在行
    设定基于网格的位置mapDict

    占有多行的士兵 需要同时应对两个敌人 刷新两行怪兽
    */
    function setMap(sol)
    {
        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy, sol.offY);
        roundGridController.setMap(oldMap[0], oldMap[1], sol.sx, sol.sy, sol);
        /*
        for(var i = 0; i < sol.sy; i++)
        {
            for(var j = 0; j < sol.sx; j++)
            {
                //var key = (oldMap[0]+j)*10000+oldMap[1]+i;
                //mapDict.update(key, sol);

            }
        }
        */
    }
    /*
    每个位置只有一个士兵
    清除某个位置的士兵 清除某行的士兵

    i 行 j 列
    */
    function clearMap(sol)
    {
        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy, sol.offY);
        roundGridController.clearMap(oldMap[0], oldMap[1], sol.sx, sol.sy, sol);
        /*
        for(var i = 0; i < sol.sy; i++)
        {
            //var row = soldiers.get(oldMap[1]+i)
            //if(row == null)
            //    continue;
            //row.remove(sol);
            for(var j = 0; j < sol.sx; j++)
            {
                var key = (oldMap[0]+j)*10000+oldMap[1]+i;
                mapDict.pop(key);
            }
        }
        */
    }

    /*
    结束战斗之后更新所有我方士兵的状态
    */
    function getAllLevelUp()
    {
        var updateSoldierData = [];
        var levelUpSol = [];
//        trace("mySoldiers", mySoldiers);
        for(var i = 0; i < len(mySoldiers); i++)
        {
            var ne = getLevelUpExp(mySoldiers[i].id, mySoldiers[i].level);
            var sol = mySoldiers[i];
            if(mySoldiers[i].exp >= ne)
            {
                mySoldiers[i].getLevelUp();

                levelUpSol.append(mySoldiers[i]);
            }
            updateSoldierData.append([sol.sid, sol.health, sol.exp, sol.dead, sol.level]);//士兵的sid 
            global.user.updateSoldiers(mySoldiers[i]);
        }
        //global.httpController.addRequest("soldierC/challengeOver", dict([["uid", global.user.uid], ["sols", updateSoldierData]]), null, null);
        return [levelUpSol, updateSoldierData];
    }
    //保持所有我方士兵的引用 检测如果杀死对方奖励我方经验
    //我方士兵如果没有死亡
    
    //存储所有我方士兵实体 当战斗结束之后清算奖励 只变更我方士兵的数据状态
    var mySoldiers = [];
    var soldierInstance = [];
    function finishArrange()
    {
        grid.removefromparent();
        for(var i = 0; i < len(soldierInstance); i++)
        {
            var so = soldierInstance[i];
            so.finishArrange();
            if(so.color == MYCOLOR && so.addToMySol() == 0)
            {
                mySoldiers.append(so);
            }
        }
    }
    function checkMySoldier()
    {
        for(var i = 0; i < len(soldierInstance); i++)
        {
            if(soldierInstance[i].color == MYCOLOR)
                return 1;
        }
        return 0;
    }
    var leftNum = [];
    //设定怪兽数量
    function finishTrainArrange()
    {
        //finishArrange();
        for(var i = 0; i < len(mySoldiers); i++)
        {
            mySoldiers[i].setLeftMonNum(MONNUM[scene.difficult]);
        }
        showLeftNum();
    }
    //显示每个我方士兵所在行剩余怪兽数量
    function showLeftNum()
    {
        var i;
        for(i = 0; i < len(leftNum); i++)
        {
            leftNum[i].removefromparent();
        }
        leftNum = [];
        for(i = 0; i < len(mySoldiers); i++)
        {
            var sol = mySoldiers[i];
            var map = getSolMap(sol.getPos(), sol.sx, sol.sy, sol.offY);
            var p = getGridPos([MAP_WIDTH/2, map[1]]);//行中间显示
            if(sol.state == MAP_SOL_DEAD || sol.state == MAP_SOL_SAVE)
                sol.leftMonNum = 0;
var w = bg.addlabel(str(sol.leftMonNum), "fonts/heiti.ttf", 40).color(0, 0, 0).pos(p[0] + (MAP_OFFX / 2), p[1] + (MAP_OFFY / 2)).anchor(50, 50);
            leftNum.append(w);
        }
    }

    //初始化敌人士兵 怪兽 
    //sid=-1 kind level addAttack addDefense addAttackTime addDefenseTime
    function initSoldier(s)
    {
        var i;
        var so;
        var nPos;
        //根据monX monY 确定位置
        //0-12
        if(scene.kind == CHALLENGE_SELF || scene.kind == CHALLENGE_MON)
        {
            for(i = 0; i < len(s); i++)
            {
                so = realAddSoldier(ENEMY, s[i]["id"], s[i], ENECOLOR);
                nPos = getSolPos(s[i].get("monX")+7, s[i].get("monY"), so.sx, so.sy, so.offY);
                so.setPos(nPos);
                setMap(so);
            }
        }
        else//程序生成士兵的位置 挑战排行榜 挑战邻居
        {
            for(i = 0; i < len(s); i++)
            {
                so = realAddSoldier(ENEMY, s[i]["id"], s[i], ENECOLOR);
                /*
                设定人物位置会设定人物的zord 
                所以要在添加了人物之后 设定位置

                */

                nPos = getInitPos(so);
                if(nPos[0] == -1)
                {
                    realRemoveSoldier(so);
                    break;
                }
                so.setPos(nPos); 
                setMap(so);
            }
        }
    }

    function updateMapGrid()
    {
        gridLayer.removefromparent();
        gridLayer = bg.addnode();
        var k = roundGridController.mapDict.keys();
        for(var i = 0; i < len(k); i++)
        {
            var x = k[i]/10000;
            var y = k[i]%10000;

            var p = getSolPos(x, y, 1, 1, 0);
            var sp = gridLayer.addsprite("gridNew.png").size(MAP_OFFX, MAP_OFFY).pos(p).anchor(50, 100);
        }
        //trace("len grid", len(k));
    }

    function getNewMapId()
    {
        return maxMapIds++;
    }
    function realAddSoldier(sid, id, priData, col)
     {
        var so = new Soldier(this, [col, id, getNewMapId()], sid, priData);
         addChild(so);
         soldierInstance.append(so);
         return so;
     }

     function realRemoveSoldier(so)
     {
         so.clearMap();
         so.removeSelf();
         soldierInstance.remove(so);
     }
    //每行只能放置一个士兵
    //取消随机放置功能
    //level grade category
    //id level 

    //得到所有该档次的怪兽 档次 等级 类型
    //根据档次分离怪兽
    //档次分成两个层次
    //大档次 小档次
    var allMonsters = null;
    function initAllMonsters()
    {
        trace("initAllMonsters");
        allMonsters = dict();
        var solId = soldierData.keys();
        for(var i = 0; i < len(solId); i++)
        {
            var sol = getData(SOLDIER, solId[i]);
            if(sol.get("solOrMon") == 1)
            {
                var gk = getGradeKey(sol.get("grade"));
                var grade = allMonsters.get(gk, []);
                grade.append(solId[i]);
                allMonsters.update(gk, grade);
            }
        }
    }
    
    /*
    首先生成 所有怪兽的一个档次列表 档次/10 大档次
    所有兵力只有 1 2 3 4 5 6 个档次
    其中英雄全部是 6档次
    boss 是 5档次的 因此 将 boss 作为 英雄的怪兽
        怪兽档次-------> 怪兽id
    */
    function genNewMonster(sol)
    {
        var leftMonNum = sol.leftMonNum;
        var level = sol.level;
        var sData = getData(SOLDIER, sol.id);
        var grade = sData.get("grade");
        var category = sData.get("category");
        
        if(allMonsters == null)
        {
            initAllMonsters();
        }
        //英雄采用boss档怪兽
        var posMon;
        if(getGradeKey(grade) == 6)
            posMon = allMonsters.get(5);
        else
            posMon = allMonsters.get(getGradeKey(grade));
        //难度0 1 2 3
        //双倍经验 增加我方士兵
        var i;

        var monCat;
        //随机构造一个同档次的士兵
        if(sol.data.get("isHero"))//英雄
        {
            monCat = soldierMonsterTab.get(HERO)[scene.difficult];//英雄怪兽类型
        }
        else if(sol.data.get("solOrMon"))//怪兽
        {
            monCat = [sol.data.get("category")];
        }
        else
        {
            monCat = soldierMonsterTab.get(NORMAL_SOL)[scene.difficult];
        }
        
        //英雄有个问题
        var ene = null;
        var rd = rand(len(posMon));
        //随机挑选一个士兵 属于敌人类别
        //如果没有此类士兵 则随机产生一个弱于我方士兵的士兵
        for(i = 0; i < len(posMon); i++)
        {
            var n = (rd+i) % len(posMon);
            sData = getData(SOLDIER, posMon[n]);
            var cat = sData.get("category");
            for(var j = 0; j < len(monCat); j++)
            {
                if(cat == monCat[j])
                {
                    ene = sData;//id--->kind grade---> category
                    break;
                }
            }
            if(ene != null)
                break;
        }
        //不存在则随机刷性若干个怪物
        //如果为空则返回即可
        if(ene == null)//存在同档次的敌方类型士兵
        {
            ene = posMon[rd];
        }

        //当前位置 记录所在行数据 用于攻击
        //怪兽和练级士兵同级 同档次
        
        //英雄的怪兽档次 等级不能平级 基本能力太强太高了

        var so = realAddSoldier(ENEMY, sData["id"], dict([["level", sol.level]]), ENECOLOR);
        var oldMap = getSolMap(sol.getPos(), sol.sx, sol.sy, sol.offY);
        var x = rand(MAP_WIDTH-so.sx);//随机横坐标
        var y = min(oldMap[1], MAP_HEIGHT-so.sy);//纵坐标保证不超越下边界
        var maxW = MAP_WIDTH-so.sx;

        //var row = soldiers.get(oldMap[1]);//当前士兵所在行 不应该有冲突

        var find = 0;
        for(var p = 0; p < maxW; p++)
        {
            var nx = (x+p)%maxW;
            var soPos = getSolPos(nx, y, so.sx, so.sy, so.offY);
            so.setPos(soPos);

            //var col = checkPosCol(so);

            var colOjects = roundGridController.checkCol(nx, y, so.sx, so.sy, so);
            if(len(colOjects) == 0)
            {
                find = 1;
                break;
            }
            /*
            if(col == null)
            {
                find = 1;
                break;
            }
            */
        }
        if(!find)
        {
            realRemoveSoldier(so);
        }
        else
        {
            setMap(so);
            so.finishArrange();
            so.doAppearAni();
            so.setAttackCofficient(sol, scene.difficult);//攻击方士兵 场景难度
            return so;
        }
        return null;
    }
    function randomAllSoldier(data)
    {
        var removed = [];
        for(var i = 0; i < len(data); i++)
        {
            if(data[i][1] == 0)//未安排的士兵
            {
                var sid = data[i][0];
                var sdata = global.user.getSoldierData(sid);
                var so = realAddSoldier(sid, sdata["id"], null, MYCOLOR);
                var nPos = getInitPos(so);
                if(nPos[0] == -1)
                {
                    realRemoveSoldier(so);
                    continue;
                }
                so.setPos(nPos);
                setMap(so);
                
                removed.append(i);
            }
        }
        return removed;
    }

    /*
    用户点击 下方block 则在地图上生成一个士兵
    士兵位置第一个合理空位
    士兵头顶有一个close icon 取消士兵
    */
    function addSoldier(sid, col)
    {
        var sdata = global.user.getSoldierData(sid);
        var so = realAddSoldier(sid, sdata["id"], null, col);
        return so;
    }

    /*
    死亡对象更新所有的士兵状态 计算经验
    */
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
        //场景双倍经验
        var rate = 1;
        if(scene.kind == CHALLENGE_TRAIN && scene.double == 1)
            rate = 2;
        for(i = 0; i < len(it); i++)
        {
            it[i][0].changeExp(totalExp*it[i][1]/totalHurt*rate);
        }
    }
    /*
    不应该出现breakDialog
    
    [oid, papayaId, score, rank]
    */
    function challengeOver(win, star, reward, levelUpSol)
    {
        var updateSoldierData = levelUpSol[1];
        levelUpSol = levelUpSol[0];

        var crystal = 0;
        var score = 0;
        //挑战RANK 或者 邻居
        if(scene.kind == CHALLENGE_FRI) 
        {
            var myRank = global.user.rankOrder;
            var myScore = global.user.rankScore;

            var eneRank = scene.argument["rank"];//param[3];
            var eneScore = scene.argument["score"];//param[2];

            var diff = eneRank-myRank;
            for(var i = 0; i < len(challengeReward); i++)
            {
                if(diff < challengeReward[i][0])
                {
                    break;
                }
            }
            i = min(i, len(challengeReward)-1);
            if(win == 1)
            {
                crystal = challengeReward[i][1];
                
                score = eneScore*challengeReward[i][2]/100;
                score = min(MAX_SCORE-myScore, score);
            }
            else
            {
                score = -myScore*challengeReward[i][3]/100;
            }
            global.user.updateRankScore(score); 
            global.user.changeValue("crystal", crystal);

        }
        else if(scene.kind == CHALLENGE_NEIBOR)
        {
            var cry = 0;
            if(win)
                cry = getChallengeNeiborCry(scene.argument["oid"]);//param[0]
            global.user.changeValue("crystal", cry);
        }
        else if(scene.kind == CHALLENGE_FIGHT || scene.kind == CHALLENGE_DEFENSE)
        {
            if(win == 1)//攻击其它人擂台 奖励为attackReward
            {

            }
        }

        trace("sceneKind", scene.kind, CHALLENGE_FRI);
        var arenaKind;
        var fData;
        var cost;
        /*
        if(scene.kind == CHALLENGE_MON)
        {
            if(win)
            {

                global.director.pushView(new ChallengeWin(this, dict([["levelUpSol", levelUpSol], ["star", star], ["reward", reward]])), 1, 0);
                //global.taskModel.doNewTaskByKey("round", 1);//任务结束 ---》 检测 是否有 开启下一个任务的时机是否成熟 所有command是否都执行过？ 另外一个任务 阶段胜利任务 一旦进入经营页面场景 就触发
            }
            else
                global.director.pushView(new ChallengeFail(this, dict([["levelUpSol", levelUpSol]])), 1, 0);

            global.httpController.addRequest("soldierC/challengeOver", dict([["uid", global.user.uid], ["sols", updateSoldierData], ["reward", reward], ["star", star], ["big", kind], ["small", small]]), null, null);
        }
        else if(scene.kind == CHALLENGE_FRI)
        {
            global.director.pushView(new ChallengeOver(win, star, crystal, score, this, levelUpSol), 1, 0);
            global.httpController.addRequest("challengeC/challengeResult", dict([["uid", global.user.uid], ["sols", updateSoldierData], ["crystal", crystal], ["score", score]]), null, null);
        }
        else if(scene.kind == CHALLENGE_NEIBOR)
        {
            global.director.pushView(new ChallengeNeibor(win, star, cry, 0, this, levelUpSol), 1, 0);
            //param[0]
            global.httpController.addRequest("friendC/challengeNeiborOver", dict([["uid", global.user.uid], ["fid", scene.argument["oid"]], ["sols", updateSoldierData], ["crystal", cry], ["mid", global.user.getNewMsgId()]]), null, null);
        }
        //奖励 金币 水晶 升级士兵 挑战擂台
        else if(scene.kind == CHALLENGE_FIGHT)
        {
            if(win == 1)
            {
                arenaKind = scene.user.get("kind"); 
                fData = getData(FIGHT_COST, arenaKind);
                cost = getCost(FIGHT_COST, arenaKind);
                cost = multiScalar(cost, fData.get("attackReward"));
                global.user.doAdd(cost);
            }
            else
                cost = dict();
            global.director.pushView(new ChallengeFight(win, star, cost, 0, this, levelUpSol), 1, 0);

            global.httpController.addRequest("fightC/attackOver", dict([["uid", global.user.uid], ["oid", scene.user.get("uid")], ["sols", updateSoldierData], ["crystal", cost.get("crystal", 0)], ["gold", cost.get("gold", 0)], ["win", win]]), null, null);
        }
        else if(scene.kind == CHALLENGE_DEFENSE)
        {
            if(win == 1)
            {
                arenaKind = global.fightModel.getArenaKind(); 
                fData = getData(FIGHT_COST, arenaKind);
                cost = getCost(FIGHT_COST, arenaKind);
                cost = multiScalar(cost, fData.get("defenseReward"));
                global.user.doAdd(cost);
            }
            else
                cost = dict();
            global.director.pushView(new ChallengeFight(win, star, cost, 0, this, levelUpSol), 1, 0);

            global.httpController.addRequest("fightC/defenseOver", dict([["uid", global.user.uid], ["oid", scene.user.get("uid")], ["sols", updateSoldierData], ["crystal", cost.get("crystal", 0)], ["gold", cost.get("gold", 0)], ["win", win]]), null, null);
        }
        */
    }
    
    //训练则不能这样判定
    //闯关挑战 可以通过检测剩余士兵数量来判定游戏是否结束
    function checkGameOver()
    {
        //var v = soldiers.values(); 
        /*
        var myCount = 0;
        var eneCount = 0;

        for(var i = 0; i < len(soldierInstance); i++)
        {
            if(soldierInstance[i].color == MYCOLOR)
            {
                myCount++;
            }
            else
                eneCount++;
        }

        if(myCount == 0 || eneCount == 0)
        {
            var reward = null;
            if(scene.kind == CHALLENGE_MON)
                reward = getRandomMapReward(kind, small);
            var levelUpSol = getAllLevelUp();
            stopGame();
            if(myCount == 0)
                challengeOver(0, 0, null, levelUpSol);
            else
                challengeOver(1, getStar(), reward, levelUpSol);
        }
        */
    }
    
    function trainOver()
    {
        stopGame();
        var levelUpSol = getAllLevelUp(); 
        var updateSoldierData = levelUpSol[1];
        levelUpSol = levelUpSol[0];
        //global.director.pushView(new TrainOverDialog(this, mySoldiers), 1, 0);
        global.httpController.addRequest("soldierC/trainOver", dict([["uid", global.user.uid], ["sols", updateSoldierData]]), null, null);
    }
    //每秒检测一次是否还有我方或者敌方士兵剩余 没有则胜利
    function disappearSoldier(so)
    {
        removeSoldier(so);
        if(scene.kind != CHALLENGE_TRAIN)
            checkGameOver();
    }
    function saveSoldier(so)
    {
        disappearSoldier(so);
    }
    function soldierDead(so)
    {
        disappearSoldier(so);
    }
    //清空mapDict 只在布局时使用
    //清空soldiers
    function removeSoldier(so)
    {
        clearMap(so);
        realRemoveSoldier(so);
    }
    /*
    布局时点击士兵头部 清除士兵数据 
    */
    function clearSoldier(so)
    {
        removeSoldier(so);
        scene.clearSoldier(so);
    }

    //假设场景两侧总有防御装置失效
    var defenses = [];
    function initDefense()
    {
        var defense = mapInfo.get(kind);
        var d = new MapDefense(this, MYCOLOR, defense[0]);
        var i;
        var row;
        d.setDefense(global.user.getValue("cityDefense"));
        addChildZ(d, 0);
        /*
        for(i = 0; i < 5; i++)
        {
            //row = soldiers.get(i, []);
            //row.append(d);
            //soldiers.update(i, row);
        }
        */
        d.setMap();
        defenses.append(d);



        //big*10+small
        d = new MapDefense(this, ENECOLOR, defense[1]);
        d.setDefense(scene.getEneDefense());

        addChildZ(d, 0);
        /*
        for(i = 0; i < 5; i++)
        {
            row = soldiers.get(i, []);
            row.append(d);
            soldiers.update(i, row);
        }
        */
        d.setMap();
        defenses.append(d);

//        trace("soldiers each row", soldiers);
    }
    function getDefense(id)
    {
        return defenses[id];
    }

    var initYet = 0;
    function update(diff)
    {
        if(scene.initYet && !initYet)
            initYet = 1;
    }
    
    function stopGame()
    {
        myTimer.gameStop();
        for(var i = 0; i < len(soldierInstance); i++)
        {
            soldierInstance[i].stopGame();
        }
        /*
        var val = soldiers.values();
        for(var i = 0; i < len(val); i++)
        {
            for(var j = 0; j < len(val[i]); j++)
            {
                val[i][j].stopGame();
            }
        }
        */
    }
    function continueGame()
    {
        myTimer.gameRestart();
        for(var i = 0; i < len(soldierInstance); i++)
        {
            soldierInstance[i].continueGame();
        }
        /*
        var val = soldiers.values();
        for(var i = 0; i < len(val); i++)
        {
            for(var j = 0; j < len(val[i]); j++)
            {
                val[i][j].continueGame();
            }
        }
        */
    }
    override function enterScene()
    {
        myTimer = new Timer(100);
        super.enterScene();
        global.timer.addTimer(this);
        
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        bg.setevent(EVENT_KEYDOWN, null);
        super.exitScene();
        myTimer.stop();
        myTimer = null;
    }

    
    var skillGrid = null;
    function moveSkillGrid(skillData, x, y)
    {
        var sx = skillData.get("sx");
        var sy = skillData.get("sy");

        var oldMap = getSkillMap([x, y], sx, sy, 0);


        var ret = checkSkillPos(scene.skillSoldier, skillData, oldMap);
        //trace("moveSkillGrid", skillData, x, y, sx, sy, "oldMap", oldMap, ret);
            
        if(skillGrid == null)
        {
            skillGrid = bg.addsprite("occGrid0.png").size(MAP_OFFX*sx, MAP_OFFY*sy);
            //bg.add(grid);
            //grid.clipping(0);
        }

        if(ret == 0)
        {
            skillGrid.texture("occGrid0.png", RED);        
        }
        else
        {
            skillGrid.texture("occGrid0.png", WHITE);
        }

        var gp = getGridPos(oldMap);
        skillGrid.pos(gp[0], gp[1]);
    }
    /*
    技能位置在50 50 中心点
    getSkillMap 计算
    */
    function checkSkillPos(sol, skillData, oldMap)
    {
        var ret = checkSkillInBoundary([skillData.get("sx"), skillData.get("sy")], oldMap);
        //trace("checkSkillPos", skillData, oldMap);
        if(ret == 0)
            return 0;

        //直线攻击需要在 英雄所在的若干条直线上
        var skillKind = skillData.get("kind");
        var solMap = getSolMap(sol.getPos(), sol.sx, sol.sy, sol.offY);
        if(skillKind == LINE_SKILL)
        {
            for(var j = 0; j < sol.sy; j++)
            {
                if(oldMap[1] == (solMap[1]+j))
                    return 1;
            }
            return 0;
        }
        //范围攻击任意位置
        return 1;
    }
    function touchBegan(n, e, p, x, y, points)
    {
        if(scene.state == MAP_START_SKILL)//释放技能选择目标开始
        {
            var skillData = getData(SKILL, scene.skillId);
            var skillKind = skillData.get("kind");
            var po = n.node2world(x, y);//可能是soldier 传递的touch时间所以需要先转化成本地的touch点
            po = bg.world2node(po[0], po[1]);
            //线性方向选择
            if(skillKind == LINE_SKILL)
            {
                moveSkillGrid(skillData, po[0], po[1]);
            }
            //选择攻击目标士兵 
            else if(skillKind == SINGLE_ATTACK_SKILL || skillKind == SPIN_SKILL || skillKind == HEAL_SKILL || skillKind == MULTI_HEAL_SKILL || skillKind == SAVE_SKILL || skillKind == USE_DRUG_SKILL)
            {
                
            }
            //选择攻击范围
            else if(skillKind == MULTI_ATTACK_SKILL)
            {
                //坐标可能从 士兵传来 需要先转化成 世界坐标再计算相对地图坐标位置
                moveSkillGrid(skillData, po[0], po[1]);
            }
            clearMoveSol();
        }
        else if(curMovSol == null)
            touchDelegate.tBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        if(scene.state == MAP_START_SKILL)//释放技能选择目标开始
        {
            var skillData = getData(SKILL, scene.skillId);
            var skillKind = skillData.get("kind");
            var po;
            po = n.node2world(x, y);
            po = bg.world2node(po[0], po[1]);
            //线性方向选择
            if(skillKind == LINE_SKILL)
            {
                moveSkillGrid(skillData, po[0], po[1]);
            }
            //选择攻击目标士兵
            else if(skillKind == SINGLE_ATTACK_SKILL || skillKind == SPIN_SKILL || skillKind == HEAL_SKILL || skillKind == MULTI_HEAL_SKILL || skillKind == SAVE_SKILL || skillKind == USE_DRUG_SKILL)
            {
            }
            //选择攻击范围
            else if(skillKind == MULTI_ATTACK_SKILL)
            {
                moveSkillGrid(skillData, po[0], po[1]);
            }
        }
        else if(curMovSol == null)
            touchDelegate.tMoved(n, e, p, x, y, points);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        if(scene.state == MAP_START_SKILL)//释放技能选择目标开始
        {
            var skillData = getData(SKILL, scene.skillId);
            var skillKind = skillData.get("kind");
            var po;

            po = n.node2world(x, y);
            po = bg.world2node(po[0], po[1]);
            var sx = skillData.get("sx");
            var sy = skillData.get("sy");
            var oldMap;
            var ret;
            //线性方向选择
            if(skillKind == LINE_SKILL)
            {
                oldMap = getSkillMap(po, sx, sy, 0);
                ret = checkSkillPos(scene.skillSoldier, skillData, oldMap);
                if(ret == 0)
                {
                    scene.setTargetSol(null);
                }
                else
                {
                    scene.setTargetSol(po);//攻击左右方向
                }
                skillGrid.removefromparent();
                skillGrid = null;
                //grid.removefromparent();
            }
            //选择攻击目标士兵
            else if(skillKind == SINGLE_ATTACK_SKILL || skillKind == SPIN_SKILL || skillKind == HEAL_SKILL || skillKind == MULTI_HEAL_SKILL || skillKind == SAVE_SKILL || skillKind == USE_DRUG_SKILL)
            {
                scene.setTargetSol(null);
            }
            //选择攻击范围
            else if(skillKind == MULTI_ATTACK_SKILL)
            {
                oldMap = getSkillMap(po, sx, sy, 0);
                ret = checkSkillPos(scene.skillSoldier, skillData, oldMap);
                if(ret == 0)
                {
                    scene.setTargetSol(null);
                }
                else
                {
                    scene.setTargetSol([oldMap[0], oldMap[1]]);
                }
                skillGrid.removefromparent();
                skillGrid = null;
            }
        }
        else if(curMovSol == null)
            touchDelegate.tEnded(n, e, p, x, y, points);
        else//确定当前士兵移动方向
        {
            po = n.node2world(x, y);
            po = bg.world2node(po[0], po[1]);
            var tarPosMov = [po[0], curMovSol.bg.pos()[1]];// 手指的x 坐标  士兵自身的y 坐标
            curMovSol.setMoveTar(tarPosMov);
            curMovSol = null;
        }
    }

    //单体技能设定 目标士兵
    //群体技能设定 范围网格
    function doSkillEffect(attacker, target, skillId, skillLevel)
    {
        var data = getData(SKILL, skillId);
        var skill = null;
        //直线 范围攻击 在地图上
        //单体攻击在 士兵身上 但是相对位置不同
        if(data["kind"] == LINE_SKILL)
        {
            skill = new LineSkill(this, attacker, target, skillId, skillLevel); 
            addChildZ(skill, MAX_BUILD_ZORD);
        }
        else if(data["kind"] == SINGLE_ATTACK_SKILL)
        {
            skill = new SingleSkill(this, attacker, target, skillId, skillLevel);
            addChildZ(skill, MAX_BUILD_ZORD);
        }
        else if(data["kind"] == MULTI_ATTACK_SKILL)
        {
            skill = new MultiSkill(this, attacker, target, skillId, skillLevel);
            addChildZ(skill, MAX_BUILD_ZORD);
        }
        else if(data["kind"] == SPIN_SKILL)
        {
            skill = new SpinSkill(this, attacker, target, skillId, skillLevel);
            addChildZ(skill, MAX_BUILD_ZORD);
        }
        else if(data["kind"] == HEAL_SKILL || data["kind"] == MULTI_HEAL_SKILL)
        {
            skill = new HealSkill(this, attacker, target, skillId, skillLevel);//显示的图片是默认的治疗图片
            target.addChildZ(skill, MAX_BUILD_ZORD);
        }
        //单体技能加在士兵身上
        else if(data["kind"] == SAVE_SKILL)
        {
            skill = new SaveSkill(this, attacker, target, skillId, skillLevel);
            addChildZ(skill, MAX_BUILD_ZORD);
        }
        else if(data["kind"] == USE_DRUG_SKILL)
        {
            skill = new UseDrugSkill(this, attacker, target, scene.drugId);
            target.addChildZ(skill, MAX_BUILD_ZORD);
        }
        else if(data["kind"] == MAKEUP_SKILL)//变身技能
        {
            attacker.doMakeUp(skillId, skillLevel);
        }

        //addChildZ(skill, MAX_BUILD_ZORD);
    }
    function hideBlood()
    {
        for(var i = 0; i < len(soldierInstance); i++)
        {
            var sol = soldierInstance[i];
            sol.hideBlood();
        }
        /*
        var allSol = soldiers.values();
        for(var i = 0; i < len(allSol); i++)
        {
            for(var j = 0; j < len(allSol[i]); j++)
            {
                var sol = allSol[i][j];
                if(sol.state != MAP_SOL_DEFENSE && sol.state != MAP_SOL_DEAD && sol.state != MAP_SOL_SAVE)
                    sol.hideBlood();
            }
        }
        */
    }
    function showBlood()
    {
        for(var i = 0; i < len(soldierInstance); i++)
        {
            var sol = soldierInstance[i];
            sol.showBlood();
        }
        /*
        var allSol = soldiers.values();
        for(var i = 0; i < len(allSol); i++)
        {
            for(var j = 0; j < len(allSol[i]); j++)
            {
                var sol = allSol[i][j];
                if(sol.state != MAP_SOL_DEFENSE && sol.state != MAP_SOL_DEAD && sol.state != MAP_SOL_SAVE)
                    sol.showBlood();
            }
        }
        */
    }
    var curMovSol = null;
    //设定当前要移动的士兵
    function setMoveSol(sol)
    {
        if(curMovSol == null && scene.kind == CHALLENGE_TRAIN)
        {
            curMovSol = sol;
            global.director.curScene.addChild(new UpgradeBanner(getStr("selTarPos", null), [100, 100, 100], null));
        }
    }
    function clearMoveSol()
    {
        curMovSol = null;
    }
}
