

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

    var map;
    var color;
    var state;
    var tar = null;
    //10000ms 2000*100
    const SPE = 20;
    var speed = 5;
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

    //var attacker = null;




    /*
    移动动画似乎有些卡
    移动动画7帧
    攻击动画8帧
    */
    //var closeIcon;
    var sid;

    //[color kindId] 只有在受到攻击的时候才会显示血条 一会接着消失
    var bloodBanner;

    var bloodTotalLen = 134;
    var bloodHeight = 9;
    var bloodScaX = 72*100/139;//根据怪兽的体积计算血条长度 
    var bloodScaY = 9*100/12;

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

    //攻击速度 
    //skId level coldTime ready
    function initData()
    {
        //初始化技能列表 等级 冷却时间
        skillList = global.user.getSolSkills(sid).items();//skillId level
        for(var i = 0; i < len(skillList); i++)
        {
            skillList[i].append(0);//累计的 冷却时间
            skillList[i].append(1);//ready 是否准备好
        }

        sx = data.get("sx");
        sy = data.get("sy");


        attSpeed = data.get("attSpeed");
        offY = data.get("offY");
        volumn = data.get("volumn");
        recoverSpeed = 0;

        //trace("soldierData", monsterData, map.monEquips);

    
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
            }

            attRange = data.get("range");

            health = 0;
            initAttackAndDefense(this);

            setEquipAttribute(this, map.monEquips);
            health = healthBoundary;

            myName = null;
            dead = 0;
        }
        //初始化额外攻击力 和 额外 防御力 以及 额外 生命值上限
        else
        {
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
        gainexp = getAddExp(id, level);
        trace("soldierData", physicAttack, physicDefense, magicAttack, magicDefense, purePhyDefense);
    }

    var attSpeed;

    //挑战的时候初始化怪兽 和 敌方士兵的时候使用 该数据 sid=-1
    var monsterData;
    function Soldier(m, d, s, md)
    {
        monsterData = md;
        sid = s;
        map = m;
        color = d[0];
        id = d[1];//士兵类型id

        var k = id/10;
        //暂时没有这些士兵的图片
        if(k >= 20)
            id = 0;

        var colStr = "red";
        if(color == 1)
            colStr = "blue";
        load_sprite_sheet("soldierm"+str(id)+colStr+".plist");
        load_sprite_sheet("soldiera"+str(id)+colStr+".plist");

        movAni = repeat(animate(1500, "soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m6.png", UPDATE_SIZE));
        //1500 ms攻击一次 
        //经营页面回复生命值 60s 一次

        data = getData(SOLDIER, id);
        initData();

        attAni = repeat(animate(attSpeed, "soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a0.png", "soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a1.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a2.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a3.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a4.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a5.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a6.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a7.png", UPDATE_SIZE));//, callfunc(finAttack)

        shiftAni = moveto(0, 0, 0);



        kind = data.get("kind");
        if(kind == CLOSE_FIGHTING)
        {
            funcSoldier = new CloseSoldier(this);
        }
        else if(kind == LONG_DISTANCE)
        {
            funcSoldier = new LongDistanceSoldier(this);
        }
        else if(kind == MAGIC)
        {
            funcSoldier = new MagicSoldier(this);
        }

        state = MAP_SOL_ARRANGE;

        /*
        依赖士兵的位置 计算都采用changeDirNode
        getSolMap getSolPos
        bg 的大小 和 士兵图片完全相同
        切换方向 只切换changeNode
        */
        bg = node();

        changeDirNode = bg.addsprite("soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m0.png").anchor(50, 100);
        changeDirNode.prepare();
        var bSize = changeDirNode.size();

        bg.size(bSize).anchor(50, 100).pos(102, 186);
        changeDirNode.pos(bSize[0]/2, bSize[1]);


        shadow = sprite("roleShadow.png").pos(bSize[0]/2, bSize[1]).anchor(50, 50).size(data.get("shadowSize"), 32);
        bg.add(shadow, -1);//攻击图片大小变化 导致 shadow的位置突然变化 这是为什么？
        init();

        var vol = data.get("volumn");
        if(sx < 2)
        {
            bloodScaX = 70*100/139;//大体积 采用144的长度 中等体积 采用普通长度    
        }
        else 
        {
            bloodScaX = 139*100/139;
        }

        backBanner = bg.addsprite("mapSolBloodBan.png").pos(bSize[0]/2, -10).anchor(50, 100).scale(bloodScaX, bloodScaY);
        //var filter = WHITE;
        //if(color == 0)
        //    filter = BLUE;
            
        bloodBanner = backBanner.addsprite("mapSolBlood.png").pos(2, 2);

        /*
        if(color == 0)//nameBanner
        {
            nameBanner = new SpeakDialog(this);
            nameBanner.setPos([bSize[0]/2, 0]);
            addChild(nameBanner);
        }
        */

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

    function changeExp(e)
    {
//        trace("changeExp", e);
        exp += e; 
        
        //为了游戏流畅 在中间过程可以不写数据库 在结算经验的 被攻击方处 更新所有士兵状态
        if(state != MAP_SOL_DEAD)
        {
            var temp = bg.addnode();
            temp.addsprite("exp.png").anchor(0, 50).pos(0, -30).size(30, 30);
            temp.addlabel("+"+str(e), null, 25).anchor(0, 50).pos(35, -30).color(0, 0, 0);
            temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
        }
    }
    function initHealth()
    {
        var sx = bloodTotalLen*health/healthBoundary;
        bloodBanner.size(sx, bloodHeight);
    }

    //不能在callfunc中调用
    //士兵 伤害
    //生命值 < 0 表示死亡
    //死亡之后复活的生命值 >= 0
    function changeHealth(sol, add)
    {
        var val = hurts.get(sol.sid, [sol, 0]);
        val[1] += add;
        hurts.update(sol.sid, val);

        health += add;

        var sx = bloodTotalLen*max(health, 0)/healthBoundary;
        bloodBanner.size(sx, bloodHeight);
        
        var cs = changeDirNode.size();
        if(sol.kind == 0 || sol.kind == 1)//近战远程 物理溅血
        {
            var bl = sprite().pos(50, 50).pos(cs[0]/2, cs[1]/2).addaction(sequence(animate(700, "hurt0.png", "hurt1.png","hurt2.png","hurt3.png","hurt4.png","hurt5.png","hurt6.png", UPDATE_SIZE), callfunc(removeTempNode)));
            changeDirNode.add(bl, 10);
        }
        else//魔法攻击显示变色
        {
            changeDirNode.addaction(sequence(tintto(500, 100, 0, 0), tintto(500, 100, 100, 100)));        
        }
        var bSize = bg.size();
        //bg 的size和图片的size大小相同
        bg.addlabel(str(add), null, 30).pos(bSize[0]/2, -5).color(100, 0, 0).anchor(50, 100).addaction(sequence(moveby(1000, 0, -20), callfunc(removeTempNode)));
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
        }
    }
    function touchWorldBegan(n, e, p, x, y, points)
    {

        if(state == MAP_SOL_ARRANGE && color == MYCOLOR)
        {
            map.moveGrid(this);
            setZord(MAX_SOL_ZORD);
            map.clearMap(this);
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
        var col = map.checkCol(this);
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

            var col = map.checkCol(this);
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
        else if(map.scene.state == MAP_FINISH_SKILL && color == MYCOLOR)//&& data.get("isHero")
        {
            map.scene.setSkillSoldier(this); 
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
            else if(color == ENECOLOR && (skillKind == LINE_SKILL || skillKind == MULTI_ATTACK_SKILL))
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
        if(drugUse == 1)
        {
            global.httpController.addRequest("soldierC/useState", dict([["uid", global.user.uid], ["sid", sid]]), null, null);
            global.user.updateSoldiers(this);
        }

        state = MAP_SOL_FREE;
        if(nameBanner != null)
        {
            nameBanner.removeSelf();
            nameBanner = null;
        }
    }
    function getDir()
    {
        var sca = changeDirNode.scale();
        return sca[0];
    }
    function setDir()
    {
        if(tar == null)
        {
            if(color == 0)
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
            //trace("my tar", this, t);
            //var posible = [];

//            trace("myTar", t, myMap);
            for(var i = 0; i < len(t); i++)
            {
//                trace("eneColor", t[i].color, t[i].state);
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
        movAni.stop();
        attAni.stop();
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
    function update(diff)
    {
        //trace("update soldier", diff, state, tar);
        //布局阶段  
        var tPos;
        var dist;
        if(stopNow == 1)
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
        if(state != MAP_SOL_DEAD)
        {
            for(var i = 0; i < len(skillList); i++)
            {
                var sk = skillList[i];
                if(sk[3] == 0)
                {
                    sk[2] += diff;
                    var coldTime = getSkillColdTime(sid, sk[0]);
                    if(sk[2] >= coldTime)
                    {
                        trace("skillReady", sk);
                        sk[3] = 1;
                    }
                }
            }
        }
        //变身时间到解除变身状态 重新计算属性值
        if(makeUpState)
        {
            makeUpTime += diff;
            var totalMT = getMakeUpTime(sid, makeUpSkillId);
            if(makeUpTime >= totalMT)
            {
                makeUpState = 0;
                initAttackAndDefense(this);
                initHealth();
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

            //changeDirNode.texture("soldier"+str(id)+"dead.png", UPDATE_SIZE);
            backBanner.removefromparent();
            addChild(new DeadOver(this));


            //设置最小zord 在死亡之后设置zord

            tar = null;
            //增加经验
            deadTime = 0;
            map.calHurts(this);

            //进入死亡状态 闯关结束时更新所有士兵状态
            global.user.updateSoldiers(this);
        }
        if(state == MAP_SOL_ARRANGE)
        {
        }
        else if(state == MAP_SOL_FREE)
        {
            tar = getTar();
//            trace("free tar", tar);
            if(tar != null)
            {
                clearAnimation();
                changeDirNode.addaction(movAni);

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
                //trace("mePos tarPos", bg.pos(), tPos, tar.getVolumn(), attRange );
                state = MAP_SOL_ATTACK;
                clearAnimation();
                //inAttacking = 1;
                changeDirNode.addaction(attAni);
                return;
            }
            
            //在前方存在冲突对象不能移动
            var colObj = map.checkDirCol(this, tar);
            //trace("colObj", colObj);
            if(colObj != null)
            {
                //trace("col now", bg.pos(), colObj.getPos());
                return;
            }
            var t = dist*100/speed;
            shiftAni = moveto(t, tPos[0], bg.pos()[1]); 
            bg.addaction(shiftAni);
        }
        else if(state == MAP_SOL_TOUCH)
        {
            tar = null;
            clearAnimation();
            changeDirNode.addaction(movAni);
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
                changeDirNode.addaction(movAni);
                setDir();
                state = MAP_SOL_MOVE; 
                return;
            }
            attTime += diff;
            //攻击动画与伤害计算 分离
            if(attTime >= attSpeed)
            {
                funcSoldier.doAttack();
                //clearAnimation();
                //changeDirNode.addaction(attAni);
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

    var makeUpRate = 100;
    var makeUpSkillId = -1;
    //选择某个英雄 在 右上角显示士兵的能力数值

    //确定对应的变身对象
    //播放变身动画---》获得相应的 移动动画 和 攻击动画
    //计时变身时间
    //计算变身技能

    //喝药水 重新计算能力时
    function doMakeUp(skillId)
    {
        if(makeUpState == 0)
        {
            makeUpSkillId = skillId;
            makeUpState = 1;
            makeUpTime = 0;
            makeUpRate = getMakeUpRate(sid); 
            initMakeUpData();
            initHealth();
        }
    }
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

        attSpeed *= getAttSpeedRate(sid);
        attSpeed /= 100;
        
        if(kind == LONG_DISTANCE || kind == MAGIC )
            attRange += getRangeAdd(sid); 
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
    function clearSkillState()
    {
        if(greenStar != null)
        {
            greenStar.removefromparent();
            greenStar = null;
        }
    }

}
