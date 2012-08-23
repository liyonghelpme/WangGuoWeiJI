//治疗所有士兵 生成大量的生命值HealSkill
//技能在士兵身上
class UseDrugSkill extends MyNode
{
    var map;
    var sol;
    var tar;
    //var skillId;
    var cus;
    var passTime = 0;
    var attackTime;
    var drugId; 

    function UseDrugSkill(m, a, t, sk)
    {
        map = m;
        sol = a;
        tar = t;
        drugId = sk;

        var tSize = tar.bg.size();
        bg = sprite().pos(tSize[0]/2, tSize[1]).anchor(50, 100);//技能和人物居中对齐
         
        //var ani = skillAnimate.get(DRUG_SKILL_ID);
        var ani = getSkillAnimate(DRUG_SKILL_ID);
        attackTime = ani[1];//动画时间
        cus = new MyAnimate(ani[1], ani[0], bg);

        tar.doDrug(drugId);
    }

    function update(diff)
    {
        passTime += diff;
        if(passTime >= attackTime)//超过眩晕时间 技能结束 
        {
            removeSelf();
        }
    }

    override function enterScene()
    {
        super.enterScene();
        map.myTimer.addTimer(this);
        cus.enterScene();
    }
    override function exitScene()
    {
        map.myTimer.removeTimer(this);
        cus.exitScene();
        super.exitScene();
    }
}
