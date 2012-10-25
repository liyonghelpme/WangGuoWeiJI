/*
遍历所有士兵 构成最多 4*4的方阵
80 * 80 间距的方阵
中心 400 240 点
编号k 位置：
    总数 M  sqrt(M) = l * l
1*1 1 
2*2 2 3 4
3*3 5 6 7 8

sqrt(M) = l
if l*l < M
l = l+1
*/
class GameFour extends MyNode
{
    var drum;
    var leftTime;
    var allGoodsList = [];

    var ids;
    var possible;

    var showSol;
    var unShowSol;

    var SPEED = 4000; //2000ms ---> 800
    var WAIT_TIME = 150;// ms 
    //400/s 2s ----> 8个   50宽度 最多放 16个  150ms---500ms随机时间
    //

    var MIN_WAIT_TIME = 500;
    var MAX_WAIT_TIME = 1000;
    var EXP_GAME_TIME = 30;

    function removeReward(reward)
    {
        allGoodsList.remove(reward);
    }

    function GameFour()
    {
        MAX_WAIT_TIME = getParam("MAX_WAIT_TIME");
        MIN_WAIT_TIME = getParam("MIN_WAIT_TIME");
        SPEED = getParam("MoveTime");
        EXP_GAME_TIME = getParam("EXP_GAME_TIME");

        initView();
        initPossible();
        genArray();
    }

    var oldSca;
    function touchBegan(n, e, p, x, y, points)
    {
        oldSca = drum.scale();
        drum.scale(120);
        //world Position is same with node position
        var find = 0;
        for(var i = 0; i < len(allGoodsList); i++)
        {
            var dPos = drum.pos();
            var diffX = abs(allGoodsList[i].bg.pos()[0]-dPos[0]);
            if(diffX < 10)
            {
                find = 1;
                var col = allGoodsList.pop(i);
                col.removeSelf();
                var j;
                var sol;
                var gData;
                var ne;
                var addNow;
                for(j = 0; j < len(showSol); j++)
                {
                    sol = showSol[j];
                    gData = getData(EXP_GAME_GOODS, col.kind);
                    ne = getLevelUpExp(sol.id, sol.level);
                    addNow = max(ne*gData["exp"]/100, 1);
                    sol.changeExp(addNow);
                }
                for(j = 0; j < len(unShowSol); j++)
                {
                    sol = unShowSol[j];
                    gData = getData(EXP_GAME_GOODS, col.kind);
                    ne = getLevelUpExp(sol.id, sol.level);
                    addNow = max(ne*gData["exp"]/100, 1);
                    sol.changeExp(addNow);
                }
                /*
                var gData = getData(EXP_GAME_GOODS, col.kind);
                var ne = getLevelUpExp(soldier.id, soldier.level);
                var addNow = max(ne*gData["exp"]/100, 1);
                addExp += addNow;
                soldier.changeExp(addNow);
                */
                break;
            }
        }
        if(!find)
        {

            //temp = bg.addsprite("miss.png").anchor(0, 0).pos(16, 364).size(75, 25).color(100, 100, 100, 100);
            var miss = bg.addsprite("miss.png").anchor(0, 0).pos(16, 364).color(100, 100, 100, 100).addaction(sequence(moveby(200, 0, -25), callfunc(removeTempNode)));
        }
    }
    function touchMoved(n, e, p, x, y, points)
    {
    }
    function touchEnded(n, e, p, x, y, points)
    {
        drum.scale(oldSca);
    }

    function initPossible()
    {
        ids = [];
        possible = [];
        var key = ExpGameGoodsData.keys();
        for(var k = 0; k < len(key); k++)
        {
            var data = getData(EXP_GAME_GOODS, key[k]);
            if(data.get("possible") > 0)//possible > 0 正常掉落物品   == 0 升级掉落物品
            {
                ids.append(key[k]);
                possible.append(data.get("possible"));
            }
        }
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;


        temp = bg.addsprite("drumBack.png").anchor(0, 0).pos(-78, 376).size(920, 104).color(100, 100, 100, 100);
        //drum = bg.addsprite("drum.png").anchor(50, 50).pos(174, 428).size(72, 69).color(100, 100, 100, 100);
        drum = bg.addsprite("drum.png").anchor(50, 50).pos(57, 427).size(72, 69).color(100, 100, 100, 100);
        drum.setevent(EVENT_TOUCH, touchBegan);
        drum.setevent(EVENT_MOVE, touchMoved);
        drum.setevent(EVENT_UNTOUCH, touchEnded);

        leftTime = bg.addlabel(getStr("lastTime", ["[NUM]", str(EXP_GAME_TIME)]), "fonts/heiti.ttf", 25).anchor(0, 50).pos(670, 355).color(28, 18, 3);
    }
    //通知buildLayer 去排列大量士兵 同时 返回士兵队列给GameFour 处理
    //两个消息 通知
    function genArray()
    {
        global.msgCenter.sendMsg(SQUARE_SOL, this); 
    }
    //buildLayer处理完士兵之后的回调函数
    function finishArray(s)
    {
        showSol = s["showSol"];
        unShowSol = s["unShowSol"];
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }
    override function exitScene()
    {
        global.myAction.removeAct(this);
        super.exitScene();
    }

    function genNewFlowReward()
    {
        var kind = getPosIds(possible);
        kind = ids[kind];
        var reward = new FlowReward(this, kind);
        addChild(reward);
        allGoodsList.append(reward);
    }

    /*
    场景游戏状态 在 压入 view 时产生
    */
    var deltaTime = 0;
    var passTime = 0;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= EXP_GAME_TIME*1000)
        {
            global.director.popView();
            global.director.curScene.finishGame();
            var i;
            var updateSol = [];
            var sol;
            for(i = 0; i < len(showSol); i++)
            {
                sol = showSol[i];
                updateSol.append([sol.sid, sol.health, sol.exp, sol.level]);
                global.user.updateSoldiers(sol);
                sol.realEndGame();
            }
            for(i = 0; i < len(unShowSol); i++)
            {
                sol = unShowSol[i];
                updateSol.append([sol.sid, sol.health, sol.exp, sol.level]);
                global.user.updateSoldiers(sol);
                sol.realEndGame();
            }

            global.httpController.addRequest("soldierC/game4Over", dict([["uid", global.user.uid], ["soldiers", json_dumps(updateSol)]]), null, null);
            //global.user.updateSoldiers(soldier);
            //soldier.endGame();
            return;
        }

        var left = EXP_GAME_TIME*1000-passTime;
        leftTime.text(getStr("lastTime", ["[NUM]", str(left/1000)]));

        deltaTime += diff;
        if(deltaTime >= WAIT_TIME)
        {
            deltaTime -= WAIT_TIME;
            WAIT_TIME = rand(MAX_WAIT_TIME-MIN_WAIT_TIME)+MIN_WAIT_TIME;
            genNewFlowReward();
        }
    }

}
