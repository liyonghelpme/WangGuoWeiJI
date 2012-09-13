class SoldierAI
{
    var soldier;
    function SoldierAI(s)
    {
        soldier = s;
    }
    //攻击目标没有在被攻击中
    function releaseLine()
    {
        var solMap = getSolMap(soldier.getPos(), soldier.sx, soldier.sy, soldier.offY);
        var row = null;
        var near = null;
        var ene;
        //多行技能释放
        for(var i = 0; i < soldier.sy; i++)
        {
            var rN = solMap[1]+i;
            row = soldier.map.soldiers.get(rN);
            //该行存在敌方士兵
            if(row != null)
            {
                for(var j = 0; j < len(row); j++)
                {
                    ene = row[j];
                    if(ene.color != soldier.color && ene.state != MAP_SOL_DEAD && ene.state != MAP_SOL_SAVE && ene.state != MAP_SOL_DEFENSE && ene.inSkill == 0)
                    {
                        var rowPos = getSolPos(0, rN, 1, 1, 0); 
                        return [ene.getPos()[0], rowPos[1]];//x y 
                    }
                }
            }
        }
        return null;
    }
    function releaseSingle()
    {
        var soldiers = soldier.map.soldiers.values();
        var res = [];
        var i;
        for(i = 0; i < len(soldiers); i++)
        {
            res += soldiers[i];
        }
        if(len(res) > 0)
        {
            var rd = rand(len(res));
            for(i = 0; i < len(res); i++)
            {
                var p = (i+rd)%len(res);
                var ene = res[p];
                if(ene.color != soldier.color && ene.state != MAP_SOL_DEAD && ene.state != MAP_SOL_SAVE && ene.state != MAP_SOL_DEFENSE && ene.inSkill == 0)
                {
                    return ene;
                }
            }
        }
        return null;
    }
    function releaseMulti()
    {
        var soldiers = soldier.map.soldiers.values();
        var res = [];
        var i;
        for(i = 0; i < len(soldiers); i++)
        {
            res += soldiers[i];
        }

        if(len(res) > 0)
        {
            var rd = rand(len(res));
            for(i = 0; i < len(res); i++)
            {
                var p = (i+rd)%len(res);
                var ene = res[p];
                if(ene.color != soldier.color && ene.state != MAP_SOL_DEAD && ene.state != MAP_SOL_SAVE && ene.state != MAP_SOL_DEFENSE)
                {
                    var solMap = getSolMap(ene.getPos(), ene.sx, ene.sy, ene.offY);//得到士兵网格左上位置
                    return solMap;
                }
            }
        }
        return null;
    }
    function releaseHeal()
    {
        var soldiers = soldier.map.soldiers.values();
        var res = [];
        var i;
        for(i = 0; i < len(soldiers); i++)
        {
            res += soldiers[i];
        }
        if(len(res) > 0)
        {
            var rd = rand(len(res));
            for(i = 0; i < len(res); i++)
            {
                var p = (i+rd)%len(res);
                var ene = res[p];
                if(ene.color == soldier.color && ene.state != MAP_SOL_DEAD && ene.state != MAP_SOL_SAVE && ene.state != MAP_SOL_DEFENSE && ene.health < ene.healthBoundary*2/3)
                {
                    return ene;
                }
            }
        }
        return null;
    }
    function releaseMultiHeal(skillId, skillLevel)
    {
        var soldiers = soldier.map.soldiers.values();
        var res = [];
        var i;
        var tar = null;
        var hasHealth = [];
        var map = soldier.map; 
        for(i = 0; i < len(soldiers); i++)
        {
            res += soldiers[i];
        }
        if(len(res) > 0)
        {
            var rd = rand(len(res));
            for(i = 0; i < len(res); i++)
            {
                var p = (i+rd)%len(res);
                var ene = res[p];
                if(ene.color == soldier.color && ene.state != MAP_SOL_DEAD && ene.state != MAP_SOL_SAVE && ene.state != MAP_SOL_DEFENSE)
                {
                    if(ene.health < ene.healthBoundary*2/3)
                    {
                        tar = ene;
                    }
                    hasHealth.append(ene);
                }
            }
            //存在我方士兵生命值低 则我方所有士兵加血
            for(i = 0; i < len(hasHealth) && tar != null; i++)
            {
                map.doSkillEffect(soldier, hasHealth[i], skillId, skillLevel);
            }
        }
        return tar;
    }

    function releaseSkill()
    {
        var skillList = soldier.skillList;

        var map = soldier.map;
        var i;
        var sk;
        for(i = 0; i < len(skillList); i++)
        {
            sk = skillList[i];
            if(sk[3] == 1)//ready技能类型--->确定技能属性 m----> map 释放技能---> 清空技能状态
            {
                var tar = null;
                var skData = getData(SKILL, sk[0]); 
                //选定存在敌方的方向
                if(skData["kind"] == LINE_SKILL)
                {
                    tar = releaseLine();
                }
                else if(skData["kind"] == SINGLE_ATTACK_SKILL)
                {
                    tar = releaseSingle();
                }
                else if(skData["kind"] == MULTI_ATTACK_SKILL)
                {
                    tar = releaseMulti(); 
                }
                else if(skData["kind"] == SPIN_SKILL)
                {
                    tar = releaseSingle();//类似于单体攻击
                }
                else if(skData["kind"] == HEAL_SKILL)//寻找我方生命值最少的士兵
                {
                    tar = releaseHeal();
                }
                else if(skData["kind"] == MULTI_HEAL_SKILL)
                {
                    tar = releaseMultiHeal(sk[0], sk[1]); 
                }
                else if(skData["kind"] == SAVE_SKILL)
                {
                }
                else if(skData["kind"] == MAKEUP_SKILL)
                {
                    tar = soldier; 
                }
                if(tar != null)
                {
                    sk[3] = 0;
                    sk[2] = 0;
                    if(skData["kind"] != MULTI_HEAL_SKILL)
                        map.doSkillEffect(soldier, tar, sk[0], sk[1]); 
                    //每个周期只释放一个技能
                    break;
                }
            }
        }
    }
}
