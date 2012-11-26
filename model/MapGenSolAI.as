/*
随机生成 4种之一的AI 士兵
加入AI 更新机制

MiniSoldier 存储士兵基本的状态 health curMap id mapSolId color
WarStateModel 存储当前游戏状态

测试需要在一个小点的棋盘上进行
getParam 获取

AI 流程：
  定时更新---》
     获取当前状态 ----》roundGridController Scene Map
     minimaxDecision ---> 决策当前状态结果
        有可行走步骤---》检测是否可以攻击到目标
        可以AI 放置士兵


minimaxDecision:
    actions 获取当前状态所有可能的下的步
    result 获取我下某步的结果
    minValue 敌方应对结果
    maxValue 我方应对结果
    
    返回可能的 类型 位置



*/
class MapGenSolAI extends MyNode
{
    const INFINITY = 10000;
    const MAX_DEPTH = 3;
    var player;
    var scene;
    var sid = [0, 20, 30, 60];
    var WAR_MAP_WIDTH;
    var WAR_MAP_HEIGHT;
    var WAR_MAP_LEFT_BOUND;
    var WAR_MAP_RIGHT_BOUND;
    function MapGenSolAI(s)
    {
        WAR_MAP_WIDTH = getParam("WAR_MAP_WIDTH");
        WAR_MAP_HEIGHT = getParam("WAR_MAP_HEIGHT");
        WAR_MAP_LEFT_BOUND = WAR_MAP_WIDTH/2-1;
        WAR_MAP_RIGHT_BOUND = WAR_MAP_LEFT_BOUND+2;

        scene = s;
        bg = node();
        init();
    }
    /*
    数量 限制地图上最多5个士兵
    棋盘 状态 x y ---> sid -----> solAttribute
    或者直接指向对象  soldierObject ---> 对应solId
    */
    //得到 我 攻击 地方时 需要 的 加的sx 
    //tar - sol = direction
    //direction > 0 mySx
    //direction < 0 tarSx
    //传入 getData 的结果
    
    function getSx(sol, des, direction)
    {
        if(direction > 0)
            return sol["sx"];
        return des["sx"];
    }

    //Todo:
    //考虑 士兵体积问题
    function checkAttackable(state, move)
    {
        var sol = new MiniSoldier(null); 
        sol.curMap = move[1];
        sol.id = move[0];
        sol.health = getData(SOLDIER, sol.id)["healthBoundary"];
        sol.color = state.toMove;
        var tc = findTar(state, sol);
        var sData;
        if(tc[0] != null)
        {
            var direction = Sign(tc[0].curMap[0]-sol.curMap[0]);
            var mid = 0;
            for(var i = sol.curMap[0]+direction; i != tc[0].curMap[0]; i += direction)
            {
                var m = state.mapDict.get(getMapKey(i, sol.curMap[1]));
                if(m != null)
                {
                    sData = getData(SOLDIER, state.solAttribute.get(m).id); 
                    mid += sData["range"]+sData["sx"];
                    if(mid > (getData(SOLDIER, sol.id)["range"]+1))
                        return 0;
                }
            }
        }
        else 
            return 0;
        return 1;
    }

    function fastPut(state, move)
    {
        var sol = new MiniSoldier(null);
        sol.curMap = move[1];
        sol.id = move[0];
        sol.health = getData(SOLDIER, move[0])["healthBoundary"];
        sol.color = state.toMove;

        addNewSol(state, sol)
        return sol;
    }
    function fastClear(state, sol)
    {
        doDead(state, sol);
    }

