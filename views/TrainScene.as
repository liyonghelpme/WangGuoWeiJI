/*
选择人物
进入地图

显示地图  显示控制banner

进行我方人物布局---->  布局确定  点击人物 拖动 位置
     人物状态 地图状态
*/
class TrainScene extends MyNode
{
    var map;
    var banner;
    var kind;//0 闯关 1 挑战


    var pausePage;
    //big small soldierData
    var big;
    var small;


    //场景技能管理
    var state = MAP_ARRANGE;

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
    //定时每行刷新怪兽
    //该行还有士兵
    //该行还有怪兽剩余量
    //
    function update(diff)
    {
        if(state != MAP_ARRANGE)//布局完成进入 游戏状态 停止刷新怪兽
        {
            var eachRow = map.soldiers.items();//rowId ----> soldiers notDead 
            var i;
            var j;
            var row;
            var sol;
            //多行士兵可能 不能生成多个怪兽
            for(i = 0; i < len(eachRow); i++)
            {
                row = eachRow[i];
                for(j = 0; j < len(row[1]); j++)
                {
                    sol = row[1][j];
                    sol.genMonYet = 0;
                }
            }
            //如果所有我方士兵 存在的 都没有了敌人 则游戏结束
            var hasLiveMon = 0;//mySol leftNum
            for(i = 0; i < len(eachRow); i++)
            {
                row = eachRow[i];
                var mySol = null;
                var eneSol = null;
                //所在行士兵我方 敌方士兵
                for(j = 0; j < len(row[1]); j++)
                {
                    sol = row[1][j]; 
                    if(sol.color ==  ENECOLOR)
                        eneSol = sol; 
                    else if(sol.color == MYCOLOR)
                        mySol = sol;
                }
                if(mySol != null && mySol.state != MAP_SOL_DEAD && mySol.state != MAP_SOL_SAVE)//未死亡
                {
                    if(eneSol != null || mySol.leftMonNum > 0)//存在敌人 或者 存在剩余怪兽数量
                        hasLiveMon = 1;
                }

                if(mySol != null && mySol.genMonYet == 0 && mySol.leftMonNum > 0 && mySol.state != MAP_SOL_DEAD && mySol.state != MAP_SOL_SAVE)
                {
                    if(eneSol == null)
                    {
                        var newMon = map.genNewMonster(mySol);
                        if(newMon != null)//有位置放置新的怪兽
                            mySol.leftMonNum--;
                    }
                    mySol.genMonYet = 1;
                }
            }
            if(!hasLiveMon)//没有存在敌人的我方士兵
            {
                map.trainOver();  
                sceneSlowTimer.removeTimer(this);//停止怪兽数量刷新
            }
            map.showLeftNum();
        }
    }
    override function enterScene()
    {
        //技能列表需要这个Timer 来实时更新技能冷却状态
        sceneSlowTimer = new Timer(500);
        super.enterScene();
        sceneSlowTimer.addTimer(this);
        global.director.curScene.addChild(new UpgradeBanner(getStr("selectSol", null), [100, 100, 100]));

        var tip = global.user.db.get("trainTip");
        if(tip == null)
            global.director.pushView(new TrainTip(), 1, 0);
    }
    override function exitScene()
    {
        sceneSlowTimer.removeTimer(this);
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

    var double;
    var difficult;
    //uid, papayaId, score rank cityDefenTrain
    //大关 小关 关卡士兵 地图类型（训练地图） 是否双倍经验 无效 
    function TrainScene(k, sm, s, ki, dou, diff)
    {
        difficult = diff;
        double = dou;
        kind = ki;
        bg = node();
        init();
        big = k;
        small = sm;
        map = new Map(k, sm, s, this, null);
        addChild(map);
        banner = new MapBanner(this);
        addChild(banner);
    }
    //防御力的key = 10*big+small 
    function getEneDefense()
    {
        trace("getEneDefense", big, small);
        return 0;
    }
    function finishArrange()
    {
        state = MAP_FINISH_SKILL;//由安置状态进入游戏状态
        banner.removeSelf();
        banner = null;
        //map.finishArrange();
        map.finishTrainArrange();
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
