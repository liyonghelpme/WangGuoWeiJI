function getPhysicHurt(data)
{
    var category = data.get("category");
    return soldierKind[category][4];
}
function getMagicHurt(data)
{
    var category = data.get("category");
    return soldierKind[category][5];
}
var stagePool = dict();

function getStage(data)
{
    var id = data.get("id");
    id = id/10*10;//转职之后 基本属性保持不变
    var res = stagePool.get(id);
    if(res != null)
        return res;

    var category = soldierKind[data.get("category")];
    var grade = soldierGrade[data.get("grade")];

    var magic = data["attackKind"];
    res = [];
    for(var i = 0; i < len(soldierLevel); i++)
    {
        var r = [];
        r.append(soldierAttBase[i][0]*category[0]*grade/10000);
        r.append(soldierAttBase[i][1]*category[1]*grade/10000);
        r.append(soldierAttBase[i][2]*category[2]*grade/10000);
        if(magic == PHYSIC_ATTACK)
            r.append(soldierAttBase[i][3]*category[3]*grade/10000);
        else
            r.append(0);
        if(magic == MAGIC_ATTACK)
            r.append(soldierAttBase[i][3]*category[3]*grade/10000);
        else
            r.append(0);
        r = [soldierLevel[i], r];     
        res.append(r);
    }
    stagePool.update(id, res);
    return res;
}
/*
计算士兵的裸露 攻击力 生命值 和受伤比例
id -->stage
*/
function getSolPureData(id, level)
{

    var data = getData(SOLDIER, id);
    var stage = getStage(data)
    var begin = 0;
    var end = 1;
    var i;
    for(i = end; i < len(stage); i++)
    {
        if(level < stage[i][0])
            break;
    }
    i = min(i, len(stage)-1);
    begin = stage[i-1];
    end = stage[i];

    var levelDiff = end[0]-begin[0];

    var addHealth = end[1][0]-begin[1][0];
    var addMagicDefense = end[1][1]-begin[1][1];
    var addPhysicDefense = end[1][2]-begin[1][2];
    var addPhysicAttack = end[1][3]-begin[1][3];
    var addMagicAttack = end[1][4]-begin[1][4];

    var physicAttack = begin[1][3]+(level-begin[0])*addPhysicAttack/levelDiff; 
    var physicDefense = begin[1][2]+(level-begin[0])*addPhysicDefense/levelDiff; 

    var magicAttack = begin[1][4]+(level-begin[0])*addMagicAttack/levelDiff; 
    var magicDefense = begin[1][1]+(level-begin[0])*addMagicDefense/levelDiff; 

    var healthBoundary = begin[1][0]+(level-begin[0])*addHealth/levelDiff;
    return dict([["physicAttack", physicAttack], ["physicDefense", physicDefense], ["magicAttack", magicAttack], ["magicDefense", magicDefense], ["healthBoundary", healthBoundary]]);
}
//士兵属性 和 士兵 数据

//[[lev, [health, magicDefense, physicDefense, physicAttack, magicAttack]], ...]
//if i >= len(stage)
//计算裸 基本属性
function calculateStage(sol)
{
    var pureData = getSolPureData(sol.id, sol.level);


    sol.physicAttack = pureData.get("physicAttack");
    sol.physicDefense = pureData.get("physicDefense");
    sol.purePhyDefense = pureData.get("physicDefense");

    sol.magicAttack = pureData.get("magicAttack");
    sol.magicDefense = pureData.get("magicDefense");
    sol.pureMagDefense = pureData.get("magicDefense");
    sol.healthBoundary = pureData.get("healthBoundary");
}
/*
裸露属性 和 装备 药品属性
首先初始化私有属性
再初始化公共属性

装备没有恢复速度属性
士兵没有生命值 攻击力等属性

初始化用户自己的士兵的装备属性

初始化怪兽和敌人士兵的装备属性在MapSoldier中处理


参数:士兵， 装备数据集
*/
function setEquipAttribute(sol, equips)
{
    if(equips == null)
        return;
    //士兵拥有的武器
    //var equips = global.user.getSoldierEquip(sol.sid);
    for(var i = 0; i < len(equips); i++)
    {
        //var eData = global.user.getEquipData(equips[i]);
        var eData = equips[i];
        var eqLevel = eData.get("level");
        var eCoff = equipLevel[eqLevel];

        var e = getData(EQUIP, eData.get("kind"));

        sol.physicAttack += e.get("physicAttack")*eCoff/100;
        sol.magicAttack += e.get("magicAttack")*eCoff/100;

        sol.physicDefense += e.get("physicDefense")*eCoff/100;
        sol.magicDefense += e.get("magicDefense")*eCoff/100;
        sol.healthBoundary += e.get("healthBoundary")*eCoff/100; 
    }
}