    //最近的可以攻击的敌人--->A B C D 之间没有太多的距离
    function findTar(state, sol)
    {
        var minTime = INFINITY;
        var tar = [];
        var i;
        var ene;
        var total;
        var mid = 0;
        var solData = getData(SOLDIER, sol.id);
        var sData;
        for(i = sol.curMap[0]-1; i >= 0; i--)
        {
            ene = state.mapDict.get(getMapKey(i, sol.curMap[1]));
            if(ene != null)
            {
                ene = state.solAttribute[ene];
                if(ene.color != sol.color)
                {
                    total = calCost(state, sol, ene);
                    if(total < minTime)
                    {
                        minTime = total;
                        tar = [ene];
                    }
                    else if(total == minTime)
                        tar.append(ene);
                    break;
                }
                else
                {
                    sData = getData(SOLDIER, ene.id); 
                    mid += sData["sx"];
                    if(mid > solData["range"])//中间距离超过攻击范围则忽略 
                        break;
                }
            }
        }
        mid = 0;
        for(i = sol.curMap[0]+1; i < WAR_MAP_WIDTH; i++)
        {
            ene = state.mapDict.get(getMapKey(i, sol.curMap[1]));
            if(ene != null)
            {
                ene = state.solAttribute[ene];
                if(ene.color != sol.col)
                {
                    total = calCost(state, sol, ene);
                    if(total < minTime)
                    {
                        minTime = total;
                        tar = [ene];
                    }
                    else if(total == minTime)
                        tar.append(ene);
                    break;
                }
                else
                {
                    sData = getData(SOLDIER, ene.id); 
                    mid += sData["sx"];
                    if(mid > solData["range"])//中间距离超过攻击范围则忽略 
                        break;
                }
            }
            
        }

        if(len(tar) > 1)
        {
            var rd = rand(len(tar));
            tar = tar[rd];
        }
        else if(len(tar) == 1)
            tar = tar[0];
        else
            tar = null;
        return [tar, minTime];
    }
    //不考虑对方下子
    function evalue(state)
    {
        var allPairs = dict(); //A {attackList, enemy}
        var kv = state.solAttribute.items();
        var i;
        for(i = 0; i < len(kv); i++)
        {
            var key = kv[i][0];
            var value = kv[i][1];
            if(value.id != MAP_DEFENSE_ID)
            {
                var tc = findTar(state, value);
                if(tc[0] != null)
                {
                    var srcAtt = allPairs.setdefault(value.mapSolId, dict());
                    var desAtt = allPairs.setdefault(tc[0].mapSolId, dict());
                    srcAtt["enemy"] = tc[0].mapSolId;
                    var attacker = desAtt.setdefault("attackList", []);
                    attacker.append(value.mapSolId);
                }
            }
        }
        //killTime allPairs sid--->time sort
        var pairs = allPairs.items();
        //计算每一个人的死亡时间
        for(i = 0; i < len(pairs); i++)
        {
            var minTime = INFINITY;
            var solId = pairs[i][0];
            var attackList = pairs[i][1].get("attackList", []);
            for(var j = 0; j < )
            
        }
        //最小的死亡 更新其攻击者状态
        //只有攻击死亡对象的 士兵需要替换目标
    }
    function update(diff)
    {
        trace("start AI");
        var curState = new WarStateModel();
        curState.toMove = "B";
        curState.mapDict = scene.map.roundGridController.mapDict;
        curState.leftSoldier = scene.map.roundGridController.leftSoldier;
        curState.rightSoldier = scene.map.roundGridController.rightSoldier;
        curState.freeList = scene.map.roundGridController.freeList;
        curState.leftSolNum = scene.leftSolNum;
        curState.rightSolNum = scene.rightSolNum; 
        curState.leftDefense = scene.map.getDefense(0).mapSolId;
        curState.rightDefense = scene.map.getDefense(1).mapSolId;
        curState.maxSolId = scene.map.maxMapIds;
        curState.solAttribute = scene.map.roundGridController.solAttribute;//修改状态需要在copy上修改 

        var newState = curState.deepCopy();
        var whereToPut = actions(newState);
        trace("whereToPut", len(whereToPut));
        var score = -INFINITY;
        var possibleAct = [];
        for(var i = 0; i < len(whereToPut); i++)
        {
            var sol = fastPut(newState, whereToPut[i]); 
            var newScore = evalue(newState);
            if(newScore > score)
            {
                possibleAct = [whereToPut[i]];
            }
            else if(newScore == score)
                possibleAct.append(whereToPut[i]);
            fastClear(newState, sol);
        }
        trace(possibleAct);
        if(len(possibleAct) > 0)
        {
        }
        /*
        var possibleActions = minimaxDecision(curState);
        if(len(possibleActions) > 0)
        {
            var move = possibleActions[rand(len(possibleActions))];
            var ret = checkAttackable(curState, move);
            if(ret)
            {
                scene.putNewSol(move);
            }
        }
        */
        trace("endAI");
    }
    function maxValue(state, depth, alpha, beta)
    {
        var nodeCount = 1;
        if(depth <= 0)
            return utility(state);
        if(gameOver(state))
            return utility(state);
        var v = -INFINITY;
        var moved = 0;
        var posActions = actions(state);
        for(var i = 0; i < len(posActions); i++)
        {
            var newV = minValue(result(state, posActions[i]), depth-1, alpha, beta);
            if(newV > beta)
                return newV;
            beta = newV;
            v = max(v, newV);
            moved = 1;
        }
        if(!moved)
            return utility(state);
        return v;
    }
    function minValue(state, depth, alpha, beta)
    {
        if(depth <= 0)
            return utility(state);
        if(gameOver(state))
            return utility(state);
        var v = INFINITY;
        var moved = 0;
        var posActions = actions(state);
        for(var i = 0; i < len(posActions); i++)
        {
            var newV = maxValue(result(state, posActions[i]), depth-1, alpha, beta);
            if(newV < alpha)
                return newV;
            alpha = newV;
            v = min(v, newV);
            moved = 1;
        }
        if(!moved)
            return utility(state);
        return v;
    }
    function minimaxDecision(state)
    {
        player = state.toMove;//只有可能是计算机
        var v = -INFINITY;
        var posActions = actions(state);
        var res = [];
        for(var i = 0; i < len(posActions); i++)
        {
            var newV = minValue(result(state, posActions[i]), MAX_DEPTH, -INFINITY, INFINITY);
            if(newV > v)
            {
                res = [posActions[i]];
            }
            else if(newV == v)
            {
                res.append(posActions[i]);
            }
            v = max(newV, v);
        }
        return res;
    }
    function utility(state)
    {
        while(!testNeedUpdate(state))
            updateState(state);
        var score = 0;
        var totalHealth;
        var leftHealth;
        var i;
        var tempArr = [];

        var AFail = state.leftSolNum >= scene.leftMaxNum && len(state.leftSoldier) == 0; 
        var BFail = state.rightSolNum >= scene.rightMaxNum && len(state.rightSoldier) == 0;

        if(state.solAttribute.get(state.leftDefense) == null && state.solAttribute.get(state.rightDefense) != null)
        {
            totalHealth = 0;
            leftHealth = 0;
            totalHealth += scene.map.getDefense(1).healthBoundary;
            leftHealth += scene.solAttributestate.get(state.rightDefense).health;
            tempArr.extend(state.rightSoldier);
            for(i = 0; i < len(tempArr); i++)
            {
                leftHealth += state.solAttribute[tempArr[i]].health;
                totalHealth += getData(SOLDIER, state.solAttribute[tempArr[i]].id)["healthBoundary"];
            }
            if(totalHealth > 0)
                score = myFloor(-leftHealth*100/totalHealth);
            else
                score = -100;
        }
        else if(state.solAttribute.get(state.leftDefense) != null && state.solAttribute.get(state.rightDefense) == null)
        //else if(state['rightDefense']['health'] <= 0 && state['leftDefense']['health'] > 0)
        {
            totalHealth = 0;
            leftHealth = 0;
            totalHealth += scene.map.getDefense(1).healthBoundary;
            leftHealth += scene.solAttributestate.get(state.leftDefense).health;
            tempArr.extend(state.leftSoldier);
            for(i = 0; i < len(tempArr); i++)
            {
                leftHealth += state.solAttribute[tempArr[i]].health;
                totalHealth += getData(SOLDIER, state.solAttribute[tempArr[i]].id)["healthBoundary"];
            }
            if(totalHealth > 0)
                score = myFloor(leftHealth*100/totalHealth);
            else
                score = 100;
        }
        else if(state.solAttribute.get(state.leftDefense) == null && state.solAttribute.get(state.rightDefense) == null)
            score = 0;
        else if(AFail || BFail)
        {
            if(AFail && BFail)
                score = 0;
            else if(AFail)
            {
                totalHealth = 0;
                leftHealth = 0;

                tempArr.extend(state.rightSoldier);
                for(i = 0; i < len(tempArr); i++)
                {
                    leftHealth += state.solAttribute[tempArr[i]].health;
                    totalHealth += getData(SOLDIER, state.solAttribute[tempArr[i]].id)["healthBoundary"];
                }
                if(totalHealth > 0)
                    score = myFloor(-leftHealth*100/totalHealth);
                else
                    score = -100;
            }
            else if(BFail)
            {
                totalHealth = 0;
                leftHealth = 0;

                tempArr.extend(state.leftSoldier);
                for(i = 0; i < len(tempArr); i++)
                {
                    leftHealth += state.solAttribute[tempArr[i]].health;
                    totalHealth += getData(SOLDIER, state.solAttribute[tempArr[i]].id)["healthBoundary"];
                }
                if(totalHealth > 0)
                    score = myFloor(leftHealth*100/totalHealth);
                else
                    score = 100;
            }
        }
        if(player == "B")
            score = -score;
        return score;
    }
    function calCost(state, sol, ene)
    {
        if(ene.health <= 0)
            return INFINITY;

        var src = getData(SOLDIER, sol.id);
        var des = getData(SOLDIER, ene.id);

        var dist = abs(sol.curMap[0]-ene.curMap[0]);
        var attRange = src["range"];
        
        var movTime = dist-attRange-getSx(src, des, ene.curMap[0]-sol.curMap[0]);
        
        var att = getData(SOLDIER, sol.id)["attack"];
        var attType = getData(SOLDIER, sol.id)["attackType"];
        var defType = getData(SOLDIER, ene.id)["defenseType"];
        var attTime = myCeil(ene.health/(att*HARM_TABLE[attType][defType]));
        var total = movTime+attTime;
        return total;
    }
    //模拟游戏 可以用于 soldierAI
    function findTar(state, sol)
    {
        var minTime = INFINITY;
        var tar = [];
        var i;
        var ene;
        var total;
        for(i = sol.curMap[0]-1; i >= 0; i--)
        {
            ene = state.mapDict.get(getMapKey(i, sol.curMap[1]));
            if(ene != null)
            {
                ene = state.solAttribute[ene];
                if(ene.color != sol.color)
                {
                    total = calCost(state, sol, ene);
                    if(total < minTime)
                    {
                        minTime = total;
                        tar = [ene];
                    }
                    else if(total == minTime)
                        tar.append(ene);
                    break;
                }
            }
        }
        for(i = sol.curMap[0]+1; i < WAR_MAP_WIDTH; i++)
        {
            ene = state.mapDict.get(getMapKey(i, sol.curMap[1]));
            if(ene != null)
            {
                ene = state.solAttribute[ene];
                if(ene.color != sol.col)
                {
                    total = calCost(state, sol, ene);
                    if(total < minTime)
                    {
                        minTime = total;
                        tar = [ene];
                    }
                    else if(total == minTime)
                        tar.append(ene);
                    break;
                }
            }
            
        }

        if(len(tar) > 1)
        {
            var rd = rand(len(tar));
            tar = tar[rd];
        }
        else if(len(tar) == 1)
            tar = tar[0];
        else
            tar = null;
        return [tar, minTime];
    }
    function doAttack(state, sol, tar)
    {
        var attType = getData(SOLDIER, sol.id)["attackType"];
        var defType = getData(SOLDIER, tar.id)["defenseType"];
        var att = getData(SOLDIER, sol.id)["attack"];
        tar.health -= HARM_TABLE[attType][defType]*att;
        if(tar.health <= 0)
            return 1;
        return 0;
    }
    //对于有体积的士兵攻击和移动计算 
    //暂时值考虑
    function doMoveOrAttack(state, sol, tar)
    {
        var dist = abs(sol.curMap[0]-tar.curMap[0]);
        var src = getData(SOLDIER, sol.id);
        var des = getData(SOLDIER, tar.id); 
        var attRange = src["range"];
        if(dist <= attRange+getSx(src, des, tar.curMap[0]-sol.curMap[0]))
        {
            var ret = doAttack(state, sol, tar);
            return [0, ret];
        }
        else
            return [1, 0];
    }
    //暂时不支持 士兵体积
    function doMove(state, sol, tar)
    {
        var direciton = Sign(tar.curMap[0]-sol.curMap[0]);
        var newPos = sol.curMap[0]+direciton;
        var occ = state.mapDict.get(getMapKey(newPos, sol.curMap[1]));
        if(occ == null)
        {
            var sData = getData(SOLDIER, sol.id);
            roundClearMap(state, sol.curMap[0], sol.curMap[1], sData["sx"], sData["sy"], sol);
            sol.curMap = [newPos, sol.curMap[1]];
            roundSetMap(state, sol.curMap[0], sol.curMap[1], sData["sx"], sData["sy"], sol);
        }
    }
    function doDead(state, sol)
    {
        var sData = getData(SOLDIER, sol.id);
        roundClearMap(state, sol.curMap[0], sol.curMap[1], sData["sx"], sData["sy"], sol);
        state.solAttribute.pop(sol.mapSolId);//死亡士兵删除
    }
    //init Defense setMap 
    function updateState(state)
    {
        var allMov = [];
        var allDead = [];
        var kv = state.solAttribute.items();
        var i;
        for(i = 0; i < len(kv); i++)
        {
            var key = kv[i][0];
            var value = kv[i][1];
            if(value.id != MAP_DEFENSE_ID)
            {
                var tc = findTar(state, value);
                if(tc[0] != null)
                {
                    var moveDead = doMoveOrAttack(state, value, tc[0]);
                    if(moveDead[0])
                        allMov.append([value, tc[0]]);
                    if(moveDead[1])
                        allDead.append(tc[0]);
                }
            }
        }
        for(var j = 0; j < len(allMov); j++)
        {
            doMove(state, allMov[j][0], allMov[j][1]);
        }
        for(i = 0; i < len(allDead); i++)
            doDead(state, allDead[i]);

    }
    function testNeedUpdate(state)
    {
        if(state.solAttribute.get(state.leftDefense) == null || state.solAttribute.get(state.rightDefense) == null)
            return 1;
        if(state.leftSolNum >= scene.leftMaxNum && len(state.leftSoldier) == 0)
            return 1;
        if(state.rightSolNum >= scene.rightMaxNum && len(state.rightSoldier) == 0)
            return 1;
        //没有士兵可以移动停止更新状态 士兵都互相攻击死亡了
        if(len(state.rightSoldier) == 0 && len(state.leftSoldier) == 0)
            return 1;
        return 0;
    }
    function gameOver(state)
    {
        if(state.solAttribute.get(state.leftDefense) == null || state.solAttribute.get(state.rightDefense) == null)
            return 1;
        if(state.leftSolNum >= scene.leftMaxNum && len(state.leftSoldier) == 0)
            return 1;
        if(state.rightSolNum >= scene.rightMaxNum && len(state.rightSoldier) == 0)
            return 1;
        return 0;
    }

