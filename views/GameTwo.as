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
    var speed = 100; // 每秒
    var tarPos;
    var startPos;
    //飘动5s时间
    function RewardGoods(g, k)
    {
        game = g;
        kind = k;

        bg = sprite("status"+str(k)+".png").anchor(50, 100);
        init();
        var p = rand(700)+45;//起始位置
        bg.pos(p, 20);
        trace("rewardGoods", k, bg.pos());
        startPos = [p, -10];
        tarPos = [rand(650)+60, 500];//终止位置
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
    //进行相交测试
    var passTime = 0;
    function update(diff)
    {
        passTime += diff;
        var s = speed*diff/1000; 
        var curPos = bg.pos();
        curPos[0] += rand(8)-4;
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

            var sData = getGain(STATUS, kind);
            var income = getTotalIncome(global.user.getValue("level"));

            if(sData.get("silver") != null)
            {
                sData["silver"] *= income;
                sData["silver"] /= 100;
            }
            game.sol.changeMoney(sData);

            global.user.doAdd(sData);
            game.cacheAdd(sData);
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
*/
class GameTwo extends MyNode
{
    var sol;
    var kind;
    var leftNum;
    var addSilver = 0;
    var addGold = 0;
    var addCrystal = 0;
    function cacheAdd(gain)
    {
        addSilver += gain.get("silver", 0);
        addCrystal += gain.get("crystal", 0);
        addGold += gain.get("gold", 0);
    }
    function GameTwo(s, k)
    {
        sol = s;
        kind = k;
        bg = node();
        init();
        var sData = getData(STATUS, k);//不同类型的降落物品奖励
        //剩余数量 复制数量
        leftNum = copy(sData.get("nums"));
        sol.beginGame(2);
    }
    //时间间隔产生一个掉落物品
    //场景
    var passTime = 0;
    const GOODS_TIME = 1000;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= GOODS_TIME)//2秒产生一个掉落物品
        {
            passTime = 0;
            var rd = rand(len(leftNum));//类型
            var find = 0;
            for(var i = 0; i < len(leftNum); i++)
            {
                var n = (rd+i)%len(leftNum);
                if(leftNum[n] > 0)
                {
                    find = 1;
                    break;
                }
            }
            if(find)
            {
                leftNum[n] -= 1;
                var rewardId = n+SUNFLOWER_STATUS;   
                var re = new RewardGoods(this, rewardId);
                addChild(re);
            }
            else
            {
                global.httpController.addRequest("soldierC/game2Over", dict([["uid", global.user.uid], ["silver", addSilver], ["crystal", addCrystal], ["gold", addGold]]), null, null);
                global.director.popView();
                global.director.curScene.finishGame();//显示场景菜单
                sol.endGame();
            }
        }
    }
    //检测
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
