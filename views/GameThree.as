//集结是需要花钱 来进入游戏的 入口一直保留有
class GameThree extends MyNode
{
    //var miss;
    var passTime = 0;
    var allGoodsList = [];
    //var addExp = 0;

    var drum;
    var ids;
    var possible;
    var leftTime;
    var SPEED = 4000; //2000ms ---> 800
    var WAIT_TIME = 150;// ms 
    //400/s 2s ----> 8个   50宽度 最多放 16个  150ms---500ms随机时间
    //

    var MIN_WAIT_TIME = 500;
    var MAX_WAIT_TIME = 1000;

    function removeReward(reward)
    {
        allGoodsList.remove(reward);

    }
    var soldier;
    var EXP_GAME_TIME;
    function GameThree(s)
    {
        MAX_WAIT_TIME = getParam("MAX_WAIT_TIME");
        MIN_WAIT_TIME = getParam("MIN_WAIT_TIME");
        SPEED = getParam("MoveTime");
        EXP_GAME_TIME = getParam("EXP_GAME_TIME");

        soldier = s;
        soldier.beginGame(3);
        initView();
        initPossible();
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
        //miss = bg.addsprite("miss.png").anchor(0, 0).pos(16, 364).size(75, 25).color(100, 100, 100, 100).visible(0);
    }
    //点击开始时检测 当前下面是否有 物品飘过
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
            //var ret = checkIn(allGoodsList[i].bg, dPos);
            var diffX = abs(allGoodsList[i].bg.pos()[0]-dPos[0]);
            if(diffX < getParam("error"))
            {
                find = 1;
                var col = allGoodsList.pop(i);
                col.removeSelf();

                var gData = getData(EXP_GAME_GOODS, col.kind);
                var ne = getLevelUpExp(soldier.id, soldier.level);
                var addNow = max(ne*gData["exp"]/100, 1);
                //addExp += addNow;
                soldier.changeExp(addNow);
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

    function closeDialog()
    {
        global.director.popView();
    }
    var deltaTime = 0;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= EXP_GAME_TIME*1000)
        {
            global.director.popView();
            global.director.curScene.finishGame();
            global.httpController.addRequest("soldierC/game1Over", dict([["uid", global.user.uid], ["sid", soldier.sid], ["health", soldier.health], ["exp", soldier.exp], ["level", soldier.level] ]), null, null);
            global.user.updateSoldiers(soldier);
            soldier.endGame();
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
    function genNewFlowReward()
    {
        var kind = getPosIds(possible);
        kind = ids[kind];
        var reward = new FlowReward(this, kind);
        addChild(reward);
        allGoodsList.append(reward);
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
}
