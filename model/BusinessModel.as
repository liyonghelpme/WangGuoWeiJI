function getFarmNum(level)
{
    //var level = global.user.getValue("level");
    if(level < 45)
        return level+5;
    return 50;
}
//coff * 100
function getFarmCoff(level)
{
    //var level = global.user.getValue("level");
    if(level < 20)
    {
        return 100;
    }
    if(level < 40)
    {
        return 100+(level-19)*5;
    }
    return 2;
}

function getFarmIncome(level)
{
    //var level = global.user.getValue("level");
    if(level < 10)
        return 200;
    if(level < 20)
        return 216;
    if(level < 30)
        return 278;
    return 323;
}

function getTotalIncome(level)
{
    var num = getFarmNum(level);
    var per = getFarmIncome(level);
    var coff = getFarmCoff(level);
//    trace("farmNum", num, per, coff);
    return num*per*coff/100;
}

function getFarmExp(level)
{
    //var level = global.user.getValue("level");
    if(level < 10)
        return 30;
    if(level < 20)
        return 38;
    if(level < 30)
        return 66;
    return 91;
}


/*
服务器自动计算的升级需要经验
客户端使用和服务器相同的数据
*/
// /1000 天数 
//6 10 20 30 40 50

//最大等级经验
//等级数据 由programWan 中生成经验序列
function getLevelUpNeedExp(level)
{
    return levelExp[min(len(levelExp)-1, level)];
}


//掉落物品价值value/1000
//0 - 9 编号
function getFallObjValue(id, fallTimes)
{
    var level = global.user.getValue("level");
    var maxGain;
    maxGain = getData(LEVEL_MAX_FALL_GAIN, min(level, len(levelMaxFallGainData)-1));
    var gData = getData(FALL_THING, id);
    var gain = getGain(FALL_THING, id);
    trace("maxGain, gain ", maxGain, gain, id, fallTimes);

    if(gain.get("silver") != null)
        gain["silver"] = min(maxGain["maxSilver"], maxGain["initSilver"]+gData["addsilver"]*fallTimes);
    if(gain.get("crystal") != null)
        gain["crystal"] = min(maxGain["maxCrystal"], maxGain["initCrystal"]+gData["addcrystal"]*fallTimes);
    if(gain.get("gold") != null)
        gain["gold"] = min(maxGain["maxGold"], maxGain["initGold"]+gData["addgold"]*fallTimes);

    return gain;
}

function getLoginReward(day)
{
    var reward = dict();
    for(var i = 0; i < len(LoginReward); i++)
    {
        if(LoginReward[i][0] > day)
            break;
    }
    i--;
    reward.update("gold", LoginReward[i][1]);
    return reward;
}

//得到level级水晶矿产量
function getProduction(level)
{
    var mData = getGain(MINE_PRODUCTION, level);
    return mData["crystal"];
}


const GOODS_COFF = 10000;
function getGoodsKey(kind, id)
{
    return kind*GOODS_COFF+id;
}
function getGoodsKindAndId(k)
{
    return [k/GOODS_COFF, k%GOODS_COFF];
}

function getMaxSkillNum(career)
{
    return career+2;
}
function getCareer(kindId)
{
    return kindId%10;
}

const UPDATE = [SOLDIER, EQUIP, BUILD];
function getUpdateObject()
{
    var updateState = global.user.updateState%len(UPDATE);
    var kind = UPDATE[updateState];
    var level = global.user.getValue("level");
    var i;
    var find = null;
    var now;
    if(kind == SOLDIER)
    {
        now = global.user.getAllSoldierKinds();
    }
    else if(kind == EQUIP)
    {
        now = global.user.getAllEquipKinds();
    }
    else if(kind == BUILD)
    {
        now = global.user.getAllBuildingKinds();
    }

    for(i = level; i <= MAX_LEVEL; i++)
    {
        var curObj = levelUpdate.get(i);
        if(curObj != null)
            for(var j = 0; j < len(curObj); j++)
            {
                var temp = curObj[j][1];
                if(curObj[j][0] == kind && now.get(temp) == null)
                {
                    find = curObj[j];
                    break;
                }
            }
        if(find != null)
            break;
    }
    return find;
}

//根据funcs来确定名字
const KIND2NAME = dict([
[FARM_BUILD, "Farm"], [HOUSE_BUILD, "House"], [MINE_KIND, "Mine"], [CAMP, "Camp"],
]);
//根据建筑ID 得到 建筑的funcs
function getCurBuildNum(id)
{
    var bData = getData(BUILD, id);
    var count = 0;
    var val = global.user.buildings.values();
    for(var i = 0; i < len(val); i++)
    {
        var bd = getData(BUILD, val[i]["id"]);
        if(bd["funcs"] == bData["funcs"])
        {
            count++;
        }
    }
    return count;
}
function getBuildEnableNum(id)
{
    var bData = getData(BUILD, id);
    var level = global.user.getValue("level");
    var name = KIND2NAME[bData["funcs"]];
    if(name == null)//没有限制
        return [999999, 0, 0];
    //K 级解锁1个
    var num = getParam("init"+name+"Num")+level/getParam(name+"Level");
    var upBound = 0;
    if(num >= getParam("max"+name+"Num"))
        upBound = 1;
    //trace("getBuildEnableNum", num, upBound);
    return [min(num, getParam("max"+name+"Num")), upBound, 1];//最大限制 总量存在限制
}
function checkBuildNum(id)
{
    var curNum = getCurBuildNum(id);
    var enableNum = getBuildEnableNum(id);
    return [enableNum[0]>curNum, enableNum[1], enableNum[2]];
}

function getNextBuildNum(id)
{
    var bData = getData(BUILD, id);
    var bLevel = getParam(KIND2NAME[bData["funcs"]]+"Level");
    var level = global.user.getValue("level");
    var need = (level+bLevel)/bLevel;
    return need*bLevel;
}

function calAccCost(leftTime)
{
    for(var i = 0; i < (len(AccCost)-1); i++)
    {
        if(AccCost[i][0] > leftTime)
            break;
    }
    i--;
    var beginTime = AccCost[i][0];
    var endTime = AccCost[i+1][0];
    var beginGold = AccCost[i][1];
    var endGold = AccCost[i+1][1];
    var needGold = beginGold + leftTime*(endGold-beginGold)/(endTime-beginTime);
    //至少消耗1个金币
    if(leftTime > 0)    
        needGold = max(needGold, 1);
    //printD(["calAccCost", needGold, leftTime]);
    return needGold;
}