    var selKind = [0, 20, 30, 60];
    function actions(state)
    {
        var i, p;
        var res = [];
        var tempArr = [];
        var coord;
        if(state.toMove == "A" && state.leftSolNum < scene.leftMaxNum)
        {
            tempArr.extend(state.freeList);
            for(i = 0; i < len(selKind); i++)
            {
                for(p = 0; p < len(tempArr); p++)
                {
                    coord = getMapXY(tempArr[p]);
                    if(coord[0] <= WAR_MAP_LEFT_BOUND && coord[0] > 0 && (coord[0] == WAR_MAP_LEFT_BOUND || !(getMapKey(coord[0]+1, coord[1]) in state.freeList) || (coord[0]-1 != 0 && !(getMapKey(coord[0]-1, coord[1]) in state.freeList))) ) 
                        res.append([selKind[i], coord]);
                }
            }
        }
        else if(state.toMove == "B" && state.rightSolNum < scene.rightMaxNum)
        {
            tempArr.extend(state.freeList);
            for(i = 0; i < len(selKind); i++)
            {
                for(p = 0; p < len(tempArr); p++)
                {
                    coord = getMapXY(tempArr[p]);
                    if(coord[0] >= WAR_MAP_RIGHT_BOUND && coord[0] < (WAR_MAP_WIDTH-1) && (coord[0] == WAR_MAP_RIGHT_BOUND || ((coord[0]+1) != (WAR_MAP_WIDTH-1) && !(getMapKey(coord[0]+1, coord[1]) in state.freeList)) || (!(getMapKey(coord[0]-1, coord[1]) in state.freeList))) ) 
                        res.append([selKind[i], coord]);
                }
            }
        }
        return res;
    }

    //一方下子 另一方下子 color 变化
    function result(state, move)
    {
        var newState = state.deepCopy();
        newState.toMove = if_(state.toMove=="A", "B", "A");
        var sol = new MiniSoldier(null);
        sol.curMap = move[1];
        sol.id = move[0];
        sol.health = getData(SOLDIER, move[0])["healthBoundary"];
        sol.color = state.toMove;

        addNewSol(newState, sol)
        return newState;
    }
    function addNewSol(state, sol)
    {
        var sdata = getData(SOLDIER, sol.id);
        sol.mapSolId = state.maxSolId++; 
        roundSetMap(state, sol.curMap[0], sol.curMap[1], sdata["sx"], sdata["sy"], sol);
    }

    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
        
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
