class MultiSkill extends MyNode
{
    var sol;
    var map;
    var skillId;
    
    var data;
    var sx;
    var sy;
    
    var effectTime;
    var attackTime = 0;
    var attackPeriod = 1000;
    var passTime = 0;

    var cus;

    var leftUp;

    function MultiSkill(m, a, t, sk)
    {
        map = m;
        sol = a;
        skillId = sk;
        leftUp = t;
        //sx sy p 左上角位置
        data = getData(SKILL, skillId);
        sx = data.get("sx");
        sy = data.get("sy");
        effectTime = data.get("effectTime");

    
        bg = sprite().pos(getSkillPos(leftUp[0], leftUp[1], sx, sy, data["offX"], data["offY"])).anchor(0, 0);
        var ani = skillAnimate.get(skillId);
        cus = new MyAnimate(ani[1], ani[0], bg);
        trace("multiAnimate", ani[1], ani[0]);
    }
    override function enterScene()
    {
        super.enterScene();
        cus.enterScene();
        map.myTimer.addTimer(this);
    }
    override function exitScene()
    {
        cus.exitScene();
        map.myTimer.removeTimer(this);
        super.exitScene();
    }
    function update(diff)
    {
        passTime += diff;
        attackTime += diff;
        //攻击频率超过
        if(attackTime >= attackPeriod)
        {
            attackTime -= attackPeriod;
            doHarm();
        }
        //有效时间超过
        if(passTime >= effectTime)
            removeSelf();
    }
    //火焰技能对防御装置无效
    function doHarm()
    {
        //总伤害
        var damage = getTotalSkillDamage(sol, skillId);
        var allEnemies = map.soldiers;
        var hurtEne = [];
        for(var i = 0; i < sy; i++)
        {
            var row = allEnemies.get(leftUp[1]+i);
            if(row != null)
            {
                for(var j = 0; j < len(row); j++)
                {
                    //敌对方非我方 未死亡
                    if(row[j].state != MAP_SOL_DEFENSE && row[j].state != MAP_SOL_DEAD && row[j].color != sol.color)
                    {
                        hurtEne.append(row[j]);
                    }
                }
            }
        }
        
        //计算伤害
        if(len(hurtEne) > 0)
        {
            var perDamage = damage/len(hurtEne);
            for(var k = 0; k < len(hurtEne); k++)
            {
                var tar = hurtEne[k];
                var hurt = calSkillHurt(perDamage, tar);
                tar.changeHealth(sol, -hurt);
                
            }
        }
    }
}
