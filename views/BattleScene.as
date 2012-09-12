
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

    var state = MAP_ARRANGE;

    var skillSoldier;
    var skillId;
    var skillLevel;
    var sceneSlowTimer;
    var drugId;
    var dialogController;

    var skills = null;
    function cancelSkill()
    {
        skillSoldier = null;
        skillId = -1;
        skillLevel = 0;
        state = MAP_FINISH_SKILL;
    }
    //使用药品技能---》 USE_DRUG_SKILL ---> 单体治疗技能---》增加属性
    function selectDrug(sol, did)
    {
        skillSoldier = sol;
        skillId = DRUG_SKILL_ID;
        skillLevel = 0;
        drugId = did;

        state = MAP_START_SKILL;
    }
    function selectSkill(sol, skId, skLevel)
    {
        trace("selectSkill", sol, skId);
        skillSoldier = sol;
        skillId = skId;
        skillLevel = skLevel;

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
                        map.doSkillEffect(skillSoldier, healSol, skillId, skillLevel);
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
            map.doSkillEffect(skillSoldier, skillSoldier, skillId, skillLevel);
            state = MAP_FINISH_SKILL;
            pausePage.skillFlowBanner.finishSkill(sol);
        }

    }
    override function enterScene()
    {
        sceneSlowTimer = new Timer(500);
        super.enterScene();
        
        sceneSlowTimer.addTimer(this);


        bg.setevent(EVENT_KEYDOWN, quitMap);
        bg.focus(1);
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
            map.doSkillEffect(skillSoldier, sol, skillId, skillLevel);
        
        skillSoldier = null;
        skillId = -1;
        drugId = -1;
        skillLevel = 0;
    }

    var double;
    var difficult;
    //uid, papayaId, score rank cityDefense
    
    //big small soldiers kind double difficult
    //big small soldiers kind param equips
    function BattleScene(k, sm, s, ki, par, eq)
    {
        difficult = eq;
        double = par;

        param = par;
        kind = ki;
        //soldierId ---> {skillId, level}
        if(kind == CHALLENGE_FRI || kind == CHALLENGE_NEIBOR)
        {
            skills = dict();
            var sk = param[5];
            for(var i = 0; i < len(sk); i++)
            {
                var solSk = sk[i];
                var skLev = skills.get(solSk[0], dict());
                skLev.update(solSk[1], solSk[2]);
                skills.update(solSk[0], skLev);
            }
        }

        bg = node();
        init();
        dialogController = new DialogController(this);
        addChild(dialogController);

        if(kind == CHALLENGE_MON && global.user.db.get("readYet") == null)//未曾读过战斗提示 显示战斗提示
        {
            //global.director.pushView(new NoTipDialog(), 1, 0);
            dialogController.addCmd(dict([["cmd", "noTip"]]));
        }
        if(kind == CHALLENGE_TRAIN)
        {
            var tip = global.user.db.get("trainTip");
            if(tip == null)
                dialogController.addCmd(dict([["cmd", "trainTip"]]));
        }

        dialogController.addCmd(dict([["cmd", "chooseSol"]]));

        big = k;
        small = sm;
        if(kind == CHALLENGE_TRAIN)
            map = new Map(k, sm, s, this, null);
        else
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
        if(kind == CHALLENGE_TRAIN)
            map.finishTrainArrange();

        pausePage = new MapPause(this);
        addChild(pausePage);
        state = MAP_FINISH_SKILL;
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

    function quitMap(n, e, p, kc)
    {
        if(kc == KEYCODE_BACK)
        {
            if(state == MAP_ARRANGE) 
                global.director.popScene();
            else 
                pausePage.onPause();
        }
    }
    function clearSoldier(so)
    {
        banner.clearSoldier(so);
    }
    function getDefense(id)
    {
        return map.getDefense(id);
    }


    //定时每行刷新怪兽
    //该行还有士兵
    //该行还有怪兽剩余量
    //
    function update(diff)
    {
        if(kind == CHALLENGE_TRAIN)
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
    }
}
