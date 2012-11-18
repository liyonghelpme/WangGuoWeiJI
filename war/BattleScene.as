
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
    var user;

    //oid papayaId score rank cityDefense
    //var param;
    var pausePage;


    var big;
    var small;

    var state = MAP_ARRANGE;

    var skillSoldier;
    var skillId;
    var skillLevel;
    var sceneSlowTimer;
    var drugId;

    var skills = null;
    var selB2 = null;
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
        /*
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
        */
    }
    override function enterScene()
    {
        sceneSlowTimer = new Timer(500);
        super.enterScene();
        
        sceneSlowTimer.addTimer(this);


        //bg.setevent(EVENT_KEYDOWN, quitMap);
        //bg.focus(1);
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
        
        //pausePage.skillFlowBanner.finishSkill(sol);
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
    //训练 单人训练需要传入派出士兵的sid 多人训练
    //big small soldiers kind [double, single] difficult
    //普通挑战 闯关
    //big small soldiers kind param equips
    
    var singleSid = null;
    /*
    想要增加一个士兵到地图上需要MapBanner 和 Map 同时参与
    k, sm, s, ki, par, eq
    */
    var argument;
    
    //kind double singleSid difficult user skills big small cityDefense 

    function BattleScene(arg)
    {
        argument = arg;
        kind = argument["kind"];
        double = argument["double"];
        singleSid = argument["singleSid"];
        difficult = argument["difficult"];
        //param = argument["param"];
        user = argument["user"];

        skills = dict();
        var sk = argument["skills"];
        if(sk != null)
        {
            for(var i = 0; i < len(sk); i++)
            {
                var solSk = sk[i];
                var skLev = skills.get(solSk[0], dict());
                skLev.update(solSk[1], solSk[2]);
                skills.update(solSk[0], skLev);
            }
        }
        big = argument["big"];
        small = argument["small"];


        initView();
        initYet = 1;
    }

    var initYet = 0;
    function initView()
    {
        bg = node();
        init();



        if(kind == CHALLENGE_TRAIN)
            map = new Map(argument["big"], argument["small"], null, this, null);
        else
            map = new Map(argument["big"], argument["small"], argument["soldier"], this, argument["equips"]);

        addChild(map);
        banner = new OkBanner(this);
        addChild(banner);
        if(singleSid != null)
        {
            banner.putSoldierOnMap(singleSid);
        }
    }
    
    //防御力的key = 10*big+small 
    function getEneDefense()
    {
        trace("getEneDefense", big, small);
        if(kind == CHALLENGE_MON)
            return mapDefense.get(big*10+small);
        else if(kind == CHALLENGE_FRI || kind == CHALLENGE_NEIBOR || kind == CHALLENGE_FIGHT || kind == CHALLENGE_DEFENSE)
            return argument["cityDefense"];//param[4];
        else if(kind == CHALLENGE_SELF)
            return argument["cityDefense"];//param[4];
        return 0;
    }
    var setLevel = 0;
    //结束布阵就进入rank 但是如何表现回去的箭头任务
    function finishArrange(lev)
    {
        setLevel = lev;
        banner.removeSelf();
        banner = null;
        map.finishArrange();
        if(kind == CHALLENGE_TRAIN)
            map.finishTrainArrange();

        pausePage = new MapPause(this);
        addChild(pausePage);

        banner = new SelBanner(this);
        addChild(banner);
        
        selB2 = new SelBanner2(this);
        addChild(selB2);

        state = MAP_FINISH_SKILL;

        if(kind == CHALLENGE_MON)
            global.taskModel.doAllTaskByKey("round", 1);
        if(kind == CHALLENGE_TRAIN)
            global.taskModel.doAllTaskByKey("train", 1);
        if(kind == CHALLENGE_NEIBOR)
            global.taskModel.doAllTaskByKey("neiborChallenge", 1);
        if(kind == CHALLENGE_FRI)
            global.taskModel.doAllTaskByKey("rankChallenge", 1);
        if(kind == CHALLENGE_FIGHT)
            global.taskModel.doAllTaskByKey("fightChallenge", 1);
    }
    function setSkillSoldier(sol)
    {
        //if(pausePage != null)
        //    pausePage.skillFlowBanner.setSoldier(sol);
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
            //if(state == MAP_ARRANGE) 
            global.director.popScene();

            //else 
            //    pausePage.onPause();
        }
    }
    function clearSoldier(so)
    {
        //banner.clearSoldier(so);
        //selB2.clearSoldier(so);
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
                var eachRow = map.roundGridController.rows.items();
                var hasLiveMon = 0;//mySol leftNum
                for(var i = 0; i < len(eachRow); i++)
                {
                    var row = eachRow[i][1];
                    var mySol = null;
                    var eneSol = null;
                    for(var j = 0; j < len(row); j++)
                    {
                        var sol = row[j];
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

                    if(mySol != null && mySol.leftMonNum > 0 && mySol.state != MAP_SOL_DEAD && mySol.state != MAP_SOL_SAVE)
                    {
                        if(eneSol == null)
                        {
                            var newMon = map.genNewMonster(mySol);
                            if(newMon != null)//有位置放置新的怪兽
                                mySol.leftMonNum--;
                        }
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
