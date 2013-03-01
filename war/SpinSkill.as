class SpinSkill extends MyNode
{
    var map;
    var sol;
    var tar;
    var skillId;
    var skillLevel;
    var cus;
    function SpinSkill(m, a, t, sk, l)
    {
        map = m;
        sol = a;
        tar = t;
        skillId = sk;
        skillLevel = l;

        var sData = getData(SKILL, skillId);
        //var sLevel = global.user.getSolSkillLevel(sol.sid, skillId);

        var effectTime = sData.get("effectTime")+sData.get("addTime")*skillLevel;

        var ani = getSkillAnimate(skillId);
        var tPos = tar.getPos();
        trace("skillAnimate", ani, tPos, tar.getBloodHeightOff());
        if(ani["atHead"]) {
            bg = sprite().pos(tPos[0], tPos[1]+ani["offY"]-tar.getBloodHeightOff()).anchor(50, 100);
        } else
            bg = sprite().pos(tPos[0], tPos[1]+ani["offY"]).anchor(50, 100);

        init();


        attackTime = effectTime;//眩晕时间ms
        
        cus = new MyAnimate(ani["time"], ani["ani"], bg);
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
