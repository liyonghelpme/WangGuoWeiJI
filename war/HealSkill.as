//治疗所有士兵 生成大量的生命值HealSkill
//技能在士兵身上
class HealSkill extends MyNode
{
    var map;
    var sol;
    var tar;
    var skillId;

    var cus;
    var passTime = 0;
    var attackTime;

    function HealSkill(m, a, t, sk, l)
    {
        map = m;
        sol = a;
        tar = t;
        skillId = sk;

        var tSize = tar.bg.size();
        bg = sprite().pos(tSize[0]/2, tSize[1]).anchor(50, 100);//技能和人物居中对齐
         
        var ani = getSkillAnimate(skillId);
        attackTime = ani["time"];//动画时间
        cus = new MyAnimate(ani["time"], ani["ani"], bg);
    }

    function update(diff)
    {
        passTime += diff;
        if(passTime >= attackTime)//超过眩晕时间 技能结束 
        {
            var sData = getData(SKILL, skillId);
            var healEffect = tar.healthBoundary*sData.get("percentHealth")+sData["health"];
            tar.doHeal(healEffect);
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
