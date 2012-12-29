//CastalScene

/*
    
    var income =  getTotalIncome(global.user.getValue("level"));

    sData["silver"] *= income;
    sData["silver"] /= 100;
    global.user.doAdd(sData);

    
*/
class RewardGoods extends MyNode
{
    var game;
    var kind;
    var speed; // 每秒
    var tarPos;
    var startPos;
    //飘动5s时间
    function RewardGoods(g, k)
    {
        game = g;
        kind = k;
        var gData = getData(MONEY_GAME_GOODS, kind);

        speed = getParam("GOODS_SPEED")*gData["speed"];

        bg = sprite("goods"+str(k)+".png").anchor(50, 100).scale(getParam("PickFallObjScale"));
        init();
        var p = rand(getParam("pickRandX"))+45;//起始位置
        bg.pos(p, 20);
        //trace("rewardGoods", k, bg.pos());
        startPos = [p, -10];
        tarPos = [rand(650)+60, 500];//终止位置
        
        //光滑bezier曲线
    }
    //只检测相撞
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }
    override function exitScene()
    {
        game.removeReward(this);
        global.myAction.removeAct(this);
        super.exitScene();
    }
    //进行相交测试
    var passTime = 0;
    function update(diff)
    {
        passTime += diff;
        var s = speed*diff/1000; 
        var curPos = bg.pos();
        curPos[0] += rand(getParam("jitterAmp"))-getParam("jitterOrigin");
        curPos[0] = min(max(45, curPos[0]), 745);
        curPos[1] += s;

        bg.pos(curPos);

        var sPos = game.sol.getPos();
        //士兵的50 100 坐标转化成 定点坐标 士兵相对于其地图上的 世界坐标
        sPos = game.sol.map.bg.node2world(sPos[0], sPos[1]);

        var dist = distance2(curPos, sPos); 
        if(dist < 40)//45*45 = 
        {
            removeSelf();
            //使用 FALL_OBJ 的数据
            var reward = getFallObjValue(kind, 0);
            game.sol.changeMoney(reward);
            global.user.doAdd(reward);
            game.cacheAdd(reward);
            return;
        }
        //超出屏幕
        if(curPos[1] >= 500)
        {
            removeSelf();
        }
    }
}
/*
getGain 要求资源key 前面有gain字符
捡 银币游戏 开始啦
*/
class GameTwo extends MyNode
{
    var sol;
    var kind;
    //var leftNum;
    var addSilver = 0;
    var addGold = 0;
    var addCrystal = 0;
    
    var goodsLeftNum;
    var ids;
    var possible;

    var allRewards = [];

    function removeReward(reward)
    {
        allRewards.remove(reward);
    }
    function cacheAdd(gain)
    {
        addSilver += gain.get("silver", 0);
        addCrystal += gain.get("crystal", 0);
        addGold += gain.get("gold", 0);
    }
    var leftNum;
    function GameTwo(s, k)
    {
        sol = s;
        kind = k;
        bg = node();
        init();
        initPossible();

        GOODS_TIME = getParam("GOODS_TIME");
        //剩余数量 复制数量
        goodsLeftNum = getParam("GameOneNum");
        sol.beginGame(2);
        leftNum = bg.addlabel(getStr("leftNum", ["[NUM]", str(goodsLeftNum)]), "fonts/heiti.ttf", 25).anchor(0, 50).pos(622, 455).color(28, 18, 3);
    }
    function initPossible()
    {
        ids = [];
        possible = [];
        var key = MoneyGameGoodsData.keys();
        for(var k = 0; k < len(key); k++)
        {
            var data = getData(MONEY_GAME_GOODS, key[k]);
            if(data.get("possible") > 0)//possible > 0 正常掉落物品   == 0 升级掉落物品
            {
                ids.append(key[k]);
                possible.append(data.get("possible"));
            }
        }
    }
    //时间间隔产生一个掉落物品
    //场景
    var passTime = 0;
    //const GOODS_TIME = 1000;
    var GOODS_TIME;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= GOODS_TIME)//2秒产生一个掉落物品
        {
            passTime = 0;
            if(goodsLeftNum > 0)
            {
                var kind = getPosIds(possible);
                kind = ids[kind];

                var re = new RewardGoods(this, kind);
                allRewards.append(re);
                addChild(re);
                goodsLeftNum--;
                leftNum.text(getStr("leftNum", ["[NUM]", str(goodsLeftNum)]));
            }
            else if(goodsLeftNum == 0 && len(allRewards) == 0)
            {
                global.httpController.addRequest("soldierC/game2Over", dict([["uid", global.user.uid], ["silver", addSilver], ["crystal", addCrystal], ["gold", addGold]]), null, null);
                global.director.popView();
                global.director.curScene.finishGame();//显示场景菜单
                sol.endGame();
                global.taskModel.doAllTaskByKey("eliminate", 1);
            }
        }
    }
    //检测
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
        global.taskModel.showHintArrow(sol.bg, sol.bg.size(), MOVE_SOL_PICK_FALL);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