//根据士兵 类型 当前状态 计算士兵的各个属性
function initAttackAndDefense(sol)
{
    calculateStage(sol);
    //士兵攻击类型 增加相应的攻击力
    if(sol.addAttackTime > 0)
    {
        if(sol.physicAttack > 0)
            sol.physicAttack += sol.addAttack;
        else 
            sol.magicAttack += sol.addAttack;
    }
    //士兵防御力 魔法物理都增加
    if(sol.addDefenseTime > 0)
    {
        sol.physicDefense += sol.addDefense;
        sol.magicDefense += sol.addDefense;
    }

    if(sol.addHealthBoundaryTime > 0)
    {
        sol.healthBoundary += sol.addHealthBoundary;
    }


    //setEquipAttribute(sol, global.user.getSoldierEquipData(sol.sid));
    if(sol.sid == ENEMY)
        setEquipAttribute(sol, sol.myEquips);
    else
        setEquipAttribute(sol, global.user.getSoldierEquipData(sol.sid));
        

    sol.health = min(sol.health, sol.healthBoundary);

    //var phurt = getPhysicHurt(sol.data);
    //var mhurt = getMagicHurt(sol.data);
//    trace("Basic Attribute", sol.physicAttack, sol.magicAttack, sol.physicDefense, sol.magicDefense, sol.healthBoundary, phurt, mhurt);
}
/*
    attack * cofficient * pure/total / 100
    攻击城墙的物理伤害系数是100 魔法伤害系数是100

    攻击力伤害至少为1
*/


function getCareerLev(id)
{
    return id%10;
}

function getTransferLevel(sol)
{
    var id = sol.id;
    var proLevel = id%10;
    var nextLevel = proLevel+1;
    var solOrMon = sol.data.get("solOrMon"); 
    if(nextLevel < len(soldierTransfer) && solOrMon == 0)
        return soldierTransfer[nextLevel];
    return -1;
}
function checkTransfer(level, solData)
{
    var id = solData.get("id");
    var proLevel = id%10;
    var nextLevel = proLevel+1;
    var solOrMon = solData.get("solOrMon"); 
    if(nextLevel < len(soldierTransfer) && soldierTransfer[nextLevel] < level && solOrMon == 0)
    {
        return 1;
    }
    return 0;
}
/*
相对基本能力 1 1 1 1 1 
A 基准 B 基本能力

A 生命值*B攻击力/A受伤比           B生命值*A攻击力/B受伤比
A 1 xxx 1                          Bheal * 1 / B受伤比
A/B攻击力   = 1                   
*/
function getBasicAbility(id, level)
{
    var data = getData(SOLDIER, id);
    var pureData = getSolPureData(id, level);
    var pcoff = getPhysicHurt(data);
    var mcoff = getMagicHurt(data);
    
    var phyBasic = pureData["physicAttack"]*pureData["healthBoundary"]*100/pcoff;
    var magBasic = pureData["magicAttack"]*pureData["healthBoundary"]*100/mcoff;
    var ab = max(phyBasic, magBasic)/(soldierAttBase[0][0]*soldierAttBase[0][3]);//除以基本攻击力系数 base的攻击力 生命值
//    trace("basicAbility", ab);
    return ab; //士兵能力
}

function getAddExp(id, level)
{
    var basic = getBasicAbility(id, level);
    var exp = (2*basic-1)*3;
//    trace("soldierExp", exp);
    return exp; 
}
//升级经验5倍于普通经验
function getLevelUpExp(id, level)
{
    var exp = getAddExp(id, level)*(5+level);
//    trace("levelNeedExp", exp);
    return exp;
}

/*
计算用户自己的士兵的技能攻击力

技能等级 基础伤害

敌方士兵的技能攻击力

技能等级由skill类控制
*/
const BASE_SOLDIER = 70;
function getTotalSkillDamage(sol, skillId, skillLevel)
{
    var sdata = getData(SKILL, skillId);
    //var level =  global.user.getSolSkillLevel(sol.sid, skillId);
    var level = skillLevel;
    level += sdata.get("startLevel");

    var pureData = getSolPureData(BASE_SOLDIER, level);
    var attack = pureData.get("physicAttack");
    return attack*2;
}

function calSkillHurt(attack, tar)
{
    var mcoff = getMagicHurt(tar.data);
    var magHurt = attack*mcoff*tar.pureMagDefense/tar.magicDefense/100;
    magHurt = max(magHurt, 1);
    return magHurt;
}

