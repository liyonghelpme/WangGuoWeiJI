class SingleSkill extends MyNode
{
    var map;
    var sol;
    var tar;
    var skillId;

    var cus;
    function SingleSkill(m, a, t, sk)
    {
        map = m;
        sol = a;
        tar = t;
        skillId = sk;

        bg = sprite().pos(tar.getPos()).anchor(50, 100);
        init();
        //var ani = skillAnimate.get(skillId);
        var ani = getSkillAnimate(skillId);
        attackTime = ani[1];
        cus = new MyAnimate(ani[1], ani[0], bg);
    }

    var passTime = 0;
    override function enterScene()
    {
        super.enterScene();
        map.myTimer.addTimer(this);
        cus.enterScene();
    }
    var attackTime;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= attackTime)
            doHarm();
    }
    function doHarm()
    {
        if(tar != null)//攻击对象没有死亡
        {
            var damage = getTotalSkillDamage(sol, skillId);
            var hurt = calSkillHurt(damage, tar);
            tar.changeHealth(sol, -hurt);
        }
        removeSelf();
    }
    override function exitScene()
    {
        map.myTimer.removeTimer(this);
        cus.exitScene();
        super.exitScene();
    }
}

