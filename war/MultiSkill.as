class MultiSkill extends MyNode
{
    var sol;
    var map;
    var skillId;
    var skillLevel;
    
    var data;
    var sx;
    var sy;
    
    var effectTime;
    var attackTime = 0;
    var attackPeriod = 1000;
    var passTime = 0;

    var cus;

    var leftUp;

    var startPos;
    var skillRange;

    function MultiSkill(m, a, t, sk, l)
    {
        map = m;
        sol = a;
        skillId = sk;
        leftUp = t;
        skillLevel = l;
        //sx sy p 左上角位置
        data = getData(SKILL, skillId);
        sx = data.get("sx");
        sy = data.get("sy");
        effectTime = data.get("effectTime");
    
        attackTime = attackPeriod;//初次释放 需要立即造成伤害？ 或者需要吟唱时间？

        startPos = getSkillPos(leftUp[0], leftUp[1], 1, 1, 0, 0);
        skillRange = [sx*MAP_OFFX, sy*MAP_OFFY];


        bg = sprite().pos(getSkillPos(leftUp[0], leftUp[1], sx, sy, data["offX"], data["offY"])).anchor(0, 0);
        //var ani = skillAnimate.get(skillId);
        var ani = getSkillAnimate(skillId);
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
        var damage = getTotalSkillDamage(sol, skillId, skillLevel);
        var row = map.roundGridController.getRowObjects(leftUp[0], leftUp[1], data["sx"], data["sy"], this);
        var hurtEne = [];

        for(var j = 0; j < len(row); j++)
            if(row[j].state != MAP_SOL_DEFENSE && row[j].state != MAP_SOL_DEAD && row[j].color != sol.color)
            {
                var ene = row[j];
                var ret = checkInterSect([ene.curMap[0], ene.curMap[1], ene.sx, ene.sy], [leftUp[0], leftUp[1], data["sx"], data["sy"]]);
                if(ret)
                    hurtEne.append(ene);
            }
        
        //计算伤害
        if(len(hurtEne) > 0)
        {
            var perDamage = damage/len(hurtEne);
            for(var k = 0; k < len(hurtEne); k++)
            {
                var tar = hurtEne[k];
                var hurt = calSkillHurt(perDamage, tar);
                tar.acceptHarm(sol, hurt);
            }
        }
    }
}