function calHurt(src, tar)
{
    var pcoff = getPhysicHurt(tar.data);
    var phyHurt = src.physicAttack*pcoff*tar.purePhyDefense/tar.physicDefense/100;
    var mcoff = getMagicHurt(tar.data);
    var magHurt = src.magicAttack*mcoff*tar.pureMagDefense/tar.magicDefense/100;

    var hurt = max(phyHurt+magHurt, 1);

    var critical = rand(100);
    var criHit = 0;
    if(critical < src.data["criticalHitRate"])
    {
        criHit = 1;
        hurt *= 2;
    }
    return [hurt, criHit];
}

function getSkillColdTime(soldierId, skillId, skillLevel)
{
    var sdata = getData(SKILL, skillId);
    var skillKind = sdata.get("kind");
    //var skillLevel = global.user.getSolSkillLevel(soldierId, skillId);
    var coldTime = sdata.get("coldTime");
    //ms 单位
    coldTime = max(coldTime-sdata.get("coldMinusTime")*skillLevel, SKILL_MIN_COLDTIME);//最少时间5s 拯救技能 最少5s时间
    return coldTime;
}

//得到转职等级 我方士兵得到转职等级
//敌方士兵 得到转职等级 敌方怪兽得到转职等级

function getMakeUpRate(id)
{
    var careerLev = getCareerLev(id);
    return 110+20*careerLev;
}
function getAttSpeedRate(id)
{
    var careerLev = getCareerLev(id);
    return 95-careerLev*5;
}
function getRangeAdd(id)
{
    var careerLev = getCareerLev(id);
    return careerLev+1;
}

function getMakeUpTime(sid, skillId, skLevel)
{
    //var skLevel = global.user.getSolSkillLevel(sid, skillId);
    var skData = getData(SKILL, skillId);

    return skData.get("effectTime")+skLevel*skData.get("addTime");
}

//var aniPool = dict();

function getSolAnimate(id)
{
    //var ret = aniPool.get(id);
    //if(ret == null)
    //{
    var ret = [
        ["soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"], 
        ["soldiera"+str(id)+".plist/ss"+str(id)+"a0.png", "soldiera"+str(id)+".plist/ss"+str(id)+"a1.png","soldiera"+str(id)+".plist/ss"+str(id)+"a2.png","soldiera"+str(id)+".plist/ss"+str(id)+"a3.png","soldiera"+str(id)+".plist/ss"+str(id)+"a4.png","soldiera"+str(id)+".plist/ss"+str(id)+"a5.png","soldiera"+str(id)+".plist/ss"+str(id)+"a6.png"], 
        ["soldierfm"+str(id)+".plist/ss"+str(id)+"fm0.png", "soldierfm"+str(id)+".plist/ss"+str(id)+"fm1.png","soldierfm"+str(id)+".plist/ss"+str(id)+"fm2.png","soldierfm"+str(id)+".plist/ss"+str(id)+"fm3.png","soldierfm"+str(id)+".plist/ss"+str(id)+"fm4.png","soldierfm"+str(id)+".plist/ss"+str(id)+"fm5.png","soldierfm"+str(id)+".plist/ss"+str(id)+"fm6.png"], 
        ["soldierfa"+str(id)+".plist/ss"+str(id)+"fa0.png", "soldierfa"+str(id)+".plist/ss"+str(id)+"fa1.png","soldierfa"+str(id)+".plist/ss"+str(id)+"fa2.png","soldierfa"+str(id)+".plist/ss"+str(id)+"fa3.png","soldierfa"+str(id)+".plist/ss"+str(id)+"fa4.png","soldierfa"+str(id)+".plist/ss"+str(id)+"fa5.png","soldierfa"+str(id)+".plist/ss"+str(id)+"fa6.png"] 
    ];
     //   aniPool.update(id) = ret;
    //}
    return ret;
}


function getSkillAnimate(id)
{
    var ani = skillAnimate.get(id);
    load_sprite_sheet(ani[2]);
    return ani;
}

//士兵 怪兽 档次 ----》对应的大档次编号
function getGradeKey(g)
{
    return g/10;
}

function intCmp(a, b)
{
    return a-b;
}
//等级 类型决定复活花费
function getReliveCost(sid)
{
    var sd = global.user.getSoldierData(sid);
    var kindData = getData(SOLDIER, sd["id"]);
    var gradeLev = kindData["grade"];
    var sg = soldierGrade.keys();
    bubbleSort(sg, intCmp);
    var ind = sg.index(gradeLev);

    var cry = (sd["level"]+1)*PARAMS["reliveA"]+(ind+1)*PARAMS["reliveB"];
    return dict([["crystal", cry]]);
}
//转职等级
//档次
function getTransferCost(sid)
{
    
    return dict([["crystal", 10]]);
}
