//default left
/*
布局的时候 拖出 0-24 的范围就认为是归还给系统

MAP_START_SKILL 场景 状态时， 点击士兵释放技能


实现士兵的方法时 需要 注意 防御装置 相应接口实现


任何initAttackAndDefense 的敌方 需要 加测是否需要 初始化 变身状态
*/
class Soldier extends MyNode
{
    //base 由属性决定的 生命值 攻击力 防御力
    //转职增加 大量的属性 包括一些静态属性  攻击速度 攻击范围 生命回复速度 这个由职业属性决定
    //士兵攻击力 = 基础职业攻击力 + 等级对应增加攻击力 + 装备属性攻击力
    //士兵生命回复速度 = 基础职业回复速度
    //士兵攻击范围 = 基础职业范围 + 装备范围
    //士兵防御力 = 基础职业防御力 + 等级对应防御力 + 装备属性防御力
    //士兵生命值 = 基础职业生命值 + 等级对应生命值 + 装备增加生命值

    var tarMovePos = null;

    var map;
    var color;
    var state;
    var tar = null;
    //10000ms 2000*100
    var speed = 50;
    var lastPoints;
    //var mobj;
    /*
    data:
    color kind
    */
    var movAni;
    var attAni;
    var shiftAni;
    var recoverSpeed;

    var id;
    //var cus;
    var shadow;
    var kind;
    var funcSoldier;
    var data;

    var health = 100;
    var healthBoundary = 100;

    var addAttack = 0;
    var addAttackTime = 0;
    var addDefense = 0;
    var addDefenseTime = 0;

    var addHealthBoundary = 0;
    var addHealthBoundaryTime = 0;

    var leftMonNum = 0;//练级过程中 剩余的敌方怪兽的数量


    /*
    移动动画似乎有些卡
    移动动画7帧
    攻击动画8帧
    */
    var sid;

    //[color kindId] 只有在受到攻击的时候才会显示血条 一会接着消失
    //blu
    var redBlood;
    var greenBlood;

    var bloodTotalLen = 134;
    var bloodHeight = 9;

    var gainexp = 100;//杀死该士兵总的经验
    var hurts = dict();//其它士兵对自己造成的伤害 士兵sid 伤害
    var exp = 0;

    var changeDirNode;
    var sx = 1;
    var sy = 1;
    var offY = 0;
    
    //var attack = 100;
    //var defense = 50;

    var physicAttack;
    var physicDefense;
    var purePhyDefense;

    var magicAttack;
    var magicDefense;
    var pureMagDefense;


    var attRange = 100;
    //var soldierKind = 0;

    var level = 5;
    var myName;
    var dead;

    var nameBanner = null;
    var backBanner = null;

    var skillList;

    //处于攻击魔法的范围中 单体攻击 或者行攻击
    var inSkill = 0;

    //攻击速度 
    //skId level coldTime ready
    /*
    初始化数据 之后 修改攻击速度 修改动画帧率
    初始化动画 使用数据来初始化动画帧率
    */
    function setLeftMonNum(diff)
    {
        leftMonNum = (5+level)*diff/100;
    }
    //skillId level time ready
    var genEneYet = 0;
    //怪兽装备
    var myEquips = [];
    var ai;
    function initData()
    {
        var i;
        //初始化技能列表 等级 冷却时间
        if(sid == ENEMY)
        {
            if(monsterData != null && map.scene.skills != null)
            {
                skillList = map.scene.skills.get(monsterData.get("sid"), dict()).items(); 
                for(i = 0; i < len(skillList); i++)
                {
                    skillList[i].append(0);//累计的 冷却时间
                    skillList[i].append(1);//ready 是否准备好
                }
            }
            else
                skillList = [];
        }
        else
        {
            skillList = global.user.getSolSkills(sid).items();//skillId level
            for(i = 0; i < len(skillList); i++)
            {
                skillList[i].append(0);//累计的 冷却时间
                skillList[i].append(1);//ready 是否准备好
            }
        }

        sx = data.get("sx");
        sy = data.get("sy");


        attSpeed = data.get("attSpeed");
        //attAni.duration = attSpeed;

        offY = data.get("offY");
        volumn = data.get("volumn");
        recoverSpeed = 0;

        //trace("soldierData", monsterData, map.monEquips);

    
        //CHALLENGE_MON
        //CHALLENGE_FRI
        //CHALLENGE_NEIBOR
        //CHALLENGE_TRAIN
        //怪兽没有装备
        if(sid == ENEMY)//敌对方士兵 地图怪兽 
        {
            if(monsterData != null)
            {
                level = monsterData.get("level");
                addAttack = monsterData.get("addAttack", 0);
                addAttackTime = monsterData.get("addAttackTime", 0);
                addDefense = monsterData.get("addDefense", 0);
                addDefenseTime = monsterData.get("addDefenseTime", 0);
                addHealthBoundary = monsterData.get("addHealthBoundary", 0);
                addHealthBoundaryTime = monsterData.get("addHealthBoundaryTime", 0);
                myEquips = map.getEnemyEquips(monsterData.get("sid"));
            }

            attRange = data.get("range");

            health = 0;
            initAttackAndDefense(this);

            //根据士兵myEquips 来初始化装备附加属性
            //setEquipAttribute(this, map.monEquips);//设定地图怪兽我方装备
            //根据敌人sid 得到获取敌人的装备
            //初始化士兵状态 设定装备属性需要
            //setEquipAttribute(this, map.getEnemyEquips(monsterData.get("sid")));

            health = healthBoundary;

            myName = null;
            dead = 0;
        }
        //初始化额外攻击力 和 额外 防御力 以及 额外 生命值上限
        else
        {
            //从用户数据得到装备数据
            myEquips = global.user.getSoldierEquipData(sid);

            var privateData = global.user.getSoldierData(sid);
            level = privateData.get("level", 0);
            
            attRange = data.get("range");

            addAttack = privateData.get("addAttack", 0);
            addAttackTime = privateData.get("addAttackTime", 0);
            addDefense = privateData.get("addDefense", 0);
            addDefenseTime = privateData.get("addDefenseTime", 0);
            addHealthBoundary = privateData.get("addHealthBoundary", 0);
            addHealthBoundaryTime = privateData.get("addHealthBoundaryTime", 0);

            health = privateData.get("health", 0);
            initAttackAndDefense(this);

            myName = privateData.get("name");
            dead = 0;

        }
        //根据士兵基本属性重新计算经验值
        gainexp = getAddExp(id, level);
        trace("soldierData", physicAttack, physicDefense, magicAttack, magicDefense, purePhyDefense);
    }

