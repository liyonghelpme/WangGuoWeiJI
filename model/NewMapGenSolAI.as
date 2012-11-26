/*
BattleScene 进入场景 开始AI
update 3000s更新一次

获取当前状态
获取当前可以移动的位置

测试每个位置
    放置士兵可以攻击目标
    评估得分战斗结果

评估得分：
    获取最近的攻击对 A<----B C D   B<-----A C 
    得到最短的攻击次数
    所有人减去最小攻击次数造成的伤害 生命值 <= 0 则死亡
    如果有剩余的士兵 则重复这个过程 
    直到平局 或者一方死光 或者 一方城墙被破坏

*/
class NewMapGenSolAI extends MyNode
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
    function NewMapGenSolAI(s)
    {
        WAR_MAP_WIDTH = getParam("WAR_MAP_WIDTH");
        WAR_MAP_HEIGHT = getParam("WAR_MAP_HEIGHT");
        WAR_MAP_LEFT_BOUND = WAR_MAP_WIDTH/2-1;
        WAR_MAP_RIGHT_BOUND = WAR_MAP_LEFT_BOUND+2;

        scene = s;
        bg = node();
        init();
    }

    function getSx(sol, des, direction)
    {
        if(direction > 0)
            return sol["sx"];
        return des["sx"];
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
        var attTime = myCeil(ene.health*100/(att*HARM_TABLE[attType][defType]));
        var total = movTime+attTime;
        return total;
    }
    function addNewSol(state, sol)
    {
        var sdata = getData(SOLDIER, sol.id);
        sol.mapSolId = state.maxSolId++; 
        roundSetMap(state, sol.curMap[0], sol.curMap[1], sdata["sx"], sdata["sy"], sol);
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

    function display(state)
    {
    }
    //最近的可以攻击的敌人--->A B C D 之间没有太多的距离
    function findTar(state, sol)
    {
        trace("now State", state, sol.mapSolId);
        sol.printSoldier();
        state.printState();
        var minTime = INFINITY;
        var tar = [];
        var i;
        var ene;
        var total;
        var mid = 0;
        var solData = getData(SOLDIER, sol.id);
        var sData;

        //找到一个方向的最近的敌人
        mid = 0;
        for(i = sol.curMap[0]-1; i >= 0; i--)
        {
            ene = state.mapDict.get(getMapKey(i, sol.curMap[1]));
            //trace("findTar", sol.printSoldier(), i, ene);
            if(ene != null)
            {
                ene = state.solAttribute[ene];
                //trace("ene", ene.id, ene.health, ene.curMap);
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
            //trace("findTar", sol.printSoldier(), i, ene);
            if(ene != null)
            {
                ene = state.solAttribute[ene];
                //trace("ene", ene.id, ene.health, ene.curMap, ene.color);
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

        if(len(tar) > 1)
        {
            var rd = rand(len(tar));
            tar = tar[rd];
        }
        else if(len(tar) == 1)
            tar = tar[0];
        else
            tar = null;
        if(tar != null)
        {
            trace("findTarOver", tar.mapSolId, "cost", minTime);
            sol.printSoldier();
            tar.printSoldier();
        }

        return [tar, minTime];
    }

    /*
    寻找最近的可以攻击的敌人 构成对
    寻找攻击次数最小的对 minKillNum
    所有士兵减去其攻击*最小次数 剔除死亡士兵
    循环 直到没有 没有攻击次数最小的士兵---> 则剩下的胜利方
    计算胜利方剩余的生命值百分比例 left/total
    */
    function findNearPairs(state)
    {
        var allPairs = dict(); //A {attackList, enemy}
        var kv = state.solAttribute.items();
        var i;
        for(i = 0; i < len(kv); i++)
        {
            var key = kv[i][0];
            var value = kv[i][1];
            trace("findNearPairs");
            trace(key);
            value.printSoldier();
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
        return allPairs;
    }
    function findMinKillNum(state, pairs)
    {
        var minKillNum = INFINITY;
        var minKillSolId = null;
        var allAttack = [];
        var i;
        //计算每一个人的死亡时间
        for(i = 0; i < len(pairs); i++)
        {
            var minTime = INFINITY;
            var solId = pairs[i][0];
            var attackList = pairs[i][1].get("attackList", []);
            var totalAttack = 0;
            var solData = getData(SOLDIER, state.solAttribute[solId].id);
            var defType = solData["defenseType"];
            for(var j = 0; j < len(attackList); j++)
            {
                var att = state.solAttribute.get(attackList[j]);
                var attData = getData(SOLDIER, att.id);
                var attackType = attData["attackType"];
                totalAttack += attData["attack"]*HARM_TABLE[attackType][defType];
            }
            if(totalAttack > 0)
            {
                var killNum = (state.solAttribute[solId].health*100+totalAttack-1)/totalAttack;
                if(killNum < minKillNum)
                {
                    minKillNum = killNum;
                    minKillSolId = solId;
                }
            }
            allAttack.append([solId, totalAttack]);
        }
        return [minKillSolId, minKillNum, allAttack];
    }
    /*
    根据当前状态评估棋盘得分
    */
    function evalue(state)
    {
        trace("evalue");
        while(1)
        {
            var allPairs = findNearPairs(state); 
            var pairs = allPairs.items();
            var minKill = findMinKillNum(state, pairs);
            var minKillSolId = minKill[0];
            var minKillNum = minKill[1];
            var allAttack = minKill[2];

            //需要杀死次数最小的士兵 优先级队列 标记删除 重新加入
            //更新所有士兵的生命值 
            //重新发现被杀死的
            if(minKillSolId != null)
            {
                for(var k = 0; k < len(allAttack); k++)
                {
                    var health = state.solAttribute[allAttack[k][0]].health;
                    health = getLeftHealth(health, allAttack[k][1], minKillNum);
                    if(health <= 0)
                        doDead(state, state.solAttribute[allAttack[k][0]]);
                }
            }
            else
                break;
            if(len(state.leftSoldier) == 0 || len(state.rightSoldier) == 0)
                break;
        }
        return utility(state);
    }
    function getLeftHealth(health, totalAttack, killNum)
    {
        health = health*100 - totalAttack*killNum;
        return health/100;
    }

    function doDead(state, sol)
    {
        var sData = getData(SOLDIER, sol.id);
        roundClearMap(state, sol.curMap[0], sol.curMap[1], sData["sx"], sData["sy"], sol);
        state.solAttribute.pop(sol.mapSolId);//死亡士兵删除
    }

    function utility(state)
    {

        var score = 0;
        var totalHealth;
        var leftHealth;
        var i;
        var tempArr = [];

        var AFail = state.leftSolNum >= scene.leftMaxNum && len(state.leftSoldier) == 0; 
        var BFail = state.rightSolNum >= scene.rightMaxNum && len(state.rightSoldier) == 0;

        trace("utility");
        state.printState();
        trace(AFail, BFail);
        if(state.solAttribute.get(state.leftDefense) == null && state.solAttribute.get(state.rightDefense) != null)
        {
            totalHealth = 0;
            leftHealth = 0;
            totalHealth += scene.map.getDefense(1).healthBoundary;
            leftHealth += state.solAttribute.get(state.rightDefense).health;
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
            leftHealth += state.solAttribute.get(state.leftDefense).health;
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

    function initState()
    {
        trace("initial state");
        var curState = new WarStateModel();
        curState.toMove = ENECOLOR;
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

        curState.printState();

        return curState;
    }

    var selKind = [0, 20, 30, 60];
    function actions(state)
    {
        trace("getActions");
        var i, p;
        var res = [];
        var tempArr = [];
        var coord;
        if(state.toMove == MYCOLOR && state.leftSolNum < scene.leftMaxNum)
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
        else if(state.toMove == ENECOLOR && state.rightSolNum < scene.rightMaxNum)
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

    function findKillNum(state, pairs)
    {
        var i;
        var allKillNum = dict();
        //计算每一个人的死亡时间
        for(i = 0; i < len(pairs); i++)
        {
            var minTime = INFINITY;
            var solId = pairs[i][0];
            var attackList = pairs[i][1].get("attackList", []);
            var totalAttack = 0;
            var solData = getData(SOLDIER, state.solAttribute[solId].id);
            var defType = solData["defenseType"];
            for(var j = 0; j < len(attackList); j++)
            {
                var att = state.solAttribute.get(attackList[j]);
                var attData = getData(SOLDIER, att.id);
                var attackType = attData["attackType"];
                totalAttack += attData["attack"]*HARM_TABLE[attackType][defType];
            }
            if(totalAttack > 0)
            {
                var killNum = (state.solAttribute[solId].health*100+totalAttack-1)/totalAttack;
                allKillNum.update(solId, killNum);
            }
            else
                allKillNum.update(solId, INFINITY);
        }
        return allKillNum;
    }
    /*
    所有对
    */
    function evalueSol(state, sol)
    {
        trace("evalueSol", state, sol.mapSolId);
        state.printState();
        var allPairs = findNearPairs(state);
        var pairs = allPairs.items();
        var allKillNum = findKillNum(state, pairs);
        trace("pairs");
        trace(allPairs);
        trace("allKillNum");
        trace(allKillNum);
        var killNum = allKillNum.items();
        var AKillNum = 0;
        var BKillNum = 0;
        for(var i = 0; i < len(killNum); i++)
        {
            if(state.solAttribute[killNum[i][0]].color == MYCOLOR)
                AKillNum += killNum[i][1];
            else
                BKillNum += killNum[i][1];
        }
        return BKillNum-AKillNum;//次数越大越有利
    }
    function immediateUpdate()
    {
        passTime = 4000;
        this.update(0);
    }
    //只评估一个士兵的局部值 即 造成的伤害 和 承受的伤害 如果存活则
    var passTime = 0;
    function update(diff)
    {
        passTime += diff;
        if(passTime < 3000)
            return;
        //用户没有行动 等待
        if(scene.leftSolNum == 0)
            return;
        player = "B";
        
        passTime = 0;
        trace("start AI");
        var curState = initState();
        var whereToPut = actions(curState);
        trace("whereToPut", len(whereToPut));
        var score = -INFINITY;
        var possibleAct = [];
        for(var i = 0; i < len(whereToPut); i++)
        {
            trace("try", whereToPut[i]);
            var newState = curState.deepCopy();
            var sol = fastPut(newState, whereToPut[i]); 
            var tc = findTar(newState, sol);//新放置的士兵的攻击目标和别人攻击它
            if(tc[0] == null)//没有可以攻击的目标 放弃该位置
                continue;

            var newScore = evalueSol(newState, sol);
            trace("evalue", newScore, score);
            if(newScore > score)
            {
                possibleAct = [whereToPut[i]];
                score = newScore;
            }
            else if(newScore == score)
                possibleAct.append(whereToPut[i]);
        }
        trace(possibleAct);
        if(len(possibleAct) > 0)
        {
            var move = possibleAct[rand(len(possibleAct))];
            scene.putNewSol(move);
        }
        trace("endAI");
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

