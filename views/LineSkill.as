class LineSkill extends MyNode
{
    var sol;
    var tar;
    var movAct;
    var speed = 20;
    var offY;
    var rowY;
    var map;
    var skillId;

    var cus = null;
    //计算攻击直线上第一个敌方单位
    //确定方向
    //遍历所有单位 计算距离 如果 在正确方向 却 小于当前距离 则 替换

    //所在行至少有一个 防御装置可以攻击
    function getTar()
    {
        var skillData = getData(SKILL, skillId);
        var skillMap = getSkillMap(tar, skillData.get("sx"), skillData.get("sy"), 0);//所在行 所在列

        //向左攻击攻击一条直线上所有第一个单位
        var row = null;
        var near = null;
        var minDistance = 1000000;
        var p = sol.getPos();
        row = map.soldiers.get(skillMap[1]);
        var i;
        var ene;
        if(row != null)
        {
            var tarDis = tar[0]-p[0];
            for(i = 0; i < len(row); i++)
            {
                ene = row[i];
                if(ene.color != sol.color && ene.state != MAP_SOL_DEAD)
                {
                    var dist = ene.getPos()[0]-p[0];
                    if(dist*tarDis >= 0 && abs(dist) < minDistance)
                    {
                        near = ene;
                        minDistance = abs(dist);
                    }
                }
            }
            if(near != null)
                return near;
        }

        for(i = 0; i < len(row); i++)
        {
            ene = row[i];
            if(ene.color != sol.color)
            {
                near = ene;
                break;
            }
        }
        return near;
    }
    function LineSkill(m, a, t, sk)
    {
        var p;
        sol = a;
        tar = t;
        map = m;
        skillId = sk;
        
        p = sol.getPos();

        tar = getTar();


        var id = sol.id;

        rowY = p[1];


        var difx = tar.getPos()[0]-p[0];
        offY = sol.data.get("arrpx");
        var offX = sol.data.get("arrpy");
        if(difx > 0)
        {
            offX = -offX;
        }


        //soldier anchor 50 100 
        //-50 -50

        bg = sprite().anchor(100, 50).pos(p[0]+offX, p[1]+offY);

        init();
        movAct = moveto(0, 0, 0);
        initArrow();
    }
    var attackTime;
    var passTime = 0;
    function initArrow()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        attackTime = dist*100/speed;
        setDir();

        //var ani = skillAnimate.get(skillId);
        var ani = getSkillAnimate(skillId);
        cus = new MyAnimate(attackTime, ani[0], bg);//播放飞行 攻击动画

        var eneSize = tar.bg.size();

        var tY = tPos[1]-eneSize[1]/2;
        if(tar.state == MAP_SOL_DEFENSE)
            tY = rowY+offY;

        movAct = moveto(attackTime, tPos[0], tY);
        bg.addaction(movAct);
    }
    function setDir()
    {
        var difx = tar.getPos()[0]-bg.pos()[0];
        if(difx > 0)
            bg.scale(-100, 100);
        else
            bg.scale(100, 100);
    }
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
    override function enterScene()
    {
        super.enterScene();
        if(cus != null)
            cus.enterScene();
        map.myTimer.addTimer(this);
    }
    override function exitScene()
    {
        if(cus != null)
            cus.exitScene();
        map.myTimer.removeTimer(this);
        super.exitScene();
    }

}

