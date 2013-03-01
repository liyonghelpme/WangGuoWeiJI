//将士兵脱离战场 从战场的 view 中删除
//soldiers
//但是增加经验的的MySoldier 不删除
//进入无敌状态 MAP_SOL_SAVE = 保护无敌状态 任何人不能攻击 不能选择为 敌人
class SaveSkill extends MyNode
{
    var map;
    var sol;
    var tar;
    var skillId;
    var cus;
    var passTime = 0;
    var attackTime;
    var skillLevel;

    function SaveSkill(m, a, t, sk, l)
    {
        map = m;
        sol = a;
        tar = t;
        skillId = sk;
        skillLevel = l;

        bg = sprite().pos(tar.getPos()).anchor(50, 100);
         
        var ani = getSkillAnimate(skillId);
        attackTime = ani[1];//动画时间
        cus = new MyAnimate(ani["time"], ani["ani"], bg);
        //拯救动画 或者 士兵初次显示
        if(tar != null)
            tar.doSave();
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
