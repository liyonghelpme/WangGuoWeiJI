//类似于 buildMenu 等全局菜单 隐藏菜单栏
//士兵瞬间移动到 训练场中心
//drum保持稳定

//只有鼓 有 touch事件
class GameOne extends MyNode
{
    var sol;
    var kind;
    var banner;
    var drum;
    var stopTimes = 0;
    var maxTime = 50000;//随机运动时间 分形布朗运动
    var passTime = 0;

    function GameOne(s, k)
    {
        sol = s;
        sol.beginGame(1);
        kind = k;
        bg = node();
        init();
        banner = bg.addsprite("drumBack.png").pos(0, global.director.disSize[1]).anchor(0, 100);
        drum = banner.addsprite("drum.png").pos(752, 66).anchor(50, 50);
        basePx = drum.pos();
        maxTime = PARAMS["EXP_GAME_TIME"]*1000;

        drum.setevent(EVENT_TOUCH, touchBegan);
        drum.setevent(EVENT_MOVE, touchMoved);
        drum.setevent(EVENT_UNTOUCH, touchEnded);
    }
    //0 静止抖动
    var state = 0;
    var jitterTime = 0;
    var movAct = null;
    var maxJitter = 900;

    //是否已经点击
    var touchYet = 1;

    var basePx;
    //50ms 更新一下位置
    var tarPos;

    var moveTime = 0;
    var maxMoveTime = 0;


    //移动距离增大
    //抖动时间减少
    //增加游戏难度
    //抖动距离增大
    const JITBASE = 200;
    const JITOFF = 200;
    var speed = 400;//800/s
    const SPEEDBASE = 100;
    const SPEEDOFF = 800;

    const OFFXBASE = 100;
    const OFFXOFF = 400;
    const JITXB = 80;
    const JITXOFF = 40;
    function update(diff)
    {
        passTime += diff;
        //游戏时间到 结束
        if(passTime >= maxTime)
        {
            global.director.popView();
            global.director.curScene.finishGame();
            global.httpController.addRequest("soldierC/game1Over", dict([["uid", global.user.uid], ["sid", sol.sid], ["health", sol.health], ["exp", sol.exp], ["level", sol.level] ]), null, null);
            global.user.updateSoldiers(sol);
            sol.endGame();
            return;
        }
        //鼓处于震动状态
        if(state == 0)
        {
            var difx;
            jitterTime += diff;
            //原地抖动位置 移动下一个位置
            if(jitterTime > maxJitter)
            {
                state = 1;
                tarPos = drum.pos(); 
                var rd = rand(OFFXBASE)+OFFXOFF;//400 - 500 移动距离范围
                var r2 = rand(2);
                if(r2 < 0)//移动方向
                    rd = -rd;

                var off = tarPos[0] - 45;//大于45 小于 745 的范围
                off += rd;
                off %= 700;
                difx = 45+off-tarPos[0];//目标位置 和 当前位置 距离差
                tarPos[0] = 45+off;
                
                speed = rand(SPEEDBASE)+SPEEDOFF;//1000ms 移动距离 400 -- 800
                var t = abs(difx)*1000/speed; //

                drum.addaction(moveto(t, tarPos[0], tarPos[1]));
                moveTime = 0;
                maxMoveTime = t;
            }
            else
            {
                difx = rand(JITXB)-JITXB/2;
                drum.pos(basePx[0]+difx, basePx[1]);
            }
        }
        //移动结束 原地抖动
        else if(state == 1)
        {
            moveTime += diff;
            if(moveTime >= maxMoveTime)
            {
                state = 0;
                jitterTime = 0;
                maxJitter = rand(JITBASE)+JITOFF;
                drum.stop();
                touchYet = 0;
                basePx = drum.pos();
            }
            else
            {
            }
        }
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
    function touchBegan(n, e, p, x, y, points)
    {
    }

    function touchMoved(n, e, p, x, y, points)
    {
    }

    var addHealth = 0;
    var addExp = 0;

    function touchEnded(n, e, p, x, y, points)
    {
        if(touchYet == 0 && state == 0)//抖动窗口期 才可以点击
        {
            touchYet = 1;
            var addSol;
            if(kind == HEART_STATUS)
            {
                addSol = max(sol.healthBoundary/100, 1);//10% health
                sol.changeHealth(addSol); 
                addHealth += addSol;
            }
            else if(kind == INSPIRE_STATUS)
            {
                var ne = getLevelUpExp(sol.id, sol.level);
                addSol = max(ne/100, 1);
                addExp += addSol;
                sol.changeExp(addSol);
            }
            //需要同步更新所有士兵的数据
            else if(kind == GATHER_STATUS)
            {
                
            }
        }
    }
}
