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

/*
var NEED_DAY = [500, 1000, 1500, 2000, 2500, 3000];
function getLevelUpNeedExp(level)
{
    //var level = global.user.getValue("level");
    var exp = getFarmExp(level)*getFarmNum(level);
    if(level < 6)
        return exp/2;
    if(level < 10)
        return exp*(500+125*(level-6))/1000;
    if(level < 50)
        return exp*(1000+50*(level-10))/1000;
    if(level < 100)
        return exp*(3000+40*(level-50))/1000;
    return exp*(5000+30*(level-100))/1000;
}
*/
//最大等级经验
//等级数据 由programWan 中生成经验序列
function getLevelUpNeedExp(level)
{
    return levelExp[min(len(levelExp)-1, level)];
}

function getTotalIncome(level)
{
    var num = getFarmNum(level);
    var per = getFarmIncome(level);
    var coff = getFarmCoff(level);
//    trace("farmNum", num, per, coff);
    return num*per*coff/100;
}
//掉落物品价值value/1000
//0 - 9 编号
function getFallObjValue(id)
{
    var level = global.user.getValue("level");
    var income = getTotalIncome(level);
    var gain = getGain(FALL_THING, id);
    if(gain.get("silver") != null)
        gain["silver"] = gain["silver"]*income/1000;
//    trace("FallThing", gain, income);
    return gain;
}

function getLoginReward(day)
{
    var reward = dict();
    if(day == 0)
        reward.update("silver", 0);
    else if(day%2 == 0)
    {
        reward.update("crystal", 5+day);
    }
    else 
    {
        var income = getTotalIncome(global.user.getValue("level"));
        income = income*20/100;
        reward.update("silver", income);
    }
//    trace("login reward", reward);
    return reward;
}
//<= bigNum
function getOpenBig()
{
    var level = global.user.getValue("level");
    if(level < 15)
        return 1;
    if(level < 30)
        return 2;
    if(level < 40)
        return 3;
    if(level < 50)
        return 4;
    return 5;
}


function showCost(bg, cost)
{
    var it = cost.items();
    for(var i = 0; i < len(it); i++)
    {
        var temp = bg.addnode();
        //key.png
        temp.addsprite(str(it[i][0])+".png").anchor(0, 50).pos(0, -30).size(30, 30);
        temp.addlabel("-"+str(it[i][1]), null, 25).anchor(0, 50).pos(35, -30).color(0, 0, 0);
        temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
    }
}


function getFarmEnableNum()
{
    var level = global.user.getValue("level");
    var num = 5+level;
    return num;
}
function getCurFarmNum()
{
    var count = 0;
    var val = global.user.buildings.values();
    for(var i = 0; i < len(val); i++)
    {
        if(val[i].get("funcs") == FARM_BUILD)
        {
            count++;
        }
    }
    return count;
}
function checkFarmNum()
{
    var now = getCurFarmNum();
    var cap = getFarmEnableNum();
    if(cap > now)//capacity > own
    {
        return 1;
    }
    return 0;
}