    var attSpeed;

    //挑战的时候初始化怪兽 和 敌方士兵的时候使用 该数据 sid=-1
    var monsterData;
    //var solAni;
    var fea;
    var oldId;

    var ShadowSize = dict([[1, 1], [2, 2], [3, 3]]);
    function Soldier(m, d, s, md)
    {
        speed = getParam("soldierSpeed");
        ai = new SoldierAI(this);
        monsterData = md;
        sid = s;
        map = m;
        color = d[0];
        id = d[1];//士兵类型id
        oldId = id;//士兵旧的类型

        var k = id/10;

        var feaFil = FEA_BLUE;
        if(color == ENECOLOR)
            feaFil = FEA_RED;

        load_sprite_sheet("soldierm"+str(id)+".plist");
        load_sprite_sheet("soldiera"+str(id)+".plist");

        load_sprite_sheet("soldierfm"+str(id)+".plist");
        load_sprite_sheet("soldierfa"+str(id)+".plist");


        //1500 ms攻击一次 
        //经营页面回复生命值 60s 一次

        data = getData(SOLDIER, id);
        initData();
        shiftAni = moveto(0, 0, 0);

        kind = data.get("kind");
        setPrivateFunc();

        state = MAP_SOL_ARRANGE;

        /*
        依赖士兵的位置 计算都采用changeDirNode
        getSolMap getSolPos
        bg 的大小 和 士兵图片完全相同
        切换方向 只切换changeNode
        */
        bg = node();
        init();

        bg.scale(MAP_SOL_SCALE);
        changeDirNode = bg.addsprite("soldiera"+str(id)+".plist/ss"+str(id)+"a0.png").anchor(50, 100);
        changeDirNode.prepare();
        var bSize = changeDirNode.size();

        bg.size(bSize).anchor(50, 100).pos(102, 186);
        changeDirNode.pos(bSize[0]/2, bSize[1]);

        //变身之后特征色消失
        //fea = changeDirNode.addsprite("soldierfm"+str(id)+".plist/ss"+str(id)+"fm0.png", feaFil);
        fea = sprite("soldierfa"+str(id)+".plist/ss"+str(id)+"fa0.png", feaFil);

        var ani = getSolAnimate(id);
        movAni = new SoldierAnimate(1500, ani[0], ani[2], changeDirNode, fea, feaFil);
        //攻击速度提升 则 动画的频率也提升
        attAni = new SoldierAnimate(attSpeed, ani[1], ani[3], changeDirNode, fea, feaFil);


        var shadowOffY = data["shadowOffY"];

        var ss = ShadowSize.get(sx, 3);
        shadow = sprite("roleShadow"+str(ss)+".png").pos(bSize[0]/2, bSize[1]+shadowOffY).anchor(50, 50);
        bg.add(shadow, -1);//攻击图片大小变化 导致 shadow的位置突然变化 这是为什么？


        //adjustPicSize();

        var suffix = "";
        if(sx >= 2)
            suffix = "1";

        backBanner = bg.addsprite("mapSolBloodBan"+suffix+".png").pos(bSize[0]/2, data["bloodHeight"]).anchor(50, 100).scale(10000/MAP_SOL_SCALE);


        if(color == ENECOLOR)
            backBanner.visible(0);//初始敌人血条不显示
        var mInfo = getData(MAP_INFO, map.kind);

        redBlood = backBanner.addsprite("mapSolBloodRed"+suffix+".png").pos(2, 2);
        if(color == MYCOLOR)
        {
            if(mInfo["blood"] == 0)
                greenBlood = backBanner.addsprite("mapSolBloodBlue"+suffix+".png").pos(2, 2);
            else if(mInfo["blood"] == 1)
                greenBlood = backBanner.addsprite("mapSolBloodGreen"+suffix+".png").pos(2, 2);
        }
        else
            greenBlood = backBanner.addsprite("mapSolBloodYellow"+suffix+".png").pos(2, 2);

        bloodTotalLen = greenBlood.prepare().size()[0];
        bloodHeight = greenBlood.prepare().size()[1];

        initHealth();

        setDir();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function showBlood()
    {
        backBanner.visible(1);
    }
    function hideBlood()
    {
        backBanner.visible(0);
    }
    var attTime = 0;
    function getLevelUp()
    {
        while(1)
        {
            var ne = getLevelUpExp(id, level);
            if(exp >= ne)
            {
                exp -= ne;
                level += 1;
            }
            else
                break;
        }
        initAttackAndDefense(this);
        health = healthBoundary;
        initMakeUpData();
        //等级自动变动
    }

    /*
    士兵升级需要的经验如何表示每种类型的士兵
    例如剑士 系列 ----> 升级需要的经验是 *2 增加
    0kindId ---->20 50 30 60 80 90 100
    10

    只在闯关结束之后 更新所有参战士兵的数据
    经验 等级 生命值 死亡状态 类型


    */
    //闯关 挑战 训练  增加的经验
    var addExp = 0;
    function changeExp(e)
    {
//        trace("changeExp", e);
        if(color == ENECOLOR)//敌方不增加经验
            return;
        addExp += e;
        exp += e; 
        
        /*
        //为了游戏流畅 在中间过程可以不写数据库 在结算经验的 被攻击方处 更新所有士兵状态
        if(state != MAP_SOL_DEAD)
        {
            var temp = bg.addnode();
            temp.addsprite("exp.png").anchor(0, 50).pos(0, -30).size(30, 30);
temp.addlabel("+" + str(e), "fonts/heiti.ttf", 25).anchor(0, 50).pos(35, -30).color(0, 0, 0);
            temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
        }
        //bWord.pos(bSize[0]/2, -5).anchor(50, 100).addaction(sequence(moveby(1000, 0, -20), fadeout(1000), callfunc(removeTempNode)));
        */
        if(state != MAP_SOL_DEAD)
        {
            var expPng = altasWord("blue", "+"+str(e)+"xp");
            expPng.scale(22*100/expPng.size()[1]);
            bg.add(expPng);
            expPng.anchor(50, 100).pos(bg.size()[0]/2, -5).addaction(sequence(moveby(1000, 0, -20), fadeout(1000), callfunc(removeTempNode)));
        }
    }
    function initHealth()
    {
        var oldSize = greenBlood.prepare().size();
        var sx = max(bloodTotalLen*health/healthBoundary, 0);

        redBlood.stop();
        if(sx < oldSize[0])
        {
            var difX = oldSize[0]-sx;

            var spe = bloodTotalLen*1000/getParam("hurtBloodShrinkTime");//speed /s
            var t = max(difX*1000/spe, getParam("hurtBloodMinTime"));//ms
            redBlood.addaction(sizeto(t, sx, bloodHeight));
        }
        else
        {
            redBlood.size(sx, bloodHeight);
        }
       
        greenBlood.size(sx, bloodHeight);
    }

    //计算missRate 如果 没有伤害则忽略
    function acceptHarm(sol, hurt)
    {
        var bSize = bg.size();
        //bg 的size和图片的size大小相同
        var bWord;
        var missRate = data["missRate"];
        var mr = rand(100);
        if(mr < missRate)
        {
            bWord = sprite("miss.png");
            bg.add(bWord);
            bWord.pos(bSize[0]/2, -5).anchor(50, 100).addaction(sequence(moveby(getParam("hurtNumFlyTime"), 0, getParam("hurtNumFlyDistance")), fadeout(getParam("hurtNumFadeTime")), callfunc(removeTempNode)));
            return;
        }
        var add = -hurt[0];
        var val = hurts.get(sol.sid, [sol, 0]);
        val[1] += add;
        hurts.update(sol.sid, val);
        health += add;

        initHealth();

        //暴击
        if(hurt[1])
            changeDirNode.addaction(sequence(tintto(getParam("criticalHitTime"), getParam("criticalHitColor"), 0, 0, 100), tintto(getParam("criticalFinishTime"), 100, 100, 100, 100)));
        
        var cs = changeDirNode.size();
        //攻击类型 物理
        //攻击类型 魔法 由 catergory决定
        var attackKind = sol.data["attackKind"];
        if(attackKind == PHYSIC_ATTACK)//近战远程 物理溅血
        {
            //var bl = sprite().pos(50, 50).pos(cs[0]/2, cs[1]/2).addaction(sequence(animate(700, "hurt0.png", "hurt1.png","hurt2.png","hurt3.png","hurt4.png","hurt5.png","hurt6.png", UPDATE_SIZE), callfunc(removeTempNode)));
            //changeDirNode.add(bl, 10);
        }
        else//魔法攻击显示变色
        {
            //changeDirNode.addaction(sequence(tintto(500, 100, 0, 0), tintto(500, 100, 100, 100)));        
        }

        if(add < 0)
        {
            bWord = altasWord("yellow", str(add));
            bWord.scale(18*100/bWord.size()[1]);
        }
        else
        {
            bWord = altasWord("blue", "+"+str(add));
            bWord.scale(22*100/bWord.size()[1]);
        }
        bg.add(bWord);
        bWord.pos(bSize[0]/2, data["bloodHeight"]).anchor(50, 100).addaction(sequence(moveby(getParam("hurtNumFlyTime"), 0, getParam("hurtNumFlyDistance")), fadeout(getParam("hurtNumFadeTime")), callfunc(removeTempNode)));


        if(health < healthBoundary)
            backBanner.visible(1);
        else
            backBanner.visible(0);
    }

    //不能在callfunc中调用
    //士兵 伤害
    //生命值 < 0 表示死亡
    //死亡之后复活的生命值 >= 0
    //只在增加生命值 使用药品时调用
    function changeHealth(sol, add)
    {
        health += add;
        initHealth();
        
        var bSize = bg.size();
        //bg 的size和图片的size大小相同
        var bWord;
        if(add < 0)
        {
            bWord = altasWord("yellow", str(add));
            bWord.scale(18*100/bWord.size()[1]);
        }
        else
        {
            bWord = altasWord("blue", "+"+str(add));
            bWord.scale(22*100/bWord.size()[1]);
        }
        bg.add(bWord);
        bWord.pos(bSize[0]/2, data["bloodHeight"]).anchor(50, 100).addaction(sequence(moveby(getParam("hurtNumFlyTime"), 0, getParam("hurtNumFlyDistance")), fadeout(getParam("hurtNumFadeTime")), callfunc(removeTempNode)));


        if(health < healthBoundary)
            backBanner.visible(1);
        else
            backBanner.visible(0);
    }


    var oldPos = null;
    /*
    移动清除旧的map 
    相对于map的 位置 
    设置grid 显示 设置zord 最大
    */
    var chooseStar = null;
    //multi Line 技能点击士兵 将会 向map 传播
    //士兵已经转化成 touchWorldBegan 世界坐标
    function showChoose(n, e, p, x, y, points)
    {
        var skillId;
        var sdata;
        var skillKind;
        var bSize;
        if(map.scene.state == MAP_START_SKILL)
        {
            skillId = map.scene.skillId;
            sdata = getData(SKILL, skillId);
            skillKind = sdata.get("kind");
            
            if((color == ENECOLOR && (skillKind == SINGLE_ATTACK_SKILL || skillKind == SPIN_SKILL))
                    || (color == MYCOLOR && (skillKind == HEAL_SKILL || skillKind == SAVE_SKILL || skillKind == USE_DRUG_SKILL))
                    )
            {
                bSize = bg.size();
                chooseStar = sprite().anchor(50, 50).pos(bSize[0]/2, bSize[1]);
                chooseStar.addaction(repeat(animate(1500, "redStar0.png", "redStar1.png", "redStar2.png", "redStar3.png", "redStar4.png", "redStar5.png", "redStar6.png", "redStar7.png", "redStar8.png", "redStar9.png", "redStar10.png", UPDATE_SIZE)));
                bg.add(chooseStar, -1);
            }
            else if(skillKind == LINE_SKILL || skillKind == MULTI_ATTACK_SKILL)
            {
                var nPos = n.world2node(x, y);
                map.touchBegan(n, e, p, nPos[0], nPos[1], points);
            }
            map.clearMoveSol();
        }
    }
    function touchWorldBegan(n, e, p, x, y, points)
    {

        if(state == MAP_SOL_ARRANGE && color == MYCOLOR)
        {
            map.moveGrid(this);
            setZord(MAX_SOL_ZORD);
            map.clearMap(this);
            //map.scene.banner.setCurChooseSol(this);
        }
        else
        {
            showChoose(n, e, p, x, y, points);
        }
    }
    function touchBegan(n, e, p, x, y, points)
    {
        oldPos = getPos();
        lastPoints = n.node2world(x, y);
        touchWorldBegan(n, e, p, lastPoints[0], lastPoints[1], points);
    }
    function setCol()
    {
        var scKind = map.scene.kind; 
        var col;
        //if(scKind != CHALLENGE_TRAIN)//训练检测每行冲突
        col = map.checkSolOutOrCol(this);
        //else
        //    col = map.checkLineCol(this);
        if(col != null)
            bg.color(93, 4, 1, 30);
        else
            bg.color(100, 100, 100, 100);
    }
    /*
    移动的新位置必须和格子对齐
    判断冲突 检测地图状态

    移动士兵 移动grid zord最大
    */
    function touchWorldMoved(n, e, p, x, y, points)
    {
        //trace("touchWorldMoved", x, y);
        
        if(state == MAP_SOL_ARRANGE && color == MYCOLOR)
        {
            lastPoints = map.bg.world2node(x, y);

            bg.pos(lastPoints);
            map.moveGrid(this);
            setCol();
        }
        else if(map.scene.state == MAP_START_SKILL)
        {
            var skillId = map.scene.skillId;
            var sdata = getData(SKILL, skillId);

            var skillKind = sdata.get("kind");
            if(skillKind == LINE_SKILL || skillKind == MULTI_ATTACK_SKILL)
            {
                var nPos = n.world2node(x, y);
                map.touchMoved(n, e, p, nPos[0], nPos[1], points);
            }
            else if((skillKind == SINGLE_ATTACK_SKILL || skillKind == SPIN_SKILL) && color == ENECOLOR)//单体攻击 移动到其它 移动没有作用
            {
            }
            else if(color == MYCOLOR && (skillKind == HEAL_SKILL || skillKind == SAVE_SKILL || skillKind == USE_DRUG_SKILL))
            {
            }
        }
    }
    function touchMoved(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        touchWorldMoved(n, e, p, lastPoints[0], lastPoints[1], points);
    }
    /*
    根据map 
    检测 超出 合理 区域 移除士兵

    计算 规整后的 坐标 设定坐标

    检测冲突 则放置回原来的位置
    设置正常的zord
    清理 地图上显示的grid
    */
    function touchWorldEnded(n, e, p, x, y, points)
    {
        if(state == MAP_SOL_ARRANGE && color == MYCOLOR)
        {
            var oldMap = getSolMap(bg.pos(), sx, sy, offY);
            var ret = map.checkInBoundary(this, oldMap);
            if(ret == 0)
            {
                map.clearSoldier(this);
                return;
            }
            else//规整位置
            {
                var nPos = getSolPos(oldMap[0], oldMap[1], sx, sy, offY); 
                setPos(nPos);
            }

            //var col = map.checkCol(this);

            var col = map.checkSolOutOrCol(this);
            if(col != null)
            {
                if(oldPos == null)//初始布阵失败则消失
                {
                    map.clearSoldier(this); 
                    map.removeGrid();
                    return;
                }
                else
                    setPos(oldPos);
            }
            setCol();//清理冲突状态
            map.setMap(this);
            map.removeGrid();
        }
        //战斗状态 场景设定 技能选择 只有英雄才有技能
        else if(map.scene.state == MAP_FINISH_SKILL)//&& data.get("isHero") && color == MYCOLOR 点击敌方士兵也出状态
        {
            map.scene.setSkillSoldier(this); 
            if(color == MYCOLOR)
                map.setMoveSol(this);
        }
        //给敌方士兵释放魔法
        else if(map.scene.state == MAP_START_SKILL)//对敌方操作
        {
            var skillId = map.scene.skillId;
            var sdata = getData(SKILL, skillId);
            var skillKind = sdata.get("kind");
            if(color == ENECOLOR && (skillKind == SINGLE_ATTACK_SKILL || skillKind == SPIN_SKILL))//单体攻击 眩晕攻击
            {
                chooseStar.removefromparent();
                chooseStar = null;
                map.scene.setTargetSol(this);
            }
            else if(skillKind == LINE_SKILL || skillKind == MULTI_ATTACK_SKILL)
            {
                var worldPos = n.world2node(x, y);
                map.touchEnded(n, e, p, worldPos[0], worldPos[1], points);
            }
            else if(color == MYCOLOR && (skillKind == HEAL_SKILL || skillKind == SAVE_SKILL || skillKind == USE_DRUG_SKILL))
            {
                chooseStar.removefromparent();
                chooseStar = null;
                map.scene.setTargetSol(this); 
            }
        }
    }
    function touchEnded(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        touchWorldEnded(n, e, p, lastPoints[0], lastPoints[1], points);
    }
    var addedYet = 0;
    /*
    检测是否已经加入了我方士兵列表如果没有则加入map的我方士兵列表
    */
    function addToMySol()
    {
        if(addedYet == 0)
        {
            addedYet = 1;
            return 0;
        }
        return 1;
    }
    //布局结束 增加士兵的攻击力 防御力 消耗 士兵的药水状态
    function finishArrange()
    {
        var drugUse = 0;
        if(addAttackTime > 0)
        {
            addAttackTime -= 1;
            drugUse = 1;
        }
        if(addDefenseTime > 0)
        {
            addDefenseTime -= 1;
            drugUse = 1;
        }
        if(addHealthBoundaryTime > 0)
        {
            addHealthBoundaryTime -= 1;
            drugUse = 1;
        }
        if(sid != ENEMY)//敌方士兵不会使用药品
        {
            if(drugUse == 1)
            {
                global.httpController.addRequest("soldierC/useState", dict([["uid", global.user.uid], ["sid", sid]]), null, null);
                global.user.updateSoldiers(this);
            }
        }

        state = MAP_SOL_FREE;
        if(nameBanner != null)
        {
            nameBanner.removeSelf();
            nameBanner = null;
        }
        //生命值小于上限则显示血条
        if(health < healthBoundary)
            backBanner.visible(1);
        else 
            backBanner.visible(0);
    }
    function getDir()
    {
        var sca = changeDirNode.scale();
        return sca[0];
    }
    function setMoveDir()
    {
        if(tarMovePos != null)
        {
            var tpos = tarMovePos;
            var mpos = bg.pos();
            var difx = tpos[0] - mpos[0];
            if(difx > 0)
            {
                changeDirNode.scale(-100, 100);
            }
            else
            {
                changeDirNode.scale(100, 100);
            }
        }
    }
    function setDir()
    {
        if(tar == null)
        {
            if(color == MYCOLOR)
                changeDirNode.scale(-100, 100);
            else
                changeDirNode.scale(100, 100);
        }
        else
        {
            var tpos = tar.getPos();
            var mpos = bg.pos();
            var difx = tpos[0] - mpos[0];
            if(difx > 0)
            {
                changeDirNode.scale(-100, 100);
            }
            else
            {
                changeDirNode.scale(100, 100);
            }
        }
    }
    /*
    攻击最近的同一条线的对象
    攻击不同线的敌人
    攻击第二近的敌人
    确认了目标 但是还需要 一步一步的移动
    */
    function getTar()
    {
        //同一条线的敌方对象 面前纵格子的对象 
        //如何有纵向的范围攻击 
        var myMap = getSolMap(getPos(), sx, sy, offY);
        var minDist = 10000;
        var minTar = null;
        for(var j = 0; j < sy; j++)
        {
            var t = map.soldiers.get(myMap[1]+j);//row  Soldiers
            for(var i = 0; i < len(t); i++)
            {
                if(t[i].color == color || t[i].state == MAP_SOL_DEAD || t[i].state == MAP_SOL_SAVE)
                    continue;
                var p = t[i].getPos();
                var dist = abs(bg.pos()[0]-p[0]);   
                if(dist < minDist)
                {
                    minDist = dist;
                    minTar = t[i];
                }
            }
        }
        return minTar;
    }
    override function setPos(p)
    {
        var zOrd = p[1];
        bg.pos(p);
        var par = bg.parent();
        bg.removefromparent();
        if(par != null)
            par.add(bg, zOrd);
    }
    function clearAnimation()
    {
        movAni.clearAnimation();
        attAni.clearAnimation();
        changeDirNode.texture("soldiera"+str(id)+".plist/ss"+str(id)+"a0.png", UPDATE_SIZE);
    }
    var volumn;
    function getVolumn()
    {
        return volumn;
    }
    var deadTime = 0;
    const DEAD_TIME = 4000;
    var deadYet = 0;
    var stopNow = 0;
    function stopGame()
    {
        stopNow = 1;
        shiftAni.stop();
    }
    function continueGame()
    {
        stopNow = 0;
    }

    function checkTarState()
    {
        if(tar.state == MAP_SOL_DEAD || tar.state == MAP_SOL_SAVE)
        {
            state = MAP_SOL_FREE;
            clearAnimation();
            tar = null;
            return 1;
        }
        return 0;
    }
    /*
    敌方士兵的AI周期---> 技能冷却释放技能
    AI 周期大于动画周期
    */
    var aiTime = 0;
    const AI_PERIOD = 5000;
    function update(diff)
    {
        var tPos;
        var dist;
        var colObj;
        var t;
        if(stopNow == 1)
            return;

        if(inTransform == 1)//进行变身状态清空
            return;


        if(spinState == 1)
        {
            spinTime -= diff;
            if(spinTime > 0)//仍在眩晕状态 停止移动 停止攻击
                return;
            spinState = 0;//眩晕状态结束
        }

        if(state == MAP_SOL_SAVE)
        {
            return;
        }
        //应该在死亡倒地之后， 去除阴影 但是阴影的大小位置都会变化的 
        //倒地是以anchor 50 100 为 轴转动 但是人物的相对位置是变化的
        //倒地的方向需要确定
        //倒地需要执行一个动作变换函数
        //倒地的时间需要控制 1 s 0-90 4frame 3 time 300ms 
        //血液在倒地 之后显示
        //id level coldTime ready
        aiTime += diff;
        var i;
        var sk;

        if(state != MAP_SOL_DEAD && state != MAP_SOL_ARRANGE)
        {
            for(i = 0; i < len(skillList); i++)
            {
                sk = skillList[i];
                if(sk[3] == 0)
                {
                    sk[2] += diff;
                    var coldTime = getSkillColdTime(sid, sk[0], sk[1]);
                    if(sk[2] >= coldTime)
                    {
                        trace("skillReady", sk);
                        sk[3] = 1;
                    }
                }
            }
            if(aiTime >= AI_PERIOD && color == ENECOLOR)
            {
                aiTime = 0;
                ai.releaseSkill();
            }
        }
        //变身时间到解除变身状态 重新计算属性值
        if(makeUpState)
        {
            makeUpTime += diff;
            var totalMT = getMakeUpTime(sid, makeUpSkillId, makeUpLevel);
            if(makeUpTime >= totalMT)
            {
                makeUpState = 0;
                finishMakeUpView();
                //initAttackAndDefense(this);
                //initHealth();
            }
        }
        var ret;
        if(health < 0 && state != MAP_SOL_DEAD)
        {
            dead = 1;
            health = 0;
            
            state = MAP_SOL_DEAD;
            shadow.removefromparent();

            shiftAni.stop();
            clearAnimation();

            backBanner.removefromparent();
            addChild(new DeadOver(this));


            //设置最小zord 在死亡之后设置zord

            tar = null;
            //增加经验
            deadTime = 0;
            map.calHurts(this);

            //进入死亡状态 闯关结束时更新所有士兵状态
            global.user.updateSoldiers(this);

            //杀死敌方怪兽
            if(color == ENECOLOR && data["solOrMon"] == 1)
                global.taskModel.doCycleTaskByKey("killMonster", 1);
        }

        if(state == MAP_SOL_ARRANGE)
        {
        }
        //设定了移动目标位置
        else if(state == MAP_SOL_POS)
        {
            shiftAni.stop();
            //clearAnimation();
             
            tPos = tarMovePos;
            dist = abs(bg.pos()[0]-tPos[0]);//同一行 
            if(dist < 5)
            {
                state = MAP_SOL_FREE;
                clearAnimation();
                return;
            }

            colObj = map.checkMoveDirCol(this, tarMovePos);
            if(colObj != null)
            {
                clearAnimation();
                state = MAP_SOL_FREE;
                return;
            }
            t = dist*1000/speed;
            shiftAni = moveto(t, tPos[0], bg.pos()[1]); 
            bg.addaction(shiftAni);

        }
        else if(state == MAP_SOL_FREE)
        {
            tar = getTar();
//            trace("free tar", tar);
            if(tar != null)
            {
                clearAnimation();
                //changeDirNode.addaction(movAni);
                movAni.enterScene();

                setDir();
                state = MAP_SOL_MOVE;
            }

        }
        //对方在移动过程中死亡 或者 被save 都停止攻击
        else if(state == MAP_SOL_MOVE)
        {
            ret = checkTarState();
            if(ret)
                return;

            shiftAni.stop();

            tPos = tar.getPos();
            dist = abs(bg.pos()[0]-tPos[0]);//同一行 

            if((dist-getVolumn()-tar.getVolumn()) <= attRange)//攻击范围
            {
                state = MAP_SOL_ATTACK;
                clearAnimation();
                attAni.enterScene();
                return;
            }
            
            //在前方存在冲突对象不能移动 更换攻击目标
            colObj = map.checkDirCol(this, tar);
            //trace("colObj", colObj);
            if(colObj != null)
            {
                clearAnimation();
                state = MAP_SOL_FREE;
                tar = null;
                return;
            }
            t = dist*1000/speed;
            shiftAni = moveto(t, tPos[0], bg.pos()[1]); 
            bg.addaction(shiftAni);
        }
        else if(state == MAP_SOL_TOUCH)
        {
            tar = null;
            clearAnimation();
            //changeDirNode.addaction(movAni);
            movAni.enterScene();
            state = MAP_SOL_WATI_TOUCH; 
        }
        /*
        inAttacking = 0 攻击动画结束 ---> 计算伤害 --->重新启动动画
        */
        else if(state == MAP_SOL_ATTACK)
        {
            ret = checkTarState();
            if(ret)
                return;
            tPos = tar.getPos();
            dist = abs(tPos[0]-bg.pos()[0]);
            if((dist- getVolumn() - tar.getVolumn())> attRange)
            {
                clearAnimation();
                movAni.enterScene();
                setDir();
                state = MAP_SOL_MOVE; 
                return;
            }
            attTime += diff;
            //攻击动画与伤害计算 分离
            if(attTime >= attSpeed)
            {
                funcSoldier.doAttack();
                attTime -= attSpeed;
            }
        }
        else if(state == MAP_SOL_WATI_TOUCH)
        {
        }
        /*
        死亡后士兵实体并不会消失
        保存在其它士兵的hurts 列表中 清空自身的hurt列表
        */
        else if(state == MAP_SOL_DEAD)
        {
            deadTime += diff;
            if(deadTime >= DEAD_TIME && deadYet == 0)
            {
                deadYet = 1;
                map.soldierDead(this); 
                hurts = null;
            }
        }

    }
    override function enterScene()
    {
//        trace("map", map, map.myTimer);
        super.enterScene();   
        map.myTimer.addTimer(this);
    }
    override function exitScene()
    {
        map.myTimer.removeTimer(this);
        //cus.exitScene();
        clearAnimation();
        super.exitScene();   
    }
    //眩晕不能攻击 不能 移动 
    var spinState = 0;
    var spinTime = 0;
    function beginSpinState(t)
    {
        spinState = 1;
        spinTime = t;//总共眩晕时间
        clearAnimation();
        shiftAni.stop();
    }
    function doHeal(heal)
    {
        var addHealth = healthBoundary*heal/100;
        health += addHealth;
        health = min(health, healthBoundary);
        initHealth();
    }

    //根据药品重新计算士兵的生命值上限 和 攻击力 以及防御力
    function doDrug(drugId)
    {
        var dd = getData(DRUG, drugId);    

        var pureData = getSolPureData(id, level);
        var pureHealthBoundary;
        if(dd.get("healthBoundary") != 0)
        {
            addHealthBoundary = dd.get("healthBoundary");
            addHealthBoundaryTime = dd.get("effectTime");
        }
        else if(dd.get("percentHealthBoundary") != 0)
        {
            pureHealthBoundary = pureData["healthBoundary"];
            addHealthBoundary = dd.get("percentHealth")*pureHealthBoundary/100;
            addHealthBoundaryTime = dd.get("effectTime");
        }
        else if(dd.get("percentAttack") != 0)
        {
            var purePhyAttack = pureData["physicAttack"];
            var pureMagAttack = pureData["magicAttack"];
            addAttack = dd.get("percentAttack")*max(purePhyAttack, pureMagAttack)/100;
            addAttackTime = dd.get("effectTime");
        }
        else if(dd.get("percentDefense") != 0)
        {
            var purePhyDef = pureData["physicDefense"];
            var pureMagDef = pureData["magicDefense"];
            addDefense = dd.get("percentDefense")*max(purePhyDef, pureMagDef)/100;
            addDefenseTime = dd.get("effectTime");
        }
        else if(dd.get("attack") != 0)
        {
            addAttack = dd.get("attack");
            addAttackTime = dd.get("effectTime");
        }
        else if(dd.get("defense") != 0)
        {
            addDefense = dd.get("defense");
            addDefenseTime = dd.get("effectTime");
        }
        else if(dd.get("health") > 0)
        {
            health += dd.get("health");
            health = min(health, healthBoundary);
        }
        else if(dd.get("percentHealth") > 0)
        {
            var addHealth = pureData["healthBoundary"]*dd.get("percentHealth")/100;
            health += addHealth;
            health = min(health, healthBoundary);//补充纯粹生命值上限 一定百分比生命值
        }
        initAttackAndDefense(this);
        initMakeUpData();
        initHealth();
    }

    //所有攻击我的士兵都停止攻击
    function doSave()
    {
        state = MAP_SOL_SAVE;
        clearAnimation();
        map.saveSoldier(this);
    }
    var makeUpState = 0;
    
    var makeUpTime = 0;
    var makeUpLevel = 0;

    var makeUpRate = 100;
    var makeUpSkillId = -1;
    //选择某个英雄 在 右上角显示士兵的能力数值

    //确定对应的变身对象
    //播放变身动画---》获得相应的 移动动画 和 攻击动画
    //计时变身时间
    //计算变身技能

    //喝药水 重新计算能力时
    
    //变身状态无敌
    //变身动画播放
    function doMakeUp(skillId, skillLevel)
    {
        if(makeUpState == 0 && !inTransform)
        {
            makeUpSkillId = skillId;
            makeUpLevel = skillLevel;
            makeUpState = 1;
            makeUpTime = 0;
            makeUpRate = getMakeUpRate(id); 
            initMakeUpData();
            initMakeUpView();
            initHealth();
        }
    }
    //id 等属性不会变化
    function initMakeUpData()
    {
        if(!makeUpState)
            return;
        physicAttack *= makeUpRate;
        physicAttack /= 100;

        physicDefense *= makeUpRate;
        physicDefense /= 100;
        
        magicAttack *= makeUpRate;
        magicAttack /= 100;

        magicDefense *= makeUpRate;
        magicDefense /= 100;

        healthBoundary *= makeUpRate;
        healthBoundary /= 100;

        health *= makeUpRate;
        health /= 100;
        health = min(health, healthBoundary);

        attSpeed *= getAttSpeedRate(id);
        attSpeed /= 100;
        
        attAni.duration = attSpeed;//修正攻击速度
        //变身之后 远程攻击范围增加
        if(data["closeOrFar"] == FAR_SOL)
            attRange += getRangeAdd(id); 
    }

    var greenStar = null;//当前技能释放者
    function setSkillState()
    {
        var bSize = bg.size();
        greenStar = sprite().anchor(50, 50).pos(bSize[0]/2, bSize[1]);
        greenStar.addaction(repeat(animate(1500, 
            "greenStar0.png", "greenStar1.png", "greenStar2.png", "greenStar3.png", "greenStar4.png", "greenStar5.png", "greenStar6.png", "greenStar7.png", "greenStar8.png", "greenStar9.png", "greenStar10.png", "greenStar11.png", "greenStar12.png", "greenStar13.png", "greenStar14.png", "greenStar15.png", "greenStar16.png", "greenStar17.png", "greenStar18.png"
            , UPDATE_SIZE)));

        bg.add(greenStar, -1);
    }
    //敌方士兵点击也显示状态
    function clearSkillState()
    {
        if(greenStar != null)
        {
            greenStar.removefromparent();
            greenStar = null;
        }
    }
    function setMoveTar(t)
    {
        tarMovePos = t;
        if(state != MAP_SOL_DEAD && state != MAP_SOL_SAVE)
        {
            state = MAP_SOL_POS;
            setMoveDir();
            clearAnimation();
            movAni.enterScene();//进入行走状态
        }
    }

    
    function doAppearAni()
    {
        map.addChildZ(new MonSmoke(map, null, this, PARAMS["smokeSkillId"], null), MAX_BUILD_ZORD);
    }
    function setAttackCofficient(sol, dif)
    {
        var rate;
        if(sol.data.get("isHero"))
            rate = ATTACK_RATE.get(HERO)[dif];
        else if(sol.data.get("solOrMon"))
            rate = ATTACK_RATE.get(MONSTER)[dif];
        else
            rate = ATTACK_RATE.get(NORMAL_SOL)[dif];
        physicAttack *= rate;
        physicAttack /= 100;
        magicAttack *= rate;
        magicAttack /= 100;

        //总的经验值 也随攻击力 成倍数增长
        gainexp *= rate;
        gainexp /= 100;
    }

    var inTransform = 0;
    var transAni = null;
    //变身动画 重新设定 id data 以及 纹理 类似于转职
    //类似于 MyAction 的动画播放 50 100 位置对齐
    //高频率更新

    //施展变身技能 --- 播放变身动画 且 进入变身状态
    function initMakeUpView()
    {
        //人物是英雄 且没有变身 等级5 
        if(data["isHero"] && id%10 != 4 && !inTransform)
        {
            inTransform = 1;
            state = MAP_SOL_FREE;

            id = id/10 * 10 + 4;//变更id 英雄要在一起调试
            data = getData(SOLDIER, id);
            
            kind = data.get("kind");
            if(kind == CLOSE_FIGHTING)
            {
                funcSoldier = new CloseSoldier(this);
            }
            else
                funcSoldier = new OtherSoldier(this);


            clearAnimation();
            shiftAni.stop();

            var skillId = heroSkill[id/10*10];
            var skillAnimate = getSkillAnimate(skillId);
            

            var feaFil = FEA_BLUE;
            if(color == ENECOLOR)
                feaFil = FEA_RED;

            var ani = getSolAnimate(id);
            movAni = new SoldierAnimate(1500, ani[0], ani[2], changeDirNode, fea, feaFil);
            attAni = new SoldierAnimate(attSpeed, ani[1], ani[3], changeDirNode, fea, feaFil);

            fea.visible(0);
            shadow.visible(0);
            transAni = new TransformAnimate(skillAnimate[1], skillAnimate[0], changeDirNode, this);
            transAni.enterScene();
        }
    }
    
    function setPrivateFunc()
    {
        if(kind == CLOSE_FIGHTING)
        {
            funcSoldier = new CloseSoldier(this);
        }
        else
            funcSoldier = new OtherSoldier(this);
    }
    //执行 逆向动画
    //动画结束 重新 initAttack  initHealth
    //old Id 
    function finishMakeUpView()
    {
        trace("finishMakeUpView");
        if(data["isHero"] && id%10 == 4 && !inTransform)
        {
    
            inTransform = 1;
            state = MAP_SOL_FREE;

            id = oldId;
            data = getData(SOLDIER, id);


            
            kind = data.get("kind");
            setPrivateFunc();

            clearAnimation();
            shiftAni.stop();

            var skillId = heroSkill[id/10*10];
            var skillAni = getSkillAnimate(skillId);
            


            var feaFil = FEA_BLUE;
            if(color == ENECOLOR)
                feaFil = FEA_RED;

            var ani = getSolAnimate(id);

            movAni = new SoldierAnimate(1500, ani[0], ani[2], changeDirNode, fea, feaFil);
            attAni = new SoldierAnimate(attSpeed, ani[1], ani[3], changeDirNode, fea, feaFil);

            fea.visible(0);
            shadow.visible(0);

            //逆向播放 英雄变身动画
            var a = copy(skillAni);
            a[0] = copy(a[0]);//copy a0 reverse
            a[0].reverse();
            //trace("reverse", a);

            //changeDirNode.texture(a[0][0]);
            adjustPicSize();
        
            //transAni = new TransformAnimate(a[1], a[0], changeDirNode, this);
            //transAni.enterScene();

            //更新英雄数据
            initAttackAndDefense(this);
            initHealth();
            finishTransform();
        }
    }
    function adjustPicSize()
    {
        var bSize = changeDirNode.prepare().size();
        bg.size(bSize);
        changeDirNode.pos(bSize[0]/2, bSize[1]);
        var shadowOffY = data["shadowOffY"];

        var ss = ShadowSize.get(sx, 3);
        shadow.texture("roleShadow"+str(ss)+".png").pos(bSize[0]/2, bSize[1]+shadowOffY).anchor(50, 50);

        backBanner.pos(bSize[0]/2, data["bloodHeight"]);
    }
    //结束变动画画
    function finishTransform()
    {
        trace("finish TransformAnimate");
        load_sprite_sheet("soldierm"+str(id)+".plist");
        load_sprite_sheet("soldiera"+str(id)+".plist");

        load_sprite_sheet("soldierfm"+str(id)+".plist");
        load_sprite_sheet("soldierfa"+str(id)+".plist");


        changeDirNode.texture("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", UPDATE_SIZE);
        //changeDirNode.prepare();
        //var bSize = changeDirNode.size();
        //bg.size(bSize);
        //changeDirNode.pos(bSize[0]/2, bSize[1]);

        var feaFil = FEA_BLUE;
        if(color == ENECOLOR)
            feaFil = FEA_RED;
        //变身之后特征色消失
        fea.texture("soldierfm"+str(id)+".plist/ss"+str(id)+"fm0.png", feaFil, UPDATE_SIZE);
        shadow.visible(1);
        
        //var shadowOffY = data["shadowOffY"];
        //shadow.pos(bSize[0]/2, bSize[1]+shadowOffY).anchor(50, 50).size(data.get("shadowSize"), 32);

        adjustPicSize();

        fea.visible(1);//重新设定图片和 特征色 
        transAni = null;
        inTransform = 0;
    }
}
