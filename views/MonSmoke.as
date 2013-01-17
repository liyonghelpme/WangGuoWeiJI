//将士兵脱离战场 从战场的 view 中删除
//soldiers
//但是增加经验的的MySoldier 不删除
//进入无敌状态 MAP_SOL_SAVE = 保护无敌状态 任何人不能攻击 不能选择为 敌人


//战斗页面 烟雾
//经营页面 初次购买
//经营页面玩游戏
//经营页面 召集

//要求添加者提供一个 timer
class MonSmoke extends MyNode
{
    var map;
    var sol;
    var tar;
    var skillId;
    var cus;
    var passTime = 0;
    var attackTime;
    var appearStar;
    var callback;

    function MonSmoke(m, a, t, sk, cb)
    {
        map = m;
        sol = a;
        tar = t;
        skillId = sk;
        callback = cb;

        bg = sprite().pos(tar.getPos()).anchor(50, 100);
         
        var ani = getSkillAnimate(skillId);
        attackTime = getParam("smokeTime");//动画时间
        cus = new OneAnimate(getParam("smokeTime"), ani[0], bg, "", 0);
        
        //怪兽脚底的绿色光环
        var bSize = tar.bg.size();
        /*
        appearStar = sprite().anchor(50, 50).pos(bSize[0]/2, bSize[1]);
        appearStar.addaction(repeat(animate(1500, 
            "greenStar0.png", "greenStar1.png", "greenStar2.png", "greenStar3.png", "greenStar4.png", "greenStar5.png", "greenStar6.png", "greenStar7.png", "greenStar8.png", "greenStar9.png", "greenStar10.png", "greenStar11.png", "greenStar12.png", "greenStar13.png", "greenStar14.png", "greenStar15.png", "greenStar16.png", "greenStar17.png", "greenStar18.png"
            , UPDATE_SIZE))
        );
        tar.bg.add(appearStar, -1);
        */
    }

    function update(diff)
    {
        passTime += diff;
        if(passTime >= attackTime)//超过眩晕时间 技能结束 
        {
            removeSelf();
            //appearStar.removefromparent();
            if(callback != null)
            {
                callback();   
            }
        }
    }

    override function enterScene()
    {
        super.enterScene();
        //map.myTimer.addTimer(this);
        global.timer.addTimer(this);
        cus.enterScene();
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        //map.myTimer.removeTimer(this);
        cus.exitScene();
        super.exitScene();
    }
}
