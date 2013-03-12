class SingleSkill extends MyNode
{
    var map;
    var sol;
    var tar;
    var skillId;
    var skillLevel;

    var cus;
    function SingleSkill(m, a, t, sk, l)
    {
        map = m;
        sol = a;
        tar = t;
        skillId = sk;
        skillLevel = l;

        var ani = getSkillAnimate(skillId);
        var tPos = tar.getPos();
        trace("skillAnimate", ani, tPos, tar.getBloodHeightOff());
        if(ani["atHead"]) {
bg = sprite("", ARGB_8888).pos(tPos[0] + ani["offX"], (tPos[1] + ani["offY"]) - tar.getBloodHeightOff()).anchor(50, 100);
        } else
bg = sprite("", ARGB_8888).pos(tPos[0] + ani["offX"], tPos[1] + ani["offY"]).anchor(50, 100);
        init();

        attackTime = ani["time"];
        cus = new MyAnimate(ani["time"], ani["ani"], bg);
        tar.inSkill = 1;
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
            var damage = getTotalSkillDamage(sol, skillId, skillLevel);
            var hurt = calSkillHurt(damage, tar);
            tar.acceptHarm(sol, hurt);
            tar.inSkill = 0;
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

