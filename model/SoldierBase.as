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
    var magic = data.get("kind");

    if(magic == 2)
        magic = 1;
    else 
        magic = 0;
    res = [];
    for(var i = 0; i < len(soldierLevel); i++)
    {
        var r = [];
        r.append(soldierAttBase[i][0]*category[0]*grade/10000);
        r.append(soldierAttBase[i][1]*category[1]*grade/10000);
        r.append(soldierAttBase[i][2]*category[2]*grade/10000);
        if(magic == 0)
            r.append(soldierAttBase[i][3]*category[3]*grade/10000);
        else
            r.append(0);
        if(magic == 1)
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
function getBasicAbiliy(id, level)
{
    var data = getData(SOLDIER, id);
    var pureData = getSolPureData(id, level);
    var pcoff = getPhysicHurt(data);
    var mcoff = getMagicHurt(data);
    
    var phyBasic = pureData["physicAttack"]*pureData["healthBoundary"]*100/pcoff;
    var magBasic = pureData["magicAttack"]*pureData["healthBoundary"]*100/mcoff;
    var ab = max(phyBasic, magBasic)/(33*13);
//    trace("basicAbility", ab);
    return ab; //士兵能力
}

function getAddExp(id, level)
{
    var basic = getBasicAbiliy(id, level);
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
*/
const BASE_SOLDIER = 70;
function getTotalSkillDamage(sol, skillId)
{
    var sdata = getData(SKILL, skillId);
    var level =  global.user.getSolSkillLevel(sol.sid, skillId);
    level += sdata.get("effectLevel");

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
    return hurt;
}
