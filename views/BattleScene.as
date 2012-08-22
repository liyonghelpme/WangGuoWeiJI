
/*
选择人物
进入地图

显示地图  显示控制banner

进行我方人物布局---->  布局确定  点击人物 拖动 位置
     人物状态 地图状态
     c
 
*/
class BattleScene extends MyNode
{
    var map;
    var banner;
    var kind;//0 闯关 1 挑战

    //oid papayaId score rank cityDefense
    var param;


    var pausePage;
    //big small soldierData
    var big;
    var small;

    var state = MAP_FINISH_SKILL;

    var skillSoldier;
    var skillId;
    var sceneSlowTimer;
    var drugId;
    function cancelSkill()
    {
        skillSoldier = null;
        skillId = -1;
        state = MAP_FINISH_SKILL;
    }
    //使用药品技能---》 USE_DRUG_SKILL ---> 单体治疗技能---》增加属性
    function selectDrug(sol, did)
    {
        skillSoldier = sol;
        skillId = DRUG_SKILL_ID;
        drugId = did;

        state = MAP_START_SKILL;
    }
    function selectSkill(sol, skId)
    {
        trace("selectSkill", sol, skId);
        skillSoldier = sol;
        skillId = skId;

        state = MAP_START_SKILL;

        var sData = getData(SKILL, skillId);
        var skillKind = sData.get("kind");
        if(skillKind == MULTI_HEAL_SKILL)
        {
            var allMySoldier = map.soldiers.values();//每行士兵[[], [], []] 
            for(var i = 0; i < len(allMySoldier); i++)
            {
                for(var j = 0; j < len(allMySoldier[i]); j++)
                {
                    var healSol = allMySoldier[i][j];//每个士兵
                    trace("healSol", healSol.color, healSol.state);
                    if(sol.color == healSol.color && healSol.state != MAP_SOL_DEAD && healSol.state != MAP_SOL_DEFENSE)//治疗效果 我方未阵亡士兵
                    {
                        map.doSkillEffect(skillSoldier, healSol, skillId);
                    }
                }
            }
            trace("finish MULTI_HEAL_SKILL");
            state = MAP_FINISH_SKILL;
            pausePage.skillFlowBanner.finishSkill(sol);
        }
        else if(skillKind == MAKEUP_SKILL)
        {
            //skillSoldier.doMakeUp(skillId);
            map.doSkillEffect(skillSoldier, skillSoldier, skillId);
            state = MAP_FINISH_SKILL;
            pausePage.skillFlowBanner.finishSkill(sol);
        }

    }
    override function enterScene()
    {
        sceneSlowTimer = new Timer(200);
        super.enterScene();
        global.director.curScene.addChild(new UpgradeBanner(getStr("selectSol", null), [100, 100, 100]));
    }
    override function exitScene()
    {
        super.exitScene();
        sceneSlowTimer.stop();
        sceneSlowTimer = null;
    }
    function setTargetSol(sol)
    {
        //global.msgCenter.sendMsg(UPDATE_SKILL, MAP_FINISH_SKILL);
        trace("finishSkill", sol);
        
        pausePage.skillFlowBanner.finishSkill(sol);
        state = MAP_FINISH_SKILL;

        //单体技能确定 攻击目标
        //群体技能确定 攻击位置 左上角
        if(sol != null)
            map.doSkillEffect(skillSoldier, sol, skillId);
        
        skillSoldier = null;
        skillId = -1;
        drugId = -1;
    }

    //uid, papayaId, score rank cityDefense
    function BattleScene(k, sm, s, ki, par, eq)
    {
        param = par;
        kind = ki;
        bg = node();
        init();
        big = k;
        small = sm;
        map = new Map(k, sm, s, this, eq);
        addChild(map);
        banner = new MapBanner(this);
        addChild(banner);
    }
    //防御力的key = 10*big+small 
    function getEneDefense()
    {
        trace("getEneDefense", big, small);
        if(kind == CHALLENGE_MON)
            return mapDefense.get(big*10+small);
        else if(kind == CHALLENGE_FRI || kind == CHALLENGE_NEIBOR)
            return param[4];
        else if(kind == CHALLENGE_SELF)
            return param[4];
        return 0;
    }
    function finishArrange()
    {
        banner.removeSelf();
        banner = null;
        map.finishArrange();
        pausePage = new MapPause(this);
        addChild(pausePage);
    }
    function setSkillSoldier(sol)
    {
        if(pausePage != null)
            pausePage.skillFlowBanner.setSoldier(sol);
    }
    //暂停游戏 需要停止技能冷却时间的更新
    //否则用户可以暂停游戏来 回复技能
    //技能冷却时间需要 以过去的时间进行基数
    //所有士兵的技能 passTime 和 当前时间 并行更新
    //updateSkill 模块
    //冷却技能时间
    function stopGame()
    {
        map.stopGame();
        sceneSlowTimer.gameStop();
    }
    function continueGame()
    {
        map.continueGame();
        sceneSlowTimer.gameRestart();
    }

    function clearSoldier(so)
    {
        banner.clearSoldier(so);
    }
    function getDefense(id)
    {
        return map.getDefense(id);
    }
}
