function initEquipAttribute(sol, equips)
{
    if(equips == null)
        return;
    trace("initEquipAttribute", equips);//不存在的装备则删除
    for(var i = 0; i < len(equips); i++)
    {
        var eData = equips[i];
        var e = getData(EQUIP, eData.get("kind"));

        sol.attack += e["attack"];
        sol.health += e["healthBoundary"];
        sol.healthBoundary += e["healthBoundary"];
        sol.defense += e["defense"];
    }
}
function initSkillList(sol, equips)
{
    if(equips == null)
        return;

    trace("initSkillList", equips);

    var skillLists = [];
    var suits = set();
    var equipsKind = [];
    var i;
    for(i = 0; i < len(equips); i++)
        equipsKind.append(equips[i]["kind"]);
    equipsKind = set(equipsKind);
    trace("equipsKind", equipsKind);

    //检测每件装备的套装属性
    //如果该套装都在 用户持有 
    //用户套装增加 该套装 且该套装没有出现过
    for(i = 0; i < len(equips); i++)
    {
        var eData = equips[i];
        var e = getData(EQUIP, eData["kind"]);
        if(e["suit"] != 0 && !(e["suit"] in suits))
        {
            var ret = checkFullEquip(equipsKind, e["suit"]); 
            if(ret)
                suits.add(e["suit"]);
        }
    }
    var temp = [];
    temp.extend(suits);
    var eq = [];
    for(i = 0; i < len(temp); i++)
        eq.append([getData(EQUIP_SKILL, temp[i])["skillId"], 0, 0, 1]);//id level time ready
    trace("suits", suits);
    return eq;
}
//检测是否装备了所有该套装装备
function checkFullEquip(equips, suitId)
{
    var suits = getSuitAllEquips(suitId);
    suits = set(suits);
    return suits.issubset(equips); 
}
//得到一套装备所有组件id
function getSuitAllEquips(suitId)
{
    var ret = [];
    var equip = getAllDataList(EQUIP); 
    for(var i = 0; i < len(equip); i++)
    {
        if(equip[i]["suit"] == suitId)
            ret.append(equip[i]["id"]);
    }
    trace("getSuitAllEquips", suitId, ret);
    return ret;
}
//基础属性 加上装备加成
function initAttackAndDefense(sol)
{
    var sData = getData(SOLDIER, sol.id);  
    sol.health = sData.get("healthBoundary");
    sol.healthBoundary = sData.get("healthBoundary");
    sol.attack = sData.get("attack");
    sol.defense = sData.get("defense");
    sol.attackType = sData["attackType"];
    sol.defenseType = sData["defenseType"];
    sol.attSpeed = sData["attSpeed"];
    sol.attRange = sData["range"];
    printSol(sol);
}
function printSol(sol)
{
    trace("solData", sol.health, sol.healthBoundary, sol.attack, sol.defense, sol.attackType, sol.defenseType, sol.attSpeed, sol.attRange);
}

//删除接口
function getSolPureData(id, lev)
{
    return getData(SOLDIER, id);
}
function getTransferLevel(sol)
{
    return 0;
}
function getLevelUpExp(id, lev)
{
    
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

function getSkillAnimate(id)
{
    var ani = skillAnimate.get(id);
    load_sprite_sheet(ani[2]);
    return ani;
}
/*
技能的没有加成
*/
function getTotalSkillDamage(sol, skillId, skillLevel)
{
    return getData(SKILL, skillId)["attack"];
}

function calSkillHurt(attack, tar)
{
    return [attack, 0, 0];
}

/*
攻击力 - 防御力 = 实际伤害
*/
function calHurt(src, tar)
{
    var hurt = HARM_TABLE[src.attackType][tar.defenseType]*src.attack; 
    hurt += src.leftHurt;
    var intHurt = hurt/100;
    src.leftHurt = hurt%100;

    var critical = rand(100);
    var criHit = 0;
    if(critical < src.data["criticalHitRate"])
    {
        criHit = 1;
        intHurt *= 2;
    }
    
    var missRate = tar.data["missRate"];
    var mr = rand(100);
    var missYet = 0;
    if(mr < missRate)
        missYet = 1;
    return [intHurt-tar.defense, criHit, missYet];//攻击力减去防御力
}

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

function getCareerLev(id)
{
    return id%10;
}

function getAddExp(id, level)
{
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
