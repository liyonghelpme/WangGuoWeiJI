class SpinSkill extends MyNode
{
    var map;
    var sol;
    var tar;
    var skillId;
    var cus;
    function SpinSkill(m, a, t, sk)
    {
        map = m;
        sol = a;
        tar = t;
        skillId = sk;
        var sData = getData(SKILL, skillId);
        var sLevel = global.user.getSolSkillLevel(sol.sid, skillId);
        var effectTime = sData.get("effectTime")+sData.get("addTime")*sLevel;

        bg = sprite().pos(tar.getPos()).anchor(50, 100);
        init();
        //var ani = skillAnimate.get(skillId);
        var ani = getSkillAnimate(skillId);

        attackTime = effectTime;//眩晕时间ms
        
        cus = new MyAnimate(ani[1], ani[0], bg);
        //目标进入 眩晕状态
        //法术时间结束 则停止眩晕 一直播放眩晕动画
        trace("spinTime", attackTime);
        tar.beginSpinState(attackTime);
    }

    var passTime = 0;
    var attackTime;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= attackTime)//超过眩晕时间 技能结束 
            removeSelf();
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
